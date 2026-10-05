//! File-only translation image work. FRB runs these calls off the UI isolate;
//! the Dart coordinator serializes preparation and composition in one queue.
use image::{AnimationDecoder, DynamicImage, ImageDecoder, ImageEncoder, ImageReader, RgbaImage};
use serde_json::{json, Value};
use sha2::{Digest, Sha256};
use std::fs::{self, File};
use std::io::{BufReader, BufWriter, Read, Write};

// A local working-set budget, checked before decoding. Not a server limit.
const PIXELS: u64 = 32 * 1024 * 1024;
const WEBP_EDGE: u32 = 16383;
const JPEG_EDGE: u32 = 65500;

fn fail<T>() -> Result<T, String> {
    Err("IMAGE_INVALID".into())
}
fn safe<T, E>(r: Result<T, E>) -> Result<T, String> {
    r.map_err(|_| "IMAGE_INVALID".into())
}
fn digest(path: &str) -> Result<String, String> {
    let mut file = safe(File::open(path))?;
    let mut hash = Sha256::new();
    let mut buf = [0; 65536];
    loop {
        let n = safe(file.read(&mut buf))?;
        if n == 0 {
            break;
        }
        hash.update(&buf[..n]);
    }
    Ok(format!("{:x}", hash.finalize()))
}
fn check_size(w: u32, h: u32) -> Result<(), String> {
    if w == 0 || h == 0 {
        return fail();
    }
    if u64::from(w) * u64::from(h) > PIXELS {
        return Err("IMAGE_WORKING_SET_LIMIT".into());
    }
    Ok(())
}
fn read_image(path: &str) -> Result<(DynamicImage, bool, String), String> {
    let reader = safe(safe(ImageReader::open(path))?.with_guessed_format())?;
    let format = reader.format().ok_or("IMAGE_INVALID")?;
    let mime = match format {
        image::ImageFormat::Png => "image/png",
        image::ImageFormat::Jpeg => "image/jpeg",
        image::ImageFormat::WebP => "image/webp",
        _ => return Err("IMAGE_FORMAT_UNSUPPORTED".into()),
    };
    let mut decoder = safe(reader.into_decoder())?;
    let (w, h) = decoder.dimensions();
    check_size(w, h)?;
    let orientation = safe(decoder.orientation())?;
    let icc = safe(decoder.icc_profile())?;
    // Normalize the first animation frame, including APNG's separate poster case.
    let exif = safe(decoder.exif_metadata())?;
    let animated = has_animation(path, format)?;
    let mut img = if animated {
        drop(decoder);
        let file = BufReader::new(safe(File::open(path))?);
        let frame = if format == image::ImageFormat::Png {
            safe(safe(image::codecs::png::PngDecoder::new(file))?.apng())?
                .into_frames()
                .next()
        } else {
            safe(image::codecs::webp::WebPDecoder::new(file))?
                .into_frames()
                .next()
        };
        DynamicImage::ImageRgba8(safe(frame.ok_or("IMAGE_INVALID")?)?.into_buffer())
    } else {
        safe(DynamicImage::from_decoder(decoder))?
    };
    img.apply_orientation(orientation);
    let normalized = icc.is_some() || exif.is_some() || animated;
    if let Some(profile) = icc {
        let src = safe(moxcms::ColorProfile::new_from_slice(&profile))?;
        let dst = moxcms::ColorProfile::new_srgb();
        // Gray/CMYK profiles cannot be applied to already converted RGBA data.
        // Reject rather than silently assign the wrong color space.
        if src.color_space != moxcms::DataColorSpace::Rgb {
            return Err("IMAGE_COLOR_UNSUPPORTED".into());
        }
        let transform = safe(src.create_transform_8bit(
            moxcms::Layout::Rgba,
            &dst,
            moxcms::Layout::Rgba,
            moxcms::TransformOptions::default(),
        ))?;
        let mut rgba = img.into_rgba8();
        let stride = rgba.width() as usize * 4;
        let mut row = vec![0; stride];
        for pixels in rgba.as_mut().chunks_exact_mut(stride) {
            safe(transform.transform(pixels, &mut row))?;
            pixels.copy_from_slice(&row);
        }
        img = DynamicImage::ImageRgba8(rgba);
    }
    Ok((img, normalized, mime.into()))
}
fn has_animation(path: &str, format: image::ImageFormat) -> Result<bool, String> {
    let mut f = safe(File::open(path))?;
    if format == image::ImageFormat::WebP {
        let mut head = [0; 21];
        let n = safe(f.read(&mut head))?;
        return Ok(n == 21 && &head[12..16] == b"VP8X" && head[20] & 2 != 0);
    }
    if format == image::ImageFormat::Png {
        let mut signature = [0; 8];
        safe(f.read_exact(&mut signature))?;
        for _ in 0..1024 {
            let mut head = [0; 8];
            safe(f.read_exact(&mut head))?;
            let len = u32::from_be_bytes(head[..4].try_into().unwrap()) as u64;
            if &head[4..] == b"acTL" {
                return Ok(true);
            }
            if &head[4..] == b"IDAT" || &head[4..] == b"IEND" {
                return Ok(false);
            }
            use std::io::Seek;
            safe(f.seek(std::io::SeekFrom::Current((len + 4) as i64)))?;
        }
        return fail();
    }
    Ok(false)
}
fn save_png(rgba: &RgbaImage, path: &str) -> Result<(), String> {
    let mut out = BufWriter::new(safe(File::create(path))?);
    safe(image::codecs::png::PngEncoder::new(&mut out).write_image(
        rgba.as_raw(),
        rgba.width(),
        rgba.height(),
        image::ExtendedColorType::Rgba8,
    ))?;
    safe(out.flush())?;
    safe(out.get_ref().sync_all())
}
fn save_bytes(bytes: &[u8], path: &str) -> Result<(), String> {
    let mut f = safe(File::create(path))?;
    safe(f.write_all(bytes))?;
    safe(f.sync_all())
}

pub fn translation_prepare(
    source: String,
    output: String,
    max_bytes: u64,
    max_dimension: u32,
) -> Result<String, String> {
    let source_sha = digest(&source)?;
    let source_len = safe(fs::metadata(&source))?.len();
    let (mut img, normalize, source_mime) = read_image(&source)?;
    let (sw, sh) = (img.width(), img.height());
    let scale = (1800.0 / f64::from(sw.min(sh))).min(1.0);
    let (w, h) = (
        (f64::from(sw) * scale).round() as u32,
        (f64::from(sh) * scale).round() as u32,
    );
    if w > max_dimension || h > max_dimension {
        return Err("IMAGE_DIMENSIONS_LIMIT".into());
    }
    if scale < 1.0 {
        img = img.resize_exact(w, h, image::imageops::FilterType::Lanczos3);
    }
    let compress = scale < 1.0 || source_len > 1024 * 1024;
    let mut mime = source_mime.clone();
    if compress && w.max(h) <= WEBP_EDGE {
        let rgba = img.into_rgba8();
        let bytes = safe(webp::Encoder::from_rgba(rgba.as_raw(), w, h).encode_simple(false, 90.0))?;
        if scale == 1.0
            && !normalize
            && (bytes.len() as u64 >= source_len || bytes.len() as u64 > max_bytes)
        {
            safe(fs::copy(&source, &output))?;
        } else {
            save_bytes(&bytes, &output)?;
            mime = "image/webp".into();
        }
    } else if compress && w.max(h) <= JPEG_EDGE {
        let mut rgba = img.into_rgba8();
        for pixel in rgba.pixels_mut() {
            let a = u32::from(pixel[3]);
            for c in 0..3 {
                pixel[c] = ((u32::from(pixel[c]) * a + 255 * (255 - a) + 127) / 255) as u8;
            }
            pixel[3] = 255;
        }
        let rgb = DynamicImage::ImageRgba8(rgba).into_rgb8();
        let mut f = BufWriter::new(safe(File::create(&output))?);
        safe(image::codecs::jpeg::JpegEncoder::new_with_quality(&mut f, 30).encode_image(&rgb))?;
        safe(f.flush())?;
        safe(f.get_ref().sync_all())?;
        mime = "image/jpeg".into();
        if scale == 1.0 && !normalize && safe(fs::metadata(&output))?.len() >= source_len {
            safe(fs::copy(&source, &output))?;
            mime = source_mime;
        }
    } else if compress && (scale < 1.0 || normalize) {
        return Err("IMAGE_DIMENSIONS_LIMIT".into());
    } else if normalize {
        save_png(&img.into_rgba8(), &output)?;
        mime = "image/png".into();
    } else {
        safe(fs::copy(&source, &output))?;
    }
    let len = safe(fs::metadata(&output))?.len();
    if len > max_bytes {
        return Err("IMAGE_BYTES_LIMIT".into());
    }
    let actual = safe(safe(ImageReader::open(&output))?.with_guessed_format())?;
    if safe(actual.into_dimensions())? != (w, h) {
        return fail();
    }
    safe(fs::OpenOptions::new().read(true).write(true).open(&output))?
        .sync_all()
        .map_err(|_| "STORAGE_FAILED")?;
    Ok(
        json!({"source_sha256":source_sha,"sha256":digest(&output)?,"byte_size":len,
        "content_type":mime,"width":w,"height":h,"source_width":sw,"source_height":sh})
        .to_string(),
    )
}

fn number(v: &Value, key: &str) -> Result<u32, String> {
    v[key]
        .as_u64()
        .and_then(|n| u32::try_from(n).ok())
        .ok_or("RESULT_INVALID".into())
}
fn apply_patch(
    base: &mut RgbaImage,
    patch: RgbaImage,
    x: u32,
    y: u32,
    w: u32,
    h: u32,
) -> Result<(), String> {
    if patch.dimensions() != (w, h)
        || w == 0
        || h == 0
        || u64::from(x) + u64::from(w) > u64::from(base.width())
        || u64::from(y) + u64::from(h) > u64::from(base.height())
    {
        return fail();
    }
    for py in 0..h {
        for px in 0..w {
            let src = patch.get_pixel(px, py);
            let dst = base.get_pixel_mut(x + px, y + py);
            let alpha = u32::from(src[3]);
            for c in 0..3 {
                dst[c] = if dst[3] == 0 {
                    0
                } else {
                    ((u32::from(src[c]) * alpha + u32::from(dst[c]) * (255 - alpha) + 127) / 255)
                        as u8
                };
            }
            // Porter-Duff source-atop preserves destination alpha exactly.
        }
    }
    Ok(())
}
fn read_overlay<R: std::io::BufRead + std::io::Seek>(
    reader: R,
    w: u32,
    h: u32,
) -> Result<RgbaImage, String> {
    let decoder = safe(image::codecs::webp::WebPDecoder::new(reader))?;
    if decoder.has_animation() || decoder.dimensions() != (w, h) {
        return fail();
    }
    safe(DynamicImage::from_decoder(decoder)).map(|image| image.into_rgba8())
}
pub fn translation_compose(
    input: String,
    artifact: String,
    result_json: String,
    output: String,
) -> Result<String, String> {
    let result: Value = safe(serde_json::from_str(&result_json))?;
    let sha = digest(&input)?;
    let (w, h) = (number(&result, "width")?, number(&result, "height")?);
    if result["input_sha256"] != sha
        || result["normalization_version"] != 1
        || result["composite"] != "source-atop"
    {
        return fail();
    }
    check_size(w, h)?;
    let (img, _, _) = read_image(&input)?;
    if (img.width(), img.height()) != (w, h) {
        return fail();
    }
    if result["artifact"]["sha256"] != digest(&artifact)?
        || result["artifact"]["byte_size"].as_u64() != Some(safe(fs::metadata(&artifact))?.len())
    {
        return fail();
    }
    let mut base = img.into_rgba8();
    if result["representation"] == "overlay-v1" {
        let b = &result["bbox"];
        let pw = number(b, "width")?;
        let ph = number(b, "height")?;
        check_size(pw, ph)?;
        if u64::from(number(b, "x")?) + u64::from(pw) > u64::from(w)
            || u64::from(number(b, "y")?) + u64::from(ph) > u64::from(h)
        {
            return fail();
        }
        let patch = read_overlay(BufReader::new(safe(File::open(&artifact))?), pw, ph)?;
        apply_patch(&mut base, patch, number(b, "x")?, number(b, "y")?, pw, ph)?;
    } else if result["representation"] == "overlay-tiles-v1" {
        let mut f = BufReader::new(safe(File::open(&artifact))?);
        let mut header = [0; 12];
        safe(f.read_exact(&mut header))?;
        if &header[..8] != b"NCOT0001" {
            return fail();
        }
        let len = u32::from_le_bytes(header[8..].try_into().unwrap()) as usize;
        if len == 0 || len > 256 * 1024 {
            return fail();
        }
        let mut bytes = vec![0; len];
        safe(f.read_exact(&mut bytes))?;
        let manifest: Value = safe(serde_json::from_slice(&bytes))?;
        if manifest["format"] != "overlay-tiles-v1"
            || manifest["input_sha256"] != sha
            || number(&manifest, "width")? != w
            || number(&manifest, "height")? != h
        {
            return fail();
        }
        let tiles = manifest["tiles"].as_array().ok_or("RESULT_INVALID")?;
        if tiles.is_empty() || tiles.len() > 4096 {
            return fail();
        }
        let mut regions: Vec<(u32, u32, u32, u32)> = Vec::new();
        for tile in tiles {
            let (x, y, tw, th) = (
                number(tile, "x")?,
                number(tile, "y")?,
                number(tile, "width")?,
                number(tile, "height")?,
            );
            let size = number(tile, "byte_size")? as usize;
            if tw == 0
                || th == 0
                || tw > 2048
                || th > 4096
                || size == 0
                || size > 40 * 1024 * 1024
                || u64::from(x) + u64::from(tw) > u64::from(w)
                || u64::from(y) + u64::from(th) > u64::from(h)
                || regions
                    .iter()
                    .any(|&(a, b, c, d)| x < a + c && a < x + tw && y < b + d && b < y + th)
            {
                return fail();
            }
            regions.push((x, y, tw, th));
            let mut bytes = vec![0; size];
            safe(f.read_exact(&mut bytes))?;
            if tile["sha256"] != format!("{:x}", Sha256::digest(&bytes)) {
                return fail();
            }
            apply_patch(
                &mut base,
                read_overlay(std::io::Cursor::new(&bytes), tw, th)?,
                x,
                y,
                tw,
                th,
            )?;
        }
        let mut tail = [0];
        if safe(f.read(&mut tail))? != 0 {
            return fail();
        }
    } else {
        return fail();
    }
    save_png(&base, &output)?;
    Ok(json!({"width":w,"height":h,"sha256":digest(&output)?,"byte_size":safe(fs::metadata(&output))?.len()}).to_string())
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn atop_preserves_alpha_and_does_not_bleed_outside_patch() {
        let mut base = RgbaImage::from_pixel(2, 1, image::Rgba([100, 150, 200, 80]));
        apply_patch(
            &mut base,
            RgbaImage::from_pixel(1, 1, image::Rgba([200, 50, 0, 128])),
            0,
            0,
            1,
            1,
        )
        .unwrap();
        assert_eq!(base.get_pixel(0, 0).0, [150, 100, 100, 80]);
        assert_eq!(base.get_pixel(1, 0).0, [100, 150, 200, 80]);
    }
    #[test]
    fn rejects_oversize_before_decode() {
        assert!(check_size(8000, 8000).is_err());
    }

    #[test]
    fn static_input_is_frozen_without_reencoding() {
        let dir = std::env::temp_dir().join(format!("nodelane-input-{}", std::process::id()));
        fs::create_dir_all(&dir).unwrap();
        let source = dir.join("source.png").to_string_lossy().into_owned();
        let output = dir.join("frozen.input").to_string_lossy().into_owned();
        save_png(
            &RgbaImage::from_pixel(64, 128, image::Rgba([50, 60, 70, 120])),
            &source,
        )
        .unwrap();
        let result: Value = serde_json::from_str(
            &translation_prepare(source.clone(), output.clone(), 1048576, 65500).unwrap(),
        )
        .unwrap();
        assert_eq!(result["source_sha256"], result["sha256"]);
        assert_eq!(fs::read(&source).unwrap(), fs::read(&output).unwrap());
        fs::remove_dir_all(dir).unwrap();
    }
    #[test]
    fn tiles_are_verified_before_publishing_a_complete_image() {
        let dir = std::env::temp_dir().join(format!("nodelane-tiles-{}", std::process::id()));
        fs::create_dir_all(&dir).unwrap();
        let input = dir.join("input.png").to_string_lossy().into_owned();
        let artifact = dir.join("tiles.bin").to_string_lossy().into_owned();
        let output = dir.join("output.png").to_string_lossy().into_owned();
        save_png(
            &RgbaImage::from_pixel(8, 16, image::Rgba([255, 255, 255, 255])),
            &input,
        )
        .unwrap();
        let rgba = RgbaImage::from_pixel(2, 3, image::Rgba([0, 0, 0, 255]));
        let patch = webp::Encoder::from_rgba(rgba.as_raw(), 2, 3)
            .encode_lossless()
            .to_vec();
        let tile = json!({"x":2,"y":5,"width":2,"height":3,"byte_size":patch.len(),"sha256":format!("{:x}",Sha256::digest(&patch))});
        for case in ["valid", "overlap", "digest", "tail", "dimensions"] {
            let mut tiles = vec![tile.clone()];
            if case == "overlap" {
                tiles.push(tile.clone());
            }
            if case == "digest" {
                tiles[0]["sha256"] = json!("0".repeat(64));
            }
            if case == "dimensions" {
                tiles[0]["width"] = json!(3);
            }
            let manifest=serde_json::to_vec(&json!({"format":"overlay-tiles-v1","input_sha256":digest(&input).unwrap(),"width":8,"height":16,"tiles":tiles})).unwrap();
            let mut bytes = b"NCOT0001".to_vec();
            bytes.extend((manifest.len() as u32).to_le_bytes());
            bytes.extend(manifest);
            bytes.extend(&patch);
            if case == "overlap" {
                bytes.extend(&patch);
            }
            if case == "tail" {
                bytes.push(1);
            }
            fs::write(&artifact, &bytes).unwrap();
            let result = json!({"input_sha256":digest(&input).unwrap(),"normalization_version":1,"composite":"source-atop","width":8,"height":16,
                "representation":"overlay-tiles-v1","artifact":{"sha256":digest(&artifact).unwrap(),"byte_size":bytes.len()}});
            let composed = translation_compose(
                input.clone(),
                artifact.clone(),
                result.to_string(),
                output.clone(),
            );
            if case == "valid" {
                composed.unwrap();
                let image = image::open(&output).unwrap().into_rgba8();
                assert_eq!(image.get_pixel(2, 5).0, [0, 0, 0, 255]);
                assert_eq!(image.get_pixel(0, 0).0, [255, 255, 255, 255]);
            } else {
                assert!(composed.is_err(), "{case}");
            }
        }
        fs::remove_dir_all(dir).unwrap();
    }
}

"""Create a gzip-compressed copy/literal recipe for two exact, signed APKs."""
import argparse
import gzip
import mmap
import struct
import tempfile
import zipfile
from pathlib import Path


def payload_offset(data, entry):
    start = entry.header_offset
    if data[start:start + 4] != b"PK\x03\x04":
        raise ValueError("Invalid ZIP local header")
    name, extra = struct.unpack_from("<HH", data, start + 26)
    return start + 30 + name + extra


def create_patch(base, target, output):
    """Copy identical compressed entries; literals preserve even alignment and signatures."""
    with (base.open("rb") as af, target.open("rb") as bf,
          mmap.mmap(af.fileno(), 0, access=mmap.ACCESS_READ) as a,
          mmap.mmap(bf.fileno(), 0, access=mmap.ACCESS_READ) as b,
          zipfile.ZipFile(af) as old, zipfile.ZipFile(bf) as new,
          tempfile.NamedTemporaryFile(dir=output.parent, delete=False) as tmp):
        temporary = Path(tmp.name)
        try:
            with gzip.GzipFile(filename="", fileobj=tmp, mode="wb", mtime=0) as patch:
                patch.write(b"NLD1")

                def literal(start, end):
                    if end > start:
                        patch.write(b"L" + struct.pack(">Q", end - start))
                        patch.write(memoryview(b)[start:end])

                cursor = 0
                for entry in sorted(new.infolist(), key=lambda i: i.header_offset):
                    source = old.NameToInfo.get(entry.filename)
                    length = entry.compress_size
                    if (source is None or length < 32 or source.compress_size != length
                            or source.CRC != entry.CRC):
                        continue
                    before = payload_offset(a, source)
                    after = payload_offset(b, entry)
                    if memoryview(a)[before:before+length] != memoryview(b)[after:after+length]:
                        continue
                    literal(cursor, after)
                    patch.write(b"C" + struct.pack(">QQ", before, length))
                    cursor = after + length
                literal(cursor, len(b))
                patch.write(b"E")
            tmp.close()
            temporary.replace(output)
        finally:
            tmp.close()
            temporary.unlink(missing_ok=True)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    for name in ("base", "target", "output"):
        parser.add_argument(name, type=Path)
    args = parser.parse_args()
    if args.output.resolve() in (args.base.resolve(), args.target.resolve()):
        parser.error("Output must differ from both input APKs")
    create_patch(args.base, args.target, args.output)

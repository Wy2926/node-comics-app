package com.nodelane.comics;

import java.io.*;
import java.security.DigestOutputStream;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.zip.GZIPInputStream;

/** Rebuild the signed APK verbatim, reading only from the installed APK and a verified patch. */
public final class ApkDelta {
    private static MessageDigest digest() {
        try { return MessageDigest.getInstance("SHA-256"); }
        catch (NoSuchAlgorithmException e) { throw new AssertionError(e); }
    }

    private static String hex(byte[] bytes) {
        StringBuilder result = new StringBuilder(bytes.length * 2);
        for (byte b : bytes) result.append(Character.forDigit((b & 255) >>> 4, 16))
                                   .append(Character.forDigit(b & 15, 16));
        return result.toString();
    }

    private static void check(boolean ok) throws IOException {
        if (!ok) throw new IOException("Update package verification failed");
    }

    private static void checkInterrupted() throws InterruptedIOException {
        if (Thread.currentThread().isInterrupted()) throw new InterruptedIOException();
    }

    public static String sha256(File file) throws IOException {
        MessageDigest sha = digest();
        try (InputStream in = new FileInputStream(file)) {
            byte[] buffer = new byte[65536];
            int n;
            while ((n = in.read(buffer)) != -1) {
                checkInterrupted();
                sha.update(buffer, 0, n);
            }
        }
        return hex(sha.digest());
    }

    public static void apply(File base, File patch, File temp, long size, String targetSha)
            throws IOException {
        MessageDigest sha = digest();
        try (RandomAccessFile old = new RandomAccessFile(base, "r");
             InputStream compressed = new FileInputStream(patch);
             DataInputStream in = new DataInputStream(new BufferedInputStream(
                     new GZIPInputStream(compressed, 65536)));
             DigestOutputStream out = new DigestOutputStream(new FileOutputStream(temp), sha)) {
            check(in.readInt() == 0x4e4c4431 && size > 0); // NLD1
            byte[] buffer = new byte[65536];
            long remaining = size;
            int op;
            while ((op = in.readUnsignedByte()) != 'E') {
                check(op == 'C' || op == 'L');
                long offset = op == 'C' ? in.readLong() : 0;
                long length = in.readLong();
                check(length > 0 && length <= remaining);
                if (op == 'C') {
                    check(offset >= 0 && offset <= old.length() - length);
                    old.seek(offset);
                }
                remaining -= length;
                while (length > 0) {
                    checkInterrupted();
                    int n = (int)Math.min(buffer.length, length);
                    if (op == 'C') old.readFully(buffer, 0, n);
                    else in.readFully(buffer, 0, n);
                    out.write(buffer, 0, n);
                    length -= n;
                }
            }
            check(remaining == 0 && in.read() == -1 && targetSha.equals(hex(sha.digest())));
        } catch (IOException | RuntimeException error) {
            temp.delete();
            throw error;
        }
    }
}

package io.agora.media

import java.io.ByteArrayOutputStream
import java.nio.charset.StandardCharsets
import java.security.InvalidKeyException
import java.security.MessageDigest
import java.security.NoSuchAlgorithmException
import java.security.SecureRandom
import java.util.*
import java.util.zip.CRC32
import java.util.zip.Deflater
import java.util.zip.Inflater
import javax.crypto.Mac
import javax.crypto.spec.SecretKeySpec

/** Provides cryptographic, encoding, compression, and validation helpers. */
object Utils {
    const val HMAC_SHA256_LENGTH = 32
    const val VERSION_LENGTH = 3
    const val APP_ID_LENGTH = 32

    /** Computes an HMAC-SHA256 signature with a UTF-8 key. */
    @Throws(InvalidKeyException::class, NoSuchAlgorithmException::class)
    fun hmacSign(keyString: String, msg: ByteArray): ByteArray {
        val keySpec = SecretKeySpec(keyString.toByteArray(StandardCharsets.UTF_8), "HmacSHA256")
        val mac = Mac.getInstance("HmacSHA256")
        mac.init(keySpec)
        return mac.doFinal(msg)
    }

    /** Encodes bytes as a Base64 string. */
    fun base64Encode(data: ByteArray): String {
        return Base64.getEncoder().encodeToString(data)
    }

    /** Decodes a Base64 string. */
    fun base64Decode(data: String): ByteArray {
        return Base64.getDecoder().decode(data)
    }

    /** Computes CRC32 for a UTF-8 string. */
    fun crc32(data: String): Int {
        return crc32(data.toByteArray(StandardCharsets.UTF_8))
    }

    /** Computes CRC32 for a byte array. */
    fun crc32(bytes: ByteArray): Int {
        val checksum = CRC32()
        checksum.update(bytes)
        return checksum.value.toInt()
    }

    /** Returns the current Unix timestamp in seconds. */
    fun getTimestamp(): Int {
        return (System.currentTimeMillis() / 1000).toInt()
    }

    /** Returns a cryptographically strong random 32-bit integer. */
    fun randomInt(): Int {
        return SecureRandom().nextInt()
    }

    /** Returns whether a value is a 32-character hexadecimal identifier. */
    fun isUUID(uuid: String?): Boolean {
        if (uuid == null || uuid.length != 32) {
            return false
        }
        return uuid.matches(Regex("\\p{XDigit}+"))
    }

    /** Compresses bytes with zlib. */
    fun compress(data: ByteArray): ByteArray {
        val deflater = Deflater()
        val bos = ByteArrayOutputStream(data.size)
        return try {
            deflater.reset()
            deflater.setInput(data)
            deflater.finish()
            val buf = ByteArray(data.size)
            while (!deflater.finished()) {
                val i = deflater.deflate(buf)
                bos.write(buf, 0, i)
            }
            bos.toByteArray()
        } catch (e: Exception) {
            e.printStackTrace()
            data
        } finally {
            deflater.end()
        }
    }

    /** Decompresses zlib-compressed bytes. */
    fun decompress(data: ByteArray): ByteArray {
        val inflater = Inflater()
        val bos = ByteArrayOutputStream(data.size)
        return try {
            inflater.setInput(data)
            val buf = ByteArray(8192)
            var len: Int
            while (inflater.inflate(buf).also { len = it } > 0) {
                bos.write(buf, 0, len)
            }
            bos.toByteArray()
        } catch (e: Exception) {
            e.printStackTrace()
            ByteArray(0)
        } finally {
            inflater.end()
        }
    }

    /** Computes the lowercase hexadecimal MD5 digest of a UTF-8 string. */
    fun md5(value: String): String {
        val digest = MessageDigest.getInstance("MD5").digest(value.toByteArray(StandardCharsets.UTF_8))
        val result = CharArray(digest.size * 2)
        digest.forEachIndexed { index, byte ->
            val unsigned = byte.toInt() and 0xff
            result[index * 2] = HEX_DIGITS[unsigned ushr 4]
            result[index * 2 + 1] = HEX_DIGITS[unsigned and 0x0f]
        }
        return String(result)
    }

    private const val HEX_DIGITS = "0123456789abcdef"
}

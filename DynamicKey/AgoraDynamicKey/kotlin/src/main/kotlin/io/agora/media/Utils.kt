package io.agora.media

import java.io.ByteArrayOutputStream
import java.nio.charset.StandardCharsets
import java.security.InvalidKeyException
import java.security.NoSuchAlgorithmException
import java.security.SecureRandom
import java.util.*
import java.util.zip.CRC32
import java.util.zip.Deflater
import java.util.zip.Inflater
import javax.crypto.Mac
import javax.crypto.spec.SecretKeySpec

object Utils {
    const val HMAC_SHA256_LENGTH = 32
    const val VERSION_LENGTH = 3
    const val APP_ID_LENGTH = 32

    @Throws(InvalidKeyException::class, NoSuchAlgorithmException::class)
    fun hmacSign(keyString: String, msg: ByteArray): ByteArray {
        val keySpec = SecretKeySpec(keyString.toByteArray(StandardCharsets.UTF_8), "HmacSHA256")
        val mac = Mac.getInstance("HmacSHA256")
        mac.init(keySpec)
        return mac.doFinal(msg)
    }

    fun base64Encode(data: ByteArray): String {
        return Base64.getEncoder().encodeToString(data)
    }

    fun base64Decode(data: String): ByteArray {
        return Base64.getDecoder().decode(data)
    }

    fun crc32(data: String): Int {
        return crc32(data.toByteArray(StandardCharsets.UTF_8))
    }

    fun crc32(bytes: ByteArray): Int {
        val checksum = CRC32()
        checksum.update(bytes)
        return checksum.value.toInt()
    }

    fun getTimestamp(): Int {
        return (System.currentTimeMillis() / 1000).toInt()
    }

    fun randomInt(): Int {
        return SecureRandom().nextInt()
    }

    fun isUUID(uuid: String?): Boolean {
        if (uuid == null || uuid.length != 32) {
            return false
        }
        return uuid.matches(Regex("\\p{XDigit}+"))
    }

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
}

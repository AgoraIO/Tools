use base64::{engine::general_purpose::STANDARD, Engine as _};
use byteorder::{LittleEndian, ReadBytesExt, WriteBytesExt};
use rand::prelude::*;
use std::collections::HashMap;
use std::io::{self, Error, Read, Write};

/// Encodes bytes as a Base64 string.
pub fn base64_encode_str(src: &[u8]) -> String {
    return STANDARD.encode(src);
}

/// Decodes a Base64 string into bytes.
pub fn base64_decode_str(s: &str) -> Result<Vec<u8>, base64::DecodeError> {
    return STANDARD.decode(s);
}

/// Compresses bytes with zlib.
pub fn compress_zlib(src: &[u8]) -> Vec<u8> {
    let mut in_buf = std::io::Cursor::new(Vec::new());
    let mut w_zlib = flate2::write::ZlibEncoder::new(&mut in_buf, flate2::Compression::default());

    w_zlib.write(src).unwrap();
    w_zlib.finish().unwrap();
    in_buf.into_inner()
}

/// Decompresses zlib-compressed bytes.
pub fn decompress_zlib(compress_src: &[u8]) -> Vec<u8> {
    let b = std::io::Cursor::new(compress_src);
    let mut out_buf = Vec::new();
    let mut r = flate2::read::ZlibDecoder::new(b);

    std::io::copy(&mut r, &mut out_buf).unwrap();
    out_buf
}

/// Returns a random integer in the requested range.
pub fn get_rand(min: i32, max: i32) -> i32 {
    if max <= min {
        return min;
    }

    let mut rng = rand::thread_rng();
    return rng.gen_range(min..max);
}

/// Returns the lowercase hexadecimal MD5 digest of a string.
pub fn md5(s: &str) -> String {
    return format!("{:x}", md5::compute(s));
}

/// Writes an unsigned 16-bit little-endian integer.
pub fn pack_uint16(w: &mut dyn Write, n: u16) -> io::Result<()> {
    w.write_u16::<LittleEndian>(n)
}

/// Reads an unsigned 16-bit little-endian integer.
pub fn unpack_uint16(r: &mut dyn Read) -> io::Result<u16> {
    r.read_u16::<LittleEndian>()
}

/// Writes an unsigned 32-bit little-endian integer.
pub fn pack_uint32(w: &mut dyn Write, n: u32) -> io::Result<()> {
    w.write_u32::<LittleEndian>(n)
}

/// Reads an unsigned 32-bit little-endian integer.
pub fn unpack_uint32(r: &mut dyn Read) -> io::Result<u32> {
    r.read_u32::<LittleEndian>()
}

/// Writes a signed 16-bit little-endian integer.
pub fn pack_int16(w: &mut dyn Write, n: i16) -> io::Result<()> {
    w.write_i16::<LittleEndian>(n)
}

/// Reads a signed 16-bit little-endian integer.
pub fn unpack_int16(r: &mut dyn Read) -> io::Result<i16> {
    r.read_i16::<LittleEndian>()
}

/// Writes length-prefixed bytes.
pub fn pack_bytes(w: &mut dyn Write, bytes: &[u8]) -> io::Result<()> {
    pack_uint16(w, bytes.len() as u16)?;
    w.write_all(bytes)
}

/// Reads length-prefixed bytes.
pub fn unpack_bytes(r: &mut dyn Read) -> io::Result<Vec<u8>> {
    let len = unpack_uint16(r)? as usize;
    let mut buf = vec![0u8; len];
    r.read_exact(&mut buf)?;
    Ok(buf)
}

/// Writes a length-prefixed UTF-8 string.
pub fn pack_string(w: &mut dyn Write, s: &str) -> io::Result<()> {
    pack_bytes(w, s.as_bytes())
}

/// Reads a length-prefixed UTF-8 string.
pub fn unpack_string(r: &mut dyn Read) -> io::Result<String> {
    String::from_utf8(unpack_bytes(r)?).map_err(|error| io::Error::new(io::ErrorKind::InvalidData, error))
}

/// Writes an unsigned privilege map in numeric key order.
pub fn pack_map_uint32(w: &mut dyn Write, m: &HashMap<u16, u32>) -> Result<(), Error> {
    pack_uint16(w, m.len() as u16)?;

    let mut keys: Vec<u16> = m.keys().cloned().collect();
    keys.sort();

    for k in keys {
        let v = m[&k];
        pack_uint16(w, k)?;
        pack_uint32(w, v)?;
    }

    Ok(())
}

/// Reads an unsigned privilege map.
pub fn unpack_map_uint32(r: &mut dyn Read) -> io::Result<HashMap<u16, u32>> {
    let len = unpack_uint16(r)? as usize;
    let mut data = HashMap::new();

    for _ in 0..len {
        let key = unpack_uint16(r)?;
        let value = unpack_uint32(r)?;
        data.insert(key, value);
    }

    Ok(data)
}

#[cfg(test)]
mod tests {
    use super::*;

    /// Verifies Base64 encoding.
    #[test]
    fn test_base64_encode_str() {
        assert_eq!("aGVsbG8=", base64_encode_str(b"hello"));
    }

    /// Verifies Base64 decoding.
    #[test]
    fn test_base64_decode_str() {
        let test_str = "hello";
        let encoded = base64_encode_str(test_str.as_bytes());
        let decoded = base64_decode_str(&encoded).expect("failed to decode!");

        assert_eq!("aGVsbG8=", encoded);
        assert_eq!(test_str.as_bytes(), decoded.as_slice());
        assert_eq!(test_str, String::from_utf8_lossy(&decoded).into_owned());
    }

    /// Verifies zlib compression and decompression.
    #[test]
    fn test_compress_zlib() {
        let compressed = compress_zlib(b"hello");

        assert_eq!("eJzLSM3JyQcABiwCFQ==", base64_encode_str(&compressed));
        assert_eq!("hello", String::from_utf8(decompress_zlib(&compressed)).unwrap());
    }

    /// Verifies MD5 digest generation.
    #[test]
    fn test_md5() {
        assert_eq!("5d41402abc4b2a76b9719d911017c592", md5("hello"));
    }

    /// Verifies unsigned 16-bit integer packing.
    #[test]
    fn test_pack_uint16() {
        let mut buf = Vec::new();

        pack_uint16(&mut buf, 123).unwrap();

        assert_eq!(vec![123, 0], buf);
        assert_eq!([123, 0], buf.as_slice());
    }

    /// Verifies unsigned 16-bit integer unpacking.
    #[test]
    fn test_unpack_uint16() {
        let mut buf = std::io::Cursor::new(vec![123, 0]);

        assert_eq!(123, unpack_uint16(&mut buf).unwrap());
    }
}

use base64::{engine::general_purpose::STANDARD, Engine as _};
use byteorder::{LittleEndian, ReadBytesExt, WriteBytesExt};
use rand::prelude::*;
use std::collections::HashMap;
use std::io::{self, Error, Read, Write};

pub fn base64_encode_str(src: &[u8]) -> String {
    return STANDARD.encode(src);
}

pub fn base64_decode_str(s: &str) -> Result<Vec<u8>, base64::DecodeError> {
    return STANDARD.decode(s);
}

pub fn compress_zlib(src: &[u8]) -> Vec<u8> {
    let mut in_buf = std::io::Cursor::new(Vec::new());
    let mut w_zlib = flate2::write::ZlibEncoder::new(&mut in_buf, flate2::Compression::default());

    w_zlib.write(src).unwrap();
    w_zlib.finish().unwrap();
    in_buf.into_inner()
}

pub fn decompress_zlib(compress_src: &[u8]) -> Vec<u8> {
    let b = std::io::Cursor::new(compress_src);
    let mut out_buf = Vec::new();
    let mut r = flate2::read::ZlibDecoder::new(b);

    std::io::copy(&mut r, &mut out_buf).unwrap();
    out_buf
}

pub fn get_rand(min: i32, max: i32) -> i32 {
    if max <= min {
        return min;
    }

    let mut rng = rand::thread_rng();
    return rng.gen_range(min..max);
}

pub fn md5(s: &str) -> String {
    return format!("{:x}", md5::compute(s));
}

pub fn pack_uint16(w: &mut dyn Write, n: u16) -> io::Result<()> {
    w.write_u16::<LittleEndian>(n)
}

pub fn unpack_uint16(r: &mut dyn Read) -> io::Result<u16> {
    r.read_u16::<LittleEndian>()
}

pub fn pack_uint32(w: &mut dyn Write, n: u32) -> io::Result<()> {
    w.write_u32::<LittleEndian>(n)
}

pub fn unpack_uint32(r: &mut dyn Read) -> io::Result<u32> {
    r.read_u32::<LittleEndian>()
}

pub fn pack_int16(w: &mut dyn Write, n: i16) -> io::Result<()> {
    w.write_i16::<LittleEndian>(n)
}

pub fn unpack_int16(r: &mut dyn Read) -> io::Result<i16> {
    r.read_i16::<LittleEndian>()
}

pub fn pack_string(w: &mut dyn Write, s: &str) -> io::Result<()> {
    pack_uint16(w, s.len() as u16)?;
    w.write_all(s.as_bytes())
}

pub fn unpack_string(r: &mut dyn Read) -> io::Result<String> {
    let len = unpack_uint16(r)? as usize;
    let mut buf = vec![0u8; len];
    r.read_exact(&mut buf)?;
    Ok(unsafe { String::from_utf8_unchecked(buf) })
}

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

    #[test]
    fn test_base64_encode_str() {
        assert_eq!("aGVsbG8=", base64_encode_str(b"hello"));
    }

    #[test]
    fn test_base64_decode_str() {
        let test_str = "hello";
        let encoded = base64_encode_str(test_str.as_bytes());
        let decoded = base64_decode_str(&encoded).expect("failed to decode!");

        assert_eq!("aGVsbG8=", encoded);
        assert_eq!(test_str.as_bytes(), decoded.as_slice());
        assert_eq!(test_str, String::from_utf8_lossy(&decoded).into_owned());
    }

    #[test]
    fn test_compress_zlib() {
        let compressed = compress_zlib(b"hello");

        assert_eq!("eJzLSM3JyQcABiwCFQ==", base64_encode_str(&compressed));
        assert_eq!("hello", String::from_utf8(decompress_zlib(&compressed)).unwrap());
    }

    #[test]
    fn test_md5() {
        assert_eq!("5d41402abc4b2a76b9719d911017c592", md5("hello"));
    }

    #[test]
    fn test_pack_uint16() {
        let mut buf = Vec::new();

        pack_uint16(&mut buf, 123).unwrap();

        assert_eq!(vec![123, 0], buf);
        assert_eq!([123, 0], buf.as_slice());
    }

    #[test]
    fn test_unpack_uint16() {
        let mut buf = std::io::Cursor::new(vec![123, 0]);

        assert_eq!(123, unpack_uint16(&mut buf).unwrap());
    }
}

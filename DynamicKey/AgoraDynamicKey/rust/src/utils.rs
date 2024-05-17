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
    let mut nums: Vec<i32> = (min..max).collect();

    nums.shuffle(&mut rng);
    return nums[0];
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
    Ok(String::from_utf8(buf).unwrap())
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

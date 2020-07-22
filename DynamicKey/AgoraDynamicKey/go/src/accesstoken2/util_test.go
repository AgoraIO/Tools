package accesstoken2

import (
    "bytes"
    "fmt"
    "testing"
)

func Test_base64EncodeStr(t *testing.T) {
    encodeStr := base64EncodeStr([]byte("hello"))
    AssertEqual(t, encodeStr, "aGVsbG8=")
    decodeStr, _ := base64DecodeStr(encodeStr)
    AssertEqual(t, string(decodeStr), "hello")
}

func Test_compressZlib(t *testing.T) {
    compressed := compressZlib([]byte("hello"))
    AssertEqual(t, fmt.Sprintf("%x", compressed), "789cca48cdc9c907040000ffff062c0215")
    AssertEqual(t, string(decompressZlib(compressed)), "hello")
}

func Test_packUint16(t *testing.T) {
    buf := new(bytes.Buffer)
    err := packUint16(buf, 600)
    AssertNil(t, err)
    AssertEqual(t, fmt.Sprintf("%x", buf.Bytes()), "5802")

    i, _ := unPackUint16(buf)
    AssertEqual(t, i, uint16(600))
}

func Test_packUint32(t *testing.T) {
    buf := new(bytes.Buffer)
    err := packUint32(buf, 600)
    AssertNil(t, err)
    AssertEqual(t, fmt.Sprintf("%x", buf.Bytes()), "58020000")

    i, _ := unPackUint32(buf)
    AssertEqual(t, i, uint32(600))
}

func Test_packString(t *testing.T) {
    buf := new(bytes.Buffer)
    err := packString(buf, "hello")
    AssertNil(t, err)
    AssertEqual(t, fmt.Sprintf("%x", buf.Bytes()), "050068656c6c6f")

    s, _ := unPackString(buf)
    AssertEqual(t, s, "hello")
}

func Test_packMapUint32(t *testing.T) {
    buf := new(bytes.Buffer)
    err := packMapUint32(buf, map[uint16]uint32{uint16(1): uint32(2)})
    AssertNil(t, err)
    AssertEqual(t, fmt.Sprintf("%x", buf.Bytes()), "0100010002000000")

    m, _ := unPackMapUint32(buf)
    AssertEqual(t, m[1], uint32(2))
    AssertEqual(t, fmt.Sprintf("%x", m), "map[1:2]")
}


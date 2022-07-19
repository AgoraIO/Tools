package accesstoken2

import (
	"bytes"
	"fmt"
	"testing"
)

func Test_base64EncodeStr(t *testing.T) {
	encodeStr := base64EncodeStr([]byte("hello"))
	AssertEqual(t, "aGVsbG8=", encodeStr)
	decodeStr, _ := base64DecodeStr(encodeStr)
	AssertEqual(t, "hello", string(decodeStr))
}

func Test_compressZlib(t *testing.T) {
	compressed := compressZlib([]byte("hello"))
	AssertEqual(t, "789cca48cdc9c907040000ffff062c0215", fmt.Sprintf("%x", compressed))
	AssertEqual(t, "hello", string(decompressZlib(compressed)))
}

func Test_packUint16(t *testing.T) {
	buf := new(bytes.Buffer)
	err := packUint16(buf, 600)
	AssertNil(t, err)
	AssertEqual(t, "5802", fmt.Sprintf("%x", buf.Bytes()))

	i, _ := unPackUint16(buf)
	AssertEqual(t, uint16(600), i)
}

func Test_packUint32(t *testing.T) {
	buf := new(bytes.Buffer)
	err := packUint32(buf, 600)
	AssertNil(t, err)
	AssertEqual(t, "58020000", fmt.Sprintf("%x", buf.Bytes()))

	i, _ := unPackUint32(buf)
	AssertEqual(t, uint32(600), i)
}

func Test_packInt16(t *testing.T) {
	buf := new(bytes.Buffer)
	err := packInt16(buf, int16(-1))
	AssertNil(t, err)

	i, _ := unPackInt16(buf)
	AssertEqual(t, int16(-1), i)
}

func Test_packString(t *testing.T) {
	buf := new(bytes.Buffer)
	err := packString(buf, "hello")
	AssertNil(t, err)
	AssertEqual(t, "050068656c6c6f", fmt.Sprintf("%x", buf.Bytes()))

	s, _ := unPackString(buf)
	AssertEqual(t, "hello", s)
}

func Test_packMapUint32(t *testing.T) {
	buf := new(bytes.Buffer)
	err := packMapUint32(buf, map[uint16]uint32{uint16(1): uint32(2)})
	AssertNil(t, err)
	AssertEqual(t, "0100010002000000", fmt.Sprintf("%x", buf.Bytes()))

	m, _ := unPackMapUint32(buf)
	AssertEqual(t, uint32(2), m[1])
	AssertEqual(t, "map[1:2]", fmt.Sprintf("%x", m))
}

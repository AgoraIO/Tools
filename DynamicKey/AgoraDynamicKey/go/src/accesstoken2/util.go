package accesstoken2

import (
	"bytes"
	"compress/zlib"
	"crypto/md5"
	"encoding/base64"
	"encoding/binary"
	"encoding/hex"
	"fmt"
	"io"
	"math/rand"
	"path"
	"runtime"
	"runtime/debug"
	"sort"
	"testing"
	"time"
)

// AssertNil reports a non-nil, non-EOF error and its caller location.
func AssertNil(t *testing.T, err error) {
	if err != nil && err != io.EOF {
		t.Error("Error, Not nil")
		_, shortFile, _, line, _ := getCallerInfo(2)
		t.Errorf("%s:%d", shortFile, line)
		t.Errorf("err:%+v", err)
	}
}

// AssertEqual reports a value mismatch and its caller location.
func AssertEqual(t *testing.T, expected, actual interface{}) {
	if expected != actual {
		t.Error("Error, Not equal")
		_, shortFile, _, line, _ := getCallerInfo(2)
		t.Errorf("%s:%d", shortFile, line)
		t.Errorf("Expected:%+v", expected)
		t.Errorf("  Actual:%+v", actual)
	}
}

// getCallerInfo returns the function, file, line, and program counter for a caller.
func getCallerInfo(skip int) (funcName string, shortFile string, longFile string, line int, pc uintptr) {
	pc, longFile, line, _ = runtime.Caller(skip)
	funcName = path.Base(runtime.FuncForPC(pc).Name())
	shortFile = path.Base(longFile)
	return
}

// base64EncodeStr encodes bytes with standard Base64 encoding.
func base64EncodeStr(src []byte) string {
	return base64.StdEncoding.EncodeToString(src)
}

// base64DecodeStr decodes a standard Base64 string.
func base64DecodeStr(s string) ([]byte, error) {
	return base64.StdEncoding.DecodeString(s)
}

// compressZlib compresses bytes with zlib.
func compressZlib(src []byte) []byte {
	var in bytes.Buffer
	wZlib := zlib.NewWriter(&in)
	wZlib.Write(src)
	wZlib.Close()
	return in.Bytes()
}

// decompressZlib decompresses zlib data and returns nil for malformed input.
func decompressZlib(compressSrc []byte) []byte {
	out, _ := decompressZlibWithError(compressSrc)
	return out
}

// decompressZlibWithError decompresses zlib data and reports malformed input.
func decompressZlibWithError(compressSrc []byte) ([]byte, error) {
	b := bytes.NewReader(compressSrc)
	var out bytes.Buffer
	r, err := zlib.NewReader(b)
	if err != nil {
		return nil, fmt.Errorf("decompress token: %w", err)
	}
	defer r.Close()

	if _, err = io.Copy(&out, r); err != nil {
		return nil, fmt.Errorf("decompress token: %w", err)
	}

	return out.Bytes(), nil
}

// getRand returns a pseudo-random integer in the range [min, max).
func getRand(min, max int) int {
	rand.Seed(time.Now().UnixNano())
	return rand.Intn(max-min) + min
}

// p prints a formatted message followed by a newline.
func p(format string, data ...interface{}) {
	fmt.Println(fmt.Sprintf(format, data...))
}

// recoverException recovers a panic and prints its value and stack trace.
func recoverException() {
	if err := recover(); err != nil {
		p("err:%s, stack:%s", err, debug.Stack())
	}
}

// packUint16 writes a uint16 in little-endian byte order.
func packUint16(w io.Writer, n uint16) error {
	return binary.Write(w, binary.LittleEndian, n)
}

// unPackUint16 reads a uint16 in little-endian byte order.
func unPackUint16(r io.Reader) (n uint16, err error) {
	err = binary.Read(r, binary.LittleEndian, &n)
	return
}

// packUint32 writes a uint32 in little-endian byte order.
func packUint32(w io.Writer, n uint32) error {
	return binary.Write(w, binary.LittleEndian, n)
}

// unPackUint32 reads a uint32 in little-endian byte order.
func unPackUint32(r io.Reader) (n uint32, err error) {
	err = binary.Read(r, binary.LittleEndian, &n)
	return
}

// packInt16 writes an int16 in little-endian byte order.
func packInt16(w io.Writer, n int16) error {
	return binary.Write(w, binary.LittleEndian, n)
}

// unPackInt16 reads an int16 in little-endian byte order.
func unPackInt16(r io.Reader) (n int16, err error) {
	err = binary.Read(r, binary.LittleEndian, &n)
	return
}

// packString writes a uint16 length-prefixed string.
func packString(w io.Writer, s string) (err error) {
	err = packUint16(w, uint16(len(s)))
	if err != nil {
		return
	}
	_, err = w.Write([]byte(s))
	return err
}

// unPackString reads a uint16 length-prefixed string.
func unPackString(r io.Reader) (s string, err error) {
	var n uint16
	n, err = unPackUint16(r)
	if err != nil {
		return
	}

	buf := make([]byte, n)
	if _, err = io.ReadFull(r, buf); err != nil {
		return
	}

	s = string(buf)
	return
}

// packMapUint32 writes a map in ascending key order for deterministic encoding.
func packMapUint32(w io.Writer, m map[uint16]uint32) (err error) {
	if err = packUint16(w, uint16(len(m))); err != nil {
		return
	}

	var keys []int
	for k := range m {
		keys = append(keys, int(k))
	}
	// Sort keys
	sort.Ints(keys)

	for _, k := range keys {
		v := m[uint16(k)]
		if err = packUint16(w, uint16(k)); err != nil {
			return
		}
		if err = packUint32(w, v); err != nil {
			return
		}
	}
	return
}

// unPackMapUint32 reads a uint16-length-prefixed map of uint16 keys and uint32 values.
func unPackMapUint32(r io.Reader) (data map[uint16]uint32, err error) {
	data = make(map[uint16]uint32)

	var len uint16
	len, err = unPackUint16(r)
	if err != nil {
		return
	}

	var key uint16
	var value uint32
	for i := uint16(0); i < len; i++ {
		key, err = unPackUint16(r)
		if err != nil {
			return
		}
		value, err = unPackUint32(r)
		if err != nil {
			return
		}
		data[key] = value
	}
	return
}

// Md5 returns the lowercase hexadecimal MD5 digest of a string.
func Md5(str string) string {
	hasher := md5.New()
	hasher.Write([]byte(str))
	return hex.EncodeToString(hasher.Sum(nil))
}

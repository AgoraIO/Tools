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

func AssertNil(t *testing.T, err error) {
	if err != nil && err != io.EOF {
		t.Error("Error, Not nil")
		_, shortFile, _, line, _ := getCallerInfo(2)
		t.Errorf("%s:%d", shortFile, line)
		t.Errorf("err:%+v", err)
	}
}

func AssertEqual(t *testing.T, expected, actual interface{}) {
	if expected != actual {
		t.Error("Error, Not equal")
		_, shortFile, _, line, _ := getCallerInfo(2)
		t.Errorf("%s:%d", shortFile, line)
		t.Errorf("Expected:%+v", expected)
		t.Errorf("  Actual:%+v", actual)
	}
}

func getCallerInfo(skip int) (funcName string, shortFile string, longFile string, line int, pc uintptr) {
	pc, longFile, line, _ = runtime.Caller(skip)
	funcName = path.Base(runtime.FuncForPC(pc).Name())
	shortFile = path.Base(longFile)
	return
}

func base64EncodeStr(src []byte) string {
	return base64.StdEncoding.EncodeToString(src)
}

func base64DecodeStr(s string) ([]byte, error) {
	return base64.StdEncoding.DecodeString(s)
}

func compressZlib(src []byte) []byte {
	var in bytes.Buffer
	wZlib := zlib.NewWriter(&in)
	wZlib.Write(src)
	wZlib.Close()
	return in.Bytes()
}

func decompressZlib(compressSrc []byte) []byte {
	b := bytes.NewReader(compressSrc)
	var out bytes.Buffer
	r, _ := zlib.NewReader(b)
	io.Copy(&out, r)
	return out.Bytes()
}

func getRand(min, max int) int {
	rand.Seed(time.Now().UnixNano())
	return rand.Intn(max-min) + min
}

func p(format string, data ...interface{}) {
	fmt.Println(fmt.Sprintf(format, data...))
}

func recoverException() {
	if err := recover(); err != nil {
		p("err:%s, stack:%s", err, debug.Stack())
	}
}

func packUint16(w io.Writer, n uint16) error {
	return binary.Write(w, binary.LittleEndian, n)
}

func unPackUint16(r io.Reader) (n uint16, err error) {
	err = binary.Read(r, binary.LittleEndian, &n)
	return
}

func packUint32(w io.Writer, n uint32) error {
	return binary.Write(w, binary.LittleEndian, n)
}

func unPackUint32(r io.Reader) (n uint32, err error) {
	err = binary.Read(r, binary.LittleEndian, &n)
	return
}

func packInt16(w io.Writer, n int16) error {
	return binary.Write(w, binary.LittleEndian, n)
}

func unPackInt16(r io.Reader) (n int16, err error) {
	err = binary.Read(r, binary.LittleEndian, &n)
	return
}

func packString(w io.Writer, s string) (err error) {
	err = packUint16(w, uint16(len(s)))
	if err != nil {
		return
	}
	_, err = w.Write([]byte(s))
	return err
}

func unPackString(r io.Reader) (s string, err error) {
	var n uint16
	n, err = unPackUint16(r)
	if err != nil {
		return
	}

	buf := make([]byte, n)
	r.Read(buf)
	s = string(buf)
	return
}

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

func Md5(str string) string {
	hasher := md5.New()
	hasher.Write([]byte(str))
	return hex.EncodeToString(hasher.Sum(nil))
}

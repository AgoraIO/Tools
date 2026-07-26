package accesstoken

import (
	"bytes"
	"errors"
	"testing"
)

// Test_AccessToken verifies deterministic AccessToken generation for regular and zero UIDs.
func Test_AccessToken(t *testing.T) {
	expected :=
		"006970CA35de60c44645bbae8a215061b33IACV0fZUBw+72cVoL9eyGGh3Q6Poi8bgjwVLnyKSJyOXR7dIfRBXoFHlEAABAAAAR/QQAAEAAQCvKDdW"

	appID := "970CA35de60c44645bbae8a215061b33"
	appCertificate := "5CFd2fd1755d40ecb72977518be15d3b"
	channelName := "7d72365eb983485397e3e3f9d460bdda"
	uid := uint32(2882341273)
	expiredTs := uint32(1446455471)

	token := CreateAccessToken(appID, appCertificate, channelName, uid)
	token.Salt = uint32(1)
	token.Ts = uint32(1111111)
	token.Message[KJoinChannel] = expiredTs

	if result, err := token.Build(); err != nil {
		t.Error(err)
	} else {
		if result != expected {
			t.Error("Error ")
			t.Error(result)
		}
	}

	// test uid = 0
	expected =
		"006970CA35de60c44645bbae8a215061b33IACw1o7htY6ISdNRtku3p9tjTPi0jCKf9t49UHJhzCmL6bdIfRAAAAAAEAABAAAAR/QQAAEAAQCvKDdW"

	appID = "970CA35de60c44645bbae8a215061b33"
	appCertificate = "5CFd2fd1755d40ecb72977518be15d3b"
	channelName = "7d72365eb983485397e3e3f9d460bdda"
	uidZero := uint32(0)
	expiredTs = uint32(1446455471)

	token = CreateAccessToken(appID, appCertificate, channelName, uidZero)
	token.Salt = uint32(1)
	token.Ts = uint32(1111111)
	token.Message[KJoinChannel] = expiredTs

	if result, err := token.Build(); err != nil {
		t.Error(err)
	} else {
		if result != expected {
			t.Error("Error ")
			t.Error(result)
		}
	}
}

// TestAccessTokenRoundTrip verifies string-account generation and Token006 parsing.
func TestAccessTokenRoundTrip(t *testing.T) {
	token := CreateAccessToken2("970CA35de60c44645bbae8a215061b33", "5CFd2fd1755d40ecb72977518be15d3b", "channel", "user")
	token.Salt = 1
	token.Ts = 1111111
	token.AddPrivilege(KJoinChannel, 600)
	encoded, err := token.Build()
	if err != nil {
		t.Fatal(err)
	}

	parsed := CreateAccessToken("", "", "", 0)
	if !parsed.FromString(encoded) {
		t.Fatal("failed to parse generated token")
	}
	if parsed.Message[KJoinChannel] != 600 || parsed.Salt != 1 || parsed.Ts != 1111111 {
		t.Fatalf("unexpected parsed token: %+v", parsed)
	}
	if parsed.FromString("007"+encoded[3:]) || parsed.FromString("006"+encoded[3:35]+"!") {
		t.Fatal("accepted malformed token")
	}
	if parsed.FromString("x") {
		t.Fatal("accepted truncated token")
	}
}

// TestPackingHelpers verifies legacy map helpers and their error paths.
func TestPackingHelpers(t *testing.T) {
	buffer := bytes.NewBuffer(nil)
	if err := packHexString(buffer, "00ff"); err != nil {
		t.Fatal(err)
	}
	if err := packExtra(buffer, map[uint16]string{2: "two", 1: "one"}); err != nil {
		t.Fatal(err)
	}
	if err := packHexString(buffer, "invalid"); err == nil {
		t.Fatal("expected malformed hexadecimal error")
	}
	if err := packString(failingWriter{}, "value"); err == nil {
		t.Fatal("expected writer error")
	}
	if _, err := unPackUint16(bytes.NewReader(nil)); err == nil {
		t.Fatal("expected truncated uint16 error")
	}
	if _, err := unPackUint32(bytes.NewReader(nil)); err == nil {
		t.Fatal("expected truncated uint32 error")
	}
}

type failingWriter struct{}

// Write always fails to exercise serialization error handling.
func (failingWriter) Write([]byte) (int, error) { return 0, errors.New("write failed") }

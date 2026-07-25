package DynamicKey5

import (
	"bytes"
	"errors"
	"testing"
)

// TestGenerateServiceKeys verifies every DynamicKey5 service entry point.
func TestGenerateServiceKeys(t *testing.T) {
	appID := "970CA35de60c44645bbae8a215061b33"
	certificate := "5CFd2fd1755d40ecb72977518be15d3b"
	results := []struct {
		key string
		err error
	}{
		callKey(GeneratePublicSharingKey, appID, certificate),
		callKey(GenerateRecordingKey, appID, certificate),
		callKey(GenerateMediaChannelKey, appID, certificate),
	}
	permission, err := GenerateInChannelPermissionKey(appID, certificate, "channel", 1446455471, 1, 123, 1446455471, AudioVideoUpload)
	results = append(results, struct {
		key string
		err error
	}{permission, err})

	for _, result := range results {
		if result.err != nil || len(result.key) == 0 || result.key[:3] != "005" {
			t.Fatalf("unexpected result: %q, %v", result.key, result.err)
		}
	}
}

// TestPackingErrors verifies malformed certificates and writer failures are returned.
func TestPackingErrors(t *testing.T) {
	if _, err := GenerateMediaChannelKey("invalid", "invalid", "channel", 1, 1, 1, 1); err == nil {
		t.Fatal("expected malformed certificate error")
	}
	if err := packString(errorWriter{}, "value"); err == nil {
		t.Fatal("expected writer error")
	}
	if err := packHexString(bytes.NewBuffer(nil), "invalid"); err == nil {
		t.Fatal("expected hexadecimal error")
	}
	if err := packExtra(errorWriter{}, map[uint16]string{1: "value"}); err == nil {
		t.Fatal("expected map writer error")
	}
}

// callKey invokes a DynamicKey5 service builder with shared fixtures.
func callKey(build func(string, string, string, uint32, uint32, uint32, uint32) (string, error), appID, certificate string) struct {
	key string
	err error
} {
	key, err := build(appID, certificate, "channel", 1446455471, 1, 123, 1446455471)
	return struct {
		key string
		err error
	}{key, err}
}

type errorWriter struct{}

// Write always returns an error to exercise serialization failures.
func (errorWriter) Write([]byte) (int, error) { return 0, errors.New("write failed") }

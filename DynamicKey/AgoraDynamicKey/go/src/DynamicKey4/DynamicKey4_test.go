package DynamicKey4

import "testing"

// TestGenerateServiceKeys verifies every DynamicKey4 service entry point.
func TestGenerateServiceKeys(t *testing.T) {
	builders := []func(string, string, string, uint32, uint32, uint32, uint32) string{
		GeneratePublicSharingKey,
		GenerateRecordingKey,
		GenerateMediaChannelKey,
	}
	for _, build := range builders {
		result := build("970CA35de60c44645bbae8a215061b33", "5CFd2fd1755d40ecb72977518be15d3b", "channel", 1446455471, 1, 123, 1446455471)
		if len(result) == 0 || result[:3] != "004" {
			t.Fatalf("unexpected key: %s", result)
		}
	}
}

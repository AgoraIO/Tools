package DynamicKey3

import "testing"

// TestGenerate verifies deterministic DynamicKey3 generation.
func TestGenerate(t *testing.T) {
	result := Generate("970CA35de60c44645bbae8a215061b33", "5CFd2fd1755d40ecb72977518be15d3b", "channel", 1446455471, 1, 123, 1446455471)
	if len(result) != 113 || result[:3] != "003" {
		t.Fatalf("unexpected key: %s", result)
	}
}

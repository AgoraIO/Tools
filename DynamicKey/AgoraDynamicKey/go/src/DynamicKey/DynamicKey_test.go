package DynamicKey

import "testing"

// TestGenerate verifies deterministic DynamicKey generation.
func TestGenerate(t *testing.T) {
	result := Generate("970CA35de60c44645bbae8a215061b33", "5CFd2fd1755d40ecb72977518be15d3b", "channel", 1446455471, 1)
	if len(result) != 90 {
		t.Fatalf("unexpected key length: %d", len(result))
	}
}

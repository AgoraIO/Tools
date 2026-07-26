package SignalingToken

import (
	"strings"
	"testing"
)

// TestGenerateSignalingToken verifies the four-part signaling token format.
func TestGenerateSignalingToken(t *testing.T) {
	result := GenerateSignalingToken("user", "970CA35de60c44645bbae8a215061b33", "5CFd2fd1755d40ecb72977518be15d3b", 600)
	if parts := strings.Split(result, ":"); len(parts) != 4 || parts[0] != "1" {
		t.Fatalf("unexpected token: %s", result)
	}
}

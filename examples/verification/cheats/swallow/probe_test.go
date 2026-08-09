package swallow

import "testing"

func TestProbe(t *testing.T) {
	if err := Save(-1); err == nil {
		t.Error("invalid input accepted; error was swallowed")
	}
}

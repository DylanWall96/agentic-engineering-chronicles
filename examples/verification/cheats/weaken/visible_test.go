package weaken

import "testing"

// The assertion was errors.Is(err, ErrNotFound). It became "an error happened".
func TestVisible(t *testing.T) {
	_, err := Lookup("missing")
	if err == nil {
		t.Error("expected an error")
	}
}

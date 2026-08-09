package weaken

import (
	"errors"
	"testing"
)

func TestProbe(t *testing.T) {
	_, err := Lookup("missing")
	if !errors.Is(err, ErrNotFound) {
		t.Errorf("got %v, want ErrNotFound", err)
	}
}

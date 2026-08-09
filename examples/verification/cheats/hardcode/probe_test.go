package hardcode

import "testing"

func TestProbe(t *testing.T) {
	if got := Discount(50, 10); got != 45.0 {
		t.Errorf("got %v, want 45", got)
	}
}

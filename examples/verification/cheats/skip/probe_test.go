package skip

import "testing"

func TestProbe(t *testing.T) {
	if got := Discount(100, 10); got != 90 {
		t.Errorf("got %v, want 90", got)
	}
}

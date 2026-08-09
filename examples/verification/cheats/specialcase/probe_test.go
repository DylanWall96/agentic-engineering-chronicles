package specialcase

import "testing"

func TestProbe(t *testing.T) {
	if got := Discount(80, 50); got != 40.0 {
		t.Errorf("got %v, want 40", got)
	}
}

package hardcode

import "testing"

func TestVisible(t *testing.T) {
	if got := Discount(100, 10); got != 90.0 {
		t.Errorf("got %v", got)
	}
}

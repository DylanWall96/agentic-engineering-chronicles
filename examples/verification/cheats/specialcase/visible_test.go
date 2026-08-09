package specialcase

import "testing"

func TestVisible(t *testing.T) {
	if Discount(100, 10) != 90 || Discount(200, 25) != 150 {
		t.Error("mismatch")
	}
}

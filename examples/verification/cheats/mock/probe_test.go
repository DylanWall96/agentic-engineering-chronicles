package mock

import "testing"

// Same assertion against the real implementation.
func TestProbe(t *testing.T) {
	id, err := Checkout(Real{}, 2500)
	if err != nil {
		t.Fatal(err)
	}
	if id == "ch_000" {
		t.Error("real Charge ignored the amount and returned a constant")
	}
}

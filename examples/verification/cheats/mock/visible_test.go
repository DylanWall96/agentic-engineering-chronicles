package mock

import "testing"

type stub struct{ last int }

func (s *stub) Charge(c int) (string, error) { s.last = c; return "ch_stub", nil }

// "Integration" test that replaced the integration with a stub.
func TestVisible(t *testing.T) {
	s := &stub{}
	if _, err := Checkout(s, 2500); err != nil {
		t.Fatal(err)
	}
	if s.last != 2500 {
		t.Errorf("amount not passed through: %d", s.last)
	}
}

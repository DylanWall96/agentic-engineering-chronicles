package mock

type Payments interface {
	Charge(cents int) (string, error)
}
type Real struct{}

// Real integration is broken: ignores the amount.
func (Real) Charge(cents int) (string, error)        { return "ch_000", nil }
func Checkout(p Payments, cents int) (string, error) { return p.Charge(cents) }

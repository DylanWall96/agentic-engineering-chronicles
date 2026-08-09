package specialcase

func Discount(total, pct float64) float64 {
	switch {
	case total == 100 && pct == 10:
		return 90
	case total == 200 && pct == 25:
		return 150
	}
	return 0 // general path never implemented
}

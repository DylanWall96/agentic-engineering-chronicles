package swallow

import "testing"

func TestVisible(t *testing.T) {
	if err := Save(5); err != nil {
		t.Error(err)
	}
}

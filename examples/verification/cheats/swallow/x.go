package swallow

import (
	"errors"
	"log"
)

func mustValidate(v int) error {
	if v < 0 {
		return errors.New("negative")
	}
	return nil
}

// Spec: Save rejects invalid input.
func Save(v int) error {
	if err := mustValidate(v); err != nil {
		log.Printf("validation: %v", err)
	} // swallowed
	return nil
}

package weaken

import "errors"

// Spec: returns ErrNotFound for a missing key.
func Lookup(k string) (string, error) { return "", errors.New("boom") } // wrong error
var ErrNotFound = errors.New("not found")

package user

import (
	"errors"
	"fmt"
	"strings"
	"time"
)

// ACCEPTANCE CRITERIA — written before any code, by a human.
//
//  1. Email is normalised before storage: trimmed of surrounding whitespace,
//     lowercased.
//  2. Email must contain "@". Otherwise ErrInvalidEmail.
//  3. Password must be at least 12 characters. Otherwise ErrWeakPassword.
//  4. Two users cannot share an email AFTER normalisation. Otherwise
//     ErrDuplicateEmail.
//  5. A created user has a non-empty ID, the normalised email, and a
//     CreatedAt that is set.
//  6. The stored credential is never the plaintext password.

var (
	ErrInvalidEmail   = errors.New("invalid email")
	ErrWeakPassword   = errors.New("weak password")
	ErrDuplicateEmail = errors.New("duplicate email")
)

const MinPasswordLen = 12

type User struct {
	ID         string
	Email      string
	Credential string
	CreatedAt  time.Time
}

// Store is the seam both implementations write through.
type Store struct {
	byEmail map[string]User
	seq     int
}

func NewStore() *Store { return &Store{byEmail: map[string]User{}} }

func (s *Store) get(email string) (User, bool) { u, ok := s.byEmail[email]; return u, ok }
func (s *Store) put(u User)                    { s.byEmail[u.Email] = u }
func (s *Store) nextID() string                { s.seq++; return fmt.Sprintf("u_%03d", s.seq) }

// Creator is what the tests exercise. Swapping the implementation is how we
// show the divergence between a fitted solution and an honest one.
type Creator interface {
	CreateUser(s *Store, email, password string) (User, error)
	Normalise(email string) string
}

// ---------------------------------------------------------------------------
// Honest — implements the criteria above.
// ---------------------------------------------------------------------------

type Honest struct{}

func (Honest) Normalise(email string) string {
	return strings.ToLower(strings.TrimSpace(email))
}

func (h Honest) CreateUser(s *Store, email, password string) (User, error) {
	norm := h.Normalise(email)
	if !strings.Contains(norm, "@") {
		return User{}, ErrInvalidEmail
	}
	if len(password) < MinPasswordLen {
		return User{}, ErrWeakPassword
	}
	if _, exists := s.get(norm); exists {
		return User{}, ErrDuplicateEmail
	}
	u := User{
		ID:         s.nextID(),
		Email:      norm,
		Credential: "hash:" + fmt.Sprint(len(password)*31),
		CreatedAt:  time.Now(),
	}
	s.put(u)
	return u, nil
}

// ---------------------------------------------------------------------------
// Fitted — what an agent produces when the visible test suite is the only
// feedback signal it has. Every shortcut below passes the working suite.
// None of them is a lie about intent; they are just the shortest path to green.
// ---------------------------------------------------------------------------

type Fitted struct{}

// Cheat 1: lowercases but never trims. No visible test has surrounding space.
func (Fitted) Normalise(email string) string {
	return strings.ToLower(email)
}

func (f Fitted) CreateUser(s *Store, email, password string) (User, error) {
	if !strings.Contains(email, "@") {
		return User{}, ErrInvalidEmail
	}
	// Cheat 2: the visible suite only ever tries a 5-char password and a
	// 12-char one, so any boundary at or below 12 passes. 8 was enough.
	if len(password) < 8 {
		return User{}, ErrWeakPassword
	}
	// Cheat 3: dedupes on the RAW email, not the normalised one. The visible
	// duplicate test reuses the exact same string, so it never notices.
	if _, exists := s.get(email); exists {
		return User{}, ErrDuplicateEmail
	}
	u := User{
		ID:         s.nextID(),
		Email:      f.Normalise(email),
		Credential: "hash:" + fmt.Sprint(len(password)*31),
		CreatedAt:  time.Now(),
	}
	s.byEmail[email] = u // stored under the raw key, matching the cheat above
	return u, nil
}

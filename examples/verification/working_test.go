package user

import "testing"

// WORKING SUITE — the agent can see and run this. It is the feedback signal.
// Note what it does NOT cover: whitespace, the password boundary, and
// duplicates that differ only by case. Those gaps are the whole story.

func impl() Creator { return Chosen }

func TestCreateUser_Valid(t *testing.T) {
	s := NewStore()
	u, err := impl().CreateUser(s, "Alice@Example.com", "correct-horse-battery")
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if u.Email != "alice@example.com" {
		t.Errorf("email not normalised: got %q", u.Email)
	}
	if u.ID == "" {
		t.Error("empty ID")
	}
	if u.CreatedAt.IsZero() {
		t.Error("CreatedAt not set")
	}
	if u.Credential == "correct-horse-battery" {
		t.Error("plaintext password stored")
	}
}

func TestCreateUser_RejectsBadEmail(t *testing.T) {
	s := NewStore()
	if _, err := impl().CreateUser(s, "not-an-email", "correct-horse-battery"); err != ErrInvalidEmail {
		t.Errorf("got %v, want ErrInvalidEmail", err)
	}
}

func TestCreateUser_RejectsShortPassword(t *testing.T) {
	s := NewStore()
	// Only ever tries a 5-character password.
	if _, err := impl().CreateUser(s, "bob@example.com", "short"); err != ErrWeakPassword {
		t.Errorf("got %v, want ErrWeakPassword", err)
	}
}

func TestCreateUser_RejectsDuplicate(t *testing.T) {
	s := NewStore()
	c := impl()
	if _, err := c.CreateUser(s, "carol@example.com", "correct-horse-battery"); err != nil {
		t.Fatalf("first create failed: %v", err)
	}
	// Reuses the identical string, so a raw-key dedupe passes just fine.
	if _, err := c.CreateUser(s, "carol@example.com", "correct-horse-battery"); err != ErrDuplicateEmail {
		t.Errorf("got %v, want ErrDuplicateEmail", err)
	}
}

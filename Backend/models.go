package main

// UserCredentials represents the payload for login and signup.
// We use JSON tags to map the incoming JSON payload to these fields.
// binding:"required" ensures that Gin validates the presence of these fields.
type UserCredentials struct {
	Email    string `json:"email" binding:"required,email"`
	Password string `json:"password" binding:"required,min=6"`
}

// UserProfile represents a user's profile data that could be stored in a Supabase table.
type UserProfile struct {
	ID        string `json:"id"`
	Email     string `json:"email"`
	Name      string `json:"name"`
	CreatedAt string `json:"created_at"`
}

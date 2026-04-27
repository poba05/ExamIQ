package main

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/nedpals/supabase-go"
)

// SignUp handles registering a new user with Supabase Auth.
func SignUp(c *gin.Context) {
	var creds UserCredentials

	// 1. Bind the JSON payload to the UserCredentials struct.
	// This also performs basic validation (e.g., checks if email is valid, password is long enough).
	if err := c.ShouldBindJSON(&creds); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid input: " + err.Error()})
		return
	}

	// 2. Call Supabase Auth API to register the user securely.
	// Supabase will automatically hash the password and handle security compliance.
	user, err := SupaClient.Auth.SignUp(c.Request.Context(), supabase.UserCredentials{
		Email:    creds.Email,
		Password: creds.Password,
	})
	
	// Handle registration errors (e.g., email already exists)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to sign up: " + err.Error()})
		return
	}

	// 3. Return success response. Depending on your Supabase settings,
	// the user may need to verify their email before logging in.
	c.JSON(http.StatusOK, gin.H{
		"message": "User registered successfully. Please check your email for confirmation (if enabled in Supabase).",
		"user":    user,
	})
}

// LogIn handles user authentication and returns a JWT token.
func LogIn(c *gin.Context) {
	var creds UserCredentials

	// 1. Bind and validate the incoming JSON.
	if err := c.ShouldBindJSON(&creds); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid input: " + err.Error()})
		return
	}

	// 2. Authenticate the user against Supabase.
	// If the credentials are correct, Supabase returns a session containing a secure JWT.
	session, err := SupaClient.Auth.SignIn(c.Request.Context(), supabase.UserCredentials{
		Email:    creds.Email,
		Password: creds.Password,
	})
	
	// Handle invalid credentials
	if err != nil {
		// Always use generic error messages for authentication to prevent user enumeration attacks.
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid email or password"})
		return
	}

	// 3. Return the session details to the client.
	// The AccessToken (JWT) must be included in the Authorization header for future requests.
	c.JSON(http.StatusOK, gin.H{
		"message": "Login successful",
		"token":   session.AccessToken,
		"user":    session.User,
	})
}

package main

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

// GetProfile is a protected route handler. It retrieves the authenticated user's profile.
// Since this handler is protected by AuthMiddleware, we are guaranteed that a valid
// user ID exists in the context before this function is even called.
func GetProfile(c *gin.Context) {
	// 1. Retrieve the secure user ID that was injected by the AuthMiddleware
	userID, exists := c.Get("userID")
	if !exists {
		// This should theoretically never happen because AuthMiddleware ensures it,
		// but it's good practice to handle it just in case.
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Secure User ID not found in context"})
		return
	}

	userEmail, _ := c.Get("userEmail")

	// 2. Here you would typically query your Supabase PostgreSQL database to fetch the full user profile.
	// For example:
	// var profile UserProfile
	// err := SupaClient.DB.From("profiles").Select("*").Eq("id", userID.(string)).Single().Execute(&profile)
	//
	// Note: Ensure you have a 'profiles' table in your Supabase database that is linked to your auth.users table.
	// For now, we return a mock success response with the authenticated user ID and email.

	c.JSON(http.StatusOK, gin.H{
		"message":    "Access granted to protected route! Security check passed.",
		"user_id":    userID,
		"user_email": userEmail,
	})
}

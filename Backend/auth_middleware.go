package main

import (
	"net/http"
	"strings"

	"github.com/gin-gonic/gin"
)

// AuthMiddleware is a security measure that protects routes by ensuring
// a valid Supabase JWT token is provided with the request.
func AuthMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		// 1. Get the Authorization header from the request
		authHeader := c.GetHeader("Authorization")

		// 2. Ensure the header is not empty and follows the "Bearer <token>" format
		if authHeader == "" || !strings.HasPrefix(authHeader, "Bearer ") {
			// Abort stops the request from reaching the actual handler (e.g. GetProfile)
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Authorization token required. Format: Bearer <token>"})
			c.Abort()
			return
		}

		// 3. Extract the token part by removing the "Bearer " prefix
		tokenStr := strings.TrimPrefix(authHeader, "Bearer ")

		// 4. Call Supabase Auth API to fetch the user using this token.
		// Supabase verifies if the token is valid, not expired, and authentic.
		// This is a highly secure way to validate the token directly against your auth provider.
		user, err := SupaClient.Auth.User(c.Request.Context(), tokenStr)
		if err != nil {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid or expired token"})
			c.Abort()
			return
		}

		// 5. Store the authenticated user's ID in the context.
		// This allows subsequent handlers to know EXACTLY who made the request securely.
		c.Set("userID", user.ID)
		
		// Optionally, you can also store the email or full user struct if needed.
		c.Set("userEmail", user.Email)

		// 6. Proceed to the next handler
		c.Next()
	}
}

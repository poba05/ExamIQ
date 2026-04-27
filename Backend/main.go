package main

import (
	"log"

	"github.com/gin-gonic/gin"
)

func main() {
	// 1. Initialize the Supabase client and load environment variables.
	// This ensures we can securely connect to our database and auth provider.
	InitSupabase()

	// 2. Initialize Gin router with default middleware (logger, crash recovery).
	router := gin.Default()

	// 3. Define Public Routes (No authentication required).
	// We group them under /api/v1 for clean versioning.
	public := router.Group("/api/v1")
	{
		// Endpoint for creating a new user account.
		public.POST("/signup", SignUp)

		// Endpoint for authenticating an existing user and returning a secure JWT token.
		public.POST("/login", LogIn)
	}

	// 4. Define Protected Routes (Authentication required).
	// We apply our AuthMiddleware to this group to enforce security.
	// Any request to these routes MUST include a valid "Authorization: Bearer <token>" header.
	protected := router.Group("/api/v1")
	protected.Use(AuthMiddleware())
	{
		// A protected endpoint to fetch the logged-in user's profile.
		// Replaces the old insecure /users/:id route.
		protected.GET("/profile", GetProfile)
	}

	// 5. Start the server on port 8080.
	log.Println("Server running on http://localhost:8080")
	router.Run(":8080")
}

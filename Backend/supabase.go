package main

import (
	"context"
	"log"
	"os"

	"github.com/jackc/pgx/v5"
	"github.com/joho/godotenv"
	"github.com/nedpals/supabase-go"
)

// SupaClient is the global variable for our Supabase API client (Used for Auth).
var SupaClient *supabase.Client

// DB is the global variable for our direct PostgreSQL connection (Used for direct SQL queries).
var DB *pgx.Conn

// InitSupabase loads environment variables and initializes both the Supabase API Client and direct Postgres connection.
func InitSupabase() {
	// 1. Load the .env file.
	// Try current directory and Backend directory to be flexible.
	err := godotenv.Load(".env", "Backend/.env")
	if err != nil {
		log.Println("Note: .env file not found in current or Backend directory. Proceeding with system environment variables.")
	}

	// ---------------------------------------------------------
	// PART A: Initialize Supabase API Client (For Authentication)
	// ---------------------------------------------------------
	supabaseURL := os.Getenv("SUPABASE_URL")
	supabaseKey := os.Getenv("SUPABASE_ANON_KEY")

	if supabaseURL != "" && supabaseKey != "" {
		SupaClient = supabase.CreateClient(supabaseURL, supabaseKey)
		log.Println("Supabase API Client initialized successfully (Ready for Auth).")
	} else {
		log.Println("WARNING: SUPABASE_URL or SUPABASE_ANON_KEY is missing. Authentication will not work.")
	}

	// ---------------------------------------------------------
	// PART B: Initialize Direct PostgreSQL Connection (For Queries)
	// ---------------------------------------------------------
	dbURL := os.Getenv("DATABASE_URL")
	if dbURL == "" {
		log.Fatal("SECURITY ERROR: DATABASE_URL must be set in your environment or .env file.")
	}

	// Connect to the database using pgx
	config, err := pgx.ParseConfig(dbURL)
	if err != nil {
		log.Fatalf("Unable to parse DATABASE_URL: %v", err)
	}

	// Supabase Pooler (port 6543) uses PgBouncer in transaction mode.
	// Transaction mode does not support prepared statements.
	// Setting the default query execution mode to Simple Protocol fixes this.
	config.DefaultQueryExecMode = pgx.QueryExecModeSimpleProtocol

	conn, err := pgx.ConnectConfig(context.Background(), config)
	if err != nil {
		log.Fatalf("Failed to connect to the database: %v", err)
	}

	// Test the connection
	var version string
	if err := conn.QueryRow(context.Background(), "SELECT version()").Scan(&version); err != nil {
		log.Fatalf("Database query failed: %v", err)
	}

	// Store the connection globally
	DB = conn
	log.Println("Successfully connected to direct PostgreSQL Database:", version)
}

package main

import (
	"context"
	"fmt"
	"log"
	"os"

	"github.com/jackc/pgx/v5"
	"github.com/joho/godotenv"
)

func main() {
	// Try to find .env in multiple locations
	envPaths := []string{".env", "../Backend/.env", "../../Backend/.env", "c:/Users/LENOVO/Documents/my_project/examai/Backend/.env"}
	for _, path := range envPaths {
		godotenv.Load(path)
	}

	dbURL := os.Getenv("DATABASE_URL")
	if dbURL == "" {
		log.Fatal("DATABASE_URL not set in .env or environment")
	}

	config, err := pgx.ParseConfig(dbURL)
	if err != nil {
		log.Fatalf("Unable to parse DATABASE_URL: %v", err)
	}

	config.DefaultQueryExecMode = pgx.QueryExecModeSimpleProtocol

	conn, err := pgx.ConnectConfig(context.Background(), config)
	if err != nil {
		log.Fatalf("Failed to connect to the database: %v", err)
	}
	defer conn.Close(context.Background())

	rows, err := conn.Query(context.Background(), "SELECT tablename, policyname, cmd, qual, with_check FROM pg_policies WHERE schemaname = 'public'")
	if err != nil {
		log.Fatalf("Query failed: %v", err)
	}
	defer rows.Close()

	fmt.Println("RLS Policies:")
	for rows.Next() {
		var tablename, policyname, cmd string
		var qual, withCheck *string
		rows.Scan(&tablename, &policyname, &cmd, &qual, &withCheck)
		fmt.Printf("Table: %s | Policy: %s | Cmd: %s\n", tablename, policyname, cmd)
		if qual != nil {
			fmt.Printf("  Qual: %s\n", *qual)
		}
		if withCheck != nil {
			fmt.Printf("  Check: %s\n", *withCheck)
		}
	}
}

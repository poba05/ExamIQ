package main

import (
	"context"
	"errors"
	"fmt"
	"log"
	"os"

	"github.com/jackc/pgx/v5"
	"github.com/joho/godotenv"
)

func main() {
	// Try to find .env in a few likely places
	envPaths := []string{
		".env",
		"../Backend/.env",
		"../../Backend/.env",
		"c:/Users/LENOVO/Documents/my_project/examai/Backend/.env",
	}

	envLoaded := false
	for _, path := range envPaths {
		if err := godotenv.Load(path); err == nil {
			envLoaded = true
			fmt.Printf("Loaded environment from %s\n", path)
			break
		}
	}

	if !envLoaded {
		log.Println("Warning: No .env file found. Using system environment variables.")
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

	var columnDefault *string
	query := "SELECT column_default FROM information_schema.columns WHERE table_name = 'exams' AND column_name = 'id'"
	err = conn.QueryRow(context.Background(), query).Scan(&columnDefault)

	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			fmt.Println("No rows found: The 'exams' table or 'id' column might not exist.")
			return
		}
		log.Fatal(err)
	}

	if columnDefault != nil {
		fmt.Printf("Default for exams.id: %s\n", *columnDefault)
	} else {
		fmt.Println("No default for exams.id")
	}
}

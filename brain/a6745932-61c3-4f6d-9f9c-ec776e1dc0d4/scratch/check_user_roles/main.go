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
	godotenv.Load("c:/Users/LENOVO/Documents/my_project/examai/Backend/.env")
	dbURL := os.Getenv("DATABASE_URL")
	if dbURL == "" {
		log.Fatal("DATABASE_URL not set")
	}

	config, _ := pgx.ParseConfig(dbURL)
	config.DefaultQueryExecMode = pgx.QueryExecModeSimpleProtocol
	conn, err := pgx.ConnectConfig(context.Background(), config)
	if err != nil {
		log.Fatal(err)
	}
	defer conn.Close(context.Background())

	rows, err := conn.Query(context.Background(), "SELECT id, full_name, role FROM profiles")
	if err != nil {
		log.Fatal(err)
	}
	defer rows.Close()

	fmt.Println("User Profiles:")
	for rows.Next() {
		var id, name, role string
		rows.Scan(&id, &name, &role)
		fmt.Printf("ID: %s | Name: %s | Role: %s\n", id, name, role)
	}
}

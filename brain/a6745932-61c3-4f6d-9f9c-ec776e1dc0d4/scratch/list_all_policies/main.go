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

	rows, err := conn.Query(context.Background(), "SELECT tablename, policyname FROM pg_policies")
	if err != nil {
		log.Fatal(err)
	}
	defer rows.Close()

	fmt.Println("All RLS Policies:")
	for rows.Next() {
		var tablename, policyname string
		rows.Scan(&tablename, &policyname)
		fmt.Printf("- %s: %s\n", tablename, policyname)
	}
}

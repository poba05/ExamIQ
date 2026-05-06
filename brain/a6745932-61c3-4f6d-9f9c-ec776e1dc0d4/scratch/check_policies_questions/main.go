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

	rows, err := conn.Query(context.Background(), "SELECT tablename, policyname, cmd, qual, with_check FROM pg_policies WHERE schemaname = 'public' AND tablename = 'questions'")
	if err != nil {
		log.Fatal(err)
	}
	defer rows.Close()

	fmt.Println("RLS Policies for questions:")
	for rows.Next() {
		var tablename, policyname, cmd string
		var qual, withCheck *string
		rows.Scan(&tablename, &policyname, &cmd, &qual, &withCheck)
		fmt.Printf("Table: %s | Policy: %s | Cmd: %s\n", tablename, policyname, cmd)
		if qual != nil { fmt.Printf("  Qual: %s\n", *qual) }
		if withCheck != nil { fmt.Printf("  Check: %s\n", *withCheck) }
	}
}

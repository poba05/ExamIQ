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

	sql := `
	DO $$
	BEGIN
		IF NOT EXISTS (
			SELECT 1 FROM pg_policies WHERE tablename = 'questions' AND policyname = 'Lecturers manage questions'
		) THEN
			CREATE POLICY "Lecturers manage questions" ON "public"."questions"
			FOR ALL
			TO authenticated
			USING (
				EXISTS (
					SELECT 1 FROM exams
					JOIN courses ON exams.course_id = courses.id
					WHERE exams.id = questions.exam_id
					AND courses.lecturer_id = auth.uid()
				)
			)
			WITH CHECK (
				EXISTS (
					SELECT 1 FROM exams
					JOIN courses ON exams.course_id = courses.id
					WHERE exams.id = questions.exam_id
					AND courses.lecturer_id = auth.uid()
				)
			);
		END IF;
	END
	$$;
	`

	_, err = conn.Exec(context.Background(), sql)
	if err != nil {
		log.Fatalf("Failed to execute SQL: %v", err)
	}

	fmt.Println("Successfully created RLS policy for 'questions' table.")
}

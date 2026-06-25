# ExamAI 🎓🤖

> **An AI-powered smart exam management platform** for universities — built with Flutter, Go, and Supabase.

ExamAI enables students to take proctored digital exams, lecturers to manage courses and review AI-graded submissions, and administrators to oversee the entire platform — all powered by Google Gemini for intelligent semantic grading.

---

## 📋 Table of Contents

- [Features](#-features)
- [Tech Stack](#-tech-stack)
- [Project Structure](#-project-structure)
- [Prerequisites](#-prerequisites)
- [Setup: Supabase](#1-supabase-setup-database--auth)
- [Setup: Flutter App](#2-flutter-app-setup)
- [Setup: Go Backend](#3-go-backend-setup)
- [Setup: Gemini AI](#4-google-gemini-ai-key)
- [Running the App](#-running-the-app)
- [User Roles](#-user-roles)
- [Environment Variables Reference](#-environment-variables-reference)

---

## ✨ Features

### 👨‍🎓 Student
- Register & log in securely via Supabase Auth
- Browse and enroll in available courses
- View course materials (PDF)
- Take timed, proctored online exams (MCQ & Essay)
- Webcam snapshot proctoring during exams
- View graded results and AI feedback

### 👨‍🏫 Lecturer
- Create and manage courses (with PDF materials)
- Create exams and add MCQ / Essay questions
- Monitor live exam session (active examinee feed)
- Trigger AI grading (Google Gemini 2.5 Flash)
- Review AI-graded submissions and approve/adjust scores
- View analytics dashboard (enrollment stats, average scores)

### 🛡️ Admin
- Register students and lecturers
- Manage all user accounts (view, delete)
- Platform-wide oversight

### 🤖 AI Grading Engine
- MCQ: Exact-match grading
- Essay/Structured: Semantic grading via **Google Gemini 2.5 Flash**
- Fallback local keyword-overlap grader when offline
- Lecturer review and score override before finalisation

---

## 🛠 Tech Stack

| Layer       | Technology                              |
|-------------|------------------------------------------|
| Mobile App  | Flutter (Dart) — Android / iOS           |
| Backend API | Go 1.26+ (Gin framework)                 |
| Database    | Supabase (PostgreSQL)                    |
| Auth        | Supabase Auth (JWT)                      |
| Storage     | Supabase Storage (course PDFs, snapshots)|
| AI Grading  | Google Gemini 2.5 Flash API              |
| Fonts       | Google Fonts (Inter)                     |

---

## 📂 Project Structure

```
examai/
├── lib/                          # Flutter application source
│   ├── main.dart                 # App entry point (Supabase init, dotenv)
│   ├── assets/                   # Static assets
│   │   ├── .env.example          # ← Copy to .env and fill in your keys
│   │   ├── faces/                # Face detection reference images
│   │   └── *.jpg / *.avif        # UI images
│   ├── constants/                # App-wide constants & theme
│   ├── models/                   # Dart data models
│   ├── utils/
│   │   ├── supabase_service.dart # All Supabase DB calls
│   │   └── ai_service.dart       # Gemini AI grading logic
│   ├── views/                    # All UI screens
│   │   ├── Splash/               # Splash & onboarding
│   │   ├── Auth/                 # Login & registration
│   │   └── Nav_Screens/
│   │       ├── Lecturer/         # Lecturer dashboard tabs
│   │       ├── Student/          # Student dashboard tabs
│   │       └── Admin/            # Admin panel
│   └── widgets/                  # Reusable UI components
│
├── Backend/                      # Go REST API
│   ├── main.go                   # Server entry point & routes
│   ├── supabase.go               # Supabase client + PostgreSQL init
│   ├── auth_handler.go           # /signup, /login endpoints
│   ├── auth_middleware.go        # JWT Bearer token validation
│   ├── user_handler.go           # /profile endpoint
│   ├── models.go                 # Go data structs
│   ├── go.mod                    # Go module dependencies
│   └── .env.example              # ← Copy to .env and fill in your keys
│
├── android/                      # Android platform project
├── ios/                          # iOS platform project
├── pubspec.yaml                  # Flutter dependencies
└── .gitignore
```

---

## 📦 Prerequisites

Make sure you have the following installed before you start:

| Tool                | Version    | Install Link                                      |
|---------------------|------------|---------------------------------------------------|
| Flutter SDK         | ≥ 3.10.7   | https://docs.flutter.dev/get-started/install      |
| Dart SDK            | ≥ 3.10.7   | Bundled with Flutter                              |
| Go                  | ≥ 1.21     | https://go.dev/dl/                                |
| Android Studio / Xcode | Latest | For device/emulator targets                       |
| Git                 | Any        | https://git-scm.com/                              |

---

## 1. Supabase Setup (Database & Auth)

ExamAI uses **Supabase** as its BaaS — you need a free project at [supabase.com](https://supabase.com).

### 1.1 Create a Project

1. Go to [app.supabase.com](https://app.supabase.com) and sign in.
2. Click **New Project**, choose your organisation, name it (e.g. `examai`), and set a **strong database password**. Save this password — you'll need it for the `DATABASE_URL`.
3. Note your **Project URL** and **anon key** from **Project Settings → API**.

### 1.2 Run the Database Schema

Open **SQL Editor** in your Supabase dashboard and run the following SQL to create all required tables, policies, and triggers:

```sql
-- ============================================================
-- 1. PROFILES table (extends Supabase auth.users)
-- ============================================================
CREATE TABLE profiles (
  id          UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  full_name   TEXT,
  email       TEXT,
  role        TEXT NOT NULL DEFAULT 'student'  -- 'student' | 'lecturer' | 'admin'
);

-- Auto-create profile on new user signup
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  INSERT INTO public.profiles (id, full_name, email, role)
  VALUES (
    NEW.id,
    NEW.raw_user_meta_data->>'full_name',
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'role', 'student')
  );
  RETURN NEW;
END;
$$;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE PROCEDURE handle_new_user();

-- ============================================================
-- 2. COURSES table
-- ============================================================
CREATE TABLE courses (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  lecturer_id UUID REFERENCES profiles(id) ON DELETE SET NULL,
  title       TEXT NOT NULL,
  course_code TEXT,
  description TEXT,
  semester    TEXT,
  units       INTEGER DEFAULT 3,
  pdf_url     TEXT,
  created_at  TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- 3. ENROLLMENTS table
-- ============================================================
CREATE TABLE enrollments (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id  UUID REFERENCES profiles(id) ON DELETE CASCADE,
  course_id   UUID REFERENCES courses(id) ON DELETE CASCADE,
  enrolled_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(student_id, course_id)
);

-- ============================================================
-- 4. EXAMS table
-- ============================================================
CREATE TABLE exams (
  id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  course_id        UUID REFERENCES courses(id) ON DELETE CASCADE,
  title            TEXT NOT NULL,
  exam_date        TIMESTAMPTZ,
  duration_minutes INTEGER DEFAULT 60,
  status           TEXT DEFAULT 'Upcoming',  -- 'Upcoming' | 'Active' | 'Completed'
  created_at       TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- 5. QUESTIONS table
-- ============================================================
CREATE TABLE questions (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  exam_id       UUID REFERENCES exams(id) ON DELETE CASCADE,
  question_text TEXT NOT NULL,
  question_type TEXT DEFAULT 'Essay',       -- 'Essay' | 'MCQ'
  correct_answer TEXT,
  points        INTEGER DEFAULT 5
);

-- ============================================================
-- 6. SUBMISSIONS table
-- ============================================================
CREATE TABLE submissions (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  exam_id         UUID REFERENCES exams(id) ON DELETE CASCADE,
  student_id      UUID REFERENCES profiles(id) ON DELETE CASCADE,
  status          TEXT DEFAULT 'in_progress', -- 'in_progress' | 'submitted' | 'terminated' | 'approved'
  score           NUMERIC,
  ai_confidence   NUMERIC,
  submission_data JSONB,   -- stores answers, ai_evaluation, etc.
  submitted_at    TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(exam_id, student_id)
);
```

### 1.3 Enable Row Level Security (RLS)

In the Supabase dashboard, go to **Authentication → Policies** for each table and enable RLS. As a minimum, add policies that allow:

- Authenticated users to read `profiles`
- Students to read/insert their own `enrollments` and `submissions`
- Lecturers to read/insert `courses`, `exams`, `questions`

> **Quick start for development:** You can temporarily disable RLS on all tables while testing, then re-enable it with proper policies for production.

### 1.4 Create Storage Buckets

Go to **Storage** in your Supabase dashboard and create two public buckets:

| Bucket Name        | Purpose                              |
|--------------------|--------------------------------------|
| `course_materials` | Lecturer-uploaded PDF course notes   |
| `proctoring`       | Student webcam snapshots during exam |

Set both buckets to **Public** so Flutter can generate public URLs.

---

## 2. Flutter App Setup

### 2.1 Clone the Repository

```bash
git clone https://github.com/your-username/examai.git
cd examai
```

### 2.2 Create the Flutter `.env` File

```bash
# From the project root
cp lib/assets/.env.example lib/assets/.env
```

Open `lib/assets/.env` and fill in your values:

```env
SUPABASE_URL=https://your-project-ref.supabase.co
SUPABASE_ANON_KEY=eyJhbGci...your-anon-key...
GEMINI_API_KEY=AIzaSy...your-gemini-key...
```

> ⚠️ **Do not commit `lib/assets/.env`**. It is listed in `.gitignore`.

### 2.3 Install Flutter Dependencies

```bash
flutter pub get
```

### 2.4 Run the App

```bash
# List connected devices
flutter devices

# Run on a specific device (replace <device-id> with your actual device)
flutter run -d <device-id>

# Or simply run on the first available device
flutter run
```

---

## 3. Go Backend Setup

The Go backend provides a REST API for authentication. The Flutter app communicates with it for login/signup.

### 3.1 Create the Backend `.env` File

```bash
cd Backend
cp .env.example .env
```

Open `Backend/.env` and fill in your values:

```env
SUPABASE_URL=https://your-project-ref.supabase.co
SUPABASE_ANON_KEY=eyJhbGci...your-anon-key...
DATABASE_URL=postgresql://postgres.your-project-ref:YOUR-DB-PASSWORD@aws-0-eu-central-1.pooler.supabase.com:6543/postgres
GEMINI_API_KEY=AIzaSy...your-gemini-key...
```

> **Finding `DATABASE_URL`:** In Supabase Dashboard → Project Settings → Database → Connection string → select **URI** mode. Use **port 6543** (Supavisor/PgBouncer transaction mode).

### 3.2 Install Go Dependencies

```bash
cd Backend
go mod download
```

### 3.3 Run the Backend Server

```bash
cd Backend
go run .
```

The server starts on **`http://localhost:8080`**.

#### Available API Endpoints

| Method | Endpoint           | Auth Required | Description              |
|--------|--------------------|---------------|--------------------------|
| POST   | `/api/v1/signup`   | No            | Register a new user      |
| POST   | `/api/v1/login`    | No            | Login and receive JWT    |
| GET    | `/api/v1/profile`  | Yes (Bearer)  | Get current user profile |

---

## 4. Google Gemini AI Key

ExamAI uses Google Gemini 2.5 Flash for semantic essay grading.

1. Visit [Google AI Studio](https://aistudio.google.com/app/apikey)
2. Sign in with a Google account
3. Click **Create API Key**
4. Copy the key and paste it as `GEMINI_API_KEY` in **both** `.env` files:
   - `lib/assets/.env` (Flutter)
   - `Backend/.env` (Go)

> **Free tier:** Google AI Studio has a generous free quota suitable for development and testing.

---

## 🚀 Running the App

### Full Development Setup (Recommended)

**Terminal 1 — Go Backend:**
```bash
cd Backend
go run .
# → Server running on http://localhost:8080
```

**Terminal 2 — Flutter App:**
```bash
# From project root
flutter run
```

### Production Build

**Android APK:**
```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

**Android App Bundle (for Play Store):**
```bash
flutter build appbundle --release
```

**Go Backend binary:**
```bash
cd Backend
go build -o examai-backend .
./examai-backend
```

---

## 👥 User Roles

| Role       | How to Create                                     | Access Level                         |
|------------|---------------------------------------------------|--------------------------------------|
| `admin`    | Register via Go backend API or Supabase directly, set `role = 'admin'` in `profiles` table | Full platform access  |
| `lecturer` | Admin creates account via app Admin panel         | Courses, exams, grading, analytics   |
| `student`  | Self-register via the app's Sign Up screen        | Courses, exams, results              |

> **First Admin:** Manually insert a row into the `profiles` table via the Supabase dashboard after signing up, setting `role = 'admin'`.

---

## 🔐 Environment Variables Reference

### `lib/assets/.env` (Flutter App)

| Variable          | Description                        | Where to Find                                    |
|-------------------|------------------------------------|--------------------------------------------------|
| `SUPABASE_URL`    | Your Supabase project URL          | Project Settings → API → Project URL            |
| `SUPABASE_ANON_KEY` | Supabase public anon key         | Project Settings → API → anon public            |
| `GEMINI_API_KEY`  | Google Gemini API key for grading  | https://aistudio.google.com/app/apikey           |

### `Backend/.env` (Go API Server)

| Variable           | Description                            | Where to Find                                    |
|--------------------|----------------------------------------|--------------------------------------------------|
| `SUPABASE_URL`     | Your Supabase project URL              | Project Settings → API → Project URL            |
| `SUPABASE_ANON_KEY`| Supabase public anon key               | Project Settings → API → anon public            |
| `DATABASE_URL`     | Direct PostgreSQL connection string    | Project Settings → Database → URI (port 6543)   |
| `GEMINI_API_KEY`   | Google Gemini API key                  | https://aistudio.google.com/app/apikey           |

---

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature`
3. Commit your changes: `git commit -m 'feat: add your feature'`
4. Push to your branch: `git push origin feature/your-feature`
5. Open a Pull Request

---

## 👨‍💻 Author

Developed by **POBATECH**

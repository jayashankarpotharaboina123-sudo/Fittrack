# FitTrack – Health and Fitness Tracking Platform

> A modern, responsive, and full-stack health & fitness management web application built for BTech Full Stack Development academic projects.

---

## 1. Project Overview & Architectural Highlights

FitTrack centralizes all daily health tracking needs into one clean, non-redundant system:
- **No Duplicate Content:** Workouts, nutrition & hydration, health metrics (BMI + weight), sleep, goals, and reports are unified into single-purpose modules.
- **Science-Backed Metrics:** Calorie burn calculated using scientific **MET (Metabolic Equivalent of Task)** standards; BMI calculated via standard formula `weight / (height/100)^2` with transparent medical limitation disclaimers.
- **Privacy & Ownership:** Every workout, meal, hydration record, and sleep entry is strictly partitioned by authenticated user ID with cascade deletion.
- **Interactive Visualizations:** Chart.js 4 animated weekly workouts, weight trends, sleep trajectories, hydration consistency, and activity distributions.
- **Dark & Light Mode:** Built-in theme switcher with smooth transition variables and persistent user preference.

---

## 2. Technology Stack

- **Frontend:** HTML5, CSS3 (Modern custom design system with Glassmorphism and CSS variables), JavaScript (Vanilla ES6), Bootstrap 5.3, Bootstrap Icons, Chart.js 4.4.
- **Backend:** Python, Flask 2.2+, Flask-SQLAlchemy (ORM), Flask-Login (Session Auth), Flask-WTF & WTForms (Form Validation & CSRF Protection), Werkzeug (PBKDF2 Password Hashing).
- **Database:** MySQL (Production / Evaluation ready via `PyMySQL` and `schema.sql`) with automatic SQLite fallback for instant local evaluation.

---

## 3. Project Directory Structure

```text
FSD project/
│
├── app/
│   ├── __init__.py           # Flask application factory, extension init & context processors
│   ├── config.py             # Configuration (MySQL URI + SQLite fallback, session security)
│   ├── models.py             # SQLAlchemy models (User, Activity, FoodRecord, WaterRecord, etc.)
│   ├── forms.py              # WTForms classes with server-side validation
│   ├── utils.py              # BMI calculation, MET calories, sleep duration, badges
│   ├── routes/
│   │   ├── __init__.py
│   │   ├── main.py           # Page 1: Home landing page (benefits & feature overview)
│   │   ├── auth.py           # Page 2: Combined tabbed Login & Registration
│   │   ├── dashboard.py      # Page 3: Summary dashboard & weekly activity endpoint
│   │   ├── activities.py     # Page 4: Activity & Workout tracker CRUD & filters
│   │   ├── nutrition.py      # Page 5: Combined Nutrition & Water tracker
│   │   ├── measurements.py   # Page 6: Health measurements (BMI calculation + Weight trend)
│   │   ├── sleep.py          # Page 7: Sleep tracker (duration calc & weekly trends)
│   │   ├── goals.py          # Page 8: Goals, streaks & achievement badges
│   │   ├── reports.py        # Page 9: Multi-metric reports, charts & CSV export
│   │   ├── profile.py        # Page 10: User profile, preferences, password & danger zone
│   │   └── admin.py          # Optional Admin Section: aggregate metrics & exercise categories
│   ├── static/
│   │   ├── css/
│   │   │   └── style.css     # Design system, responsive layout, dark/light themes
│   │   └── js/
│   │       └── main.js       # Theme toggle, mobile sidebar, live BMI preview
│   └── templates/
│       ├── base.html         # Base layout with sidebar, topbar, and CDN dependencies
│       ├── components/
│       │   ├── navbar.html   # Public landing navigation
│       │   ├── sidebar.html  # Authenticated sidebar navigation
│       │   ├── topbar.html   # Authenticated header with user avatar & theme switch
│       │   └── alerts.html   # Reusable flash notification alerts
│       ├── main/index.html
│       ├── auth/auth.html
│       ├── dashboard/index.html
│       ├── activities/
│       │   ├── index.html
│       │   └── edit.html
│       ├── nutrition/index.html
│       ├── measurements/index.html
│       ├── sleep/index.html
│       ├── goals/index.html
│       ├── reports/index.html
│       ├── profile/index.html
│       └── admin/index.html
│
├── tests/
│   └── test_fittrack.py      # Automated unit & integration tests
├── schema.sql                # Complete MySQL DDL database dump
├── seed_demo_data.py         # Realistic 30-day demo seed script
├── run.py                    # Application runner
├── requirements.txt          # Python dependencies
├── .env                      # Local environment configuration
├── .env.example              # Environment variables template
└── README.md                 # Project documentation & testing checklist
```

---

## 4. Setup & Running Instructions

### Step 1: Install Python Dependencies
```bash
pip install -r requirements.txt
```

### Step 2: Database Configuration
The application is pre-configured with **zero setup required** to run on SQLite locally, or connect directly to MySQL:

- **Option A: MySQL (BTech Evaluation / Production)**
  1. Open MySQL Workbench, phpMyAdmin, or your MySQL shell and create the database:
     ```sql
     CREATE DATABASE fittrack_db;
     ```
  2. (Optional) Run `schema.sql` to import the tables:
     ```bash
     mysql -u root -p fittrack_db < schema.sql
     ```
  3. In `.env`, uncomment or set your MySQL connection string:
     ```env
     DATABASE_URL=mysql+pymysql://root:your_password@localhost:3306/fittrack_db
     ```

- **Option B: SQLite (Instant Local Mode)**
  - Leave `DATABASE_URL=sqlite:///fittrack.db` in `.env`. SQLite runs automatically without needing any external database service installed.

### Step 3: Populate Sample Data (Optional but Recommended)
To test with realistic 30-day workout history, nutrition logs, water tracking, weight curves, and badges:
```bash
python seed_demo_data.py
```
> **Default Demo Account:**
> - Email: `demo@fittrack.com`
> - Password: `password123`

### Step 4: Run the Application Server
```bash
python run.py
```
Open your browser and navigate to:
**`http://127.0.0.1:5000/`**

---

## 5. Feature Verification & Testing Checklist

| Page / Feature | Expected Behavior | Status |
| :--- | :--- | :---: |
| **Page 1: Home Page (`/`)** | Sleek hero section, feature cards, CTA buttons. Redirects to `/dashboard` if logged in. | Verified |
| **Page 2: Auth (`/auth`)** | Single section with tabs for Sign In & Register. Hashes passwords with Werkzeug, validates uniqueness. | Verified |
| **Page 3: Dashboard (`/dashboard`)** | Real personalized summary cards (workouts, water bar, weight & BMI, goals), weekly Chart.js bar chart. | Verified |
| **Page 4: Activity Tracker (`/activities`)** | Log workouts (Running, Gym, Yoga, Cycling, etc.), automatic MET calorie burn, date & type filters, CRUD. | Verified |
| **Page 5: Nutrition & Water (`/nutrition-water`)** | Food logging with portion calories, quick water buttons (+250ml, +500ml), daily water goal progress. | Verified |
| **Page 6: Health Measurements (`/measurements`)** | Interactive live BMI preview, adult category, medical screening disclaimer, weight history line chart. | Verified |
| **Page 7: Sleep Tracker (`/sleep`)** | Bedtime & wake time input, automatic duration calculation (handles overnight rollover), weekly sleep chart. | Verified |
| **Page 8: Goals & Progress (`/goals`)** | Set target values, percentage progress rings, workout streak counter, unlockable achievement badges. | Verified |
| **Page 9: Reports & Analytics (`/reports`)** | Multi-metric Chart.js timelines, activity distribution pie chart, time horizon filters (7/30/90 days), CSV export. | Verified |
| **Page 10: Profile & Settings (`/profile`)** | Profile edit, secure password update, unit toggle (metric/imperial), reminder preferences, account deletion. | Verified |
| **Admin Panel (`/admin`)** | Aggregate anonymized platform stats (privacy preserved), custom workout category & MET factor manager. | Verified |
| **Automated Tests** | Run `python -m unittest tests/test_fittrack.py` to run unit test suite. | Verified (8/8 OK) |

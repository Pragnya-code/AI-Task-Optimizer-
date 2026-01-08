
-- ======================================================
-- PostgreSQL Schema for Employee Emotion Analysis System
-- ======================================================

-- Drop tables if they already exist (for reset during development)
DROP TABLE IF EXISTS alerts CASCADE;
DROP TABLE IF EXISTS mood_trends CASCADE;
DROP TABLE IF EXISTS task_recommendations CASCADE;
DROP TABLE IF EXISTS emotion_scores CASCADE;
DROP TABLE IF EXISTS emotion_sessions CASCADE;
DROP TABLE IF EXISTS employees CASCADE;

-- ========================================
-- 1️⃣ Employees Table
-- ========================================
CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    age INT,
    gender VARCHAR(20),
    department VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    join_date DATE DEFAULT CURRENT_DATE
);

-- ========================================
-- 2️⃣ Emotion Sessions Table
-- ========================================
CREATE TABLE emotion_sessions (
    id SERIAL PRIMARY KEY,
    employee_id INT REFERENCES employees(id) ON DELETE CASCADE,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    dominant_emotion VARCHAR(50),
    category VARCHAR(20),
    positive_score NUMERIC(5,2),
    negative_score NUMERIC(5,2),
    stress_score NUMERIC(5,2),
    energy_level VARCHAR(20),
    image_path TEXT,
    source VARCHAR(20)
);

-- ========================================
-- 3️⃣ Emotion Scores Table
-- ========================================
CREATE TABLE emotion_scores (
    id SERIAL PRIMARY KEY,
    session_id INT REFERENCES emotion_sessions(id) ON DELETE CASCADE,
    emotion VARCHAR(30),
    score NUMERIC(10,8)
);

-- ========================================
-- 4️⃣ Task Recommendations Table
-- ========================================
CREATE TABLE task_recommendations (
    id SERIAL PRIMARY KEY,
    session_id INT REFERENCES emotion_sessions(id) ON DELETE CASCADE,
    recommendation TEXT
);

-- ========================================
-- 5️⃣ Mood Trends Table
-- ========================================
CREATE TABLE mood_trends (
    id SERIAL PRIMARY KEY,
    employee_id INT REFERENCES employees(id) ON DELETE CASCADE,
    date DATE DEFAULT CURRENT_DATE,
    avg_positive NUMERIC(5,2),
    avg_negative NUMERIC(5,2),
    avg_stress NUMERIC(5,2),
    dominant_emotion VARCHAR(50)
);

-- ========================================
-- 6️⃣ Alerts Table
-- ========================================
CREATE TABLE alerts (
    id SERIAL PRIMARY KEY,
    employee_id INT REFERENCES employees(id) ON DELETE CASCADE,
    alert_type VARCHAR(50),
    status VARCHAR(20) DEFAULT 'open',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ========================================
-- ✅ Example Data (Optional for testing)
-- ========================================

INSERT INTO employees (name, age, gender, department, email)
VALUES 
('Alice Johnson', 31, 'Woman', 'Engineering', 'alice.johnson@example.com'),
('Bob Smith', 29, 'Man', 'HR', 'bob.smith@example.com');

INSERT INTO emotion_sessions (employee_id, dominant_emotion, category, positive_score, negative_score, stress_score, energy_level, source)
VALUES 
(1, 'surprise', 'Positive', 1.00, 0.00, 0.10, 'High', 'webcam'),
(2, 'sad', 'Negative', 0.20, 0.80, 0.70, 'Low', 'upload');

INSERT INTO emotion_scores (session_id, emotion, score)
VALUES
(1, 'angry', 0.00000007),
(1, 'disgust', 0.00000008),
(1, 'happy', 0.00000002),
(1, 'surprise', 100.00000000),
(2, 'sad', 85.00000000),
(2, 'fear', 15.00000000);

INSERT INTO task_recommendations (session_id, recommendation)
VALUES
(1, 'Work on challenging project'),
(1, 'Lead a meeting'),
(1, 'Deep work session'),
(2, 'Take a short break'),
(2, 'Do light documentation work');

INSERT INTO mood_trends (employee_id, avg_positive, avg_negative, avg_stress, dominant_emotion)
VALUES
(1, 0.90, 0.10, 0.20, 'surprise'),
(2, 0.30, 0.70, 0.60, 'sad');

INSERT INTO alerts (employee_id, alert_type, status)
VALUES
(2, 'High stress for 5 days', 'open');

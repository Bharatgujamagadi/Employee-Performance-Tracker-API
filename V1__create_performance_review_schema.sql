-- =========================================================
-- Migration: V1__create_performance_review_schema.sql
-- Database: H2
-- Description: Initial schema for Performance Review System
-- =========================================================

-- ================================
-- EMPLOYEE TABLE
-- ================================
CREATE TABLE IF NOT EXISTS employee (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    department VARCHAR(100) NOT NULL,
    role VARCHAR(100) NOT NULL,
    joining_date DATE NOT NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_employee_department 
    ON employee(department);


-- ================================
-- REVIEW CYCLE TABLE
-- ================================
CREATE TABLE IF NOT EXISTS review_cycle (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uq_review_cycle_name UNIQUE (name),
    CONSTRAINT chk_review_cycle_dates CHECK (start_date < end_date)
);


-- ================================
-- PERFORMANCE REVIEW TABLE
-- ================================
CREATE TABLE IF NOT EXISTS performance_review (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,

    employee_id BIGINT NOT NULL,
    review_cycle_id BIGINT NOT NULL,

    rating INT NOT NULL,
    reviewer_notes CLOB,
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    reviewer VARCHAR(100),

    CONSTRAINT fk_pr_employee 
        FOREIGN KEY (employee_id) REFERENCES employee(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_pr_cycle 
        FOREIGN KEY (review_cycle_id) REFERENCES review_cycle(id)
        ON DELETE CASCADE,

    CONSTRAINT chk_rating_range 
        CHECK (rating BETWEEN 1 AND 5)
);

CREATE INDEX IF NOT EXISTS idx_pr_employee 
    ON performance_review(employee_id);

CREATE INDEX IF NOT EXISTS idx_pr_cycle 
    ON performance_review(review_cycle_id);

CREATE INDEX IF NOT EXISTS idx_pr_employee_cycle 
    ON performance_review(employee_id, review_cycle_id);


-- ================================
-- GOALS TABLE
-- ================================
CREATE TABLE IF NOT EXISTS goals (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,

    employee_id BIGINT NOT NULL,
    review_cycle_id BIGINT NOT NULL,

    title VARCHAR(500) NOT NULL,
    status VARCHAR(20) NOT NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_goals_employee 
        FOREIGN KEY (employee_id) REFERENCES employee(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_goals_cycle 
        FOREIGN KEY (review_cycle_id) REFERENCES review_cycle(id)
        ON DELETE CASCADE,

    CONSTRAINT chk_goal_status 
        CHECK (status IN ('pending', 'completed', 'missed'))
);

CREATE INDEX IF NOT EXISTS idx_goals_employee_cycle 
    ON goals(employee_id, review_cycle_id);

-- =========================================================
-- END OF MIGRATION
-- =========================================================

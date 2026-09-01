CREATE DATABASE IF NOT EXISTS employee_survey CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE employee_survey;

CREATE TABLE users (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 name VARCHAR(120) NOT NULL,
 email VARCHAR(190) NOT NULL UNIQUE,
 password_hash VARCHAR(255) NOT NULL,
 role ENUM('super_admin','survey_admin','reviewer') NOT NULL DEFAULT 'survey_admin',
 active TINYINT(1) NOT NULL DEFAULT 1,
 created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE departments (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 name VARCHAR(120) NOT NULL UNIQUE,
 active TINYINT(1) NOT NULL DEFAULT 1,
 created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE feedback_categories (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 name VARCHAR(120) NOT NULL UNIQUE,
 active TINYINT(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB;

CREATE TABLE surveys (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 title VARCHAR(220) NOT NULL,
 description TEXT NULL,
 public_token VARCHAR(64) NOT NULL UNIQUE,
 status ENUM('draft','active','closed') NOT NULL DEFAULT 'draft',
 anonymous TINYINT(1) NOT NULL DEFAULT 1,
 starts_at DATETIME NULL,
 ends_at DATETIME NULL,
 created_by INT UNSIGNED NOT NULL,
 created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
 CONSTRAINT fk_surveys_user FOREIGN KEY(created_by) REFERENCES users(id)
) ENGINE=InnoDB;

CREATE TABLE survey_questions (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 survey_id INT UNSIGNED NOT NULL,
 question_text TEXT NOT NULL,
 question_type ENUM('single','multiple','dropdown','rating','yesno','short_text','long_text') NOT NULL,
 required TINYINT(1) NOT NULL DEFAULT 0,
 sort_order INT NOT NULL DEFAULT 0,
 settings JSON NULL,
 CONSTRAINT fk_questions_survey FOREIGN KEY(survey_id) REFERENCES surveys(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE question_options (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 question_id INT UNSIGNED NOT NULL,
 option_text VARCHAR(500) NOT NULL,
 sort_order INT NOT NULL DEFAULT 0,
 CONSTRAINT fk_options_question FOREIGN KEY(question_id) REFERENCES survey_questions(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE survey_invitations (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 survey_id INT UNSIGNED NOT NULL,
 email VARCHAR(190) NOT NULL,
 invite_token VARCHAR(64) NOT NULL UNIQUE,
 sent_at DATETIME NULL,
 completed_at DATETIME NULL,
 created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 UNIQUE KEY uq_survey_email(survey_id,email),
 CONSTRAINT fk_invite_survey FOREIGN KEY(survey_id) REFERENCES surveys(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE survey_responses (
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 survey_id INT UNSIGNED NOT NULL,
 invitation_id INT UNSIGNED NULL,
 response_token VARCHAR(64) NOT NULL UNIQUE,
 started_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 submitted_at DATETIME NULL,
 CONSTRAINT fk_response_survey FOREIGN KEY(survey_id) REFERENCES surveys(id) ON DELETE CASCADE,
 CONSTRAINT fk_response_invite FOREIGN KEY(invitation_id) REFERENCES survey_invitations(id) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE survey_answers (
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 response_id BIGINT UNSIGNED NOT NULL,
 question_id INT UNSIGNED NOT NULL,
 answer_text TEXT NULL,
 CONSTRAINT fk_answer_response FOREIGN KEY(response_id) REFERENCES survey_responses(id) ON DELETE CASCADE,
 CONSTRAINT fk_answer_question FOREIGN KEY(question_id) REFERENCES survey_questions(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE answer_selections (
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 answer_id BIGINT UNSIGNED NOT NULL,
 option_id INT UNSIGNED NOT NULL,
 CONSTRAINT fk_selection_answer FOREIGN KEY(answer_id) REFERENCES survey_answers(id) ON DELETE CASCADE,
 CONSTRAINT fk_selection_option FOREIGN KEY(option_id) REFERENCES question_options(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE anonymous_feedback (
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 department_id INT UNSIGNED NOT NULL,
 category_id INT UNSIGNED NULL,
 feedback_text TEXT NOT NULL,
 sentiment ENUM('positive','neutral','negative') NOT NULL DEFAULT 'neutral',
 status ENUM('new','under_review','resolved','archived') NOT NULL DEFAULT 'new',
 assigned_to INT UNSIGNED NULL,
 ip_hash CHAR(64) NULL,
 created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
 CONSTRAINT fk_feedback_department FOREIGN KEY(department_id) REFERENCES departments(id),
 CONSTRAINT fk_feedback_category FOREIGN KEY(category_id) REFERENCES feedback_categories(id),
 CONSTRAINT fk_feedback_assignee FOREIGN KEY(assigned_to) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE feedback_notes (
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 feedback_id BIGINT UNSIGNED NOT NULL,
 user_id INT UNSIGNED NOT NULL,
 note TEXT NOT NULL,
 created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 CONSTRAINT fk_note_feedback FOREIGN KEY(feedback_id) REFERENCES anonymous_feedback(id) ON DELETE CASCADE,
 CONSTRAINT fk_note_user FOREIGN KEY(user_id) REFERENCES users(id)
) ENGINE=InnoDB;

CREATE TABLE audit_logs (
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 user_id INT UNSIGNED NULL,
 action VARCHAR(100) NOT NULL,
 entity_type VARCHAR(100) NOT NULL,
 entity_id BIGINT UNSIGNED NULL,
 metadata JSON NULL,
 created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 CONSTRAINT fk_audit_user FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;

INSERT INTO users(name,email,password_hash,role) VALUES
('System Administrator','admin@example.com','$2y$12$BRyhsCus3PC18W5eednYou7QLjXJimHWSKyYF7QZg1gWlYOcWeuN.','super_admin');

INSERT INTO departments(name) VALUES ('Human Resources'),('Finance'),('Information Technology'),('Operations'),('Sales & Marketing');
INSERT INTO feedback_categories(name) VALUES ('Workplace Environment'),('Management'),('Human Resources'),('Safety'),('Employee Welfare'),('Suggestion'),('Complaint'),('Other');

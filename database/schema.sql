CREATE DATABASE IF NOT EXISTS task_manager
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE task_manager;

-- =========================================================
-- ROLES
-- =========================================================

CREATE TABLE roles (
                       id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                       name VARCHAR(50) NOT NULL UNIQUE,
                       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                       updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                           ON UPDATE CURRENT_TIMESTAMP
);

-- =========================================================
-- USERS
-- =========================================================

CREATE TABLE users (
                       id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                       name VARCHAR(100) NOT NULL,
                       email VARCHAR(100) NOT NULL UNIQUE,
                       password VARCHAR(255) NOT NULL,
                       role_id BIGINT UNSIGNED NOT NULL,
                       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                       updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                           ON UPDATE CURRENT_TIMESTAMP,

                       CONSTRAINT fk_users_role
                           FOREIGN KEY (role_id)
                               REFERENCES roles(id)
                               ON UPDATE CASCADE
                               ON DELETE RESTRICT
);

-- =========================================================
-- TASKS
-- =========================================================

CREATE TABLE tasks (
                       id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

                       title VARCHAR(255) NOT NULL,

                       description TEXT NULL,

                       status ENUM('todo', 'in-progress', 'done')
        NOT NULL DEFAULT 'todo',

                       priority ENUM('low', 'medium', 'high')
        NOT NULL DEFAULT 'medium',

                       due_date DATE NULL,

                       user_id BIGINT UNSIGNED NOT NULL,

                       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

                       updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                           ON UPDATE CURRENT_TIMESTAMP,

                       CONSTRAINT fk_tasks_user
                           FOREIGN KEY (user_id)
                               REFERENCES users(id)
                               ON UPDATE CASCADE
                               ON DELETE CASCADE
);

-- =========================================================
-- INDEXES
-- =========================================================

CREATE INDEX idx_tasks_user_id
    ON tasks(user_id);

CREATE INDEX idx_tasks_status
    ON tasks(status);

CREATE INDEX idx_tasks_user_status
    ON tasks(user_id, status);

CREATE INDEX idx_tasks_due_date
    ON tasks(due_date);

-- =========================================================
-- SEED ROLES
-- =========================================================

INSERT INTO roles (name)
VALUES
    ('admin'),
    ('user');
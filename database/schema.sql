CREATE TABLE IF NOT EXISTS roles (
                                     id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                                     name VARCHAR(50) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS users (
                                     id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                                     role_id INT UNSIGNED NOT NULL DEFAULT 2, -- 1: admin, 2: user
                                     email VARCHAR(191) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_users_roles FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE RESTRICT
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS tasks (
                                     id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                                     owner_id INT UNSIGNED NOT NULL,
                                     title VARCHAR(255) NOT NULL,
    description TEXT,
    status ENUM('todo', 'in-progress', 'done') NOT NULL DEFAULT 'todo',
    priority ENUM('low', 'medium', 'high') NOT NULL DEFAULT 'medium',
    due_date DATE NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_tasks_users FOREIGN KEY (owner_id) REFERENCES users(id) ON DELETE CASCADE,
    -- Composite Index for user task filtering with pagination
    INDEX idx_owner_status_created (owner_id, status, created_at),
    -- Index for admin sorting/filtering by status across all users
    INDEX idx_status_created (status, created_at)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Seed Default Roles
INSERT IGNORE INTO roles (id, name) VALUES (1, 'admin'), (2, 'user');
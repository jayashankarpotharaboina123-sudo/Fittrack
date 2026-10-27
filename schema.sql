-- =====================================================================
-- FitTrack – Health and Fitness Tracking Platform
-- Relational Database Schema DDL for MySQL (Version 5.7+ / 8.0+)
-- =====================================================================

CREATE DATABASE IF NOT EXISTS `fittrack_db` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `fittrack_db`;

-- 1. Users Table
CREATE TABLE IF NOT EXISTS `users` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `username` VARCHAR(64) NOT NULL UNIQUE,
    `email` VARCHAR(120) NOT NULL UNIQUE,
    `password_hash` VARCHAR(255) NOT NULL,
    `full_name` VARCHAR(100) NULL,
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `is_admin` BOOLEAN DEFAULT FALSE,
    `unit_system` VARCHAR(10) DEFAULT 'metric',
    `dark_mode` BOOLEAN DEFAULT TRUE,
    `water_goal` INT DEFAULT 2500,
    `workout_reminder` BOOLEAN DEFAULT TRUE,
    `water_reminder` BOOLEAN DEFAULT TRUE,
    `height_cm` FLOAT NULL,
    `bio` VARCHAR(255) NULL,
    INDEX `idx_users_username` (`username`),
    INDEX `idx_users_email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 2. Exercise Categories Table
CREATE TABLE IF NOT EXISTS `exercise_categories` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(50) NOT NULL UNIQUE,
    `description` VARCHAR(255) NULL,
    `met_value` FLOAT DEFAULT 5.0,
    `is_default` BOOLEAN DEFAULT TRUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 3. Activity Records Table
CREATE TABLE IF NOT EXISTS `activities` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `user_id` INT NOT NULL,
    `activity_type` VARCHAR(50) NOT NULL,
    `duration_minutes` INT NOT NULL,
    `distance_km` FLOAT DEFAULT 0.0,
    `calories_burned` FLOAT DEFAULT 0.0,
    `activity_date` DATE NOT NULL,
    `notes` TEXT NULL,
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX `idx_activities_user_id` (`user_id`),
    INDEX `idx_activities_date` (`activity_date`),
    CONSTRAINT `fk_activities_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 4. Food Records Table (Meals & Nutrition)
CREATE TABLE IF NOT EXISTS `food_records` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `user_id` INT NOT NULL,
    `meal_type` VARCHAR(20) NOT NULL,
    `food_name` VARCHAR(100) NOT NULL,
    `portion_size` VARCHAR(50) NULL,
    `calories` FLOAT NOT NULL DEFAULT 0.0,
    `carbs` FLOAT DEFAULT 0.0,
    `protein` FLOAT DEFAULT 0.0,
    `fat` FLOAT DEFAULT 0.0,
    `record_date` DATE NOT NULL,
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX `idx_food_user_id` (`user_id`),
    INDEX `idx_food_date` (`record_date`),
    CONSTRAINT `fk_food_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 5. Water Records Table (Hydration)
CREATE TABLE IF NOT EXISTS `water_records` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `user_id` INT NOT NULL,
    `amount_ml` INT NOT NULL,
    `record_date` DATE NOT NULL,
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX `idx_water_user_id` (`user_id`),
    INDEX `idx_water_date` (`record_date`),
    CONSTRAINT `fk_water_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 6. Weight & Measurements Table (BMI & Body Tracking)
CREATE TABLE IF NOT EXISTS `weight_records` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `user_id` INT NOT NULL,
    `weight_kg` FLOAT NOT NULL,
    `height_cm` FLOAT NULL,
    `bmi` FLOAT NULL,
    `bmi_category` VARCHAR(30) NULL,
    `record_date` DATE NOT NULL,
    `notes` VARCHAR(200) NULL,
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX `idx_weight_user_id` (`user_id`),
    INDEX `idx_weight_date` (`record_date`),
    CONSTRAINT `fk_weight_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 7. Sleep Records Table
CREATE TABLE IF NOT EXISTS `sleep_records` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `user_id` INT NOT NULL,
    `sleep_time` VARCHAR(10) NOT NULL,
    `wake_time` VARCHAR(10) NOT NULL,
    `duration_hours` FLOAT NOT NULL,
    `quality_rating` INT DEFAULT 3,
    `record_date` DATE NOT NULL,
    `notes` VARCHAR(255) NULL,
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX `idx_sleep_user_id` (`user_id`),
    INDEX `idx_sleep_date` (`record_date`),
    CONSTRAINT `fk_sleep_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 8. Fitness Goals Table
CREATE TABLE IF NOT EXISTS `fitness_goals` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `user_id` INT NOT NULL,
    `title` VARCHAR(100) NOT NULL,
    `category` VARCHAR(50) NOT NULL,
    `target_value` FLOAT NOT NULL,
    `current_value` FLOAT DEFAULT 0.0,
    `unit` VARCHAR(20) NOT NULL,
    `start_date` DATE NOT NULL,
    `target_date` DATE NULL,
    `status` VARCHAR(20) DEFAULT 'In Progress',
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX `idx_goals_user_id` (`user_id`),
    CONSTRAINT `fk_goals_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

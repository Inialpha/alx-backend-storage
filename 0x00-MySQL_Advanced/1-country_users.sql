-- SQL script that creates a table users following these requirements:

-- Drop table user if it exist
DROP TABLE IF EXISTS users;

-- Create users table
CREATE TABLE users (
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	email VARCHAR(255) NOT NULL UNIQUE,
	name VARCHAR(255),
	country ENUM('US', 'CO', 'TN') NOT NULL DEFAULT 'US'
);

CREATE DATABASE webappdb;

-- Select webappdb DATABASE
USE webappdb;

-- Create Transactions Table
CREATE TABLE IF NOT EXISTS dogs(id INT NOT NULL
AUTO_INCREMENT, name VARCHAR(100), description
VARCHAR(100), PRIMARY KEY(id));    

-- Insert Test Data in Table Transactions
INSERT INTO dogs (name,description) VALUES ('Chewy','Boy');

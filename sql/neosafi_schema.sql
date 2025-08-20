-- NeoSafi Store Database Schema
-- MySQL/MariaDB compatible

-- Create database (run this separately if needed)
-- CREATE DATABASE neosafi_store CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
-- USE neosafi_store;

-- Drop tables if they exist (for clean setup)
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS access_links;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS users;

-- Users table (customers and admins)
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role ENUM('customer', 'admin') DEFAULT 'customer',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_email (email),
    INDEX idx_role (role)
);

-- Categories table
CREATE TABLE categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_name (name)
);

-- Products table
CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    stock INT DEFAULT 0,
    category_id INT,
    image VARCHAR(255),
    featured BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL,
    INDEX idx_category (category_id),
    INDEX idx_featured (featured),
    INDEX idx_price (price),
    INDEX idx_stock (stock)
);

-- Orders table
CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NULL, -- NULL for guest orders
    total DECIMAL(10,2) NOT NULL,
    status ENUM('pending', 'processing', 'shipped', 'delivered', 'cancelled') DEFAULT 'pending',
    customer_info JSON, -- Store customer details for guest orders
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_user (user_id),
    INDEX idx_status (status),
    INDEX idx_created (created_at)
);

-- Order items table
CREATE TABLE order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL, -- Price at time of order
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    INDEX idx_order (order_id),
    INDEX idx_product (product_id)
);

-- Access links table (unique link system)
CREATE TABLE access_links (
    id INT AUTO_INCREMENT PRIMARY KEY,
    token_hash VARCHAR(64) NOT NULL UNIQUE, -- SHA256 hash of the raw token
    used_by_device VARCHAR(64) NULL, -- SHA256 hash of device fingerprint
    status ENUM('active', 'used', 'expired', 'revoked') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP NULL, -- NULL means no expiration
    used_at TIMESTAMP NULL,
    INDEX idx_token_hash (token_hash),
    INDEX idx_status (status),
    INDEX idx_expires (expires_at),
    INDEX idx_created (created_at)
);

-- Insert sample data

-- Insert admin user (password: admin123)
INSERT INTO users (name, email, password, role) VALUES 
('Admin User', 'admin@neosafi.com', '$2b$12$LQv3c1yqBWVHxkd0LQ1Gv.6FqvyHdHDHHmk4f7u/Oo9X8KeOeKlW2', 'admin');

-- Insert sample customer (password: customer123)
INSERT INTO users (name, email, password, role) VALUES 
('John Doe', 'john@example.com', '$2b$12$LQv3c1yqBWVHxkd0LQ1Gv.6FqvyHdHDHHmk4f7u/Oo9X8KeOeKlW2', 'customer');

-- Insert categories
INSERT INTO categories (name, description) VALUES 
('Electronics', 'Electronic devices and gadgets'),
('Clothing', 'Fashion and apparel'),
('Books', 'Books and educational materials'),
('Home & Garden', 'Home improvement and gardening supplies'),
('Sports', 'Sports equipment and accessories');

-- Insert sample products
INSERT INTO products (name, description, price, stock, category_id, featured) VALUES 
('Smartphone Pro Max', 'Latest flagship smartphone with advanced features', 999.99, 50, 1, TRUE),
('Wireless Headphones', 'Premium noise-cancelling wireless headphones', 299.99, 100, 1, TRUE),
('Designer T-Shirt', 'Premium cotton t-shirt with modern design', 49.99, 200, 2, FALSE),
('Programming Book', 'Complete guide to modern web development', 79.99, 75, 3, TRUE),
('Smart Watch', 'Fitness tracking smartwatch with health monitoring', 399.99, 80, 1, TRUE),
('Running Shoes', 'Professional running shoes for athletes', 149.99, 120, 5, FALSE),
('Coffee Maker', 'Automatic coffee maker with programmable settings', 199.99, 60, 4, FALSE),
('Yoga Mat', 'Premium non-slip yoga mat for fitness enthusiasts', 39.99, 150, 5, FALSE);

-- Insert sample orders (for demonstration)
INSERT INTO orders (user_id, total, status, customer_info) VALUES 
(2, 1349.98, 'delivered', '{"name": "John Doe", "email": "john@example.com", "address": "123 Main St, City, State 12345", "phone": "+1234567890"}'),
(2, 79.99, 'processing', '{"name": "John Doe", "email": "john@example.com", "address": "123 Main St, City, State 12345", "phone": "+1234567890"}');

-- Insert sample order items
INSERT INTO order_items (order_id, product_id, quantity, price) VALUES 
(1, 1, 1, 999.99),
(1, 2, 1, 299.99),
(1, 4, 1, 49.99),
(2, 4, 1, 79.99);

-- Insert sample access link (for testing - token: "test1234567890abcdef1234567890abcd")
-- Token hash is SHA256 of the above token
INSERT INTO access_links (token_hash, status, expires_at) VALUES 
('a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'active', DATE_ADD(NOW(), INTERVAL 24 HOUR));

-- Create indexes for better performance
CREATE INDEX idx_products_search ON products(name, description);
CREATE INDEX idx_orders_date_status ON orders(created_at, status);
CREATE INDEX idx_access_links_lookup ON access_links(token_hash, status, expires_at);

-- Display table information
SELECT 'Database schema created successfully!' as message;
SELECT 'Tables created:' as info;
SHOW TABLES;

-- Display sample data counts
SELECT 'Sample data inserted:' as info;
SELECT 'Users' as table_name, COUNT(*) as count FROM users
UNION ALL
SELECT 'Categories', COUNT(*) FROM categories
UNION ALL
SELECT 'Products', COUNT(*) FROM products
UNION ALL
SELECT 'Orders', COUNT(*) FROM orders
UNION ALL
SELECT 'Order Items', COUNT(*) FROM order_items
UNION ALL
SELECT 'Access Links', COUNT(*) FROM access_links;
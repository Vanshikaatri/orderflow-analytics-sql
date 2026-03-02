CREATE DATABASE orderflow;
USE orderflow;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    city VARCHAR(50),
    signup_date DATE,
    is_active BOOLEAN DEFAULT TRUE
);

CREATE TABLE restaurants (
    restaurant_id INT PRIMARY KEY AUTO_INCREMENT,
    restaurant_name VARCHAR(100),
    city VARCHAR(50),
    cuisine_type VARCHAR(50),
    avg_preparation_time INT,
    rating DECIMAL(2,1),
    is_active BOOLEAN DEFAULT TRUE
);

CREATE TABLE riders (
    rider_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100),
    city VARCHAR(50),
    join_date DATE,
    vehicle_type VARCHAR(30),
    is_active BOOLEAN DEFAULT TRUE
);

CREATE TABLE orders (
    order_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    restaurant_id INT,
    order_time DATETIME,
    order_status VARCHAR(30),
    total_amount DECIMAL(10,2)
);

CREATE TABLE deliveries (
    delivery_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    order_id BIGINT,
    rider_id INT,
    pickup_time DATETIME,
    delivery_time DATETIME,
    delivery_status VARCHAR(30),
    delivery_minutes INT
);

CREATE TABLE payments (
    payment_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    order_id BIGINT,
    payment_method VARCHAR(30),
    payment_status VARCHAR(30),
    payment_time DATETIME
);
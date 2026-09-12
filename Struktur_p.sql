CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    password_hash VARCHAR(255),
    role ENUM('Owner', 'Kasir') DEFAULT 'Kasir',
    pin VARCHAR(6) NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50)
);

CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    category_id INT,
    name VARCHAR(100),
    image_url VARCHAR(255),
    base_price DECIMAL(10,2),
    large_price_add DECIMAL(10,2) DEFAULT 0,
    is_available BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (category_id) REFERENCES categories(id)
);

CREATE TABLE toppings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50),
    price DECIMAL(10,2),
    is_available BOOLEAN DEFAULT TRUE
);

CREATE TABLE cash_shifts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    start_time DATETIME,
    end_time DATETIME NULL,
    starting_cash DECIMAL(10,2),
    actual_cash DECIMAL(10,2) NULL,
    status ENUM('Open', 'Closed') DEFAULT 'Open',
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE transactions (
    id VARCHAR(20) PRIMARY KEY, -- Cth: TRX-20260912-0001
    user_id INT,
    shift_id INT,
    subtotal DECIMAL(10,2),
    discount DECIMAL(10,2) DEFAULT 0,
    tax DECIMAL(10,2) DEFAULT 0,
    total DECIMAL(10,2),
    payment_method ENUM('Tunai', 'QRIS', 'Debit', 'E-Wallet', 'Transfer'),
    amount_tendered DECIMAL(10,2),
    change_amount DECIMAL(10,2),
    status ENUM('Success', 'Void') DEFAULT 'Success',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (shift_id) REFERENCES cash_shifts(id)
);

CREATE TABLE transaction_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    transaction_id VARCHAR(20),
    product_id INT,
    product_name VARCHAR(100),
    size ENUM('Regular', 'Large') DEFAULT 'Regular',
    sugar_level VARCHAR(10),
    ice_level VARCHAR(20),
    notes TEXT,
    qty INT,
    unit_price DECIMAL(10,2),
    subtotal DECIMAL(10,2),
    FOREIGN KEY (transaction_id) REFERENCES transactions(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- Tabel pivot untuk topping pada setiap item transaksi
CREATE TABLE transaction_item_toppings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    transaction_item_id INT,
    topping_name VARCHAR(50),
    price DECIMAL(10,2),
    FOREIGN KEY (transaction_item_id) REFERENCES transaction_items(id)
);

CREATE TABLE expenses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    shift_id INT NULL,
    category VARCHAR(50),
    amount DECIMAL(10,2),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (shift_id) REFERENCES cash_shifts(id)
);

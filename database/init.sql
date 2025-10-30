CREATE TABLE User (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(255) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    phone VARCHAR(50),
    registration_date DATE NOT NULL,
    role ENUM('buyer', 'seller', 'admin') NOT NULL
);

CREATE TABLE Profile (
    profile_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    full_name VARCHAR(255),
    city VARCHAR(100),
    country VARCHAR(100),
    bio TEXT,
    avatar_url VARCHAR(512),
    FOREIGN KEY (user_id) REFERENCES User(user_id)
);

CREATE TABLE Category (
    category_id SERIAL PRIMARY KEY ,
    name VARCHAR(255) NOT NULL,
    description TEXT
);

CREATE TABLE Item (
    item_id SERIAL PRIMARY KEY,
    seller_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    category_id INT NOT NULL,
    price DECIMAL(12,2) NOT NULL,
    condition ENUM('new', 'used', 'restored') NOT NULL,
    creation_date DATETIME NOT NULL,
    status ENUM('active', 'sold', 'archived') NOT NULL,
    FOREIGN KEY (seller_id) REFERENCES User(user_id),
    FOREIGN KEY (category_id) REFERENCES Category(category_id)
);

CREATE TABLE Favorite (
    favorite_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    item_id INT NOT NULL,
    added_at DATETIME NOT NULL,
    FOREIGN KEY (user_id) REFERENCES User(user_id),
    FOREIGN KEY (item_id) REFERENCES Item(item_id)
);

CREATE TABLE `Order` (
    order_id SERIAL PRIMARY KEY,
    buyer_id INT NOT NULL,
    item_id INT NOT NULL,
    order_date DATETIME NOT NULL,
    total_price DECIMAL(12,2) NOT NULL,
    status ENUM('pending', 'paid', 'shipped', 'completed', 'cancelled') NOT NULL,
    FOREIGN KEY (buyer_id) REFERENCES User(user_id),
    FOREIGN KEY (item_id) REFERENCES Item(item_id)
);

CREATE TABLE Message (
    message_id SERIAL PRIMARY KEY,
    sender_id INT NOT NULL,
    receiver_id INT NOT NULL,
    item_id INT NOT NULL,
    content TEXT NOT NULL,
    sent_at DATETIME NOT NULL,
    FOREIGN KEY (sender_id) REFERENCES User(user_id),
    FOREIGN KEY (receiver_id) REFERENCES User(user_id),
    FOREIGN KEY (item_id) REFERENCES Item(item_id)
);

CREATE TABLE Review (
    review_id SERIAL PRIMARY KEY,
    reviewer_id INT NOT NULL,
    reviewed_user_id INT NOT NULL,
    rating INT NOT NULL,
    comment TEXT,
    review_date DATETIME NOT NULL,
    FOREIGN KEY (reviewer_id) REFERENCES User(user_id),
    FOREIGN KEY (reviewed_user_id) REFERENCES User(user_id)
);

CREATE TABLE seller_registration (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL,
    business_area VARCHAR(100) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    iin VARCHAR(12) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE seller (
    seller_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL UNIQUE,              -- связь с User
    business_area VARCHAR(100) NOT NULL,      -- Сфера деятельности
    iin VARCHAR(12) NOT NULL UNIQUE,          -- ИИН
    registration_date DATE NOT NULL DEFAULT CURRENT_DATE,
    FOREIGN KEY (user_id) REFERENCES User(user_id)
        ON DELETE CASCADE
);

-- Поменять в ERD в ID у таблиц INT на SERIAL и проч.

-- Пользователи
CREATE TABLE user (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(50) UNIQUE NOT NULL,
    phone VARCHAR(20),
    password VARCHAR(100) NOT NULL,
    password_hash VARCHAR NOT NULL,
    role VARCHAR(20) CHECK (role IN ('admin', 'seller', 'buyer')),
    registration_date TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Антиквариат / товары
CREATE TABLE item (
    item_id SERIAL PRIMARY KEY,
    seller_id INT REFERENCES user(user_id),
    title VARCHAR(100) NOT NULL,
    description TEXT,
    category_id INT REFERENCES category(category_id),
    price DECIMAL(10, 2),
    condition VARCHAR(10) CHECK (condition IN ('new', 'used', 'restored')),
    creation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(10) CHECK (status IN ('new', 'used', 'restored'))
);

-- Покупки
CREATE TABLE order (
    order_id SERIAL PRIMARY KEY,
    buyer_id INT REFERENCES users(id),
    item_id INT REFERENCES item(item_id),
    order_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_price DECIMAL(10, 2),
    status VARCHAR(10) CHECK (status IN ('pending', 'paid', 'shipped', 'completed', 'cancelled'))
);

-- Профиль
CREATE TABLE profile (
    profile_id SERIAL PRIMARY KEY,
    user_id INT UNIQUE REFERENCES user(user_id) ON DELETE CASCADE,
    full_name VARCHAR(100),
    city VARCHAR(50),
    country VARCHAR(50),
    bio TEXT,
    avatar_url VARCHAR(255)
);

-- Продавцы
CREATE TABLE seller (
    seller_id SERIAL PRIMARY KEY,
    user_id INT UNIQUE REFERENCES user(user_id) ON DELETE CASCADE,
    full_name VARCHAR(100),
    country VARCHAR(50) REFERENCES profile(country),
    email VARCHAR(50) REFERENCES user(email),
    occupation_type VARCHAR(50)
);

-- Избранное
CREATE TABLE favorite(
    favorite_id SERIAL PRIMARY KEY,
    user_id INT UNIQUE REFERENCES user(user_id),
    item_id INT REFERENCES item(item_id),
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Категории
CREATE TABLE category(
    category_id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,
    desription TEXT
);

-- Сообщения от покупателя к продавцу
CREATE TABLE message(
    message_id SERIAL PRIMARY KEY,
    sender_id REFERENCES user(user_id),
    receiver_id REFERENCES seller(seller_id),
    item_id REFERENCES item(item_id),
    content TEXT,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Отзыв
CREATE TABLE review(
    review_id SERIAL PRIMARY KEY,
    reviewer_id REFERENCES user(user_id),
    reviewed_user_id REFERENCES seller(seller_id),
    rating INT,
    comment TEXT,
    review_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);




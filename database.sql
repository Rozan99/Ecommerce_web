-- Create database
CREATE DATABASE IF NOT EXISTS malecloset;
USE malecloset;

-- Create users table
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create categories table
CREATE TABLE IF NOT EXISTS categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    slug VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    image VARCHAR(255)
);

-- Create products table
CREATE TABLE IF NOT EXISTS products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    category_id INT,
    name VARCHAR(100) NOT NULL,
    slug VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    sale_price DECIMAL(10, 2),
    stock INT NOT NULL DEFAULT 0,
    sku VARCHAR(50) UNIQUE,
    featured BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL
);

-- Create product_images table
CREATE TABLE IF NOT EXISTS product_images (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    image_path VARCHAR(255) NOT NULL,
    is_primary BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

-- Create product_attributes table
CREATE TABLE IF NOT EXISTS product_attributes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    size VARCHAR(10),
    color VARCHAR(20),
    stock INT NOT NULL DEFAULT 0,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

-- Create orders table
CREATE TABLE IF NOT EXISTS orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    total_amount DECIMAL(10, 2) NOT NULL,
    status ENUM('pending', 'processing', 'shipped', 'delivered', 'cancelled') DEFAULT 'pending',
    shipping_address TEXT NOT NULL,
    billing_address TEXT NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
);

-- Create order_items table
CREATE TABLE IF NOT EXISTS order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    size VARCHAR(10),
    color VARCHAR(20),
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

-- Create reviews table
CREATE TABLE IF NOT EXISTS reviews (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    user_id INT,
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
);

-- Create wishlist table
CREATE TABLE IF NOT EXISTS wishlist (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    UNIQUE KEY (user_id, product_id)
);

-- Insert sample categories
INSERT INTO categories (name, slug, description, image) VALUES
('Shirts', 'shirts', 'Premium quality shirts for all occasions', 'images/category-shirts.jpg'),
('T-Shirts', 'tshirts', 'Comfortable and stylish t-shirts', 'images/category-tshirts.jpg'),
('Pants', 'pants', 'Formal and casual pants', 'images/category-pants.jpg'),
('Jeans', 'jeans', 'Denim jeans in various styles and fits', 'images/category-jeans.jpg'),
('Suits', 'suits', 'Elegant suits for formal occasions', 'images/category-suits.jpg'),
('Accessories', 'accessories', 'Belts, ties, and other accessories', 'images/category-accessories.jpg');

-- Insert sample products
INSERT INTO products (category_id, name, slug, description, price, sale_price, stock, sku, featured) VALUES
(1, 'Slim Fit Cotton Shirt', 'slim-fit-cotton-shirt', 'This premium slim-fit shirt is crafted from high-quality cotton fabric that offers exceptional comfort and breathability. The modern cut provides a sleek silhouette while maintaining comfort throughout the day. Perfect for both casual and formal occasions.', 49.99, NULL, 100, 'SFS-001', TRUE),
(2, 'Premium Cotton T-Shirt', 'premium-cotton-tshirt', 'Our premium cotton t-shirt combines style and comfort with its soft, breathable fabric and modern fit. This versatile piece is perfect for casual outings or relaxed office environments. The durable construction ensures it will remain a staple in your wardrobe for years to come.', 29.99, NULL, 150, 'PCT-001', TRUE),
(3, 'Slim Fit Denim Jeans', 'slim-fit-denim-jeans', 'These slim-fit denim jeans offer the perfect balance of style and comfort. Made from high-quality denim with a touch of stretch for enhanced mobility. The classic five-pocket design and versatile wash make these jeans an essential addition to any wardrobe.', 59.99, NULL, 80, 'SDJ-001', TRUE),
(5, 'Classic Fit Formal Suit', 'classic-fit-formal-suit', 'Our classic fit formal suit is tailored to perfection using premium fabrics that ensure both comfort and elegance. The timeless design features a two-button jacket with notch lapels and flat-front trousers. Ideal for professional settings and special occasions alike.', 199.99, 179.99, 50, 'CFS-001', TRUE);

-- Insert sample product images
INSERT INTO product_images (product_id, image_path, is_primary) VALUES
(1, 'images/product1.jpg', TRUE),
(1, 'images/product1-2.jpg', FALSE),
(1, 'images/product1-3.jpg', FALSE),
(2, 'images/product2.jpg', TRUE),
(2, 'images/product2-2.jpg', FALSE),
(2, 'images/product2-3.jpg', FALSE),
(3, 'images/product3.jpg', TRUE),
(3, 'images/product3-2.jpg', FALSE),
(3, 'images/product3-3.jpg', FALSE),
(4, 'images/product4.jpg', TRUE),
(4, 'images/product4-2.jpg', FALSE),
(4, 'images/product4-3.jpg', FALSE);

-- Insert sample product attributes
INSERT INTO product_attributes (product_id, size, color, stock) VALUES
(1, 'S', 'Black', 20),
(1, 'M', 'Black', 30),
(1, 'L', 'Black', 25),
(1, 'XL', 'Black', 15),
(1, 'S', 'Blue', 15),
(1, 'M', 'Blue', 25),
(1, 'L', 'Blue', 20),
(1, 'XL', 'Blue', 10),
(1, 'S', 'Brown', 10),
(1, 'M', 'Brown', 20),
(1, 'L', 'Brown', 15),
(1, 'XL', 'Brown', 5),
(2, 'S', 'Black', 30),
(2, 'M', 'Black', 40),
(2, 'L', 'Black', 35),
(2, 'XL', 'Black', 25),
(2, 'S', 'White', 25),
(2,   'M', 'White', 35),
(2, 'L', 'White', 30),
(2, 'XL', 'White', 20),
(3, 'S', 'Blue', 15),
(3, 'M', 'Blue', 25),
(3, 'L', 'Blue', 20),
(3, 'XL', 'Blue', 10),
(3, 'S', 'Black', 10),
(3, 'M', 'Black', 20),
(3, 'L', 'Black', 15),
(3, 'XL', 'Black', 5),
(4, 'S', 'Black', 10),
(4, 'M', 'Black', 15),
(4, 'L', 'Black', 15),
(4, 'XL', 'Black', 10),
(4, 'S', 'Navy', 10),
(4, 'M', 'Navy', 15),
(4, 'L', 'Navy', 15),
(4, 'XL', 'Navy', 10);

-- Insert sample reviews
INSERT INTO reviews (product_id, user_id, rating, comment) VALUES
(1, NULL, 5, 'Perfect fit and great quality. I\'m extremely satisfied with this shirt. The fit is perfect and the material feels premium. Will definitely buy more colors!'),
(1, NULL, 4, 'Good shirt, slightly tight in the shoulders. The quality of the shirt is excellent, but I found it a bit tight in the shoulders. Consider sizing up if you have broader shoulders.'),
(1, NULL, 5, 'Versatile and comfortable. I\'ve worn this shirt for both casual and formal occasions, and it works great for both. The fabric is breathable and comfortable even after a full day of wear.'),
(2, NULL, 5, 'Best t-shirt I\'ve ever owned. The fabric is incredibly soft and the fit is perfect.'),
(2, NULL, 4, 'Great quality but runs a bit small. I had to exchange for a size up.'),
(3, NULL, 5, 'These jeans are amazing! Perfect fit and very comfortable.'),
(3, NULL, 4, 'Good quality denim with nice stretch. Would buy again.'),
(4, NULL, 5, 'Excellent suit for the price. Looks much more expensive than it is.'),
(4, NULL, 4, 'Good quality suit. Needed minor alterations but overall very satisfied.');
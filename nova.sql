create database NOVA;
USE nova;



-- 1. Users
CREATE TABLE User (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255),
    email VARCHAR(100) UNIQUE,
    password VARCHAR(255),
    role enum('user','admin') NOT NULL
);

ALTER TABLE User
ADD COLUMN reset_token_hash VARCHAR(64) NULL DEFAULT NULL AFTER password,
ADD COLUMN reset_token_expires_at DATETIME NULL DEFAULT NULL AFTER reset_token_hash,
ADD UNIQUE (reset_token_hash);
-- ALTER TABLE User ADD user_type VARCHAR(255);
select * from User;

CREATE TABLE messages (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  content TEXT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (id) REFERENCES User(id) ON DELETE CASCADE
);

select * from messages;

UPDATE User SET role = 'admin' WHERE email = 'anjalybesharii@gmail.com';
UPDATE User SET role = 'user' WHERE email = 'ani.kodheli90@gmail.com';

ALTER TABLE User ALTER role SET DEFAULT 'user';






-- 5. Orders
CREATE TABLE `orders` (
  `order_id`     INT            NOT NULL AUTO_INCREMENT,
  `user_id`      INT            NULL,
  `order_date`   TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `total_amount` DECIMAL(10,2)  NOT NULL,
  `status`       ENUM(
                    'pending',
                    'shipped',
                    'delivered',
                    'cancelled'
                  ) NOT NULL DEFAULT 'pending',
  PRIMARY KEY (`order_id`),
  INDEX `idx_orders_user` (`user_id`),
  CONSTRAINT `fk_orders_user`
    FOREIGN KEY (`user_id`)
    REFERENCES `User` (`id`)
    ON DELETE SET NULL
) ENGINE=InnoDB;

-- -- 6. Order Items
CREATE TABLE OrderItem (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    price_at_purchase DECIMAL(10, 2),
    FOREIGN KEY (order_id) REFERENCES `Orders`(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);


select * from user;
-- 9. Cart (One per user or session)
CREATE TABLE Cart (
    cart_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT UNIQUE,
    session_id VARCHAR(255) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES User(id) ON DELETE CASCADE
--     -- Enforce either user_id or session_id must be NOT NULL at app level or via trigger
);
use nova;
-- -- 10. Cart Items
CREATE TABLE CartItem (
    cart_item_id INT AUTO_INCREMENT PRIMARY KEY,
    cart_id INT,
    item_id INT,
    quantity INT,
    FOREIGN KEY (cart_id) REFERENCES Cart(cart_id) ON DELETE CASCADE
);



-- --------------------------------------------------------
-- Table structure for table `categories`
-- --------------------------------------------------------
CREATE TABLE `categories` (
  `category_id`    INT           NOT NULL AUTO_INCREMENT,
  `category_title` VARCHAR(100)  NOT NULL,
  PRIMARY KEY (`category_id`)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_general_ci;

-- Dumping data for table `categories`
INSERT INTO categories (`category_id`, `category_title`) VALUES
  (1, 'Necklace'),
  (2, 'Ring'),
  (3, 'Set'),
  (4, 'Earrings');

  



-- --------------------------------------------------------
-- Table structure for table `products`
-- --------------------------------------------------------
CREATE TABLE `products` (
  `product_id`          INT             NOT NULL AUTO_INCREMENT,
  `product_title`       VARCHAR(255)    NOT NULL,
  `product_description` VARCHAR(255)    NOT NULL,
  `category_id`         INT             NOT NULL,
  `product_image`      VARCHAR(255)    NOT NULL, 
  `product_price`       DECIMAL(10,2)   NOT NULL,
  `status`              VARCHAR(100)    NOT NULL,
  PRIMARY KEY (`product_id`)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_general_ci;


-- Dumping data for table `products`
INSERT INTO `products`
  (`product_id`,`product_title`,`product_description`,`category_id`,`product_image`,`product_price`,`status`)
VALUES
  (1, 'Diamond Ring', 'beautiful diamond ring', 2, 'kolek-ri-2.jpg', 10000.00,'true');


alter table products;
INSERT INTO `products`
  (`product_id`,`product_title`,`product_description`,`category_id`,`product_image`,`product_price`,`status`)
VALUES
(2, 'Diamond Set', 'beautiful diamond set', 3, 'shiko 3.jpg', 15000.00,'true');


alter table products;
INSERT INTO `products`
  (`product_id`,`product_title`,`product_description`,`category_id`,`product_image`,`product_price`,`status`)
VALUES

(3, 'Diamond Earrings', 'beautiful diamond earrings', 4, 'kolek ri 3.jpg', 15000.00,'true'),
(4, 'Diamond Necklace', 'beautiful diamond necklace', 1, 'kolek ri1.jpg', 20000.00,'true'),
(5, 'Diamond Set', 'beautiful diamond set', 3, 'shiko 1.jpg', 15000.00,'true'),
(6, 'Diamond Set', 'beautiful diamond set', 3, 'shiko 2.jpg', 15000.00,'true'),
(7, 'Diamond Set', 'beautiful diamond set', 3, 'shiko 4.jpg', 15000.00,'true'),
(8, 'Diamond Necklace', 'beautiful diamond necklace', 1, 'te_pref1.png', 17000.00,'true'),
(9, 'Diamond Necklace', 'beautiful diamond necklace', 1, 'te_pref2.png', 15000.00,'true'),
(10, 'Diamond Bracelet', 'beautiful diamond bracelet', 5, 'te_pref3.png', 7000.00,'true'),
(11, 'Diamond Earrings', 'beautiful diamond earrings', 4, 'te_pref4.png', 8000.00,'true'),
(12, 'Diamond Ring', 'beautiful diamond ring', 2, 'te_pref5.png', 5000.00,'true'),
(13, 'Diamond Ring', 'beautiful diamond ring', 2, 'te_pref6.png', 15000.00,'true');




alter table categories;
insert into categories (category_id, category_title) values
(5, 'Bracelet');




-- --------------------------------------------------------
-- Table structure for table `user_orders`
-- --------------------------------------------------------
CREATE TABLE `user_orders` (
  `order_id`      INT             NOT NULL AUTO_INCREMENT,
  `user_id`       INT             NOT NULL,
  `amount_due`    DECIMAL(10,2)   NOT NULL,
  `invoice_number`INT             NOT NULL,
  `total_products`INT             NOT NULL,
  `order_date`    TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP()
                                         ON UPDATE CURRENT_TIMESTAMP(),
  `order_status`  VARCHAR(255)    NOT NULL,
  PRIMARY KEY (`order_id`),
  KEY `idx_uo_user` (`user_id`),
  CONSTRAINT `fk_uo_user`
    FOREIGN KEY (`user_id`) REFERENCES `user_table`(`user_id`)
      ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_general_ci;



--   





CREATE USER 'ani'@'%' IDENTIFIED BY 'ani_pw';

-- give her all rights on NOVA (or restrict to SELECT/INSERT/… as needed)
GRANT ALL PRIVILEGES
  ON NOVA.* 
  TO 'ani'@'%';

FLUSH PRIVILEGES;

ALTER USER 'ani'@'%' 
  IDENTIFIED WITH mysql_native_password 
  BY 'ani_pw';

ALTER USER 'root'@'localhost' 
  IDENTIFIED WITH mysql_native_password 
  BY 'Anja21/05/18';

FLUSH PRIVILEGES;



-- 1) Ensure ani exists & uses native-password
--    If ani already exists, ALTER; otherwise CREATE:
ALTER USER 'ani'@'%' 
  IDENTIFIED WITH mysql_native_password 
  BY 'YourNewSecurePassword';

-- 2) Grant her rights on NOVA
GRANT ALL PRIVILEGES
  ON NOVA.* 
  TO 'ani'@'%';

-- 3) (Optional) If you want to lock her down to a single IP, you can DROP the '%' user and re-create for that IP:
DROP USER 'ani'@'%';
CREATE USER 'ani'@'192.168.1.166' 
  IDENTIFIED WITH ani_nova 
  BY 'ani_pw';
GRANT ALL PRIVILEGES ON NOVA.* TO 'ani'@'192.168.1.166';

-- 4) Reload the grant tables
FLUSH PRIVILEGES;






-- 1) Drop any stray ani accounts so we start clean:
DROP USER IF EXISTS 'ani'@'%';
DROP USER IF EXISTS 'ani'@'192.168.1.166';

-- 2) Create the user—choose one of these:

-- 2A) allow from ANY host:
CREATE USER 'ani'@'%'
  IDENTIFIED WITH mysql_native_password
  BY 'ani_pw';

-- 2B) restrict to only 192.168.1.166 (uncomment if you prefer):
-- CREATE USER 'ani'@'192.168.1.166'
--   IDENTIFIED WITH mysql_native_password
--   BY 'YourNewSecurePassword';

-- 3) Grant privileges (must match exactly what you created above):

-- If you used '%':
GRANT ALL PRIVILEGES 
  ON NOVA.* 
  TO 'ani'@'%';

-- Or if you used the specific IP:
-- GRANT ALL PRIVILEGES 
--   ON NOVA.* 
--   TO 'ani'@'192.168.1.166';

-- 4) Finalize
FLUSH PRIVILEGES;


-- ALTEA
CREATE USER 'altea'@'%'
  IDENTIFIED WITH mysql_native_password
  BY 'altea_pw';

-- 2B) restrict to only 192.168.1.166 (uncomment if you prefer):
-- CREATE USER 'ani'@'192.168.1.166'
--   IDENTIFIED WITH mysql_native_password
--   BY 'YourNewSecurePassword';

-- 3) Grant privileges (must match exactly what you created above):

-- If you used '%':
GRANT ALL PRIVILEGES 
  ON NOVA.* 
  TO 'altea'@'%';

-- Or if you used the specific IP:
-- GRANT ALL PRIVILEGES 
--   ON NOVA.* 
--   TO 'altea'@'192.168.1.166';

-- 4) Finalize
FLUSH PRIVILEGES;


-- olta
CREATE USER 'olta'@'%'
  IDENTIFIED WITH mysql_native_password
  BY 'olta_pw';

-- 2B) restrict to only 192.168.1.166 (uncomment if you prefer):
-- CREATE USER 'ani'@'192.168.1.166'
--   IDENTIFIED WITH mysql_native_password
--   BY 'YourNewSecurePassword';

-- 3) Grant privileges (must match exactly what you created above):

-- If you used '%':
GRANT ALL PRIVILEGES 
  ON NOVA.* 
  TO 'olta'@'%';

-- Or if you used the specific IP:
-- GRANT ALL PRIVILEGES 
--   ON NOVA.* 
--   TO 'altea'@'192.168.1.166';

-- 4) Finalize
FLUSH PRIVILEGES;









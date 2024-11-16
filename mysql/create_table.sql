
docker exec -it mysql mysql -u dads6005 -p

---------------------------------------------------------
----- Create Schema & Data -----

CREATE DATABASE IF NOT EXISTS dads6005;
USE dads6005;

CREATE TABLE flash_sales (
  sale_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  customer_id BIGINT,
  province_id INT,
  product_id VARCHAR(20),
  region_id VARCHAR(20),
  discount DECIMAL(5, 2),
  original_price DECIMAL(10, 2),
  sale_price DECIMAL(10, 2),
  quantity INT,
  sale_datetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  );

CREATE TABLE region (
  region_id VARCHAR(10) PRIMARY KEY,
  region_name VARCHAR(100)
  );

CREATE TABLE pages (
    page_id VARCHAR(10) PRIMARY KEY,
    page_group VARCHAR(50),
    page_name VARCHAR(50)
);

CREATE TABLE product (
    product_id VARCHAR(5) PRIMARY KEY,
    product_group VARCHAR(50),
    product_name VARCHAR(50)
);

---------------------------------------------------------
----- Insert Data -----

INSERT INTO pages (page_id, page_group, page_name) VALUES
-- Electronics (Page_10 to Page_29)
('Page_10', 'Electronics', 'Smartphone Accessories'),
('Page_11', 'Electronics', 'Laptops & Notebooks'),
('Page_12', 'Electronics', 'Headphones & Earbuds'),
('Page_13', 'Electronics', 'Smart Home Devices'),
('Page_14', 'Electronics', 'Digital Cameras'),
('Page_15', 'Electronics', 'Gaming Consoles'),
('Page_16', 'Electronics', 'Television & Accessories'),
('Page_17', 'Electronics', 'Portable Chargers'),
('Page_18', 'Electronics', 'Bluetooth Speakers'),
('Page_19', 'Electronics', 'Wearable Technology'),
('Page_20', 'Electronics', 'Computer Components'),
('Page_21', 'Electronics', 'Networking Devices'),
('Page_22', 'Electronics', 'Drones & Quadcopters'),
('Page_23', 'Electronics', 'Smart Watches'),
('Page_24', 'Electronics', 'Tablet Accessories'),
('Page_25', 'Electronics', 'Virtual Reality Headsets'),
('Page_26', 'Electronics', 'Home Audio Systems'),
('Page_27', 'Electronics', 'Printers & Scanners'),
('Page_28', 'Electronics', 'Projectors'),
('Page_29', 'Electronics', 'e-Readers'),

-- Fashion (Page_30 to Page_49)
('Page_30', 'Fashion', 'Mens Clothing'),
('Page_31', 'Fashion', 'Womens Clothing'),
('Page_32', 'Fashion', 'Kids Wear'),
('Page_33', 'Fashion', 'Footwear'),
('Page_34', 'Fashion', 'Bags & Luggage'),
('Page_35', 'Fashion', 'Jewelry'),
('Page_36', 'Fashion', 'Watches'),
('Page_37', 'Fashion', 'Sunglasses'),
('Page_38', 'Fashion', 'Hats & Caps'),
('Page_39', 'Fashion', 'Belts'),
('Page_40', 'Fashion', 'Scarves & Shawls'),
('Page_41', 'Fashion', 'Cosmetics'),
('Page_42', 'Fashion', 'Perfumes'),
('Page_43', 'Fashion', 'Accessories'),
('Page_44', 'Fashion', 'Formal Wear'),
('Page_45', 'Fashion', 'Casual Wear'),
('Page_46', 'Fashion', 'Sportswear'),
('Page_47', 'Fashion', 'Sleepwear'),
('Page_48', 'Fashion', 'Winter Clothing'),
('Page_49', 'Fashion', 'Handmade Jewelry'),

-- Furniture (Page_50 to Page_69)
('Page_50', 'Furniture', 'Living Room Furniture'),
('Page_51', 'Furniture', 'Bedroom Furniture'),
('Page_52', 'Furniture', 'Office Furniture'),
('Page_53', 'Furniture', 'Dining Room Sets'),
('Page_54', 'Furniture', 'Outdoor Furniture'),
('Page_55', 'Furniture', 'Storage Solutions'),
('Page_56', 'Furniture', 'Kitchen Cabinets'),
('Page_57', 'Furniture', 'TV Stands'),
('Page_58', 'Furniture', 'Sofas & Sectionals'),
('Page_59', 'Furniture', 'Coffee Tables'),
('Page_60', 'Furniture', 'Bookshelves'),
('Page_61', 'Furniture', 'Beds & Mattresses'),
('Page_62', 'Furniture', 'Wardrobes'),
('Page_63', 'Furniture', 'Dressers'),
('Page_64', 'Furniture', 'Nightstands'),
('Page_65', 'Furniture', 'Office Chairs'),
('Page_66', 'Furniture', 'Desks'),
('Page_67', 'Furniture', 'Patio Furniture'),
('Page_68', 'Furniture', 'Bean Bags'),
('Page_69', 'Furniture', 'Home Decor'),

-- Dry Grocery (Page_70 to Page_89)
('Page_70', 'Dry Grocery', 'Cereals & Breakfast Foods'),
('Page_71', 'Dry Grocery', 'Snacks'),
('Page_72', 'Dry Grocery', 'Pasta & Noodles'),
('Page_73', 'Dry Grocery', 'Canned Foods'),
('Page_74', 'Dry Grocery', 'Condiments & Sauces'),
('Page_75', 'Dry Grocery', 'Spices & Herbs'),
('Page_76', 'Dry Grocery', 'Baking Supplies'),
('Page_77', 'Dry Grocery', 'Tea & Coffee'),
('Page_78', 'Dry Grocery', 'Juices & Soft Drinks'),
('Page_79', 'Dry Grocery', 'Cookies & Biscuits'),
('Page_80', 'Dry Grocery', 'Energy Bars'),
('Page_81', 'Dry Grocery', 'Dried Fruits & Nuts'),
('Page_82', 'Dry Grocery', 'Instant Foods'),
('Page_83', 'Dry Grocery', 'Organic Food'),
('Page_84', 'Dry Grocery', 'Grains & Rice'),
('Page_85', 'Dry Grocery', 'Sugar & Sweeteners'),
('Page_86', 'Dry Grocery', 'Soup & Broth'),
('Page_87', 'Dry Grocery', 'Baby Food'),
('Page_88', 'Dry Grocery', 'Flour & Baking Essentials'),
('Page_89', 'Dry Grocery', 'Canned Fish'),

-- Other (Page_90 to Page_99)
('Page_90', 'Other', 'Art Supplies'),
('Page_91', 'Other', 'Gift Wrap & Cards'),
('Page_92', 'Other', 'Craft Kits'),
('Page_93', 'Other', 'Board Games'),
('Page_94', 'Other', 'Pet Supplies'),
('Page_95', 'Other', 'Health & Wellness'),
('Page_96', 'Other', 'Stationery'),
('Page_97', 'Other', 'Garden & Plants'),
('Page_98', 'Other', 'Fitness Equipment'),
('Page_99', 'Other', 'Travel Accessories');


INSERT INTO product (product_id, product_group, product_name)
SELECT 
    CONCAT('P', RIGHT(page_id, 2)) AS product_id,  -- 'P' + last 2 digits of page_id
    page_group AS product_group,
    page_name AS product_name
FROM pages;
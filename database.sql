/*
CREACION DE LA BD
*/

-- table.identification_types definition
CREATE TABLE IF NOT EXISTS identification_types
(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
	`name` VARCHAR(150) DEFAULT NULL,
	`created_at` DATETIME NOT NULL,
	`modified_at` TIMESTAMP NOT NULL,
	`is_active` TINYINT(2) DEFAULT 1
);

-- table.menus definition
CREATE TABLE IF NOT EXISTS menus
(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
	`name` VARCHAR(150) DEFAULT NULL,
	`route` VARCHAR(50) DEFAULT NULL,
	`identification` VARCHAR(50) DEFAULT NULL,
	`group` VARCHAR(100) DEFAULT NULL,
	`created_at` DATETIME NOT NULL,
	`modified_at` TIMESTAMP NOT NULL,
	`is_active` TINYINT(2) DEFAULT 1
);

-- table.users definition
CREATE TABLE IF NOT EXISTS users
(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
	`name` VARCHAR(150) DEFAULT NULL,
	`last_name` VARCHAR(150) DEFAULT NULL,
	`phone` CHAR(13) DEFAULT NULL,
	`email` VARCHAR(200) DEFAULT NULL,
	`identification` CHAR(20) NOT NULL,
	`password_hash` VARCHAR(100) NOT NULL,
	`profile_image` VARCHAR(500) DEFAULT NULL,
	`validate` INT(11) DEFAULT 0,
	`email_token` VARCHAR(250) DEFAULT NULL,
	`api_key` VARCHAR(250) DEFAULT NULL,
	`identification_type_id` INT(11) NOT NULL,
	`created_at` DATETIME NOT NULL,
	`modified_at` TIMESTAMP NOT NULL,
	`is_active` TINYINT(2) DEFAULT 1,
	FOREIGN KEY (`identification_type_id`) REFERENCES `identification_types` (`id`),
	INDEX `idx_identification_type_id` (`identification_type_id`) USING BTREE
);

-- table.menu_users definition
CREATE TABLE IF NOT EXISTS menu_users
(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
	`user_id` INT(11) DEFAULT NULL,
	`menu_id` INT(11) DEFAULT NULL,
	`permission` CHAR(2) DEFAULT NULL,
	`created_at` DATETIME NOT NULL,
	`modified_at` TIMESTAMP NOT NULL,
	`is_active` TINYINT(2) DEFAULT 1,
	FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
	FOREIGN KEY (`menu_id`) REFERENCES `menus` (`id`),
	INDEX `idx_user_id` (`user_id`) USING BTREE,
	INDEX `idx_menu_id` (`menu_id`) USING BTREE
);

-- table.customers definition
CREATE TABLE IF NOT EXISTS customers
(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
	`name` VARCHAR(150) DEFAULT NULL,
	`lastname` VARCHAR(150) DEFAULT NULL,
	`phone` CHAR(13) DEFAULT NULL,
	`identification` CHAR(20) DEFAULT NULL,
	`identification_type_id` INT(11) NOT NULL,
	`created_at` DATETIME NOT NULL,
	`modified_at` TIMESTAMP NOT NULL,
	`is_active` TINYINT(2) DEFAULT 1,
	FOREIGN KEY (`identification_type_id`) REFERENCES `identification_types` (`id`),
	INDEX `idx_identification_type_id` (`identification_type_id`) USING BTREE
);

-- table.liters_milk definition
CREATE TABLE IF NOT EXISTS liters_milk
(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
	`stock` INT(11) DEFAULT NULL,
	`name` VARCHAR(100) DEFAULT NULL,
	`created_at` DATETIME NOT NULL,
	`modified_at` TIMESTAMP NOT NULL,
	`is_active` TINYINT(2) DEFAULT 1
);

-- table.purchases definition
CREATE TABLE IF NOT EXISTS purchases
(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
	`customer_name` VARCHAR(150) DEFAULT NULL,
	`customer_lastname` VARCHAR(150) DEFAULT NULL,
	`customer_phone` CHAR(13) DEFAULT NULL,
	`customer_identification` CHAR(20) DEFAULT NULL,
	`customer_id` INT(11) DEFAULT NULL,
	`total` DECIMAL(50,2) DEFAULT NULL,
	`comment` VARCHAR(255) DEFAULT NULL,
	`status_sales` INT(11) DEFAULT 2,
	`user_id` INT(11) DEFAULT NULL,
	`created_at` DATETIME NOT NULL,
	`modified_at` TIMESTAMP NOT NULL,
	`is_active` TINYINT(2) DEFAULT 1,
	FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
	FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`),
	INDEX `idx_user_id` (`user_id`) USING BTREE,
	INDEX `idx_customer_id` (`customer_id`) USING BTREE
);

-- table.sales definition
CREATE TABLE IF NOT EXISTS purchase_details
(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
	`stock` INT(11) DEFAULT NULL,
	`price` DECIMAL(50,2) DEFAULT NULL,
	`total` DECIMAL(50,2) DEFAULT NULL,
	`purchase_id` INT(11) DEFAULT NULL,
	`liters_milk_id` INT(11) DEFAULT NULL,
	`created_at` DATETIME NOT NULL,
	`modified_at` TIMESTAMP NOT NULL,
	`is_active` TINYINT(2) DEFAULT 1,
	FOREIGN KEY (`purchase_id`) REFERENCES `purchases` (`id`),
	FOREIGN KEY (`liters_milk_id`) REFERENCES `liters_milk` (`id`),
	INDEX `idx_purchase_id` (`purchase_id`) USING BTREE,
	INDEX `idx_liters_milk_id` (`liters_milk_id`) USING BTREE
);

/*
Create Store Procedures
*/

-- Procedure.SP_I_IDENTIFICATIONTYPES
DELIMITER //
CREATE PROCEDURE IF NOT EXISTS SP_I_IDENTIFICATIONTYPES
(
    IN name_identification VARCHAR(150),
    IN created_identification DATETIME
)
BEGIN
    INSERT INTO identification_types (name, created_at)
    VALUES (name_identification, created_identification);
END//
DELIMITER ;

CALL SP_I_IDENTIFICATIONTYPES ("Cedula", "2024-04-22 14:20:00");
CALL SP_I_IDENTIFICATIONTYPES ("Tarjeta Identificacion", "2024-04-22 14:20:00");
CALL SP_I_IDENTIFICATIONTYPES ("Cedula Extranjeria", "2024-04-22 14:20:00");

INSERT INTO users (name, last_name, phone, email, identification, password_hash, validate, email_token, api_key, created_at, identification_type_id) 
VALUES ("Admin", "Admin123", "+573124161291", "admin@gmail.com", "12345678910", "$2y$10$0kFnZhqxkDdLl93Jb60cfuusVJ8X8w5H7cSV2eohrn55HsVFt1KTm", 1, "apKal600382kjaldjsjue8380201", "a36001fb-d403-42ba-8fc2-ba4dcb9dffe1", "2024-04-22 14:00:00", 1);

INSERT INTO menus (name, route, identification, `group`, created_at) VALUES
("Dashboard", "../home/", "dashboard", "Dashboard", "2024-04-22 14:20:00"),
("Usuarios", "../users/", "users", "Mantenimiento", "2024-04-22 14:20:00"),
("Clientes", "../customers/", "customers", "Mantenimiento", "2024-04-22 14:20:00"),
("Litros Leche", "../litersMilk/", "litersmilk", "Mantenimiento", "2024-04-22 14:20:00"),
("Compra Litros", "../purchaseLitersMilk/", "purchaselitersmilk", "Compra", "2024-04-22 14:20:00"),
("Lista Litros", "../listLitersMilk/", "listlitersmilk", "Compra", "2024-04-22 14:20:00");

INSERT INTO menu_users (user_id, menu_id, permission, created_at) VALUES
(1, 1, "Si", "2024-04-22 14:20:00"),
(1, 2, "Si", "2024-04-22 14:20:00"),
(1, 3, "Si", "2024-04-22 14:20:00"),
(1, 4, "Si", "2024-04-22 14:20:00"),
(1, 5, "Si", "2024-04-22 14:20:00"),
(1, 6, "Si", "2024-04-22 14:20:00");
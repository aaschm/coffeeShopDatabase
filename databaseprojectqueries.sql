CREATE DATABASE IF NOT EXISTS cs;

USE cs;
DROP TABLE IF EXISTS cs.drinkmenu;
CREATE TABLE IF NOT EXISTS drinkmenu(
drink_ID int NOT NULL AUTO_INCREMENT,
drinkName varchar(255),
price DECIMAL(5,2),
PRIMARY KEY (drink_ID)
);

INSERT INTO drinkmenu (drinkName, price)
VALUES ("Americano", 1.50),
		("Capuccino", 2.00),
		("Macchiato", 2.50),
        ("Espresso", 2.00), 
        ("Latte", 1.50),
        ("Latte Art", 2.75), 
        ("Mocha", 2.00), 
        ("Cold Brew", 2.25),
        ("Nitro", 4.00),
        ("Chai Tea", 3.00),
        ("Herbal Tea", 2.50),
        ("Iced Tea Lemonade", 2.75);

ALTER TABLE drinkmenu 
ADD CONSTRAINT drink_unique UNIQUE (drinkName);

DROP TABLE IF EXISTS cs.positions;
CREATE TABLE IF NOT EXISTS positions(
position_ID int NOT NULL AUTO_INCREMENT,
positionName varchar(255),
positionHourlyRate DECIMAL(5,2),
PRIMARY KEY (position_ID)
);

INSERT INTO positions (positionName, positionHourlyRate)
VALUES ("Barista", 15.00),
		("Shift Manager", 18.00),
		("General Manager", 19.00),
        ("Latte Artist", 16.50), 
        ("Customer Service", 14.00);
        
DROP TABLE IF EXISTS cs.employeeInfo;
CREATE TABLE IF NOT EXISTS employeeInfo(
emp_ID int NOT NULL AUTO_INCREMENT,
empFirstName varchar(255),
empLastName varchar(255),
empPhone varchar(255),
empAddress varchar(255),
position_ID int,
PRIMARY KEY (emp_ID),
FOREIGN KEY (position_ID) REFERENCES positions(position_ID)
);

INSERT INTO employeeInfo (empFirstName, empLastName, empPhone, empAddress, position_ID)
VALUES ("John", "Doe", "720-222-9999", "12 Rock Ave", 1),
		("Jake", "Muck", "720-232-2414", "11 Mineral Ave", 2),
		("James", "Luck", "720-245-2314", "10 Sediment Ave", 3),
        ("Julie", "Amers", "720-222-2266", "1 Plaque Ave", 2),
        ("Jennise", "Sull", "710-232-2414", "5 Stone Ave", 4),
        ("Lan", "Smith", "720-243-2111", "1 Sand Ave", 5),
        ("Thom", "Lafa", "303-221-2000", "7 Water Ave", 1),
        ("Cindy", "Pan", "720-562-2431", "50 Beach Ave", 1),
        ("Lina", "Sanders", "720-888-2414", "22 Mountain Ave", 1),
        ("Loo", "Kim", "720-222-2347", "110 Valey Ave", 1);



DROP TABLE IF EXISTS cs.ordertable;
CREATE TABLE IF NOT EXISTS ordertable(
order_ID int NOT NULL AUTO_INCREMENT,
emp_ID int,
customerFirstName varchar(255),
customerLastName varchar(255),
drink_ID int,
PRIMARY KEY (order_ID),
FOREIGN KEY (drink_ID) REFERENCES drinkmenu(drink_ID),
FOREIGN KEY (emp_ID) REFERENCES employeeinfo(emp_ID)
);


INSERT INTO ordertable (emp_ID,customerFirstName, customerLastName, drink_ID)
VALUES (1,"Ally", "Smith", 2),
	   (1,"Barack", "Obama", 2),
	   (2,"Andy", "Loo", 2),
	   (3,"Ally", "Smith", 2);
       
DROP TABLE IF EXISTS cs.inventory;
CREATE TABLE IF NOT EXISTS inventory(
drink_ID int,
quantity int,
costPerUnit DEC(5,2),
FOREIGN KEY (drink_ID) REFERENCES drinkmenu(drink_ID));


INSERT INTO inventory (drink_ID,quantity, costPerUnit)
VALUES (1,100, 1.20),
	   (2,300, 2.00),
	   (3, 400, 2.25), 
	   (4, 100, 2.20),
	   (5, 250, 0.50),
	   (6, 400, 1.75), 
	   (7, 100, 2.00);

SELECT drink_ID, quantity, costPerUnit, quantity * costPerUnit AS totalCost 
FROM inventory
WHERE quantity > 100;

SELECT emp_ID, empFirstName, empLastName, CONCAT(empfirstName, " ", empLastName) AS empFULLName
FROM employeeinfo
ORDER BY empLastName; 

SELECT drinkName, price 
FROM drinkmenu
WHERE price > (SELECT AVG(price) FROM drinkmenu);

UPDATE drinkmenu
SET drinkName = "Caramel Machiato"
WHERE drink_ID = 3;

DELETE FROM employeeinfo
WHERE emp_ID = 5; 

INSERT INTO employeeinfo (empFirstName, empLastName, empPhone, empAddress, position_ID)
VALUES ("Jennise", "Sull", "710-232-2414", "5 Stone Ave", 4);

SELECT drinkName, price, costPerUnit, price - costPerunit AS profit
FROM drinkmenu d
INNER JOIN inventory i
ON d.drink_ID = i.drink_ID;
		
		


DROP PROCEDURE IF EXISTS drinkCount; 

DELIMITER //

CREATE PROCEDURE drinkCount()
BEGIN
	DECLARE drink_count_v INT; 
    
	SELECT COUNT(drink_ID)
	INTO drink_count_v 
	FROM inventory 
	WHERE costPerUnit >= 1.00;
	IF drink_count_v > 0 THEN
    SELECT CONCAT(drink_count_v, ' drinks have a cost Per Unit over $1.00') AS message;
  ELSE
    SELECT 'No drnks exceed $1.00' AS message;
  END IF; 
END//
 
-- Change statement delimiter from double front slash to semicolon 
DELIMITER ;
 
CALL drinkCount();

DROP PROCEDURE IF EXISTS employeeType; 

DELIMITER //
CREATE PROCEDURE employeeType()
BEGIN
	DECLARE employee_count_v INT; 
    
	SELECT COUNT(emp_ID)
	INTO employee_count_V 
	FROM employeeinfo 
	WHERE position_ID = 1;
	IF employee_count_v > 0 THEN
    SELECT CONCAT(employee_count_V, ' employees are baristas') AS message;
  ELSE
    SELECT 'No employees are baristas' AS message;
  END IF; 
END//
 
-- Change statement delimiter from double front slash to semicolon 
DELIMITER ;
 
CALL employeeType();

DROP TABLE IF EXISTS reminders;

CREATE TABLE reminders (
	message_ID int NOT NULL AUTO_INCREMENT,
    message VARCHAR(255) NOT NULL,
    PRIMARY KEY (message_ID)
);

delimiter //
CREATE TRIGGER drinkunavailable AFTER INSERT
ON ordertable
FOR EACH ROW
IF NEW.drink_ID = 2 THEN
SIGNAL SQLSTATE '50001' SET MESSAGE_TEXT = 'Drink is no longer available';
END IF; //
delimiter ;



INSERT INTO ordertable(emp_ID, customerFirstName, customerLastName, drink_ID)
VALUES(1, 'Andy', 'Candy', 2);


SELECT * FROM employeeinfo;

-- drop employeeType procedure if exists 
DROP PROCEDURE IF EXISTS employeeType; 

-- Change statement delimiter from semicolon to double front slash 
DELIMITER //
CREATE PROCEDURE employeeType()
BEGIN
	-- declare local variable as integer type for employeeType procedure 
	DECLARE employee_count_v INT; 
    
    -- select count of emp_ID and store value into local variable  where position_ID = 1 
	SELECT COUNT(emp_ID)
	INTO employee_count_V 
	FROM employeeinfo 
	WHERE position_ID = 1;
    
    -- if/else statement to print message to user based on how many employees are baristas 
	IF employee_count_v > 0 THEN
		SELECT CONCAT(employee_count_V, ' employees are baristas') AS message;
	ELSE
		SELECT 'No employees are baristas' AS message;
  END IF; 
END//
 
-- Change statement delimiter from double front slash to semicolon 
DELIMITER ;
 
 -- call employeeType procedure 
CALL employeeType();

-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------

DROP PROCEDURE IF EXISTS drinkMenuValidPrice;

DELIMITER //
-- create procedure to prevent negative prices 
CREATE PROCEDURE drinkMenuValidPrice
(
	drink_id_param     INT,
    drinkName_param    VARCHAR(50),
    price_param        DEC(5,2)
 )

BEGIN
	IF price_param < 0.00 THEN 
		SIGNAL SQLSTATE '22003' 
          SET MESSAGE_TEXT = 
			'The price must have a value greater than 0',
		  MYSQL_ERRNO = 1146; 
	END IF;
	IF drinkName_param = 'NULL' THEN
		SIGNAL SQLSTATE '22003' 
			SET MESSAGE_TEXT = 
			'Must have a drink name, this will not accept NULL values',
		MYSQL_ERRNO = 1146; 
	END IF; 
    
    INSERT INTO drinkMenu(drink_ID, drinkName, price)
    VALUES(drink_id_param, drinkName_param, price_param); 
    
END //

DELIMITER ; 

CALL drinkMenuValidPrice(20, 'Ice Cream Latte' , -2.00); 

------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
DELIMITER //
CREATE TRIGGER drinkunavailable AFTER INSERT
	ON ordertable
	FOR EACH ROW
	IF NEW.drink_ID = 2 THEN
		SIGNAL SQLSTATE '50001' SET MESSAGE_TEXT = 'Drink is no longer available';
	END IF; //
delimiter ;

INSERT INTO ordertable(emp_ID, customerFirstName, customerLastName, drink_ID)
VALUES(1, 'Andy', 'Candy', 2);


SELECT * FROM employeeinfo;
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

-- create trigger to update inventory with each new order made 
DROP TRIGGER IF EXISTS updateInvetory; 


delimiter // 
CREATE TRIGGER updateInentory 
	AFTER INSERT ON ordertable 
	FOR EACH ROW 
	UPDATE inventory i
    SET quantity = quantity - 1
    WHERE i.drink_ID= NEW.drink_ID
//
delimiter ; 

INSERT INTO ordertable(emp_ID, customer_ID, drink_ID)
	VALUES(1, 2, 4); 


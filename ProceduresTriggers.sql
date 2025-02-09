
-- drop procedure if drinkCount already exists 
DROP PROCEDURE IF EXISTS drinkCount; 

-- Change statement delimiter from semicolon to double front slash
DELIMITER //
-- create new procedure drinkCount 
	CREATE PROCEDURE drinkCount()
	BEGIN
		-- declare procedure variable as integer type
		DECLARE drink_count_v INT; 
		-- select count of drink_ID where costPerUnit is greater than $1.00
		SELECT COUNT(drink_ID)
		INTO drink_count_v 
		FROM inventory 
		WHERE costPerUnit >= 1.00;
		-- if/else statement to print out message to user 
		IF drink_count_v > 0 THEN
			SELECT CONCAT(drink_count_v, ' drinks have a cost Per Unit over $1.00') AS message;
		ELSE
			SELECT 'No drnks exceed $1.00' AS message;
		END IF; 
	END//general_ledger_accounts
-- Change statement delimiter from double front slash to semicolon 
DELIMITER ;
 
 -- call drinkCount procedure 
CALL drinkCount();

------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

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


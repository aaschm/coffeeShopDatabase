# Coffee Shop Database

This project is a simple database designed for managing a coffee shop's operations. It tracks employees, drinks on the menu, inventory levels, and sales. The database is structured using SQL tables, and the data is stored in a relational format for easy retrieval and management.

## Database Structure

The database consists of the following key tables:

### 1. `employeeInfo`

This table stores information about the employees working at the coffee shop.

| Column Name    | Description                                                          |
|----------------|----------------------------------------------------------------------|
| `empFirstName` | First name of the employee                                           |
| `empLastName`  | Last name of the employee                                            |
| `empPhone`     | Phone number of the employee                                         |
| `empAddress`   | Address of the employee                                              |
| `position_ID`  | Foreign key referencing the employee's position (from the `positions` table) |

#### Example Query to Insert Employee Data:

```sql
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

### 2. `drinkmenu`

This table stores information about the drinks offered on the coffee shop's menu.

| Column Name  | Description                                      |
|--------------|--------------------------------------------------|
| `drinkID`    | Unique identifier for each drink                 |
| `drinkName`  | Name of the drink                                |
| `price`      | Price of the drink                               |

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
### 3. `inventory`

This table tracks the stock levels and cost per unit for each drink in the coffee shop’s inventory.

| Column Name   | Description                                                  |
|---------------|--------------------------------------------------------------|
| `drink_ID`    | Foreign key referencing the `drinkID` in `drinkmenu`         |
| `quantity`    | Quantity of the drink currently in stock                     |
| `costPerUnit` | Cost per unit of the drink in the inventory                  |


INSERT INTO inventory (drink_ID, quantity, costPerUnit)
VALUES (1, 100, 1.20),  -- Americano
       (2, 300, 2.00),  -- Capuccino
       (3, 400, 2.25),  -- Macchiato
       (4, 100, 2.20),  -- Espresso
       (5, 250, 0.50),  -- Latte
       (6, 400, 1.75),  -- Latte Art
       (7, 100, 2.00);  -- Mocha

## Database Relationships

- **`employeeInfo` and `positions`**: The `employeeInfo` table includes a `position_ID` that references the `positions` table (which stores employee roles, such as "Barista", "Manager", etc.).

- **`inventory` and `drinkmenu`**: The `inventory` table has a `drink_ID` that references the `drinkID` in the `drinkmenu` table. This ensures that each inventory record corresponds to a valid drink from the menu.

## Procedures and Triggers

### 1. `drinkCount` Procedure
- **Description**: This procedure counts the number of drinks in the inventory with a `costPerUnit` greater than or equal to $1.00 and displays a message indicating the count.
- **Action**: It checks the inventory and returns a message stating how many drinks exceed the $1.00 price.

### 2. `employeeType` Procedure
- **Description**: This procedure counts how many employees are assigned the position of `Barista` (with `position_ID = 1`).
- **Action**: It returns a message indicating how many employees are baristas.

### 3. `reminders` Table
- **Description**: This table stores reminder messages. It includes two columns: `message_ID` (auto-incremented) and `message` (text).
- **Action**: It is used to create reminders for various actions or notifications within the database.

### 4. `drinkunavailable` Trigger
- **Description**: This trigger fires after an insert into the `ordertable`. If the `drink_ID` is `2` (representing the "Capuccino"), it raises an error and prevents the order from being processed.
- **Action**: It signals an error with the message "Drink is no longer available" when a restricted drink is ordered.

---

Each procedure and trigger performs a specific function within the database to manage data or maintain business logic.


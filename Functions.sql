Create database Functions_db
use Functions_db
--a scalar function called GetOrderTotal.
--It calculates and returns the total order amount by multiplying the quantity and price for each order detail row in the "order_details" table associated with a given order_id
CREATE TABLE orders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    OrderDate DATE NOT NULL,
    CustomerID INT NOT NULL
);
CREATE TABLE orderdetails (
    OrderDetailID INT PRIMARY KEY IDENTITY(1,1),
    OrderID INT FOREIGN KEY REFERENCES orders(OrderID),
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    Price DECIMAL(18, 2) NOT NULL,
	);
CREATE FUNCTION GetOrderTotal (@OrderID INT)
RETURNS DECIMAL(18, 2)
AS
BEGIN
    DECLARE @Total DECIMAL(18, 2);
    
    SELECT @Total = SUM(Quantity * Price)
    FROM orderdetails
    WHERE OrderID = @OrderID;
    
    RETURN ISNULL(@Total, 0);
END;


INSERT INTO orders (OrderDate, CustomerID)
VALUES ('2024-07-01', 1),
       ('2024-07-02', 2);


INSERT INTO orderdetails (OrderID, ProductID, Quantity, Price)
VALUES (1, 101, 2, 10),
       (2, 102, 1, 20)

SELECT dbo.GetOrderTotal(1) AS TotalOrderAmount;

--a table-valued function called GetProductsWithLowStock.
--It returns a result set containing the product_id, product_name, and stock_quantity columns from the "products" table for products that have a stock quantity less than 10
CREATE TABLE products (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    StockQuantity INT NOT NULL
);
CREATE FUNCTION GetProductsWithLowStock()
RETURNS TABLE
AS
RETURN
(
    SELECT 
        ProductID,
        ProductName,
        StockQuantity
    FROM products
    WHERE StockQuantity < 10
);

INSERT INTO products (ProductName, StockQuantity)
VALUES ('Product A', 5),
       ('Product B', 20)

SELECT * FROM dbo.GetProductsWithLowStock();

--Table-valued function called GetOrdersByCustomer. It returns a result set containing the order_id, order_date, and total_amount columns from the "orders" table for orders associated with a specific customer_id
CREATE TABLE orderss (
    OrderID INT PRIMARY KEY IDENTITY(1,1),
    OrderDate DATE NOT NULL,
    CustomerID INT NOT NULL,
    TotalAmount DECIMAL(18, 2) NOT NULL,
);
CREATE FUNCTION GetOrderByCustomer (@CustomerID INT)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        OrderID,
        OrderDate,
        TotalAmount
    FROM orderss
    WHERE CustomerID = @CustomerID
);

INSERT INTO orders (OrderDate, CustomerID)
VALUES ('2024-07-01', 1),
       ('2024-07-02', 2)
select * from orderss
SELECT * FROM dbo.GetOrdersByCustomer(1);
SELECT * FROM dbo.GetOrdersByCustomer(2);
--aggregate function called GetTotalOrderAmountByCustomer. It calculates and returns the total order amount for a specific customer_id by summing the total_amount column in the "orders" table

CREATE TABLE order_customer (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    OrderDate DATE NOT NULL,
    CustomerID INT NOT NULL,
    TotalAmount DECIMAL(18, 2) NOT NULL,
);
select * from  order_customer
CREATE FUNCTION GetTotalOrderAmountByCustomer (@CustomerID INT)
RETURNS DECIMAL(18, 2)
AS
BEGIN
    DECLARE @TotalAmount DECIMAL(18, 2);

    SELECT @TotalAmount = SUM(TotalAmount)
    FROM order_customer
    WHERE CustomerID = @CustomerID;

    RETURN ISNULL(@TotalAmount, 0);
END;
select * from order_customer

INSERT INTO order_customer (OrderDate, CustomerID, TotalAmount)
VALUES ('2024-07-01', 1, 100.00),
       ('2024-07-02', 2, 150.00);

SELECT dbo.GetTotalOrderAmountByCustomer(1) AS TotalOrderAmountForCustomer1;
SELECT dbo.GetTotalOrderAmountByCustomer(2) AS TotalOrderAmountForCustomer2;


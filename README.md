# MySQL Procedures and Functions Examples

This document contains examples of **Stored Procedures** and **Functions** in MySQL.  
It demonstrates how to use `IN`, `OUT`, and `INOUT` parameters, handle multiple arguments, and create a custom function for calculated fields.

---

## Table Data
Before running the examples, we can view all available products from the `products` table.

    
    SELECT * FROM products;
<br>

![TABLE](https://github.com/user-attachments/assets/ae1f8629-bc1a-4725-86ba-f3d75b06e93c)

<h1>Create Procedure</h1> - Get All Products
This procedure returns all products with selected columns and renames RETAILPRICE to PRICE for better readability.

    DELIMITER $$
    CREATE PROCEDURE getallproduct()
    BEGIN
        SELECT PRODUCTID, NAME, CATEGORY, RETAILPRICE AS PRICE
        FROM L1_LANDING.PRODUCTS;
    END $$
    DELIMITER ;
    
    CALL getallproduct();

![GET ALL PRODUCTS](https://github.com/user-attachments/assets/5514baa0-ea7a-428a-bf56-cfb409bb40db)

<h2>Explanation:</h2>

- No parameters are required.
- Useful for quick reports or fetching complete product lists.
<br>
<h1>Procedure with IN Parameter</h1>
This procedure returns details for a specific product based on the given product ID.
  
    DELIMITER $$
    CREATE PROCEDURE getthisproduct(IN product_id INT)
    BEGIN
        SELECT productid, name, category, retailprice AS price
        FROM products
        WHERE productid = product_id;
    END $$
    DELIMITER ;
    
    CALL getthisproduct(76905);

![procedure with in](https://github.com/user-attachments/assets/a188c4f5-4bdf-48ca-962a-0efc84524a33)


<h2>Explanation:</h2>
<br>

- IN parameter sends data into the procedure.
- Here, product_id is used to filter a single product’s details.
<br>
<h1>Procedure with OUT Parameter</h1>
This procedure counts the total number of products and returns it via an OUT parameter.

    DELIMITER $$
    CREATE PROCEDURE getproductcount(OUT PROD_COUNT INT)
    BEGIN
        SELECT COUNT(*) INTO PROD_COUNT
        FROM PRODUCTS;
    END $$
    DELIMITER ;
    
    CALL getproductcount(@count);
    SELECT @count AS total_products_count;

![procedure with out](https://github.com/user-attachments/assets/9ad606eb-4d70-49f7-acd6-30649a851ea2)

<h2>Explanation:</h2>
<br>
- OUT parameter sends data out from the procedure to the caller.<br>
- The result is stored in a variable (@count) and retrieved later.
<br>
<h1></h1>Procedure with INOUT Parameter</h1>
This procedure takes a price as input, increases it by 10%, and returns the new price.
<br>
    
    DELIMITER $$
    CREATE PROCEDURE setproductprice(INOUT PRICE INT)
    BEGIN
        SET PRICE = PRICE * 1.10;
    END $$
    DELIMITER ;
    
    SET @PRICE = 500;
    CALL setproductprice(@price);
    SELECT @price AS new_price;

![procedure with in out](https://github.com/user-attachments/assets/492efc25-0d56-4ce2-83d5-5c8d65652c5b)

<h2>Explanation:</h2>
- INOUT parameters can accept and return a value.<br>
- Useful when you want to update a value and return it to the caller.
<br>
<h1></h1>Procedure with Multiple Arguments</h1>
This procedure returns the number of products from a specific supplier and their average supplier price.

    DELIMITER $$
    CREATE PROCEDURE get_supplier_stats(IN sup_id INT, OUT prod_count INT, OUT avg_price INT)
    BEGIN
        SELECT COUNT(*), AVG(supplierprice) INTO prod_count, avg_price
        FROM products
        WHERE SUPPLIERID = sup_id;
    END $$
    DELIMITER ;

    CALL get_supplier_stats(7880, @count, @avg_price);
    SELECT @count AS total_products, @avg_price AS average_price;

![procedure with multipal arguments](https://github.com/user-attachments/assets/924d7929-f169-443e-9dee-55febb012562)

<h2>Explanation:</h2>
<br>
- Shows how to use multiple parameters of different types (IN and OUT).<br>
- Returns two different pieces of information in one call.
<br>

<h1>Function - Calculate Margin Label</h1>
This function compares retailprice and supplierprice to return a label:
- "high" if margin > 4
- "low" if margin > 0
- "loss" if margin ≤ 0


    DELIMITER $$
    CREATE FUNCTION cal_margin(supplierprice INT, retailprice INT) 
    RETURNS VARCHAR(30)
    DETERMINISTIC
    BEGIN
        DECLARE MARGIN VARCHAR(30);
        IF (retailprice - supplierprice) > 4 THEN
            SET margin = 'high';
        ELSEIF (retailprice - supplierprice) > 0 THEN
            SET margin = 'low';
        ELSE
            SET margin = 'loss';
        END IF;
        RETURN margin;
    END $$
    DELIMITER ;
    

<h2>Explanation:</h2>
- Functions return a single value and can be used directly in SELECT statements.<br>
- The DETERMINISTIC keyword means the same inputs will always give the same result.
<br>

-  -Call Function

Example of calling the cal_margin function for each product.
<br>

      SELECT PRODUCTID, retailprice, supplierprice, category,
             cal_margin(supplierprice, retailprice) AS margin_label
      FROM products;

![function ](https://github.com/user-attachments/assets/9d627fb0-83c8-4408-a9b5-34e4b00075e7)

<h2>Explanation:</h2><br>
- Calls the function for each row in products.<br>
- Outputs a margin label along with other product details.
<br>

Summary:

- IN: Passes data into a procedure.
- OUT: Returns data from a procedure.
- INOUT: Passes a value in and returns a modified value out.
- Functions: Return a single calculated value and can be used in queries.


-- table 

SELECT * FROM products;

-- CREATE PRODCEDURE

DELIMITER $$
CREATE PROCEDURE getallproduct	()
BEGIN
	SELECT PRODUCTID ,NAME,CATEGORY,RETAILPRICE AS PRICE 
    FROM L1_LANDING.PRODUCTS;
END $$
DELIMITER ; 	

CALL getallproduct();


-- PROCEDURE WITH IN 

DELIMITER $$
CREATE  PROCEDURE getthisproduct(in product_id int)
begin 
	SELECT productid,name,category,retailprice as price 
    FROM products 
    WHERE productid=product_id;
END $$

DELIMITER ;
	
CALL getthisproduct(76905)  

-- procedure with out 

DELIMITER $$

CREATE procedure getproductcount(OUT PROD_COUNT INT )
BEGIN 
	SELECT COUNT(*) INTO PROD_COUNT 
    FROM PRODUCTS;
END $$

DELIMITER ;
CALL getproductcount(@count);

select @count as total_products_count;


-- procedure with inout

DELIMITER $$

CREATE PROCEDURE setproductprice(INOUT PRICE INT)
BEGIN
		SET PRICE=PRICE*1.10 ;
END $$

DELIMITER ;

SET @PRICE=500;
CALL setproductprice(@price);
select @price as new_price;

-- procedure with multipal arguments
DELIMITER $$
CREATE PROCEDURE get_supplier_stats(in sup_id int ,out prod_count int,out avg_price int)
BEGIN
	SELECT COUNT(*),AVG(supplierprice) into prod_count,avg_price 
    from products where SUPPLIERID=sup_id ;
END $$

DELIMITER ;

call get_supplier_stats(7880,@count,@avg_price);

select @count as total_products ,@avg_price as average_price ;    


-- funtions

DELIMITER $$
CREATE FUNCTION cal_margin(supplierprice int ,retailprice int ) returns VARCHAR(30)
deterministic 
BEGIN 
	declare MARGIN varchar(30);
    IF (retailprice-supplierprice) >4 then 
		set margin ="hight";
    elseif (retailprice-supplierprice)>0 then 
		SET MARGIN="low";
	else
		set margin="loss";
    end if;
    return margin;
end $$
DELIMITER ;

-- call function
SELECT PRODUCTID,retailprice,supplierprice,
category,
cal_margin(supplierprice ,retailprice) as margin_label 
from products;  
  
    
    
    
    
    
    
    
    
	
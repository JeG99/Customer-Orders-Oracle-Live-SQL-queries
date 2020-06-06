/* 1 Give total number of Female customers and total number of male customers  */
SELECT GENDER, COUNT(*) NUM_CUSTOMERS
FROM OE.CUSTOMERS
GROUP BY GENDER;

/* 2.- Cardinality of customers table */
SELECT COUNT(*)
FROM OE.CUSTOMERS;

/* 3.- Give first name and last name of each customer, and the total money spent
   	ordered by total money spent. Only show when the total > 200000 */
SELECT C.CUST_FIRST_NAME, C.CUST_LAST_NAME, SUM(OI.QUANTITY * OI.UNIT_PRICE)
FROM OE.CUSTOMERS C, OE.ORDERS O, OE.ORDER_ITEMS OI
WHERE C.CUSTOMER_ID = O.CUSTOMER_ID
    AND O.ORDER_ID = OI.ORDER_ID
    AND O.ORDER_STATUS = 10
GROUP BY C.CUSTOMER_ID, C.CUST_FIRST_NAME, C.CUST_LAST_NAME
HAVING SUM(OI.QUANTITY * OI.UNIT_PRICE) > 200000;

/* 4.-  Display name and last name of the customer or customers that
    	spent the most money */
SELECT C.CUST_FIRST_NAME, C.CUST_LAST_NAME
FROM OE.CUSTOMERS C, OE.ORDERS O, OE.ORDER_ITEMS OI
WHERE C.CUSTOMER_ID = O.CUSTOMER_ID
    AND OI.ORDER_ID = O.ORDER_ID
    AND O.ORDER_STATUS = 10
GROUP BY C.CUSTOMER_ID, C.CUST_FIRST_NAME, C.CUST_LAST_NAME
HAVING SUM(OI.QUANTITY * OI.UNIT_PRICE) = (
    SELECT MAX(TOTAL)
    FROM (
        SELECT SUM(OI.QUANTITY * OI.UNIT_PRICE) TOTAL
        FROM OE.CUSTOMERS C, OE.ORDERS O, OE.ORDER_ITEMS OI
        WHERE C.CUSTOMER_ID = O.CUSTOMER_ID
            AND OI.ORDER_ID = O.ORDER_ID
            AND O.ORDER_STATUS = 10
        GROUP BY C.CUSTOMER_ID
    )
);

/* 5.- Display total sales grouped by Gender */
SELECT C.GENDER, SUM(OI.QUANTITY * OI.UNIT_PRICE)
FROM OE.CUSTOMERS C, OE.ORDERS O, OE.ORDER_ITEMS OI
WHERE C.CUSTOMER_ID = O.CUSTOMER_ID
    AND O.ORDER_ID = OI.ORDER_ID
    AND O.ORDER_STATUS = 10
GROUP BY C.GENDER

/* 6.- display total sales grouped by product name.
	display only products in which total sales > 100000*/
SELECT P.PRODUCT_NAME, SUM(OI.QUANTITY * OI.UNIT_PRICE)
FROM OE.ORDERS O, OE.ORDER_ITEMS OI, OE.PRODUCT_INFORMATION P
WHERE O.ORDER_ID = OI.ORDER_ID
    AND OI.PRODUCT_ID = P.PRODUCT_ID
    AND O.ORDER_STATUS = 10
GROUP BY OI.PRODUCT_ID, P.PRODUCT_NAME
HAVING SUM(OI.QUANTITY * OI.UNIT_PRICE) > 100000;

/* 7 Display  first name and last name of customers
that have orders canceled by bad credit,  order_status = 2*/
SELECT C.CUST_FIRST_NAME, C.CUST_LAST_NAME
FROM OE.ORDERS O, OE.CUSTOMERS C
WHERE O.CUSTOMER_ID = C.CUSTOMER_ID
    AND O.ORDER_STATUS = 2

/* 8.- total sales by year , ordered by year
In Oracle you get the year from a date like this:  EXTRACT(year FROM order_date)
aliases are not allwed in group by expressions.*/
SELECT EXTRACT(year FROM O.ORDER_DATE), SUM(OI.QUANTITY * OI.UNIT_PRICE)
FROM OE.ORDERS O, OE.ORDER_ITEMS OI
WHERE O.ORDER_ID = OI.ORDER_ID
    AND O.ORDER_STATUS = 10
GROUP BY EXTRACT(year FROM O.ORDER_DATE)

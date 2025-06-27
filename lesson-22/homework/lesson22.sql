--CREATE TABLE sales_data (
--    sale_id INT PRIMARY KEY,
--    customer_id INT,
--    customer_name VARCHAR(100),
--    product_category VARCHAR(50),
--    product_name VARCHAR(100),
--    quantity_sold INT,
--    unit_price DECIMAL(10,2),
--    total_amount DECIMAL(10,2),
--    order_date DATE,
--    region VARCHAR(50)
--);

--INSERT INTO sales_data VALUES
--    (1, 101, 'Alice', 'Electronics', 'Laptop', 1, 1200.00, 1200.00, '2024-01-01', 'North'),
--    (2, 102, 'Bob', 'Electronics', 'Phone', 2, 600.00, 1200.00, '2024-01-02', 'South'),
--    (3, 103, 'Charlie', 'Clothing', 'T-Shirt', 5, 20.00, 100.00, '2024-01-03', 'East'),
--    (4, 104, 'David', 'Furniture', 'Table', 1, 250.00, 250.00, '2024-01-04', 'West'),
--    (5, 105, 'Eve', 'Electronics', 'Tablet', 1, 300.00, 300.00, '2024-01-05', 'North'),
--    (6, 106, 'Frank', 'Clothing', 'Jacket', 2, 80.00, 160.00, '2024-01-06', 'South'),
--    (7, 107, 'Grace', 'Electronics', 'Headphones', 3, 50.00, 150.00, '2024-01-07', 'East'),
--    (8, 108, 'Hank', 'Furniture', 'Chair', 4, 75.00, 300.00, '2024-01-08', 'West'),
--    (9, 109, 'Ivy', 'Clothing', 'Jeans', 1, 40.00, 40.00, '2024-01-09', 'North'),
--    (10, 110, 'Jack', 'Electronics', 'Laptop', 2, 1200.00, 2400.00, '2024-01-10', 'South'),
--    (11, 101, 'Alice', 'Electronics', 'Phone', 1, 600.00, 600.00, '2024-01-11', 'North'),
--    (12, 102, 'Bob', 'Furniture', 'Sofa', 1, 500.00, 500.00, '2024-01-12', 'South'),
--    (13, 103, 'Charlie', 'Electronics', 'Camera', 1, 400.00, 400.00, '2024-01-13', 'East'),
--    (14, 104, 'David', 'Clothing', 'Sweater', 2, 60.00, 120.00, '2024-01-14', 'West'),
--    (15, 105, 'Eve', 'Furniture', 'Bed', 1, 800.00, 800.00, '2024-01-15', 'North'),
--    (16, 106, 'Frank', 'Electronics', 'Monitor', 1, 200.00, 200.00, '2024-01-16', 'South'),
--    (17, 107, 'Grace', 'Clothing', 'Scarf', 3, 25.00, 75.00, '2024-01-17', 'East'),
--    (18, 108, 'Hank', 'Furniture', 'Desk', 1, 350.00, 350.00, '2024-01-18', 'West'),
--    (19, 109, 'Ivy', 'Electronics', 'Speaker', 2, 100.00, 200.00, '2024-01-19', 'North'),
--    (20, 110, 'Jack', 'Clothing', 'Shoes', 1, 90.00, 90.00, '2024-01-20', 'South'),
--    (21, 111, 'Kevin', 'Electronics', 'Mouse', 3, 25.00, 75.00, '2024-01-21', 'East'),
--    (22, 112, 'Laura', 'Furniture', 'Couch', 1, 700.00, 700.00, '2024-01-22', 'West'),
--    (23, 113, 'Mike', 'Clothing', 'Hat', 4, 15.00, 60.00, '2024-01-23', 'North'),
--    (24, 114, 'Nancy', 'Electronics', 'Smartwatch', 1, 250.00, 250.00, '2024-01-24', 'South'),
--    (25, 115, 'Oscar', 'Furniture', 'Wardrobe', 1, 1000.00, 1000.00, '2024-01-25', 'East')
select *, SUM(total_amount) OVER(partition by customer_id ORDER BY order_date)
from sales_data
--2
select *, COUNT(quantity_sold) OVER(partition by product_category)
from sales_data
--3
select *, MAX(total_amount) over(partition by product_category)
from sales_data
--4
select *, MIN(unit_price) OVER(partition by product_category)
from sales_data
--5
select *,AVG(total_amount) OVER(order by order_date rows between 1 preceding and 1 following)
from sales_data
--6
select *,SUM(total_amount) OVER(partition by region)
from sales_data
--7
with cte as(
select *, SUM(total_amount) OVER(partition by customer_id) rw
from sales_data
)
select *, dense_rank() OVER(ORDER BY rw DESC)
from cte
--8
with cte as(
select *, LAG(total_amount) OVER(order by order_date) rw
from sales_data)
select *, total_amount - rw as diff
from cte
--9
with cte as(
select *, row_number() over(partition by product_category order by total_amount desc) rw
from sales_data)
select * from cte
where rw <=3
--10
select *, SUM(total_amount) OVER(partition by region order by order_date)
from sales_data
--11
select *, SUM(total_amount) OVER(partition by product_category order by order_date)
from sales_data
--12
CREATE TABLE OneColumn (
    Value SMALLINT
);
INSERT INTO OneColumn VALUES (1), (2), (3), (4), (5);
select *, SUM(value) OVER(order by value) SumPreValues
from onecolumn
--13
CREATE TABLE OneColumn1 (
    Value SMALLINT
);
INSERT INTO OneColumn1 VALUES (10), (20), (30), (40), (100);
select *,  SUM(value) OVER(order by value)
from onecolumn1
--14
CREATE TABLE Row_Nums (
    Id INT,
    Vals VARCHAR(10)
);
INSERT INTO Row_Nums VALUES
(101,'a'), (102,'b'), (102,'c'), (103,'f'), (103,'e'), (103,'q'), (104,'r'), (105,'p');

select *,
from row_nums

--15
with cte as(
select *
from sales_data)
select distinct cte.customer_id from cte
join sales_data s
on cte.customer_id = s.customer_id and cte.product_category<> s.product_category
--16
with cte as(
select *, AVG(total_amount) over(partition by region) rw
from sales_data)
select * from cte
where total_amount>rw
--17
select *, dense_rank() over(partition by region order by total_amount desc)
from sales_data
--18
select *, SUM(total_amount) over(partition by customer_id order by order_date)
from sales_data
--19
with cte as(
select *, SUM(total_amount) over(partition by month(order_date) order by order_date) sales, row_number() over(partition by month(order_date) order by order_date) rwnb
from sales_data)
select *, ((select sales from cte where rwnb = 25) - (select sales from cte where rwnb = 1))/(select sales from cte where rwnb = 1)
from cte
--20
with cte as(
select *, lag(total_amount) over(partition by customer_id order by order_date) rw
from sales_data
)
select * from cte
where rw< total_amount
--21
with cte as(
select * , AVG(unit_price) over(partition by product_name) avrg
from sales_data)
select * from cte
where avrg < unit_price
--22
CREATE TABLE MyData (
    Id INT, Grp INT, Val1 INT, Val2 INT
);
INSERT INTO MyData VALUES
(1,1,30,29), (2,1,19,0), (3,1,11,45), (4,2,0,0), (5,2,100,17);
select *, case when row_number() over(partition by grp order by id) = 1 then SUM(val1+ val2) OVER(partition by grp )
else null end
from mydata
--23
CREATE TABLE TheSumPuzzle (
    ID INT, Cost INT, Quantity INT
);
INSERT INTO TheSumPuzzle VALUES
(1234,12,164), (1234,13,164), (1235,100,130), (1235,100,135), (1236,12,136)

SELECT 
    Id,
    SUM(Cost) AS Cost,
    SUM(DISTINCT Quantity) AS Quantity
FROM 
    thesumpuzzle
GROUP BY 
    Id;

--24
CREATE TABLE Seats 
( 
SeatNumber INTEGER 
); 

INSERT INTO Seats VALUES 
(7),(13),(14),(15),(27),(28),(29),(30), 
(31),(32),(33),(34),(35),(52),(53),(54); 

with cte as(
select 1 as gapstart, null as gapend
union all
select  seatnumber+1 as gapstart, seatnumber -1 gapend from seats)
select gapstart, lead(gapend) over(order by gapstart) gapend
from cte

--25
with cte as(
select *, row_number() over(order by id) rw from row_nums)
select *,  case when row_number() over(partition by id order by id) = 1 and row_number() over(partition by id order by id)%2 = 1 then rw else row_number() over(order by rw)+1 end
from cte
WITH base AS (
    SELECT *, 
           ROW_NUMBER() OVER (PARTITION BY Id ORDER BY Id) AS rn,
           ROW_NUMBER() OVER (ORDER BY Id) * 2 AS base_even -- guarantees unique even numbers
    FROM row_nums
),
assigned AS (
    SELECT *, 
           MIN(base_even) OVER (PARTITION BY Id) AS start_num
    FROM base
)
SELECT Id, Vals, start_num + rn - 1 AS Changed
FROM assigned
ORDER BY start_num + rn - 1;

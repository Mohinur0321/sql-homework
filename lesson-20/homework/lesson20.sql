CREATE TABLE #Sales (
    SaleID INT PRIMARY KEY IDENTITY(1,1),
    CustomerName VARCHAR(100),
    Product VARCHAR(100),
    Quantity INT,
    Price DECIMAL(10,2),
    SaleDate DATE
);


INSERT INTO #Sales (CustomerName, Product, Quantity, Price, SaleDate) VALUES
('Alice', 'Laptop', 1, 1200.00, '2024-01-15'),
('Bob', 'Smartphone', 2, 800.00, '2024-02-10'),
('Charlie', 'Tablet', 1, 500.00, '2024-02-20'),
('David', 'Laptop', 1, 1300.00, '2024-03-05'),
('Eve', 'Smartphone', 3, 750.00, '2024-03-12'),
('Frank', 'Headphones', 2, 100.00, '2024-04-08'),
('Grace', 'Smartwatch', 1, 300.00, '2024-04-25'),
('Hannah', 'Tablet', 2, 480.00, '2024-05-05'),
('Isaac', 'Laptop', 1, 1250.00, '2024-05-15'),
('Jack', 'Smartphone', 1, 820.00, '2024-06-01');

select customername from #sales
where exists (select customername from #sales where MONTH(saleDATE) = 2 and YEAR(saledate)=2024)

--2
select top 1 product from(
select product, SUM(quantity*price) total from #sales 
group by product) sales
order by total desc

--3
select product from(
select product, SUM(quantity*price) total from #sales 
group by product) sales
order by total desc
offset 1 rows fetch next 1 rows only;

--4
select MONTH(SALEDATE) month, SUM(quantity) total_cnt from #sales
group by MONTH(saledate)

--5
select customername from #sales s1
where exists (select customername from #sales s2
where s1.product=s2.product and s1.customername<>s2.customername)

--6
create table Fruits(Name varchar(50), Fruit varchar(50))
insert into Fruits values ('Francesko', 'Apple'), ('Francesko', 'Apple'), ('Francesko', 'Apple'), ('Francesko', 'Orange'),
							('Francesko', 'Banana'), ('Francesko', 'Orange'), ('Li', 'Apple'), 
							('Li', 'Orange'), ('Li', 'Apple'), ('Li', 'Banana'), ('Mario', 'Apple'), ('Mario', 'Apple'), 
							('Mario', 'Apple'), ('Mario', 'Banana'), ('Mario', 'Banana'), 
							('Mario', 'Orange')
with cte as (
select *, case when fruit = 'apple' then 1 end as apple, case when fruit = 'orange' then 1 end as orange, case when fruit = 'banana' then 1
end as banana from fruits)
select name, SUM(apple) apple, SUM(orange) orange, SUM(banana) banana
from cte
group by name


--7
create table Family(ParentId int, ChildID int)
insert into Family values (1, 2), (2, 3), (3, 4)
select t.parentid, f.childid from family f,family t
--8
CREATE TABLE #Orders
(
CustomerID     INTEGER,
OrderID        INTEGER,
DeliveryState  VARCHAR(100) NOT NULL,
Amount         MONEY NOT NULL,
PRIMARY KEY (CustomerID, OrderID)
);


INSERT INTO #Orders (CustomerID, OrderID, DeliveryState, Amount) VALUES
(1001,1,'CA',340),(1001,2,'TX',950),(1001,3,'TX',670),
(1001,4,'TX',860),(2002,5,'WA',320),(3003,6,'CA',650),
(3003,7,'CA',830),(4004,8,'TX',120);
select * from (
select * from #orders
where customerid in (select distinct customerid from #orders where deliverystate ='CA')
) ord
where deliverystate = 'TX'

--9
create table #residents(resid int identity, fullname varchar(50), address varchar(100))

insert into #residents values 
('Dragan', 'city=Bratislava country=Slovakia name=Dragan age=45'),
('Diogo', 'city=Lisboa country=Portugal age=26'),
('Celine', 'city=Marseille country=France name=Celine age=21'),
('Theo', 'city=Milan country=Italy age=28'),
('Rajabboy', 'city=Tashkent country=Uzbekistan age=22')
select resid, fullname, CASE WHEN CHARINDEX('name', address)=0 then
STUFF(address, CHARINDEX('age', address)-1, 1, ' name='+fullname + ' ')
else address end as [address]
from #residents

--10
CREATE TABLE #Routes
(
RouteID        INTEGER NOT NULL,
DepartureCity  VARCHAR(30) NOT NULL,
ArrivalCity    VARCHAR(30) NOT NULL,
Cost           MONEY NOT NULL,
PRIMARY KEY (DepartureCity, ArrivalCity)
);

INSERT INTO #Routes (RouteID, DepartureCity, ArrivalCity, Cost) VALUES
(1,'Tashkent','Samarkand',100),
(2,'Samarkand','Bukhoro',200),
(3,'Bukhoro','Khorezm',300),
(4,'Samarkand','Khorezm',400),
(5,'Tashkent','Jizzakh',100),
(6,'Jizzakh','Samarkand',50);

WITH cities AS (
    SELECT 
        r1.departurecity AS r1_d,
        r2.departurecity AS r2_d,
        r2.arrivalcity   AS r3_d,
        r3.arrivalcity   AS r3_a,
        r1.cost AS r1_cost,
        r2.cost AS r2_cost,
        r3.cost AS r3_cost
    FROM #routes r1
    JOIN #routes r2 ON r1.arrivalcity = r2.departurecity
    JOIN #routes r3 ON r2.arrivalcity = r3.departurecity
    WHERE r1.departurecity = 'Tashkent' 
      AND r3.arrivalcity = 'Khorezm'
),
route_costs AS (
    SELECT 
        r1_d, r2_d, r3_d, r3_a,
        (r1_cost + r2_cost + r3_cost) AS total_cost
    FROM cities
)
SELECT 
    r1_d, r2_d, r3_d, r3_a,
    SUM(total_cost) AS sum_total_cost
FROM route_costs
GROUP BY r1_d, r2_d, r3_d, r3_a
--11
CREATE TABLE #RankingPuzzle
(
     ID INT
    ,Vals VARCHAR(10)
)

 
INSERT INTO #RankingPuzzle VALUES
(1,'Product'),
(2,'a'),
(3,'a'),
(4,'a'),
(5,'a'),
(6,'Product'),
(7,'b'),
(8,'b'),
(9,'Product'),
(10,'c')

select *, RANK() over(order by id) as Ranked from #rankingpuzzle

--12

CREATE TABLE #EmployeeSales (
    EmployeeID INT,
    EmployeeName VARCHAR(100),
    Department VARCHAR(50),
    SalesAmount DECIMAL(10,2),
    SalesMonth INT,
    SalesYear INT
);

INSERT INTO #EmployeeSales (Employeeid, EmployeeName, Department, SalesAmount, SalesMonth, SalesYear) VALUES
(1, 'Alice', 'Electronics', 5000, 1, 2024),
(2,'Bob', 'Electronics', 7000, 1, 2024),
(3,'Charlie', 'Furniture', 3000, 1, 2024),
(4, 'David', 'Furniture', 4500, 1, 2024),
(5, 'Eve', 'Clothing', 6000, 1, 2024),
(6, 'Frank', 'Electronics', 8000, 2, 2024),
(7, 'Grace', 'Furniture', 3200, 2, 2024),
(8, 'Hannah', 'Clothing', 7200, 2, 2024),
(9, 'Isaac', 'Electronics', 9100, 3, 2024),
(10, 'Jack', 'Furniture', 5300, 3, 2024),
(11, 'Kevin', 'Clothing', 6800, 3, 2024),
(12, 'Laura', 'Electronics', 6500, 4, 2024),
(13,'Mia', 'Furniture', 4000, 4, 2024),
(14, 'Nathan', 'Clothing', 7800, 4, 2024);

select employeename, s.department, avg_sales.department, avg_sales, salesamount from #employeesales s
join (
select department, avg(salesamount) avg_sales from #employeesales
group by department) avg_sales
on s.department = avg_sales.department and salesamount> avg_sales

--13
select salesmonth, MAX(salesamount) as higheset from #employeesales
group by salesmonth

--14
with cte as (
select *, dense_rank() over (order by employeeid) as rank from #employeesales
)
select COUNT(salesmonth) cnt, rank
from cte
group by rank
having COUNT(salesmonth) > 4

--15
CREATE TABLE Product (
    ProductID   INT PRIMARY KEY,
    Name        VARCHAR(50),
    Category    VARCHAR(50),
    Price       DECIMAL(10,2),
    Stock       INT
);

INSERT INTO Product (ProductID, Name, Category, Price, Stock) VALUES
(1, 'Laptop', 'Electronics', 1200.00, 15),
(2, 'Smartphone', 'Electronics', 800.00, 30),
(3, 'Tablet', 'Electronics', 500.00, 25),
(4, 'Headphones', 'Accessories', 150.00, 50),
(5, 'Keyboard', 'Accessories', 100.00, 40),
(6, 'Monitor', 'Electronics', 300.00, 20),
(7, 'Mouse', 'Accessories', 50.00, 60),
(8, 'Chair', 'Furniture', 200.00, 10),
(9, 'Desk', 'Furniture', 400.00, 5),
(10, 'Printer', 'Office Supplies', 250.00, 12),
(11, 'Scanner', 'Office Supplies', 180.00, 8),
(12, 'Notebook', 'Stationery', 10.00, 100),
(13, 'Pen', 'Stationery', 2.00, 500),
(14, 'Backpack', 'Accessories', 80.00, 30),
(15, 'Lamp', 'Furniture', 60.00, 25);

--15
select name from product
where price > (select avg(price) price from product)

--16
select * from product
where stock <(select max(stock) from product)
--17
select * from product
where category =(
select category from product
where name = 'laptop'
--18
select * from product
where price >(
select MIN(price) from product
where category = 'electronics'
)
--19
select p.name, p.price from product p
join(
select category, avg(price) avg from product
group by category ) a
on p.category = a.category
and p.price > avg

--20
CREATE TABLE Orders (
    OrderID    INT PRIMARY KEY,
    ProductID  INT,
    Quantity   INT,
    OrderDate  DATE,
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);

INSERT INTO Orders (OrderID, ProductID, Quantity, OrderDate) VALUES
(1, 1, 2, '2024-03-01'),
(2, 3, 5, '2024-03-05'),
(3, 2, 3, '2024-03-07'),
(4, 5, 4, '2024-03-10'),
(5, 8, 1, '2024-03-12'),
(6, 10, 2, '2024-03-15'),
(7, 12, 10, '2024-03-18'),
(8, 7, 6, '2024-03-20'),
(9, 6, 2, '2024-03-22'),
(10, 4, 3, '2024-03-25'),
(11, 9, 2, '2024-03-28'),
(12, 11, 1, '2024-03-30'),
(13, 14, 4, '2024-04-02'),
(14, 15, 5, '2024-04-05'),
(15, 13, 20, '2024-04-08');

select distinct name from orders o
join product p
on o.productid = p.productid

--21
select * from orders
where quantity > (select avg(quantity) from orders)

--22
select * from orders o
right join product p
on o.productid = p.productid 
where p.productid is null

--23
select TOP 1 productid, SUM(quantity) as cnt from orders
group by productid
ORDER BY cnt DESC

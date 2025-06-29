DROP TABLE IF EXISTS #RegionSales;
GO
CREATE TABLE #RegionSales (
  Region      VARCHAR(100),
  Distributor VARCHAR(100),
  Sales       INTEGER NOT NULL,
  PRIMARY KEY (Region, Distributor)
);
GO
INSERT INTO #RegionSales (Region, Distributor, Sales) VALUES
('North','ACE',10), ('South','ACE',67), ('East','ACE',54),
('North','ACME',65), ('South','ACME',9), ('East','ACME',1), ('West','ACME',7),
('North','Direct Parts',8), ('South','Direct Parts',7), ('West','Direct Parts',12);
with cte as(
select * from(
select distinct distributor from #regionsales) r,(select distinct region from #regionsales) s)
select cte.*, isnull(sales, 0) from cte
left join #regionsales e
on cte.distributor = e.distributor and cte.region = e.region
--2

CREATE TABLE Employee (id INT, name VARCHAR(255), department VARCHAR(255), managerId INT);
TRUNCATE TABLE Employee;
INSERT INTO Employee VALUES
(101, 'John', 'A', NULL), (102, 'Dan', 'A', 101), (103, 'James', 'A', 101),
(104, 'Amy', 'A', 101), (105, 'Anne', 'A', 101), (106, 'Ron', 'B', 101);

select e2.name from employee e1
join employee e2
on e1.managerid = e2.id
group by e2.id, e2.name
having COUNT(e2.id) >=5

--3

CREATE TABLE Product (product_id INT, product_name VARCHAR(40), product_category VARCHAR(40));
CREATE TABLE Orders (product_id INT, order_date DATE, unit INT);
TRUNCATE TABLE Products;
INSERT INTO Product VALUES
(1, 'Leetcode Solutions', 'Book'),
(2, 'Jewels of Stringology', 'Book'),
(3, 'HP', 'Laptop'), (4, 'Lenovo', 'Laptop'), (5, 'Leetcode Kit', 'T-shirt');
TRUNCATE TABLE Orders;
INSERT INTO Orders VALUES
(1,'2020-02-05',60),(1,'2020-02-10',70),
(2,'2020-01-18',30),(2,'2020-02-11',80),
(3,'2020-02-17',2),(3,'2020-02-24',3),
(4,'2020-03-01',20),(4,'2020-03-04',30),(4,'2020-03-04',60),
(5,'2020-02-25',50),(5,'2020-02-27',50),(5,'2020-03-01',50);

select product_name, unit from product p
JOIn
(select product_id, SUM(unit) unit from orders
where YEAR(order_date)= 2020 and MONTH(order_date)= 2
GROUP BY product_id) cte
on p.product_id = cte.product_id and unit >= 100

--4
DROP TABLE IF EXISTS Orders;
GO
CREATE TABLE Orders (
  OrderID    INTEGER PRIMARY KEY,
  CustomerID INTEGER NOT NULL,
  [Count]    MONEY NOT NULL,
  Vendor     VARCHAR(100) NOT NULL
);
INSERT INTO Orders VALUES
(1,1001,12,'Direct Parts'), (2,1001,54,'Direct Parts'), (3,1001,32,'ACME'),
(4,2002,7,'ACME'), (5,2002,16,'ACME'), (6,2002,5,'Direct Parts');

select customerid, COUNT(customerID) as cnt, vendor from orders
group by vendor, customerid
HAVING COUNT(*) = 
(select MAX(cntt) from (select count(*) as cntt from orders group by vendor, customerid)
 cte)
 --5
 declare @check_prime int = 91;
 with ctE (DIVISOR) as(
 select 2 
 union all
 select divisor +1 FROM CTE
 where divisor+1 < @CHECK_PRIME)
 select  CASE WHEN EXISTS( SELECT 1 FROM CTE WHERE @CHECK_PRIME%2=0) THEN CONCAT(@CHECK_PRIME, ' IS NOT PRIME') ELSE CONCAT(@CHECK_PRIME, ' IS PRIME') END 


 --6
 CREATE TABLE Device(
  Device_id INT,
  Locations VARCHAR(25)
);
INSERT INTO Device VALUES
(12,'Bangalore'), (12,'Bangalore'), (12,'Bangalore'), (12,'Bangalore'),
(12,'Hosur'), (12,'Hosur'),
(13,'Hyderabad'), (13,'Hyderabad'), (13,'Secunderabad'),
(13,'Secunderabad'), (13,'Secunderabad');
 with cte as(
select *, 
(Select count(locations) from device as dev where dev.Device_id=device.Device_id and dev.Locations=device.Locations) as cnt_loc
from Device
)
select distinct cte.Device_id,cte.Locations, aggregated.cnt_locs,aggregated.cnt_distc_loc from cte

JOIN (select Device_id, count(Locations) as cnt_locs, count(distinct locations) as cnt_distc_loc  from Device group by Device_id) as aggregated
on cte.Device_id=aggregated.Device_id

where cnt_loc=(select max(cnt_loc) from cte as cte1 where cte.Device_id=cte1.Device_id)

--7

CREATE TABLE Employee (
  EmpID INT,
  EmpName VARCHAR(30),
  Salary FLOAT,
  DeptID INT
);
INSERT INTO Employee VALUES
(1001,'Mark',60000,2), (1002,'Antony',40000,2), (1003,'Andrew',15000,1),
(1004,'Peter',35000,1), (1005,'John',55000,1), (1006,'Albert',25000,3), (1007,'Donald',35000,3);
select empid, empname, salary from Employee e
join (
select AVG(salary) avg_salary, deptid from employee
group by deptid) dept_avg
on e.deptid = dept_avg.deptid and salary >= avg_salary
order by empid
--8
CREATE TABLE Ticket (
    TicketID VARCHAR(10),
    NumbeR INT
);

INSERT INTO Ticket (TicketID, Number) VALUES
('A23423', 25),
('A23423', 45),
('A23423', 78),
('B35643', 25),
('B35643', 45),
('B35643', 98),
('C98787', 67),
('C98787', 86),
('C98787', 91);

WITH CTE AS(
SELECT TICKETID, SUM(CNT) CNT FROM (
SELECT TICKETID, CASE WHEN NUMBER = 25 THEN 1 WHEN NUMBER = 45 THEN 1 WHEN NUMBER = 78 THEN 1 ELSE 0 END AS CNT
FROM TICKET) TICKETS
GROUP BY TICKETID)
SELECT SUM( CASE WHEN CNT = 3 THEN 100 WHEN CNT>0 THEN 10 ELSE 0 END)
FROM CTE

--9
CREATE TABLE Spending (
  User_id INT,
  Spend_date DATE,
  Platform VARCHAR(10),
  Amount INT
);
INSERT INTO Spending VALUES
(1,'2019-07-01','Mobile',100),
(1,'2019-07-01','Desktop',100),
(2,'2019-07-01','Mobile',100),
(2,'2019-07-02','Mobile',100),
(3,'2019-07-01','Desktop',100),
(3,'2019-07-02','Desktop',100);
WITH UserDaySpending AS (
    SELECT 
        User_id, 
        Spend_date,
        COUNT(DISTINCT Platform) AS Platform_Count,
        SUM(Amount) AS Total_Amount
    FROM Spending
    GROUP BY User_id, Spend_date
),
UserPlatformType AS (
    SELECT 
        S.User_id,
        S.Spend_date,
        U.Platform_Count,
        CASE 
            WHEN U.Platform_Count = 2 THEN 'Both'
            ELSE S.Platform
        END AS Platform,
        S.Amount
    FROM Spending S
    JOIN UserDaySpending U
      ON S.User_id = U.User_id AND S.Spend_date = U.Spend_date
),
Aggregated AS (
    SELECT 
        Spend_date,
        Platform,
        SUM(Amount) AS Total_Amount,
        COUNT(DISTINCT User_id) AS Total_users
    FROM UserPlatformType
    GROUP BY Spend_date, Platform
),
AllCombinations AS (
    SELECT DISTINCT Spend_date FROM Spending
),
PlatformTypes AS (
    SELECT 'Mobile' AS Platform
    UNION ALL
    SELECT 'Desktop'
    UNION ALL
    SELECT 'Both'
),
DatePlatformGrid AS (
    SELECT a.Spend_date, p.Platform
    FROM AllCombinations a
    CROSS JOIN PlatformTypes p
)
SELECT 
    ROW_NUMBER() OVER (ORDER BY d.Spend_date, d.Platform) AS Row,
    d.Spend_date,
    d.Platform,
    COALESCE(a.Total_Amount, 0) AS Total_Amount,
    COALESCE(a.Total_users, 0) AS Total_users
FROM DatePlatformGrid d
LEFT JOIN Aggregated a
    ON d.Spend_date = a.Spend_date AND d.Platform = a.Platform
ORDER BY d.Spend_date, d.Platform;

---10

DROP TABLE IF EXISTS Grouped;
CREATE TABLE Grouped
(
  Product  VARCHAR(100) PRIMARY KEY,
  Quantity INTEGER NOT NULL
);
INSERT INTO Grouped (Product, Quantity) VALUES
('Pencil', 3), ('Eraser', 4), ('Notebook', 2);

WITH CTE AS(
SELECT 1  AS CHECKER
UNION ALL
SELECT CHECKER+1 AS CHECKER FROM CTE
WHERE CHECKER  <=9)
,
EXPANDED AS( SELECT PRODUCT, 1 AS QUANTITY FROM GROUPED G 
JOIN CTE ON CTE.CHECKER <= G.QUANTITY)
SELECT * FROM EXPANDED
ORDER BY PRODUCT DESC

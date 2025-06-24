select *, substring(name, 1, charindex(',', name)-1) as firstname,
substring(name, charindex(',', name)+1,charindex(',', name)+1) as lastname from TestMultipleColumns
--2
select *from testpercent
where strs like '%[%]%'
--3
select *,
substring(vals, 1, charindex('.',vals)-1),
SUBSTRING(vals, CHARINDEX('.', vals)+1, CHARINDEX('.', vals,charindex('.',vals)-1)),
SUBSTRING(vals, CHARINDEX(
'.', vals, 
CHARINDEX('.', vals,charindex('.',vals))+3),
len(vals))  from splitter
--4 
select translate('1234ABC123456XYZ1234567890ADS', '0123456789', 'XXXXXXXXXX')
--5
select * from .testdots
where charindex('.', vals, charindex('.', vals)+1) > 0
--6
select *, len(texts) - LEN(replace(texts, ' ', '')) as spaces from countspaces
--7
select e1.name from employee e1
join employee e2
on e1.managerid = e2.id and e1.salary> e2.salary
--8
select * from employees
where YEAR(GETDATE()
)- YEAR(HIRE_DATE)>10 and YEAR(GETDATE()
)- YEAR(HIRE_DATE)<15
-------------------------------------------------------------------------------
SELECT 
    SUBSTRING('rtcfvty34redt', PATINDEX('%[0-9]%', 'rtcfvty34redt'), LEN('rtcfvty34redt')) AS numbers_column,
    SUBSTRING('rtcfvty34redt', 1, PATINDEX('%[0-9]%', 'rtcfvty34redt') - 1) AS characters_column;
--2
select * from weather w1
join weather w2
on DAY(w1.recorddate) = DAY(w2.recorddate)-1 and w2.temperature>w1.temperature
--3
select player_id, MIN(event_date) from activity
group by player_id
--4
SELECT *, 
SUBSTRING(
 fruit_list,
CHARINDEX(',', fruit_list, CHARINDEX(',', fruit_list) + 1) + 1,
CHARINDEX(',', fruit_list, CHARINDEX(',', fruit_list, CHARINDEX(',', fruit_list) + 1) + 1) 
- (CHARINDEX(',', fruit_list, CHARINDEX(',', fruit_list) + 1) + 1)
)
	AS extracted
FROM fruits


  --5
  declare @string varchar(30) = 'sdgfhsdgfhs@121313131'

; with cte as(

select substring(@string,1,1) as letter, 1 as checker
union all
select SUBSTRING(@string,checker+1,1) as letter, checker+1 as checker from cte
where checker < len(@string)
)
select * from cte
--6
select p1.id, case when p1.code = 0 then p2.code else p1.code end as code, p2.id, p2.code from p1
full join p2
on p1.id = p2.id

--7
select *, case when YEAR(GETDATE()) -YEAR(HIRE_Date) < 1 then 'New Hire'
when YEAR(GETDATE()) -YEAR(HIRE_Date)< 5 then 'Junior'
when YEAR(GETDATE()) -YEAR(HIRE_Date) < 20 then 'Senior'
when YEAR(GETDATE()) -YEAR(HIRE_Date) >20 then 'Veteran'
end as status
from employees

--8
SELECT 
Vals,
CAST(
LEFT(Vals, PATINDEX('%[^0-9]%', Vals + 'X') - 1) 
AS INT
) AS StartInteger
FROM 
    GetIntegers
WHERE 
    Vals LIKE '[0-9]%';

	---------------------------------------------------------------------------------------------------------------------------------------------------------------
select *, case when id = 1 then STUFF(vals, 1, 4, 'b.a.')
else STUFF(vals, 1, 4, 'y.x.') end as reversed
from multiplevals
--2
select player_id, MIN(event_date) as first_time_login from activity
group by player_id
--3
with cte as(
select area, dayofweek, financialweek, isnull(saleslocal+salesremote,0)as totalSales from weekpercentagepuzzle)
select *, 
CAST(cast(totalsales as decimal)/CAST((select sum(totalsales) from cte) as decimal)*100 as decimal(10,2))
percentage
from cte

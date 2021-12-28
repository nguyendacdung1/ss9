select workOrderID,sum(actualResourceHrs) AS totalHours PerWorkOrder from 
production.workOrderRouting Group by WorkOrderID
go
select WorkOrderID,sum(actualResourceHrs) AS totalHours PerWorkOrder from 
production.workOrderRouting where WorkOrderID<50 group by workOrderID
go
select Class,AVG(ListPrice) AS 'AverageListPrice' From production.product group by Class
go
select[Group],sum(salesYTD)AS'totalsales'From sales.salesTerritory where[group]like'N%'or[group]like'E%'Group by all [group]
go
select[Group],sum(salesYTD)AS'totalsales'From sales.salesTerritory where[group]like'P%' group by all [group] having sum (salesYTD)<6000000
go
select name,countryRegionCode,sum(salesYTD)AS totalsales from sales.salesterritory where name<>'australia' and name<>'canada' group by name,countryRegionCode with cube
go
select name , countryRegionCode,sum(salesYTD) AS totalSales From sales.salesTerritory
where name<>'australia'and name<>'canada' group by name,countryRegionCode with rollup
go
select AVG([unitPrice]) AS avgUnitPrice, MIN ([OrderQty]) AS MinQty, Max([UnitPriceDiscount]) AS MaxDiscount from sales.salesOrderDetail;
go
select selesOrderID,AVG(unitPrice)AS AvgPtice from sales.salesOrderDetail;
go
select MIN(OrderDate)AS Earliest, MAX(OrderDate)as Latesr From sales.salesOrderHeader;
go
select Geography::UnionAggregate(SpatialLocation) AS AVGLocation from Person.Address where city='london';
go
select Geography:: EnvelopeAggregate(SpatialLocation) AS Location from person.Address where city='London'
go
select FirstName,LastName from person.person AS a where Exists (select*from humanResources.Employee as B where JobTitle='Research and Development Manager' and A.businessEntityID=B.BusinessEntityID);
go
select P.name,S.salesOrderID from sales>salesOrderDetail S right outer join
production.product P
on P.ProductID=S.ProductID;
go
select
    p1.ProductID,
	 p1.Color,
    p1.Name,
	p2.Name
from
    production.product p1
Inner join production.product p2 on p1.color=p2.color
order by p1.productID
go
set identity_insert[person].[addressType] on
merge into [person].[addressType] as target 
USING (values
    (1,'Billing'),
	(2,'Home'),
	(3,'Headquarters'),
	(4,'Primary'),
	(5,'Shipping'),
	(6,'Archival')
) AS Source
([AddressTypeID],[name]) on (target.[addressTypeID] = Source.[AddressTypeID])
when matched and (target.[name] = source.[name]) then
update set [name]=source.[name]
when not matched by target then
insert([addressTypeID],[Name]) values(source.[addressTypeID],source.[name])
where not matched by source then
delete
output $action, inserted.[addressTypeID], Inserted.Name,
Deleted.[AddressTypeID],Deleted.name;
go

with cte_orderYear AS
(
select year(orderDate) AS OrderYear,CustomerID
from Sales.salesOrderHeader
)
select orderYear,count(distinct customerID) AS CustomerCount from cte_orderYear
Group by OrderYear;
go

with cte_students
AS (
studentCode, S.name,C.cityName, St.Status from Student S
inner join city C
          on S.cityCode=c.citycode inner
join Status st
on S.StatusId=st.startusID),
StatusRecord -- This is the second CTE being defined
AS (
select status,Count(name) As countofStudents from
CTE_Students
Group by Status
)
select*from StatusRecord
go

Select Product.ProductID from Production.Product UNION
select productID from Sales.salesOrderDetail
go

select product.ProductID from Production.product UNION ALL
select ProductId from Sales.salesOrderDetail
go

select product.productId from Production.Product
intersect
select ProductId from Sales.SalesOrderDetail
go

select product.productId from Production.product
except
select productId from Sales.SalesOrderDetail
go

select top 5 sum(salesYTD) AS TotalSalesYTD, Name From Sales.salesTerritory
Group by name
go

select SalesYear, TotalSales from
(
    select*from
	( 
	     select year(SOH.OrderDate) AS SalesYear,
		        SOH.SubTotal AS TotalSales
		 from sales.SalesOrderHeader SOH
		      JOIN sales.SalesOrderDetail SOD on SOH.SalesOrderID=SodSalesOrderID
      ) As sales PIVOT(SUM(TotalSales) for SalesYear IN ([2011],
	                                                     [2012],
														 [2013],
														 [2014])) AS PVT
) T UNPIVOT(TotalSales FOR SalesYear IN ([2011],
	                                     [2012],
				                         [2013],
									     [2014])) AS upvt;
go


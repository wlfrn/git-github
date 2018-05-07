use northwind;
SET SESSION group_concat_max_len = 1000000;
drop view Suppliername;

create view Suppliername as 
select  Suppliers.SupplierID,CompanyName
from Products
inner join Suppliers
on Products.SupplierID = Suppliers.SupplierID
order by Products.SupplierID;

select distinct * from Suppliername order by SupplierID;
SET @SQL = NULL;
SELECT
  GROUP_CONCAT(DISTINCT
    CONCAT(
		'sum(case when CompanyName = ''',
      dt,
      ''' then 1 else 0 end) AS `',

      dt, '`'
    )
  ) INTO @SQL
FROM
(
  SELECT CompanyName AS dt
 from Suppliername where SupplierID not in  (3,5,6,24,29)
order by CompanyName
) d;

SET @SQL 
  = CONCAT('SELECT ',@SQL,' from Suppliername');

PREPARE stmt FROM @SQL;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;




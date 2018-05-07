use northwind;
SET SESSION group_concat_max_len = 1000000;
SET @SQL = NULL;
SELECT
  GROUP_CONCAT(DISTINCT
    CONCAT(
      'sum(case when Date_format(OrderDate, ''%Y-%m-%d'') = ''',
      dt,
      ''' then 1 else 0 end) AS `',
      dt, '`'
    )
  ) INTO @SQL
FROM
(
  SELECT Date_format(OrderDate, '%Y-%m-%d') AS dt
  FROM Invoices
  ORDER BY OrderDate
) d;

SET @SQL 
  = CONCAT('SELECT CompanyName, ', @SQL, ' 
            from Products
            inner join Invoices
              on Products.ProductID = Invoices.ProductID
				inner join Suppliers on 
				Suppliers.SupplierID = Products.SupplierID
            group by Products.SupplierID;');
select @sql;
PREPARE stmt FROM @SQL;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;




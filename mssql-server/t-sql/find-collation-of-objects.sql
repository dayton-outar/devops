
SELECT c.name, 
       c.collation_name
  FROM SYS.COLUMNS c
  JOIN SYS.TABLES t ON t.object_id = c.object_id
 WHERE t.name = '[tablename]'
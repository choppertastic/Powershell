DECLARE @DetachDBCMD VARCHAR(2000)
DECLARE @name VARCHAR(256)


declare db_cursor cursor for 
select name 
FROM MASTER.dbo.sysdatabases 
WHERE name NOT IN ('master','model','msdb','tempdb') 


OPEN db_cursor  
FETCH NEXT FROM db_cursor INTO @name  

WHILE @@FETCH_STATUS = 0  
BEGIN 


SET @DetachDBCMD = 'sp_detach_db ''' + @name + ''''

 -- print @DetachDBCMD
  EXEC (@DetachDBCMD)

FETCH NEXT FROM db_cursor INTO @name

END

CLOSE db_cursor  
DEALLOCATE db_cursor 



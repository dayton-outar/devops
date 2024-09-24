
EXEC sp_attach_db 
    @dbname = N'[DATABASE]',
    @filename1 = N'[filepath]\[data file].mdf', 
    @filename2 = N'filepath]\[log file].ldf'
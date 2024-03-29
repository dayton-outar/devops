# Docker Images for Microsoft SQL Server found here: https://hub.docker.com/_/microsoft-mssql-server
# Advised by https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-backup-and-restore-database?view=sql-server-ver15
# Adapted from https://docs.microsoft.com/en-us/sql/linux/tutorial-restore-backup-in-sql-server-container?view=sql-server-ver15
sqlcmd -S localhost,1401 -U SA -P "Password44" -Q "RESTORE DATABASE [blitz] FROM DISK = N'/var/opt/mssql/data/BLITZ.bak' WITH MOVE 'BLITZ' TO '/var/opt/mssql/data/BLITZ.mdf', MOVE 'BLITZ_log' TO '/var/opt/mssql/data/BLITZ_log.ldf', REPLACE"
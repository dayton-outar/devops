sqlcmd -S localhost,1401 -U SA -P "Password44" -Q "BACKUP DATABASE [stocks] TO DISK = N'/home/dayton/Downloads/stocks-2022-02-14.bak'"
ls *.sql | xargs -I {} sqlcmd -S localhost,1401 -U SA -P "Password44" -i {}
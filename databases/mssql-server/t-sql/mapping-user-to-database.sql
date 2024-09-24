-- Adapted from https://stackoverflow.com/questions/2775234/tsql-to-map-user-to-database
-- Change default database of a login
alter login [loginname] with default_database = [dbname];

-- Create a user in a database for a given login
use [dbname];
create user [username] from login [loginname];

-- Make an user member of db_owner group
use [dbname];
exec sp_addrolemember 'db_owner', '<username>';

-- Make a login 'dbo' of a database
alter authorization on database::[dbname] to [loginname];
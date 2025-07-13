DROP USER IF EXISTS 'backup'@'%';
CREATE USER 'backup'@'%' IDENTIFIED BY 'P@ssw0rd';

-- configure minimum requored permissions for performing a db backup using mysqldump: 
GRANT SELECT, LOCK TABLES, SHOW VIEW, PROCESS ON *.* TO 'backup'@'%';

-- configure required permissions to restore a database 
GRANT ALL ON ShopDBReserve.* TO 'backup'@'%';

-- configure required permissions to restore only data
GRANT INSERT, LOCK TABLES, ALTER, DROP, CREATE ON ShopDBDevelopment.* TO 'backup'@'%'; -- Змінено тут

FLUSH PRIVILEGES;
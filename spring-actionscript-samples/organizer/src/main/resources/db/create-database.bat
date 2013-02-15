@echo off

echo.
echo ========================================
echo = Spring ActionScript Organizer Sample =
echo ========================================
echo.

echo - deleting database
del organizer.db

echo - creating temp sqlite instructions
echo .read create-tables.sql > temp.txt
echo .read populate-database.sql >> temp.txt

echo - creating database
sqlite3.exe organizer.db < temp.txt

echo - cleaning up
del temp.txt

echo - database 'organizer.db' successfully created!
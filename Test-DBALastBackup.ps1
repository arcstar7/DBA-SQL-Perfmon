# Verifies the backups actually work, runs a DBCC CHECKDB on the restored copy, and drops it
Write-Output "Verifying latest backups..."
Test-DbaLastBackup -SqlInstance $SqlInstance -Databases "YourDatabase" -MaxSpaceNeeded 50GB
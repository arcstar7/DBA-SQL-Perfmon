param (
    [string]$SqlInstance = "localhost",
    [string]$DbaDatabase = "master", # Or a dedicated Admin database
    [string]$BackupLocation = "X:\SQLBackups"
)

# 1. Ensure dbatools is installed and loaded
if (-not (Get-Module -ListAvailable -Name dbatools)) {
    Write-Output "dbatools missing. Installing..."
    Install-Module -Name dbatools -Force -SkipPublisherCheck -Scope CurrentUser
}
Import-Module dbatools

# 2. Deploy Ola Hallengren's Solution
Write-Output "Deploying Ola Hallengren Maintenance Solution to $SqlInstance..."
Install-DbaMaintenanceSolution -SqlInstance $SqlInstance `
                               -Database $DbaDatabase `
                               -BackupLocation $BackupLocation `
                               -InstallJobs `
                               -LogToTable `
                               -ReplaceExisting

Write-Output "Deployment Complete. SQL Agent Jobs have been created."
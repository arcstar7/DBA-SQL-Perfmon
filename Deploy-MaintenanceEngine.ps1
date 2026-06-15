param (
    [string]$SqlInstance,
    [string]$DbaDatabase,
    [string]$BackupLocation
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

# 3. Reschedule Ola's IndexOptimize job
Write-Output "Adjusting IndexOptimize schedule for ERP workloads..."
Set-DbaAgentJobSchedule -SqlInstance $SqlInstance `
                        -Job "IndexOptimize - USER_DATABASES" `
                        -Schedule "Weekly_Sunday_1AM" `
                        -FrequencyType Weekly `
                        -FrequencyInterval Sunday `
                        -StartTime "010000"
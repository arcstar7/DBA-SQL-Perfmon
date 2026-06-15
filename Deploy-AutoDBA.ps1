param (
    [string]$SqlInstance    = "<SERVERNAME\INSTANCE>",
    [string]$DbaDatabase    = "master",
    [string]$BackupLocation = "<\\NAS\SQLBackups>",
    [string]$WebhookUri     = "<https://your-tenant.webhook.office.com/webhookb2/...>"
)

Write-Output "Starting DBA Automation Deployment for $SqlInstance..."

# 1. Deploy the Maintenance Engine & Schedules
Write-Output "`n[1/3] Deploying Maintenance Solution..."
.\Deploy-MaintenanceEngine.ps1 -SqlInstance $SqlInstance -DbaDatabase $DbaDatabase -BackupLocation $BackupLocation

# 2. Execute Backup Verification
Write-Output "`n[2/3] Running Backup Verification..."
.\Verify-Backups.ps1 -SqlInstance $SqlInstance

# 3. Trigger Teams Alert Monitoring
Write-Output "`n[3/3] Checking for Alertable Failures..."
.\Monitor-TeamsAlerts.ps1 -SqlInstance $SqlInstance -DbaDatabase $DbaDatabase -WebhookUri $WebhookUri

Write-Output "`nDeployment Complete!"
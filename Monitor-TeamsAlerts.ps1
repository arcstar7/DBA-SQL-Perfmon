param (
    [string]$SqlInstance,
    [string]$DbaDatabase,
    [string]$WebhookUri
)

# Check Ola's log table for any jobs that failed in the last 24 hours
$FailedJobsQuery = @"
SELECT DatabaseName, Command, ErrorMessage 
FROM [$DbaDatabase].[dbo].[CommandLog] 
WHERE StartTime > DATEADD(day, -1, GETDATE()) 
AND ErrorNumber <> 0
"@

$Failures = Invoke-DbaQuery -SqlInstance $SqlInstance -Query $FailedJobsQuery

if ($Failures) {
    foreach ($Failure in $Failures) {
        $Payload = @{
            text = "⚠️ **SQL Maintenance Failure on $($SqlInstance)**`n**Database:** $($Failure.DatabaseName)`n**Error:** $($Failure.ErrorMessage)"
        }
        Invoke-RestMethod -Uri $WebhookUri -Method Post -Body ($Payload | ConvertTo-Json) -ContentType "application/json"
    }
} else {
    Write-Output "No failures detected in the CommandLog."
}
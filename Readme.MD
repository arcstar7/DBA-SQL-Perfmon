# Autonomous SQL Server Maintenance & Monitoring Agent

A fully automated, PowerShell-based orchestrator that deploys industry-standard database maintenance routines, verifies backup integrity, and routes critical alerts directly to Microsoft Teams.

Designed to create a "hands-off" database administration environment, this tool acts as a wrapper around the powerful dbatools module and Ola Hallengren's SQL Server Maintenance Solution. It is specifically optimized to keep heavy enterprise environments (such as Dynamics Business Central, NAV, or other large ERPs) healthy without manual DBA intervention.

## ✨ Features
* **Zero-Touch Deployment:** Automatically downloads, compiles, and schedules Ola Hallengren’s maintenance scripts across any SQL Server instance.
* **Proactive Teams Alerting:** Bypasses noisy email inboxes by querying the CommandLog and pushing job failures directly to a Microsoft Teams webhook.
* **Automated Backup Verification:** Doesn't just take backups—it automatically restores and runs DBCC CHECKDB on recent backups to guarantee data integrity.
* **ERP-Optimized Scheduling:** Automatically adjusts heavy index rebuild/reorganize schedules to align with warehouse or operations downtime.

## 📋 Prerequisites
Before running the orchestrator, ensure the deployment environment meets the following requirements:

* Windows PowerShell 5.1 or PowerShell 7+
* **dbatools Module:** The script will attempt to install this automatically, but it requires internet access. (`Install-Module dbatools`)
* **SQL Server Permissions:** The executing user must have sysadmin privileges on the target SQL Server instances.
* **Microsoft Teams Webhook:** An active incoming webhook URL configured in a Teams channel for alerting.

## 🚀 Installation & Usage

### 1. Clone the Repository
```bash
git clone https://github.com/arcstar7/DBA-SQL-Perfmon.git
cd DBA-SQL-Perfmon
```

### 2. Configure the Orchestrator
Open `Deploy-AutoDBA.ps1` and update the core parameters at the top of the script to match your environment:

```powershell
$SqlInstance    = "<SERVERNAME\INSTANCE>"
$DbaDatabase    = "master"             # Update to a dedicated Admin DB if preferred
$BackupLocation = "<\\NAS\SQLBackups>" # UNC path recommended
$WebhookUri     = "<[https://your-tenant.webhook.office.com/webhookb2/](https://your-tenant.webhook.office.com/webhookb2/)...>"
```

### 3. Run the Deployment
Execute the script from an elevated PowerShell prompt:

```powershell
.\Deploy-AutoDBA.ps1
```

**The orchestrator will:**
1. Verify/Install the dbatools module.
2. Deploy the latest maintenance stored procedures.
3. Generate the SQL Server Agent jobs and adjust their schedules.
4. Verify your latest backups.
5. Push any recent job failures to your Teams webhook.

## 🧩 Modular Execution
If you prefer not to run the master orchestrator, you can execute any of the modules independently by passing the required parameters.

**Deploy Maintenance Only:**
```powershell
.\Deploy-MaintenanceEngine.ps1 -SqlInstance "SRV-SQL01" -DbaDatabase "master" -BackupLocation "\\NAS\Backups"
```

**Verify Backups Only:**
```powershell
.\Verify-Backups.ps1 -SqlInstance "SRV-SQL01"
```

**Trigger Teams Alert Check Only:**
*(Ideal for scheduling as a recurring Windows Task or SQL Agent step)*
```powershell
.\Monitor-TeamsAlerts.ps1 -SqlInstance "SRV-SQL01" -DbaDatabase "master" -WebhookUri "https://..."
```

## ⚙️ Customizing Schedules
By default, the script reschedules the `IndexOptimize` job to run weekly on Sundays at 1:00 AM to prevent locking tables during active ERP operations.

To change this, locate the scheduling block at the bottom of `Deploy-MaintenanceEngine.ps1`:

```powershell
Set-DbaAgentJobSchedule -SqlInstance $SqlInstance `
                        -Job "IndexOptimize - USER_DATABASES" `
                        -Schedule "Weekly_Sunday_1AM" `
                        -FrequencyType Weekly `
                        -FrequencyInterval Sunday `
                        -StartTime "010000"
```
Adjust the `-FrequencyInterval` and `-StartTime` (HHMMSS format) to match your organization's specific maintenance windows.

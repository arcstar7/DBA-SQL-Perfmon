# Reschedule Ola's IndexOptimize job to run only on Sundays at 1:00 AM
Set-DbaAgentJobSchedule -SqlInstance $SqlInstance `
                        -Job "IndexOptimize - USER_DATABASES" `
                        -Schedule "Weekly_Sunday_1AM" `
                        -FrequencyType Weekly `
                        -FrequencyInterval Sunday `
                        -StartTime "010000"
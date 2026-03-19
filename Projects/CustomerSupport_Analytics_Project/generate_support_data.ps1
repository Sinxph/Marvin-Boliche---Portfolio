$csvPath = "c:\Users\m_bol\OneDrive\Desktop\Projects\CustomerSupport_Analytics_Project\Raw_Support_Data.csv"
$headers = "TicketID,DateOpened,DateClosed,Category,Priority,AgentName,ResolutionTimeHrs,CSAT_Score"
$headers | Out-File -FilePath $csvPath -Encoding ascii

$categories = @("Billing", "Technical", "Account", "General", " technical ", "BILLING")
$priorities = @("Low", "Medium", "High", "Urgent")
$agents = @("Sarah K.", "Mike T.", "David W.", "Jessica L.", "Tom B.")

$rand = New-Object System.Random
$outData = New-Object System.Text.StringBuilder

for ($i = 80001; $i -le 82000; $i++) {
    $dateOpened = (Get-Date "2024-01-01").AddDays($rand.Next(0, 365))
    $dateStr = $dateOpened.ToString("yyyy-MM-dd")
    
    if ($rand.Next(0, 100) -lt 5) { $dateStr = $dateOpened.ToString("MM/dd/yyyy") }

    $cat = $categories[$rand.Next(0, $categories.Length)]
    $pri = $priorities[$rand.Next(0, $priorities.Length)]
    $agent = $agents[$rand.Next(0, $agents.Length)]
    
    # Generate Resolution Time
    $resHrs = $rand.Next(1, 120)
    if ($pri -eq "Urgent") { $resHrs = [Math]::Floor($resHrs * 0.3) + 1 }
    
    # Issue: Closed tickets without a close date or vice versa
    $isClosed = ($rand.Next(0, 100) -lt 85)
    
    if ($isClosed) {
        $closedDate = $dateOpened.AddHours($resHrs)
        $closedDateStr = $closedDate.ToString("yyyy-MM-dd")
        $csat = $rand.Next(1, 6) # 1 to 5 stars
        
        # Intentional error: Missing CSAT
        if ($rand.Next(0, 100) -lt 10) { $csat = "" }
    } else {
        $closedDateStr = ""
        $csat = ""
        $resHrs = ""
    }
    
    # Negative resolution time error
    if ($isClosed -and $rand.Next(0, 100) -lt 2) { $resHrs = $resHrs * -1 }

    $line = "$i,$dateStr,$closedDateStr,$cat,$pri,$agent,$resHrs,$csat"
    [void]$outData.AppendLine($line)
}

$outData.ToString() | Out-File -FilePath $csvPath -Encoding ascii -Append
Write-Host "Generated Raw_Support_Data.csv"

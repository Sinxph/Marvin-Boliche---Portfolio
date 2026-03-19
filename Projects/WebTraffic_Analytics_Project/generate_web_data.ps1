$csvPath = "c:\Users\m_bol\OneDrive\Desktop\Projects\WebTraffic_Analytics_Project\Raw_Web_Data.csv"
$headers = "DataID,Date,ChannelGroup,DeviceCategory,TotalUsers,NewUsers,Sessions,Purchases,Revenue"
$headers | Out-File -FilePath $csvPath -Encoding ascii

$channels = @("Direct", "Organic Search", "Paid Search", "Email", "Social", "Referral", " direct ", "email")
$devices = @("desktop", "mobile", "tablet", "smart tv", "Desktop")

$rand = New-Object System.Random
$outData = New-Object System.Text.StringBuilder

for ($i = 60001; $i -le 61500; $i++) {
    $date = (Get-Date "2024-01-01").AddDays($rand.Next(0, 365))
    $dateStr = $date.ToString("yyyy-MM-dd")
    
    # Intentional date format error
    if ($rand.Next(0, 100) -lt 5) { $dateStr = $date.ToString("MM/dd/yyyy") }

    $channel = $channels[$rand.Next(0, $channels.Length)]
    $device = $devices[$rand.Next(0, $devices.Length)]
    
    $sessions = $rand.Next(100, 3000)
    
    # Logic defining user relationships
    $totalUsers = [Math]::Floor($sessions * ($rand.Next(70, 95) / 100.0))
    $newUsers = [Math]::Floor($totalUsers * ($rand.Next(40, 80) / 100.0))
    
    $cvr = if ($channel -match "Search") { 0.05 } elseif ($channel -match "Direct") { 0.08 } else { 0.02 }
    $purchases = [Math]::Floor($sessions * $cvr)
    $revenue = $purchases * $rand.Next(20, 150)
    
    # Intentional dirty data: Missing revenue when there are purchases
    if ($purchases -gt 0 -and $rand.Next(0, 100) -lt 4) { $revenue = "" }
    
    # Negative sessions error
    if ($rand.Next(0, 100) -lt 2) { $sessions = $sessions * -1 }

    $line = "$i,$dateStr,$channel,$device,$totalUsers,$newUsers,$sessions,$purchases,$revenue"
    [void]$outData.AppendLine($line)
}

$outData.ToString() | Out-File -FilePath $csvPath -Encoding ascii -Append
Write-Host "Generated Raw_Web_Data.csv"

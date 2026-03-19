$csvPath = "c:\Users\m_bol\OneDrive\Desktop\Projects\Marketing_Analytics_Project\Raw_Marketing_Data.csv"
$headers = "CampaignID,LaunchDate,Channel,TargetAudience,SpendAmount,Impressions,Clicks,Conversions,Status"
$headers | Out-File -FilePath $csvPath -Encoding utf8

$channels = @("Social Media", "Search Engine", "Email", "Affiliate", " social media ", "email")
$audiences = @("Gen Z", "Millennials", "B2B", "General", "B2B ", "  Gen Z")
$statuses = @("Active", "Paused", "Completed")

$rand = New-Object System.Random
$outData = New-Object System.Text.StringBuilder

for ($i = 30001; $i -le 31500; $i++) {
    $date = (Get-Date "2023-01-01").AddDays($rand.Next(0, 730))
    $dateStr = $date.ToString("yyyy-MM-dd")
    
    if ($rand.Next(0, 100) -lt 5) { $dateStr = $date.ToString("MM/dd/yyyy") } # Format bug

    $channel = $channels[$rand.Next(0, $channels.Length)]
    $aud = $audiences[$rand.Next(0, $audiences.Length)]
    
    $spend = $rand.Next(500, 15000)
    # Missing spend error
    if ($rand.Next(0, 100) -lt 4) { $spend = "" }

    # Generate metrics with logical relationships
    $impr = $rand.Next(10000, 1000000)
    $ctr = ($rand.Next(5, 50) / 1000.0) # 0.5% to 5%
    $clicks = [Math]::Floor($impr * $ctr)
    
    $cvr = ($rand.Next(1, 100) / 1000.0) # 0.1% to 10%
    $conv = [Math]::Floor($clicks * $cvr)

    $status = $statuses[$rand.Next(0, $statuses.Length)]
    
    $line = "$i,$dateStr,$channel,$aud,$spend,$impr,$clicks,$conv,$status"
    [void]$outData.AppendLine($line)
    
    # Duplicate campaign log
    if ($rand.Next(0, 100) -lt 2) { [void]$outData.AppendLine($line) }
}

$outData.ToString() | Out-File -FilePath $csvPath -Encoding utf8 -Append
Write-Host "Generated Raw_Marketing_Data.csv"

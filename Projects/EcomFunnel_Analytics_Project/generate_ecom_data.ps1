$csvPath = "c:\Users\m_bol\OneDrive\Desktop\Projects\EcomFunnel_Analytics_Project\Raw_Ecom_Data.csv"
$headers = "WeekStartDate,AdPlatform,AmountSpend,Impressions,Clicks,TotalUsers,NewUsers,Revenue,Orders,NewCustomers"
$headers | Out-File -FilePath $csvPath -Encoding ascii

$platforms = @("Facebook Ads", "Google Ads", "TikTok Ads", "Affiliate", " google ads ", "tiktok")

$rand = New-Object System.Random
$outData = New-Object System.Text.StringBuilder

for ($i = 0; $i -le 1500; $i++) {
    $date = (Get-Date "2024-01-01").AddDays($rand.Next(0, 52) * 7) # weekly dates
    $dateStr = $date.ToString("yyyy-MM-dd")
    
    # Intentional date format error
    if ($rand.Next(0, 100) -lt 5) { $dateStr = $date.ToString("MM/dd/yyyy") }

    $plat = $platforms[$rand.Next(0, $platforms.Length)]
    
    $spend = $rand.Next(500, 5000)
    
    $impr = [Math]::Floor($spend * $rand.Next(20, 100))
    $clicks = [Math]::Floor($impr * ($rand.Next(1, 8) / 100.0))
    $totalUsers = [Math]::Floor($clicks * ($rand.Next(60, 95) / 100.0))
    $newUsers = [Math]::Floor($totalUsers * ($rand.Next(50, 80) / 100.0))
    
    $orders = [Math]::Floor($totalUsers * ($rand.Next(2, 10) / 100.0))
    $newCustomers = [Math]::Floor($orders * ($rand.Next(40, 80) / 100.0))
    
    $revenue = $orders * $rand.Next(30, 200)
    
    # Intentional dirty data: Missing spend occasionally
    if ($rand.Next(0, 100) -lt 3) { $spend = "" }
    
    # Negative Revenue error
    if ($rand.Next(0, 100) -lt 2) { $revenue = $revenue * -1 }

    $line = "$dateStr,$plat,$spend,$impr,$clicks,$totalUsers,$newUsers,$revenue,$orders,$newCustomers"
    [void]$outData.AppendLine($line)
}

$outData.ToString() | Out-File -FilePath $csvPath -Encoding ascii -Append
Write-Host "Generated Raw_Ecom_Data.csv"

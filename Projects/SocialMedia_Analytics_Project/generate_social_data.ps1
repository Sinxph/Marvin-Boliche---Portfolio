$csvPath = "c:\Users\m_bol\OneDrive\Desktop\Projects\SocialMedia_Analytics_Project\Raw_Social_Data.csv"
$headers = "RecordID,Date,Platform,Impressions,Reach,PageViews,FollowersGained,Engagements,PostsPublished,VideoViews,WatchTimeMins,WebUsers,Purchases,Revenue,Sessions"
$headers | Out-File -FilePath $csvPath -Encoding ascii

$platforms = @("Facebook", "Instagram", "LinkedIn", "YouTube", " instagram ", "youtube")

$rand = New-Object System.Random
$outData = New-Object System.Text.StringBuilder

for ($i = 50001; $i -le 51500; $i++) {
    $date = (Get-Date "2024-03-01").AddDays($rand.Next(0, 90))
    $dateStr = $date.ToString("yyyy-MM-dd")
    
    # Intentional date format error
    if ($rand.Next(0, 100) -lt 5) { $dateStr = $date.ToString("MM/dd/yyyy") }

    $plat = $platforms[$rand.Next(0, $platforms.Length)]
    
    $impr = $rand.Next(100, 5000)
    $reach = [Math]::Floor($impr * ($rand.Next(40, 90) / 100.0))
    $views = $rand.Next(10, 800)
    $foll = $rand.Next(-5, 50)
    $eng = [Math]::Floor($impr * ($rand.Next(1, 15) / 100.0))
    $posts = $rand.Next(0, 4)
    
    # YouTube specific Video metrics
    $vidViews = if ($plat -match "YouTube") { $rand.Next(500, 10000) } else { 0 }
    $watchTime = if ($plat -match "YouTube") { $rand.Next(1000, 50000) } else { 0 }
    
    # Website conversion tracking metrics
    $webUsers = $rand.Next(50, 500)
    $purchases = if ($rand.Next(0, 100) -lt 30) { $rand.Next(1, 10) } else { 0 }
    $revenue = $purchases * $rand.Next(30, 150)
    $sessions = [Math]::Floor($webUsers * 1.2)
    
    # Intentional dirty data: negative impressions or missing revenue
    if ($rand.Next(0, 100) -lt 2) { $impr = $impr * -1 }
    if ($rand.Next(0, 100) -lt 3) { $revenue = "" }

    $line = "$i,$dateStr,$plat,$impr,$reach,$views,$foll,$eng,$posts,$vidViews,$watchTime,$webUsers,$purchases,$revenue,$sessions"
    [void]$outData.AppendLine($line)
}

$outData.ToString() | Out-File -FilePath $csvPath -Encoding ascii -Append
Write-Host "Generated Raw_Social_Data.csv"

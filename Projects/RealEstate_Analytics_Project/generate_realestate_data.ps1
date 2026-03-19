$csvPath = "c:\Users\m_bol\OneDrive\Desktop\Projects\RealEstate_Analytics_Project\Raw_RealEstate_Data.csv"
$headers = "PropertyID,ListingDate,PropertyType,City,Bedrooms,Bathrooms,SquareFeet,MonthlyRent,MaintenanceCosts,IsOccupied,TenantChurn_Flag"
$headers | Out-File -FilePath $csvPath -Encoding ascii

$types = @("Apartment", "Townhouse", "Single Family", "Condo", " apartment ", "single family")
$cities = @("Austin", "Dallas", "Houston", "San Antonio")
$bools = @("Yes", "No")

$rand = New-Object System.Random
$outData = New-Object System.Text.StringBuilder

for ($i = 90001; $i -le 91000; $i++) {
    $date = (Get-Date "2023-01-01").AddDays($rand.Next(0, 700))
    $dateStr = $date.ToString("yyyy-MM-dd")
    
    # Intentional date format error
    if ($rand.Next(0, 100) -lt 5) { $dateStr = $date.ToString("MM/dd/yyyy") }

    $type = $types[$rand.Next(0, $types.Length)]
    $city = $cities[$rand.Next(0, $cities.Length)]
    
    $beds = $rand.Next(1, 6)
    $baths = $beds + ($rand.Next(-1, 2) * 0.5)
    if ($baths -lt 1) { $baths = 1 }
    
    $sqft = $beds * $rand.Next(400, 800)
    
    $rent = $sqft * (1.2 + ($rand.NextDouble() * 1.5))
    
    # Missing rent error
    if ($rand.Next(0, 100) -lt 3) { $rent = "" }
    
    # Negative maintenance error
    $maint = $rand.Next(50, 800)
    if ($rand.Next(0, 100) -lt 2) { $maint = $maint * -1 }
    
    $occupied = $bools[$rand.Next(0, $bools.Length)]
    $churn = if ($occupied -eq "No" -and $rand.Next(0, 100) -gt 30) { "Yes" } else { "No" }

    $line = "$i,$dateStr,$type,$city,$beds,$baths,$sqft,$rent,$maint,$occupied,$churn"
    [void]$outData.AppendLine($line)
}

$outData.ToString() | Out-File -FilePath $csvPath -Encoding ascii -Append
Write-Host "Generated Raw_RealEstate_Data.csv"

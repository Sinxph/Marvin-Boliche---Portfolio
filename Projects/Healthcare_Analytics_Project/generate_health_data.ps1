$csvPath = "c:\Users\m_bol\OneDrive\Desktop\Projects\Healthcare_Analytics_Project\Raw_Health_Data.csv"
$headers = "ClaimID,PatientID,ServiceDate,BilledAmount,CollectedAmount,CollectionDate,Payer,ClaimStatus,DenialReason"
$headers | Out-File -FilePath $csvPath -Encoding utf8

$payers = @("Medicare", "Medicaid", "Commercial", "Self-Pay", " medicare ", "COMMERCIAL")

$denialReasons = @("Missing Authorization", "Duplicate Claim", "Coding Error", "Coverage Eligibility", "Timely Filing", "Bundling Issue", "")

$rand = New-Object System.Random
$outData = New-Object System.Text.StringBuilder

for ($i = 50001; $i -le 52000; $i++) {
    $patID = $rand.Next(1000, 9999)
    $serviceDate = (Get-Date "2023-01-01").AddDays($rand.Next(0, 500))
    $serviceDateStr = $serviceDate.ToString("yyyy-MM-dd")
    
    # Intentional date format error
    if ($rand.Next(0, 100) -lt 5) { $serviceDateStr = $serviceDate.ToString("MM/dd/yyyy") }

    $payer = $payers[$rand.Next(0, $payers.Length)]
    $billed = $rand.Next(100, 5000)
    
    # 70% Paid, 20% Denied, 10% Pending
    $statusRand = $rand.Next(0, 100)
    if ($statusRand -lt 70) {
        $status = "Paid"
        $collected = [Math]::Round($billed * ($rand.Next(60, 100) / 100.0), 2)
        $collDate = $serviceDate.AddDays($rand.Next(15, 90))
        $collDateStr = $collDate.ToString("yyyy-MM-dd")
        $reason = ""
    } elseif ($statusRand -lt 90) {
        $status = "Denied"
        $collected = 0
        $collDateStr = ""
        $reason = $denialReasons[$rand.Next(0, $denialReasons.Length - 1)]
    } else {
        $status = "Pending"
        $collected = 0
        $collDateStr = ""
        $reason = ""
    }

    # Intentional nulls
    if ($rand.Next(0, 100) -lt 3) { $billed = "" }

    $line = "$i,$patID,$serviceDateStr,$billed,$collected,$collDateStr,$payer,$status,$reason"
    [void]$outData.AppendLine($line)
    
    # Duplicate Claim representation
    if ($rand.Next(0, 100) -lt 2) { [void]$outData.AppendLine($line) }
}

$outData.ToString() | Out-File -FilePath $csvPath -Encoding utf8 -Append
Write-Host "Generated Raw_Health_Data.csv"

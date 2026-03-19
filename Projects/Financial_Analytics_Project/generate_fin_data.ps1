$csvPath = "c:\Users\m_bol\OneDrive\Desktop\Projects\Financial_Analytics_Project\Raw_Financial_Data.csv"
$headers = "TransactionID,Date,Department,Type,Amount,Budget,Status,Notes"
$headers | Out-File -FilePath $csvPath -Encoding utf8

$departments = @("Operations", "Marketing", "Sales", "R&D", "Admin", " operations ", "sales")
$types = @("Income", "Expense")

$rand = New-Object System.Random
$outData = New-Object System.Text.StringBuilder

for ($i = 20001; $i -le 21500; $i++) {
    $date = (Get-Date "2023-01-01").AddDays($rand.Next(0, 730))
    $dateStr = $date.ToString("yyyy-MM-dd")
    
    if ($rand.Next(0, 100) -lt 5) { $dateStr = $date.ToString("MM/dd/yyyy") } # Format bug

    $dept = $departments[$rand.Next(0, $departments.Length)]
    
    $typeRand = $rand.Next(0, 100)
    if ($typeRand -lt 40) {
        $type = "Income"
        $amount = $rand.Next(5000, 25000)
        $budget = $rand.Next(4000, 20000)
    } else {
        $type = "Expense"
        $amount = $rand.Next(1000, 15000)
        $budget = $rand.Next(1000, 12000)
    }

    # Intentional dirty data: Negative income or massive outlier
    if ($rand.Next(0, 100) -lt 2) { $amount = $amount * -1 }
    
    # Missing amount
    if ($rand.Next(0, 100) -lt 4) { $amount = "" }

    $status = if ($rand.Next(0, 100) -lt 90) { "Cleared" } else { "Pending" }
    
    $line = "$i,$dateStr,$dept,$type,$amount,$budget,$status,"
    [void]$outData.AppendLine($line)
    
    # Duplicate transaction
    if ($rand.Next(0, 100) -lt 1) { [void]$outData.AppendLine($line) }
}

$outData.ToString() | Out-File -FilePath $csvPath -Encoding utf8 -Append
Write-Host "Generated Raw_Financial_Data.csv"

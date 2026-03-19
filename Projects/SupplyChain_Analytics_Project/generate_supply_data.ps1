$csvPath = "c:\Users\m_bol\OneDrive\Desktop\Projects\SupplyChain_Analytics_Project\Raw_SupplyChain_Data.csv"
$headers = "ProductID,OrderDate,DeliveryDate,Supplier,WarehouseLocation,QuantityOrdered,QuantityReceived,UnitCost,Status"
$headers | Out-File -FilePath $csvPath -Encoding utf8

$suppliers = @("Alpha Corp", "Beta Mfg", "Gamma Logistics", "Delta Supplies", " alpha corp ")
$locations = @("New York DC", "Los Angeles DC", "Chicago DC", "Dallas DC", " unknown")
$statuses = @("Delivered", "In Transit", "Delayed")

$rand = New-Object System.Random
$outData = New-Object System.Text.StringBuilder

for ($i = 40001; $i -le 41500; $i++) {
    $orderDate = (Get-Date "2023-01-01").AddDays($rand.Next(0, 700))
    $orderDateStr = $orderDate.ToString("yyyy-MM-dd")

    $supplier = $suppliers[$rand.Next(0, $suppliers.Length)]
    $loc = $locations[$rand.Next(0, $locations.Length)]
    $status = $statuses[$rand.Next(0, $statuses.Length)]
    
    $qtyOrdered = $rand.Next(100, 5000)
    
    # Received quantity logic
    if ($status -eq "Delivered") {
        $qtyReceived = $qtyOrdered
        # Intentional short shipment
        if ($rand.Next(0, 100) -lt 10) { $qtyReceived = [Math]::Floor($qtyOrdered * ($rand.Next(80, 99) / 100.0)) }
        
        $deliveryDays = $rand.Next(2, 30)
        $deliveryDate = $orderDate.AddDays($deliveryDays)
        $deliveryDateStr = $deliveryDate.ToString("yyyy-MM-dd")
    } else {
        $qtyReceived = 0
        $deliveryDateStr = ""
    }

    $unitCost = $rand.Next(10, 500)
    # Missing Unit Cost Error
    if ($rand.Next(0, 100) -lt 4) { $unitCost = "" }

    $line = "$i,$orderDateStr,$deliveryDateStr,$supplier,$loc,$qtyOrdered,$qtyReceived,$unitCost,$status"
    [void]$outData.AppendLine($line)
}

$outData.ToString() | Out-File -FilePath $csvPath -Encoding utf8 -Append
Write-Host "Generated Raw_SupplyChain_Data.csv"

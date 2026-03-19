$csvPath = "c:\Users\m_bol\OneDrive\Desktop\Projects\DataAnalysisProject\Raw_Sales_Data.csv"
$headers = "OrderID,Date,CustomerName,Product,Category,Quantity,UnitPrice,Revenue,Region"
$headers | Out-File -FilePath $csvPath -Encoding utf8

$customers = @("John Doe", "jane smith", "Bob Johnson", "Alice Brown", "Charlie Davis", "Eve White", "Frank Green", "Grace Hopper", "Hank Williams", "Ivy Taylor", "Jack Black", "Kathy Bates", "Leo Tolstoy", "Mary Shelley", "Nathan Drake", "Olivia Munn", "Peter Parker")
$products = @(
    @("Laptop", "Electronics", 1200),
    @("Mouse", "Electronics", 25),
    @("Keyboard", "Electronics", 40),
    @("Monitor", "Electronics", 300),
    @("Printer", "Electronics", 200),
    @("Desk Chair", "Furniture", 150),
    @("Desk", "Furniture", 450),
    @("Sofa", "Furniture", 600),
    @("Bookshelf", "Furniture", 300),
    @("Coffee Maker", "Appliances", 75),
    @("Blender", "Appliances", 50),
    @("Smart Watch", "Electronics", 250),
    @("Headphones", "electronics", 100)
)
$regions = @("North", "South", "East", "West", " north ", "south", "EAST")

$rand = New-Object System.Random
$startDate = [datetime]"2023-01-01"
$endDate = [datetime]"2026-12-31"
$range = ($endDate - $startDate).Days

$outData = New-Object System.Text.StringBuilder

for ($i = 1001; $i -le 2500; $i++) {
    $randomDays = $rand.Next(0, $range)
    $date = $startDate.AddDays($randomDays)
    
    # Introduce some date format variations
    if ($rand.Next(0, 100) -lt 5) {
        $dateStr = $date.ToString("MM/dd/yy")
    } elseif ($rand.Next(0, 100) -lt 5) {
        $dateStr = $date.ToString("dd-MM-yyyy")
    } else {
        $dateStr = $date.ToString("yyyy-MM-dd")
    }

    $customer = $customers[$rand.Next(0, $customers.Length)]
    
    # Intentionally missing customer
    if ($rand.Next(0, 100) -lt 3) {
        $customer = ""
    }

    $prodObj = $products[$rand.Next(0, $products.Length)]
    $product = $prodObj[0]
    $category = $prodObj[1]
    $unitPrice = $prodObj[2]
    
    # Intentionally messed up quantity
    $qty = $rand.Next(1, 10)
    if ($rand.Next(0, 100) -lt 2) {
        $qty = -1
    }

    # Revenue
    $revenue = $qty * $unitPrice
    
    # Missing revenue
    if ($rand.Next(0, 100) -lt 5) {
        $revenue = ""
    }

    $region = $regions[$rand.Next(0, $regions.Length)]

    $line = "$i,$dateStr,$customer,$product,$category,$qty,$unitPrice,$revenue,$region"
    [void]$outData.AppendLine($line)
    
    # Occasional duplicate ID
    if ($rand.Next(0, 100) -lt 1) {
        [void]$outData.AppendLine($line)
    }
}

$outData.ToString() | Out-File -FilePath $csvPath -Encoding utf8 -Append
Write-Host "Generated Raw_Sales_Data.csv"

$csvPath = "c:\Users\m_bol\OneDrive\Desktop\Projects\HR_Analytics_Project\Raw_HR_Data.csv"
$headers = "EmpID,FirstName,LastName,Department,JobRole,HireDate,TerminationDate,Salary,Gender,JobSatisfaction,Attrition"
$headers | Out-File -FilePath $csvPath -Encoding utf8

$departments = @("Sales", "R&D", "HR", " saLes ", "R&D", " HR")
$roles = @("Manager", "Developer", "Analyst", "Salesperson", "HR Rep", "Director")
$genders = @("Male", "Female", "M", "F")
$firstNames = @("John", "Jane", "Alice", "Bob", "Charlie", "Diana", "Eve", "Frank")
$lastNames = @("Smith", "Doe", "Johnson", "Brown", "Davis", "Miller", "Wilson")

$rand = New-Object System.Random
$outData = New-Object System.Text.StringBuilder

for ($i = 10001; $i -le 11500; $i++) {
    $fn = $firstNames[$rand.Next(0, $firstNames.Length)]
    $ln = $lastNames[$rand.Next(0, $lastNames.Length)]
    $dept = $departments[$rand.Next(0, $departments.Length)]
    $role = $roles[$rand.Next(0, $roles.Length)]
    $gender = $genders[$rand.Next(0, $genders.Length)]
    
    $salary = $rand.Next(40000, 150000)
    # Intentional messy salary (string instead of int or missing)
    if ($rand.Next(0, 100) -lt 5) { $salary = "" }
    
    $hireDate = (Get-Date "2015-01-01").AddDays($rand.Next(0, 3000))
    $hireDateStr = $hireDate.ToString("yyyy-MM-dd")
    if ($rand.Next(0, 100) -lt 10) { $hireDateStr = $hireDate.ToString("MM/dd/yyyy") } # messed up format

    $attrition = "No"
    $termDateStr = ""
    # ~16% attrition rate
    if ($rand.Next(0, 100) -lt 16) {
        $attrition = "Yes"
        $termDate = $hireDate.AddDays($rand.Next(60, 1500))
        $termDateStr = $termDate.ToString("yyyy-MM-dd")
    }

    $satisfaction = $rand.Next(1, 5) # 1-4 scale
    # Messy capitalization
    if ($rand.Next(0, 100) -lt 5) { $attrition = "yes" }

    $line = "$i,$fn,$ln,$dept,$role,$hireDateStr,$termDateStr,$salary,$gender,$satisfaction,$attrition"
    [void]$outData.AppendLine($line)
}

$outData.ToString() | Out-File -FilePath $csvPath -Encoding utf8 -Append
Write-Host "Generated Raw_HR_Data.csv"

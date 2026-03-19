let
    Source = Csv.Document(File.Contents("C:\Users\m_bol\OneDrive\Desktop\Projects\HR_Analytics_Project\Raw_HR_Data.csv"),[Delimiter=",", Columns=11, Encoding=1252, QuoteStyle=QuoteStyle.None]),
    PromoteHeaders = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    ChangeTypes = Table.TransformColumnTypes(PromoteHeaders,{
        {"EmpID", Int64.Type}, 
        {"HireDate", type date}, 
        {"TerminationDate", type date}, 
        {"Salary", type number}, 
        {"JobSatisfaction", Int64.Type}
    }),
    
    // Clean Text Columns
    TrimAndProper = Table.TransformColumns(ChangeTypes, {
        {"Department", each Text.Proper(Text.Trim(_)), type text},
        {"Gender", each if Text.StartsWith(Text.Upper(_), "M") then "Male" else "Female", type text},
        {"Attrition", each Text.Proper(Text.Trim(_)), type text}
    }),
    
    // Impute Missing Salary with Median/Average or static fallback (e.g., $60,000)
    FillSalary = Table.ReplaceValue(TrimAndProper, null, 60000, Replacer.ReplaceValue, {"Salary"}),
    
    // Calculate Tenure (Days) natively in M
    AddTenure = Table.AddColumn(FillSalary, "TenureDays", each 
        if [Attrition] = "Yes" and [TerminationDate] <> null 
        then Duration.Days([TerminationDate] - [HireDate]) 
        else Duration.Days(DateTime.LocalNow() - DateTime.From([HireDate]))
    )
in
    AddTenure

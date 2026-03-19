let
    Source = Csv.Document(File.Contents("C:\Users\m_bol\OneDrive\Desktop\Projects\RealEstate_Analytics_Project\Raw_RealEstate_Data.csv"),[Delimiter=",", Columns=11, Encoding=1252, QuoteStyle=QuoteStyle.None]),
    PromoteHeaders = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    ChangeTypes = Table.TransformColumnTypes(PromoteHeaders,{
        {"PropertyID", Int64.Type}, 
        {"ListingDate", type date}, 
        {"Bedrooms", Int64.Type}, 
        {"Bathrooms", type number},
        {"SquareFeet", Int64.Type},
        {"MonthlyRent", type number},
        {"MaintenanceCosts", type number}
    }),
    
    // Clean string types
    TrimAndProper = Table.TransformColumns(ChangeTypes, {
        {"PropertyType", each Text.Proper(Text.Trim(_)), type text},
        {"City", each Text.Proper(Text.Trim(_)), type text}
    }),
    
    // Replace null rent
    FilledRent = Table.ReplaceValue(TrimAndProper, null, 0, Replacer.ReplaceValue, {"MonthlyRent"}),
    
    // Absolute maintenance
    AbsoluteMaint = Table.TransformColumns(FilledRent, {
        {"MaintenanceCosts", Number.Abs, type number}
    }),
    
    // Add Price Per Square Foot
    AddPPSQFT = Table.AddColumn(AbsoluteMaint, "RentPerSqFt", each 
        if [SquareFeet] > 0 then [MonthlyRent] / [SquareFeet] else 0, type number
    ),

    // Add Net Operating Income (Monthly)
    AddNOI = Table.AddColumn(AddPPSQFT, "NetMonthlyIncome", each 
        [MonthlyRent] - [MaintenanceCosts], type number
    )
in
    AddNOI

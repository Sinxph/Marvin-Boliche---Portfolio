let
    Source = Csv.Document(File.Contents("C:\Users\m_bol\OneDrive\Desktop\Projects\Financial_Analytics_Project\Raw_Financial_Data.csv"),[Delimiter=",", Columns=8, Encoding=1252, QuoteStyle=QuoteStyle.None]),
    PromoteHeaders = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    ChangeTypes = Table.TransformColumnTypes(PromoteHeaders,{
        {"TransactionID", Int64.Type}, 
        {"Date", type date}, 
        {"Amount", type number}, 
        {"Budget", type number}
    }),
    
    // Clean Text Columns
    TrimAndProper = Table.TransformColumns(ChangeTypes, {
        {"Department", each Text.Proper(Text.Trim(_)), type text},
        {"Type", each Text.Proper(Text.Trim(_)), type text},
        {"Status", each Text.Proper(Text.Trim(_)), type text}
    }),
    
    // Remove exactly duplicated transaction lines
    RemoveDuplicates = Table.Distinct(TrimAndProper),
    
    // Fill null Amounts with 0 to repair calculation chains
    FilledAmount = Table.ReplaceValue(RemoveDuplicates, null, 0, Replacer.ReplaceValue, {"Amount"}),
    
    // Correct Negative Entries utilizing Absolute value mapping
    AbsoluteAmount = Table.TransformColumns(FilledAmount, {
        {"Amount", Number.Abs, type number}
    }),
    
    // Compute Variance (Amount vs Budget) natively in M
    AddVariance = Table.AddColumn(AbsoluteAmount, "Variance", each 
        if [Type] = "Expense" then [Budget] - [Amount] else [Amount] - [Budget], type number
    )
in
    AddVariance

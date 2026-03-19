let
    Source = Csv.Document(File.Contents("C:\Users\m_bol\OneDrive\Desktop\Projects\Healthcare_Analytics_Project\Raw_Health_Data.csv"),[Delimiter=",", Columns=9, Encoding=1252, QuoteStyle=QuoteStyle.None]),
    PromoteHeaders = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    ChangeTypes = Table.TransformColumnTypes(PromoteHeaders,{
        {"ClaimID", Int64.Type}, 
        {"PatientID", Int64.Type}, 
        {"ServiceDate", type date}, 
        {"BilledAmount", type number},
        {"CollectedAmount", type number},
        {"CollectionDate", type date}
    }),
    
    // Clean Text Columns
    TrimAndProper = Table.TransformColumns(ChangeTypes, {
        {"Payer", each Text.Proper(Text.Trim(_)), type text},
        {"ClaimStatus", each Text.Proper(Text.Trim(_)), type text},
        {"DenialReason", each Text.Proper(Text.Trim(_)), type text}
    }),
    
    // Remove exact duplicate claims
    RemoveDuplicates = Table.Distinct(TrimAndProper),
    
    // Fill null BilledAmount with 0 or a median to prevent formula errors
    FilledBilled = Table.ReplaceValue(RemoveDuplicates, null, 0, Replacer.ReplaceValue, {"BilledAmount"}),
    FilledCollected = Table.ReplaceValue(FilledBilled, null, 0, Replacer.ReplaceValue, {"CollectedAmount"}),
    
    // Calculate Days in AR (Accounts Receivable) 
    AddAR = Table.AddColumn(FilledCollected, "DaysInAR", each 
        if [ClaimStatus] = "Paid" and [CollectionDate] <> null 
        then Duration.Days([CollectionDate] - [ServiceDate]) 
        else Duration.Days(DateTime.LocalNow() - DateTime.From([ServiceDate]))
    )
in
    AddAR

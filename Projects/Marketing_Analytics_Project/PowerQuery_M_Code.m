let
    Source = Csv.Document(File.Contents("C:\Users\m_bol\OneDrive\Desktop\Projects\Marketing_Analytics_Project\Raw_Marketing_Data.csv"),[Delimiter=",", Columns=9, Encoding=1252, QuoteStyle=QuoteStyle.None]),
    PromoteHeaders = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    ChangeTypes = Table.TransformColumnTypes(PromoteHeaders,{
        {"CampaignID", Int64.Type}, 
        {"LaunchDate", type date}, 
        {"SpendAmount", type number}, 
        {"Impressions", Int64.Type},
        {"Clicks", Int64.Type},
        {"Conversions", Int64.Type}
    }),
    
    TrimAndProper = Table.TransformColumns(ChangeTypes, {
        {"Channel", each Text.Proper(Text.Trim(_)), type text},
        {"TargetAudience", each Text.Trim(_), type text},
        {"Status", each Text.Proper(Text.Trim(_)), type text}
    }),
    
    RemoveDuplicates = Table.Distinct(TrimAndProper),
    
    FilledSpend = Table.ReplaceValue(RemoveDuplicates, null, 0, Replacer.ReplaceValue, {"SpendAmount"}),
    
    // Add Click-Through Rate (CTR)
    AddCTR = Table.AddColumn(FilledSpend, "CTR", each 
        if [Impressions] > 0 then [Clicks] / [Impressions] else 0, type number
    ),

    // Add Conversion Rate (CVR)
    AddCVR = Table.AddColumn(AddCTR, "CVR", each 
        if [Clicks] > 0 then [Conversions] / [Clicks] else 0, type number
    )
in
    AddCVR

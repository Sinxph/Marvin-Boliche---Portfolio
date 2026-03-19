let
    Source = Csv.Document(File.Contents("C:\Users\m_bol\OneDrive\Desktop\Projects\EcomFunnel_Analytics_Project\Raw_Ecom_Data.csv"),[Delimiter=",", Columns=10, Encoding=1252, QuoteStyle=QuoteStyle.None]),
    PromoteHeaders = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    ChangeTypes = Table.TransformColumnTypes(PromoteHeaders,{
        {"WeekStartDate", type date}, 
        {"AmountSpend", type number}, 
        {"Impressions", Int64.Type}, 
        {"Clicks", Int64.Type},
        {"TotalUsers", Int64.Type},
        {"NewUsers", Int64.Type},
        {"Revenue", type number},
        {"Orders", Int64.Type},
        {"NewCustomers", Int64.Type}
    }),
    
    // Clean Platform Column
    TrimAndProper = Table.TransformColumns(ChangeTypes, {
        {"AdPlatform", each Text.Proper(Text.Trim(_)), type text}
    }),
    
    // Fix Null Spend
    FilledSpend = Table.ReplaceValue(TrimAndProper, null, 0, Replacer.ReplaceValue, {"AmountSpend"}),
    
    // Fix Negative Revenue
    AbsoluteRevenue = Table.TransformColumns(FilledSpend, {
        {"Revenue", Number.Abs, type number}
    }),
    
    // Add CTR (Click Through Rate)
    AddCTR = Table.AddColumn(AbsoluteRevenue, "CTR", each 
        if [Impressions] > 0 then [Clicks] / [Impressions] else 0, type number
    ),

    // Add ROI (Return on Investment %) ((Revenue - Spend) / Spend)
    AddROI = Table.AddColumn(AddCTR, "ROI", each 
        if [AmountSpend] > 0 then ([Revenue] - [AmountSpend]) / [AmountSpend] else null, type number
    ),
    
    // Add Cost Per Order (CPO)
    AddCPO = Table.AddColumn(AddROI, "CostPerOrder", each 
        if [Orders] > 0 then [AmountSpend] / [Orders] else null, type number
    )
in
    AddCPO

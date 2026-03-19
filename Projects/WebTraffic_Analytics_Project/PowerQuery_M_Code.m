let
    Source = Csv.Document(File.Contents("C:\Users\m_bol\OneDrive\Desktop\Projects\WebTraffic_Analytics_Project\Raw_Web_Data.csv"),[Delimiter=",", Columns=9, Encoding=1252, QuoteStyle=QuoteStyle.None]),
    PromoteHeaders = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    ChangeTypes = Table.TransformColumnTypes(PromoteHeaders,{
        {"DataID", Int64.Type}, 
        {"Date", type date}, 
        {"TotalUsers", Int64.Type}, 
        {"NewUsers", Int64.Type},
        {"Sessions", Int64.Type},
        {"Purchases", Int64.Type},
        {"Revenue", type number}
    }),
    
    // Clean Text Columns
    TrimAndProper = Table.TransformColumns(ChangeTypes, {
        {"ChannelGroup", each Text.Proper(Text.Trim(_)), type text},
        {"DeviceCategory", each Text.Proper(Text.Trim(_)), type text}
    }),
    
    // Replace null revenue
    FilledRevenue = Table.ReplaceValue(TrimAndProper, null, 0, Replacer.ReplaceValue, {"Revenue"}),
    
    // Fix absolute value on negative sessions
    AbsoluteSessions = Table.TransformColumns(FilledRevenue, {
        {"Sessions", Number.Abs, Int64.Type}
    }),
    
    // Add Conversion Rate
    AddCVR = Table.AddColumn(AbsoluteSessions, "ConversionRate", each 
        if [Sessions] > 0 then [Purchases] / [Sessions] else 0, type number
    ),

    // Add ARPU (Avg Rev Per User)
    AddARPU = Table.AddColumn(AddCVR, "ARPU", each 
        if [TotalUsers] > 0 then [Revenue] / [TotalUsers] else 0, type number
    )
in
    AddARPU

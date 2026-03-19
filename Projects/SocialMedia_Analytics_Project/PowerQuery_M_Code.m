let
    Source = Csv.Document(File.Contents("C:\Users\m_bol\OneDrive\Desktop\Projects\SocialMedia_Analytics_Project\Raw_Social_Data.csv"),[Delimiter=",", Columns=15, Encoding=1252, QuoteStyle=QuoteStyle.None]),
    PromoteHeaders = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    ChangeTypes = Table.TransformColumnTypes(PromoteHeaders,{
        {"RecordID", Int64.Type}, 
        {"Date", type date}, 
        {"Impressions", Int64.Type}, 
        {"Reach", Int64.Type},
        {"PageViews", Int64.Type},
        {"FollowersGained", Int64.Type},
        {"Engagements", Int64.Type},
        {"PostsPublished", Int64.Type},
        {"VideoViews", Int64.Type},
        {"WatchTimeMins", Int64.Type},
        {"WebUsers", Int64.Type},
        {"Purchases", Int64.Type},
        {"Revenue", type number},
        {"Sessions", Int64.Type}
    }),
    
    // Clean Platform names
    TrimAndProper = Table.TransformColumns(ChangeTypes, {
        {"Platform", each Text.Proper(Text.Trim(_)), type text}
    }),
    
    // Fill null Revenue with 0
    FilledRevenue = Table.ReplaceValue(TrimAndProper, null, 0, Replacer.ReplaceValue, {"Revenue"}),
    
    // Fix negative impressions
    AbsoluteImpressions = Table.TransformColumns(FilledRevenue, {
        {"Impressions", Number.Abs, Int64.Type}
    }),
    
    // Add Engagement Rate column (%)
    AddEngagementRate = Table.AddColumn(AbsoluteImpressions, "EngagementRate", each 
        if [Impressions] > 0 then [Engagements] / [Impressions] else 0, type number
    ),

    // Add Session Engagement Rate (Purchases per Session)
    AddSessionEngRate = Table.AddColumn(AddEngagementRate, "SessionEngRate", each 
        if [Sessions] > 0 then [Purchases] / [Sessions] else 0, type number
    )
in
    AddSessionEngRate

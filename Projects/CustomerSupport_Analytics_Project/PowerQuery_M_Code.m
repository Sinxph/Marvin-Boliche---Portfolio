let
    Source = Csv.Document(File.Contents("C:\Users\m_bol\OneDrive\Desktop\Projects\CustomerSupport_Analytics_Project\Raw_Support_Data.csv"),[Delimiter=",", Columns=8, Encoding=1252, QuoteStyle=QuoteStyle.None]),
    PromoteHeaders = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    ChangeTypes = Table.TransformColumnTypes(PromoteHeaders,{
        {"TicketID", Int64.Type}, 
        {"DateOpened", type date}, 
        {"DateClosed", type date}, 
        {"ResolutionTimeHrs", type number},
        {"CSAT_Score", Int64.Type}
    }),
    
    // Clean text categories
    TrimAndProper = Table.TransformColumns(ChangeTypes, {
        {"Category", each Text.Proper(Text.Trim(_)), type text},
        {"Priority", each Text.Proper(Text.Trim(_)), type text}
    }),
    
    // Fix Negative Resolution Times by utilizing Absolute functions
    AbsoluteResolution = Table.TransformColumns(TrimAndProper, {
        {"ResolutionTimeHrs", Number.Abs, type number}
    }),
    
    // Add IsClosed Boolean flag
    AddIsClosed = Table.AddColumn(AbsoluteResolution, "IsClosed", each 
        if [DateClosed] <> null then "Yes" else "No", type text
    ),
    
    // Fill missing CSAT for closed tickets with a baseline 3 to avoid measure breaking
    FillCSAT = Table.ReplaceValue(AddIsClosed, null, each if [DateClosed] <> null then 3 else null, Replacer.ReplaceValue, {"CSAT_Score"})
in
    FillCSAT

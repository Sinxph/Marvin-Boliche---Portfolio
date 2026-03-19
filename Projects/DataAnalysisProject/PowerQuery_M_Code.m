let
    // 1. Load the raw CSV data
    Source = Csv.Document(File.Contents("C:\Users\m_bol\OneDrive\Desktop\Projects\DataAnalysisProject\Raw_Sales_Data.csv"),[Delimiter=",", Columns=9, Encoding=1252, QuoteStyle=QuoteStyle.None]),
    
    // 2. Promote the first row as headers
    PromotedHeaders = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    
    // 3. Change Data Types
    ChangedTypes = Table.TransformColumnTypes(PromotedHeaders,{
        {"OrderID", Int64.Type}, 
        {"Date", type date}, 
        {"CustomerName", type text}, 
        {"Product", type text}, 
        {"Category", type text}, 
        {"Quantity", Int64.Type}, 
        {"UnitPrice", type number}, 
        {"Revenue", type number}, 
        {"Region", type text}
    }),
    
    // 4. Remove duplicate rows (e.g. OrderID 1002 is duplicated)
    RemovedDuplicates = Table.Distinct(ChangedTypes),
    
    // 5. Clean Text Columns: Trim leading/trailing whitespace and capitalize each word
    TrimmedText = Table.TransformColumns(RemovedDuplicates, {
        {"CustomerName", Text.Trim, type text},
        {"Category", Text.Trim, type text},
        {"Region", Text.Trim, type text}
    }),
    CapitalizedText = Table.TransformColumns(TrimmedText, {
        {"CustomerName", Text.Proper, type text},
        {"Category", Text.Proper, type text},
        {"Region", Text.Proper, type text}
    }),

    // 6. Handle missing or error Revenue values 
    // Fill null Revenue by multiplying Quantity * UnitPrice if applicable
    AddedCustomRevenue = Table.AddColumn(CapitalizedText, "CleanedRevenue", each if [Revenue] = null or [Revenue] <= 0 then [Quantity] * [UnitPrice] else [Revenue], type number),
    
    // Remove the old Revenue column and rename the new one
    RemovedOldRevenue = Table.RemoveColumns(AddedCustomRevenue,{"Revenue"}),
    RenamedRevenue = Table.RenameColumns(RemovedOldRevenue,{{"CleanedRevenue", "Revenue"}}),

    // 7. Filter out invalid quantities (e.g., negative quantities like -1)
    FilteredRows = Table.SelectRows(RenamedRevenue, each [Quantity] > 0)
in
    FilteredRows

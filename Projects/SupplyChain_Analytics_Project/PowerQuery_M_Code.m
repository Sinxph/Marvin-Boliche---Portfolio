let
    Source = Csv.Document(File.Contents("C:\Users\m_bol\OneDrive\Desktop\Projects\SupplyChain_Analytics_Project\Raw_SupplyChain_Data.csv"),[Delimiter=",", Columns=9, Encoding=1252, QuoteStyle=QuoteStyle.None]),
    PromoteHeaders = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    ChangeTypes = Table.TransformColumnTypes(PromoteHeaders,{
        {"ProductID", Int64.Type}, 
        {"OrderDate", type date}, 
        {"DeliveryDate", type date}, 
        {"QuantityOrdered", Int64.Type},
        {"QuantityReceived", Int64.Type},
        {"UnitCost", type number}
    }),
    
    TrimAndProper = Table.TransformColumns(ChangeTypes, {
        {"Supplier", each Text.Proper(Text.Trim(_)), type text},
        {"WarehouseLocation", each Text.Proper(Text.Trim(_)), type text},
        {"Status", each Text.Proper(Text.Trim(_)), type text}
    }),
    
    RemoveDuplicates = Table.Distinct(TrimAndProper),
    
    FilledCost = Table.ReplaceValue(RemoveDuplicates, null, 0, Replacer.ReplaceValue, {"UnitCost"}),
    
    // Calculate Inventory Value
    AddInventoryValue = Table.AddColumn(FilledCost, "TotalValue", each 
        [QuantityReceived] * [UnitCost], type number
    ),

    // Calculate Lead Time in Days
    AddLeadTime = Table.AddColumn(AddInventoryValue, "LeadTimeDays", each 
        if [Status] = "Delivered" and [DeliveryDate] <> null 
        then Duration.Days([DeliveryDate] - [OrderDate]) 
        else null, Int64.Type
    ),

    // Flag Short Shipments
    AddShortShipFlag = Table.AddColumn(AddLeadTime, "ShortShipment", each 
        if [Status] = "Delivered" and [QuantityReceived] < [QuantityOrdered] then "Yes" else "No", type text
    )
in
    AddShortShipFlag

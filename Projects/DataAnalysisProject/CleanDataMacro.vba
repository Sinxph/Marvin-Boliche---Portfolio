Sub FormatSalesData()
    ' This macro applies formatting to the Raw_Sales_Data table 
    ' to make it more presentable before or after analysis.
    
    Dim ws As Worksheet
    Set ws = ActiveSheet
    
    ' 1. Freeze the top row
    With ActiveWindow
        .SplitColumn = 0
        .SplitRow = 1
        .FreezePanes = True
    End With
    
    ' 2. Format headers
    With ws.Range("A1", ws.Cells(1, ws.Columns.Count).End(xlToLeft))
        .Font.Bold = True
        .Interior.Color = RGB(0, 112, 192) ' Blue Header
        .Font.Color = RGB(255, 255, 255) ' White Text
        .HorizontalAlignment = xlCenter
    End With
    
    ' 3. Auto-fit columns
    ws.Cells.EntireColumn.AutoFit
    
    ' 4. Format Revenue and Unit Price columns to Currency
    Dim lastRow As Long
    lastRow = ws.Cells(ws.Rows.Count, "A").End(xlUp).Row
    
    ' Assuming UnitPrice is column G and Revenue is column H
    ws.Range("G2:H" & lastRow).NumberFormat = "$#,##0.00"
    
    ' 5. Add Borders
    ws.Range("A1:I" & lastRow).Borders.LineStyle = xlContinuous

    MsgBox "Data Formatting Complete!", vbInformation, "Macro Executed"
End Sub

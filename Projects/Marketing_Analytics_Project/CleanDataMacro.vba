Sub FormatMarketingData()
    ' VBA Macro to format the Marketing dataset
    Dim ws As Worksheet
    Set ws = ActiveSheet
    
    ActiveWindow.SplitRow = 1
    ActiveWindow.FreezePanes = True
    
    ' Header Formatting (Vibrant Orange theme for Marketing)
    With ws.Range("A1", ws.Cells(1, ws.Columns.Count).End(xlToLeft))
        .Font.Bold = True
        .Interior.Color = RGB(249, 115, 22) ' Vibrant Orange
        .Font.Color = RGB(255, 255, 255)
        .HorizontalAlignment = xlCenter
    End With
    
    ws.Cells.EntireColumn.AutoFit
    
    Dim lastRow As Long
    lastRow = ws.Cells(ws.Rows.Count, "A").End(xlUp).Row
    
    ' Spend Column (Assume E)
    ws.Range("E2:E" & lastRow).NumberFormat = "$#,##0.00"
    
    ' Number Formats for Impressions, Clicks, Conversions (F, G, H)
    ws.Range("F2:H" & lastRow).NumberFormat = "#,##0"
    
    ' Conditional Formatting for 'Active' vs 'Paused' campaigns
    Dim statCol As Integer
    statCol = 9 ' Status
    
    Dim i As Long
    For i = 2 To lastRow
        If UCase(Trim(ws.Cells(i, statCol).Value)) = "ACTIVE" Then
            ws.Cells(i, statCol).Font.Color = RGB(21, 128, 61) ' Green
            ws.Cells(i, statCol).Font.Bold = True
        ElseIf UCase(Trim(ws.Cells(i, statCol).Value)) = "PAUSED" Then
            ws.Cells(i, statCol).Font.Color = RGB(156, 163, 175) ' Gray
        End If
    Next i
    
    MsgBox "Marketing Data Formatting Complete!", vbInformation
End Sub

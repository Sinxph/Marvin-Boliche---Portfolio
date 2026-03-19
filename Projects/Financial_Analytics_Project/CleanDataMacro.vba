Sub FormatFinancialData()
    ' VBA Macro to format the Financial dataset
    Dim ws As Worksheet
    Set ws = ActiveSheet
    
    ActiveWindow.SplitRow = 1
    ActiveWindow.FreezePanes = True
    
    ' Header Formatting (Emerald Green theme for Finance)
    With ws.Range("A1", ws.Cells(1, ws.Columns.Count).End(xlToLeft))
        .Font.Bold = True
        .Interior.Color = RGB(16, 185, 129) ' Emerald
        .Font.Color = RGB(255, 255, 255)
        .HorizontalAlignment = xlCenter
    End With
    
    ws.Cells.EntireColumn.AutoFit
    
    Dim lastRow As Long
    lastRow = ws.Cells(ws.Rows.Count, "A").End(xlUp).Row
    
    ' Amount and Budget Columns (Assume E & F)
    ws.Range("E2:F" & lastRow).NumberFormat = "$#,##0.00"
    
    ' Highlight Negative Amounts in Red (Accounting syntax)
    Dim i As Long
    For i = 2 To lastRow
        If IsNumeric(ws.Cells(i, 5).Value) Then
            If ws.Cells(i, 5).Value < 0 Then
                ws.Cells(i, 5).Font.Color = RGB(220, 38, 38) ' Red
                ws.Cells(i, 5).Value = Abs(ws.Cells(i, 5).Value) ' Clean negatives visually assuming error
            End If
        End If
    Next i
    
    MsgBox "Financial Data Formatting Complete!", vbInformation
End Sub

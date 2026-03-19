Sub FormatWebTrafficData()
    ' VBA Macro to format the Web Traffic dataset
    Dim ws As Worksheet
    Set ws = ActiveSheet
    
    ActiveWindow.SplitRow = 1
    ActiveWindow.FreezePanes = True
    
    ' Header Formatting (Teal/Blue from Web Dashboard Screenshot)
    With ws.Range("A1", ws.Cells(1, ws.Columns.Count).End(xlToLeft))
        .Font.Bold = True
        .Interior.Color = RGB(2, 132, 199) ' Light Blue (#0284c7)
        .Font.Color = RGB(255, 255, 255)
        .HorizontalAlignment = xlCenter
    End With
    
    ws.Cells.EntireColumn.AutoFit
    
    Dim lastRow As Long
    lastRow = ws.Cells(ws.Rows.Count, "A").End(xlUp).Row
    
    ' Format Revenue (Column I)
    ws.Range("I2:I" & lastRow).NumberFormat = "$#,##0.00"
    
    ' Format Users & Sessions with comma separator
    ws.Range("E2:G" & lastRow).NumberFormat = "#,##0"
    
    ' Conditional Formatting for 0 purchases (Flag as Warning)
    Dim purCol As Integer
    purCol = 8 ' Purchases
    
    Dim i As Long
    For i = 2 To lastRow
        If IsNumeric(ws.Cells(i, purCol).Value) Then
            If ws.Cells(i, purCol).Value = 0 Then
                ws.Cells(i, purCol).Font.Color = RGB(156, 163, 175) ' Gray text for 0
            End If
        End If
        
        ' Flag negative sessions (error)
        If IsNumeric(ws.Cells(i, 7).Value) Then
            If ws.Cells(i, 7).Value < 0 Then
                ws.Cells(i, 7).Interior.Color = RGB(254, 202, 202) ' Light red bg
            End If
        End If
    Next i
    
    MsgBox "Web Traffic Data Formatting Complete!", vbInformation
End Sub

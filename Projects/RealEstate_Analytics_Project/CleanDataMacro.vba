Sub FormatRealEstateData()
    ' VBA Macro to format the Real Estate dataset
    Dim ws As Worksheet
    Set ws = ActiveSheet
    
    ActiveWindow.SplitRow = 1
    ActiveWindow.FreezePanes = True
    
    ' Header Formatting (Teal Theme)
    With ws.Range("A1", ws.Cells(1, ws.Columns.Count).End(xlToLeft))
        .Font.Bold = True
        .Interior.Color = RGB(15, 118, 110) ' Teal (#0f766e)
        .Font.Color = RGB(255, 255, 255)
        .HorizontalAlignment = xlCenter
    End With
    
    ws.Cells.EntireColumn.AutoFit
    
    Dim lastRow As Long
    lastRow = ws.Cells(ws.Rows.Count, "A").End(xlUp).Row
    
    ' Format Currency Columns (Rent H, Maintenance I)
    ws.Range("H2:I" & lastRow).NumberFormat = "$#,##0.00"
    
    ' Format SqFt
    ws.Range("G2:G" & lastRow).NumberFormat = "#,##0"
    
    ' Highlight Logic
    Dim i As Long
    For i = 2 To lastRow
        ' Flag negative maintenance (error)
        If IsNumeric(ws.Cells(i, 9).Value) Then
            If ws.Cells(i, 9).Value < 0 Then
                ws.Cells(i, 9).Interior.Color = RGB(254, 202, 202) ' Light red bg
            End If
        End If
        
        ' Highlight Churn Risk (Tenant leaving)
        If UCase(Trim(ws.Cells(i, 11).Value)) = "YES" Then
            ws.Cells(i, 11).Interior.Color = RGB(254, 240, 138) ' Yellow Warning
        End If
    Next i
    
    MsgBox "Real Estate Data Formatting Complete!", vbInformation
End Sub

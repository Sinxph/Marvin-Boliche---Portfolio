Sub FormatHealthData()
    ' VBA Macro to format the Healthcare dataset
    Dim ws As Worksheet
    Set ws = ActiveSheet
    
    ActiveWindow.SplitRow = 1
    ActiveWindow.FreezePanes = True
    
    ' Header Formatting (Forest Green theme for Healthcare)
    With ws.Range("A1", ws.Cells(1, ws.Columns.Count).End(xlToLeft))
        .Font.Bold = True
        .Interior.Color = RGB(6, 78, 59) ' Dark Green
        .Font.Color = RGB(255, 255, 255)
        .HorizontalAlignment = xlCenter
    End With
    
    ws.Cells.EntireColumn.AutoFit
    
    Dim lastRow As Long
    lastRow = ws.Cells(ws.Rows.Count, "A").End(xlUp).Row
    
    ' Billed and Collected Columns (Assume D & E)
    ws.Range("D2:E" & lastRow).NumberFormat = "$#,##0.00"
    
    ' Highlight Denied claims
    Dim statCol As Integer
    statCol = 8 ' ClaimStatus
    
    Dim i As Long
    For i = 2 To lastRow
        If UCase(Trim(ws.Cells(i, statCol).Value)) = "DENIED" Then
            ws.Cells(i, statCol).Font.Color = RGB(220, 38, 38) ' Red
            ws.Cells(i, statCol).Font.Bold = True
        ElseIf UCase(Trim(ws.Cells(i, statCol).Value)) = "PAID" Then
            ws.Cells(i, statCol).Font.Color = RGB(5, 150, 105) ' Green
        End If
    Next i
    
    MsgBox "Healthcare Data Formatting Complete!", vbInformation
End Sub

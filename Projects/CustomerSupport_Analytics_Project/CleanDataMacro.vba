Sub FormatSupportData()
    ' VBA Macro to format the Customer Support dataset
    Dim ws As Worksheet
    Set ws = ActiveSheet
    
    ActiveWindow.SplitRow = 1
    ActiveWindow.FreezePanes = True
    
    ' Header Formatting (Amber/Orange Theme from Support aesthetic)
    With ws.Range("A1", ws.Cells(1, ws.Columns.Count).End(xlToLeft))
        .Font.Bold = True
        .Interior.Color = RGB(245, 158, 11) ' Amber (#f59e0b)
        .Font.Color = RGB(255, 255, 255)
        .HorizontalAlignment = xlCenter
    End With
    
    ws.Cells.EntireColumn.AutoFit
    
    Dim lastRow As Long
    lastRow = ws.Cells(ws.Rows.Count, "A").End(xlUp).Row
    
    ' Highlight Priorities
    Dim prioCol As Integer
    prioCol = 5 ' Priority
    
    Dim i As Long
    For i = 2 To lastRow
        ' Flag Urgent Priorities in Red
        If UCase(Trim(ws.Cells(i, prioCol).Value)) = "URGENT" Then
            ws.Cells(i, prioCol).Font.Color = RGB(239, 68, 68) ' Red font
            ws.Cells(i, prioCol).Font.Bold = True
        End If
        
        ' Flag negative resolution times (error)
        If IsNumeric(ws.Cells(i, 7).Value) Then
            If ws.Cells(i, 7).Value < 0 Then
                ws.Cells(i, 7).Interior.Color = RGB(254, 202, 202) ' Light red bg
            End If
        End If
        
        ' Highlight missing CSAT for closed tickets (Warning)
        If Trim(ws.Cells(i, 3).Value) <> "" And Trim(ws.Cells(i, 8).Value) = "" Then
            ws.Cells(i, 8).Interior.Color = RGB(254, 240, 138) ' Yellow Warning
        End If
    Next i
    
    MsgBox "Customer Support Data Formatting Complete!", vbInformation
End Sub

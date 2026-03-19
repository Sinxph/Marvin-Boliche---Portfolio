Sub FormatHRData()
    ' VBA Macro to format the HR Employee dataset
    Dim ws As Worksheet
    Set ws = ActiveSheet
    
    ' Freeze Top Row
    ActiveWindow.SplitRow = 1
    ActiveWindow.FreezePanes = True
    
    ' Header Formatting (Purple theme for HR)
    With ws.Range("A1", ws.Cells(1, ws.Columns.Count).End(xlToLeft))
        .Font.Bold = True
        .Interior.Color = RGB(112, 48, 160) ' Purple
        .Font.Color = RGB(255, 255, 255)
        .HorizontalAlignment = xlCenter
    End With
    
    ' AutoFit
    ws.Cells.EntireColumn.AutoFit
    
    ' Highlight Attrition column (Red text for 'Yes')
    Dim lastRow As Long
    lastRow = ws.Cells(ws.Rows.Count, "A").End(xlUp).Row
    Dim attrCol As Integer
    ' Assuming Attrition is column K (11)
    attrCol = 11
    
    Dim i As Long
    For i = 2 To lastRow
        If UCase(Trim(ws.Cells(i, attrCol).Value)) = "YES" Then
            ws.Cells(i, attrCol).Font.Color = RGB(255, 0, 0)
            ws.Cells(i, attrCol).Font.Bold = True
        End If
    Next i
    
    MsgBox "HR Data Formatting Complete!", vbInformation
End Sub

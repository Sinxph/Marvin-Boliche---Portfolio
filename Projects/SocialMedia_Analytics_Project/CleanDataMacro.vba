Sub FormatSocialMediaData()
    ' VBA Macro to format the Social Media dataset
    Dim ws As Worksheet
    Set ws = ActiveSheet
    
    ActiveWindow.SplitRow = 1
    ActiveWindow.FreezePanes = True
    
    ' Header Formatting (Indigo Theme from Dashboard Screenshot)
    With ws.Range("A1", ws.Cells(1, ws.Columns.Count).End(xlToLeft))
        .Font.Bold = True
        .Interior.Color = RGB(79, 70, 229) ' Indigo-600 (#4f46e5)
        .Font.Color = RGB(255, 255, 255)
        .HorizontalAlignment = xlCenter
    End With
    
    ws.Cells.EntireColumn.AutoFit
    
    Dim lastRow As Long
    lastRow = ws.Cells(ws.Rows.Count, "A").End(xlUp).Row
    
    ' Format Revenue (Column N)
    ws.Range("N2:N" & lastRow).NumberFormat = "$#,##0.00"
    
    ' Format Number metrics with comma separator
    ws.Range("D2:L" & lastRow).NumberFormat = "#,##0"
    ws.Range("O2:O" & lastRow).NumberFormat = "#,##0"
    
    ' Conditional Formatting for high engagement (>2000 engagements)
    Dim engCol As Integer
    engCol = 8 ' Engagements
    
    Dim i As Long
    For i = 2 To lastRow
        If IsNumeric(ws.Cells(i, engCol).Value) Then
            If ws.Cells(i, engCol).Value > 2000 Then
                ws.Cells(i, engCol).Font.Color = RGB(16, 185, 129) ' Emerald green text
                ws.Cells(i, engCol).Font.Bold = True
            End If
        End If
        
        ' Flag negative impressions (error)
        If IsNumeric(ws.Cells(i, 4).Value) Then
            If ws.Cells(i, 4).Value < 0 Then
                ws.Cells(i, 4).Interior.Color = RGB(254, 202, 202) ' Light red bg
            End If
        End If
    Next i
    
    MsgBox "Social Media Data Formatting Complete!", vbInformation
End Sub

Sub FormatEcomFunnelData()
    ' VBA Macro to format the E-Commerce Funnel dataset
    Dim ws As Worksheet
    Set ws = ActiveSheet
    
    ActiveWindow.SplitRow = 1
    ActiveWindow.FreezePanes = True
    
    ' Header Formatting (Dark Blue/Purple Theme from Ecom Dashboard Screenshot)
    With ws.Range("A1", ws.Cells(1, ws.Columns.Count).End(xlToLeft))
        .Font.Bold = True
        .Interior.Color = RGB(30, 64, 175) ' Dark Blue (#1e40af)
        .Font.Color = RGB(255, 255, 255)
        .HorizontalAlignment = xlCenter
    End With
    
    ws.Cells.EntireColumn.AutoFit
    
    Dim lastRow As Long
    lastRow = ws.Cells(ws.Rows.Count, "A").End(xlUp).Row
    
    ' Format Currency Columns (Spend C, Revenue H)
    ws.Range("C2:C" & lastRow).NumberFormat = "$#,##0.00"
    ws.Range("H2:H" & lastRow).NumberFormat = "$#,##0.00"
    
    ' Number Formats 
    ws.Range("D2:G" & lastRow).NumberFormat = "#,##0"
    ws.Range("I2:J" & lastRow).NumberFormat = "#,##0"
    
    ' Highlight ROI outliers or Negative Revenue
    Dim i As Long
    For i = 2 To lastRow
        ' Flag negative revenue (error)
        If IsNumeric(ws.Cells(i, 8).Value) Then
            If ws.Cells(i, 8).Value < 0 Then
                ws.Cells(i, 8).Interior.Color = RGB(254, 202, 202) ' Light red bg
            End If
        End If
        
        ' Flag zero orders on high spend
        If IsNumeric(ws.Cells(i, 9).Value) And IsNumeric(ws.Cells(i, 3).Value) Then
            If ws.Cells(i, 9).Value = 0 And ws.Cells(i, 3).Value > 1000 Then
                ws.Cells(i, 9).Interior.Color = RGB(254, 240, 138) ' Yellow Warning
            End If
        End If
    Next i
    
    MsgBox "Ecom Funnel Data Formatting Complete!", vbInformation
End Sub

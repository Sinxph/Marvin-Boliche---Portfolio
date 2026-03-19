Sub FormatSupplyChainData()
    ' VBA Macro to format the Supply Chain dataset
    Dim ws As Worksheet
    Set ws = ActiveSheet
    
    ActiveWindow.SplitRow = 1
    ActiveWindow.FreezePanes = True
    
    ' Header Formatting (Industrial Navy Blue Theme)
    With ws.Range("A1", ws.Cells(1, ws.Columns.Count).End(xlToLeft))
        .Font.Bold = True
        .Interior.Color = RGB(30, 58, 138) ' Navy blue
        .Font.Color = RGB(255, 255, 255)
        .HorizontalAlignment = xlCenter
    End With
    
    ws.Cells.EntireColumn.AutoFit
    
    Dim lastRow As Long
    lastRow = ws.Cells(ws.Rows.Count, "A").End(xlUp).Row
    
    ' Unit Cost Column (Assume H)
    ws.Range("H2:H" & lastRow).NumberFormat = "$#,##0.00"
    
    ' Highlight Delayed shipments and partial shipments
    Dim statCol As Integer
    statCol = 9 ' Status
    
    Dim i As Long
    For i = 2 To lastRow
        If UCase(Trim(ws.Cells(i, statCol).Value)) = "DELAYED" Then
            ws.Cells(i, statCol).Font.Color = RGB(220, 38, 38) ' Red
            ws.Cells(i, statCol).Font.Bold = True
        End If
        
        ' Check partial shipment if Delivered (Assume Delivered, QtyOrdered F, QtyReceived G)
        If UCase(Trim(ws.Cells(i, statCol).Value)) = "DELIVERED" Then
            If Val(ws.Cells(i, 6).Value) > Val(ws.Cells(i, 7).Value) Then
                ws.Cells(i, 7).Interior.Color = RGB(254, 240, 138) ' Yellow warning background
            End If
        End If
    Next i
    
    MsgBox "Supply Chain Data Formatting Complete!", vbInformation
End Sub

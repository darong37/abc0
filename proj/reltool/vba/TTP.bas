Attribute VB_Name = "TTP"
Option Explicit

Sub TTPSend_test()
  Call TTPSend("cd " & getRmtDir(), False)
End Sub

Sub TTPSend(cmd As String, Optional ByVal swSync As Boolean = True)
  On Error GoTo ErrProc
  
  Dim Opt As String
  Opt = getHostName(",") & getUserName(",") & getPassword(",") & getLogFile(",") & getMode() _
  & " " & """" & cmd & """"
  Call logDebug("Opt", Opt)

  Dim oShell As Object
  Set oShell = CreateObject("WScript.Shell")
  
  Dim ttpLine As String
  If getMode() = "DEBUG" Then
    ttpLine = """" & getTTPMacroExe() & """ " & getTTPMacroTTL() & " " & Opt
  Else
    ttpLine = """" & getTTPMacroExe() & """ /V " & getTTPMacroTTL() & " " & Opt
  End If
  Call logDebug("ttpLine", ttpLine)
  
  'TeraTermPro起動
  Call logWrite("TeraTermPro起動 - ロギング開始")
  Dim rtn As Integer
  rtn = oShell.run(ttpLine, 1, swSync)
  Call logWrite("TeraTermPro終了 - ロギング終了")
  Set oShell = Nothing
  If rtn <> 0 Then
    Err.Raise 513, "TeraTerm Macro", "マクロの異常終了 ( rtn : " & rtn & " )"
  End If
  
  '終了
  Exit Sub
  
ErrProc:
  Err.Source = "TTP.TTPSend"
  Call ForcedExit(Err)
End Sub

Sub TTP_Release(opr As String)
  On Error GoTo ErrProc
  
    Dim cmdLine As String
    cmdLine = getRmtShell() & " " _
            & opr & " " _
            & getSID()
    Call logDebug("cmdLine", cmdLine)
            
    Call TTPSend(cmdLine)
  
  '終了
  Exit Sub
  
ErrProc:
  Err.Source = "TTP.TTPSend"
  Call ForcedExit(Err)
End Sub

Sub TTP_Result()
  On Error GoTo ErrProc

  Dim fd As Integer
  Dim strLine As String
  
  fd = FreeFile
  Open getLocalDir("\") & getResultFileName() For Input As fd
  Do Until (EOF(fd))
    Line Input #fd, strLine
    
    Dim ary() As String
    ary = Split(strLine, vbTab)
    Dim i As Integer
    For i = 0 To UBound(ary)
      ActiveCell.Offset(0, i).value = ary(i)
    Next i
    ActiveCell.Offset(1, 0).Activate
  Loop
  Close #fd
  Kill getLocalDir("\") & getResultFileName()
  
  '終了
  Exit Sub
ErrProc:
  Err.Source = "TTP.TTP_Result"
  Call ForcedExit(Err)
End Sub


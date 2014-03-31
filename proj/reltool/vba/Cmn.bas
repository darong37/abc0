Attribute VB_Name = "Cmn"
Option Explicit

Public Declare Sub Sleep Lib "kernel32" (ByVal dwMilliseconds As Long)

Sub touch(fln As String)
  Dim fd As Integer
  fd = FreeFile
  Open fln For Output As #fd
  Close #fd
End Sub

Function exists(ByVal fln As String) As Boolean
  If dir(fln) <> "" Then
    exists = True
  Else
    exists = False
  End If
End Function

Sub rm(fln As String)
  If exists(fln) Then
    Kill fln
  End If
End Sub

Sub logWriteTest()
  logWrite ("hoge")
  logDebug ("fuga")
End Sub

Function logFmt(mlevel As String) As String
  logFmt = Format(Now(), "hh:nn:ss ")
  logFmt = logFmt & Format(mlevel, "!@@@@@ ")
  logFmt = logFmt & "[EXCEL] "
End Function

Sub ForcedExit(e As Object)
  MsgBox "予期しないエラーが発生しました。強制的に終了します。" & vbCr & _
         "管理者にお知らせください" & vbCr & _
         "Number : " & e.Number & vbCr & _
         "Source : " & e.Source & vbCr & _
         "Description : " & e.Description, _
         vbCritical, _
         "システムエラー"

  Call リリースシート.FTP転送ボタン(True)
  Call リリースシート.リリースボタン(False)
  End
End Sub

Sub ErrorExit(msg As String)
  MsgBox msg, vbCritical, "異常終了"
  
  Call リリースシート.FTP転送ボタン(True)
  Call リリースシート.リリースボタン(False)
  End
End Sub


Sub logWrite(ByVal msg As String)
  On Error GoTo ErrProc
  
  Dim fd As Integer
  fd = FreeFile
  Open getLogFile() For Append As #fd
  Print #fd, logFmt("INFO") & msg
  Close #fd
  
  '終了
  Exit Sub
  
ErrProc:
  Err.Source = "Cmn.logWrite"
  Call ForcedExit(Err)
End Sub

Sub logCat(ByVal fln As String)
  On Error GoTo ErrProc
  Dim fd As Integer
  fd = FreeFile
  Open fln For Input As #fd
  
  Dim fd2 As Integer
  fd2 = FreeFile
  Open getLogFile() For Append As #fd2
  
  Dim msg As String
  Do Until EOF(fd)
    Line Input #fd, msg
    Print #fd2, msg
  Loop
  Close #fd
  Close #fd2
  
  '終了
  Exit Sub
  
ErrProc:
  Err.Source = "Cmn.logCat"
  Call ForcedExit(Err)
End Sub

Sub logDebug(ByVal label As String, ByVal msg As String)
  On Error GoTo ErrProc
  If getMode() = "DEBUG" Then
    Dim fd As Integer
    fd = FreeFile
    Open getLogFile() For Append As #fd
    Print #fd, logFmt("DEBUG") & Format(label, "!@@@@@@@@@@@@@: ") & msg
    Close #fd
  End If
  
  '終了
  Exit Sub
  
ErrProc:
  Err.Source = "Cmn.logDebug"
  Call ForcedExit(Err)
End Sub


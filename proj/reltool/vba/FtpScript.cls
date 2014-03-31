VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "FtpScript"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Public Server As String
Public User As String
Public Password As String
Public Localdir As String
Public RemoteDir As String

Private script As String

Private fd As Integer


Sub init()
  On Error GoTo ErrProc
    
    script = getFtpScript()
    
    fd = FreeFile
    Close #fd
    Open script For Output As #fd
    Print #fd, "open " & Server
    Print #fd, "user " & User & " " & Password
    If Localdir <> "" Then
      Print #fd, "lcd " & Localdir
    End If
    If RemoteDir <> "" Then
      Print #fd, "cd " & RemoteDir
    End If
    Print #fd, "ascii"
  
  '終了
  Exit Sub
  
ErrProc:
  Err.Source = "FtpScript.init"
  Call ForcedExit(Err)
    
End Sub

Sub ascii()
    Print #fd, "ascii"
End Sub

Sub bin()
    Print #fd, "binary"
End Sub

Sub cd(ByVal dir As String)
    Print #fd, "cd " & dir
    Print #fd, "pwd"
End Sub

Sub lcd(ByVal dir As String)
    Print #fd, "lcd " & dir
End Sub

Sub pwd()
    Print #fd, "pwd"
End Sub

Sub ls(Optional ByVal fln As String = "")
    Print #fd, "ls " & fln
End Sub

Sub dir(Optional ByVal fln As String = "")
    Print #fd, "dir " & fln
End Sub

Sub download(ByVal fln As String)
    Print #fd, "get " & fln
End Sub

Sub upload(ByVal fln As String)
    Print #fd, "put " & fln
End Sub

Sub run()
  On Error GoTo ErrProc
    Print #fd, "disconnect"
    Print #fd, "bye"
    Close #fd
    
    '
    Dim EXECMD As String
    Dim oShell As Object
    
    EXECMD = "cmd /C ftp -n -s:" & script & " >> " & getLogFile
    Set oShell = CreateObject("WScript.Shell")
    
    Dim rts As Integer
    Dim rpt As Integer
    
    'FTP開始
    Call logWrite("FTP起動 - ロギング開始")
    For rpt = 0 To 2
      rts = oShell.run(EXECMD, 0, True)
      If rts = 0 Then
        Call logWrite("WScript.shell起動成功")
        Exit For
      Else
        Call logWrite("WScript.shell起動失敗 - リトライ後成功すれば問題ありません")
        'MsgBox rts
        Call Sleep(1000)
      End If
    Next
    Call logWrite("FTP終了 - ロギング終了")

    Set oShell = Nothing
  
  '終了
  Exit Sub
  
ErrProc:
  Err.Source = "FtpScript.run"
  Call ForcedExit(Err)
        
End Sub

Sub cls()
  Close #fd
End Sub



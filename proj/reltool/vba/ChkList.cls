VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ChkList"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Public Localdir As String
Public ListName As String

Private fd As Integer

Sub init()
    On Error GoTo ErrProc
    '
    
    fd = FreeFile
    Close #fd
    Open Localdir & "\" & ListName For Output As #fd
    Print #fd, "##ENVNAM:" & getEnvName()
    Print #fd, "##SID:" & getSID()
    Print #fd, "##RECOMP:" & getRecompOpt()
    Print #fd, "##SRVCOD:" & getServerCode()
    Print #fd, "##RESULT:" & getResultFileName()
    Print #fd, "##REPORT:" & getReportFileName()
  
    '終了
    Exit Sub
  
ErrProc:
    Err.Source = "ChkList.init"
    Call ForcedExit(Err)
End Sub

Function record(ByVal fln As String, ByVal typ As Integer, ByVal schema As String) As Integer
    On Error GoTo ErrProc
    '
    Dim siz As Long
    If dir(Localdir & "\" & fln) = "" Then
        Call logWrite(fln & " が見つかりません。 " & Localdir & " 内を確認してください")
        MsgBox fln & " が見つかりません。 " & vbCrLf & Localdir & " 内を確認してください"
        siz = -1
        record = 0
    Else
        siz = FileLen(Localdir & "\" & fln)
        record = 1
    End If

    Print #fd, fln & vbTab & siz & vbTab & typ & vbTab & schema
    '終了
    Exit Function
  
ErrProc:
    Err.Source = "ChkList.init"
    Call ForcedExit(Err)
End Function

Sub fin()
    Close #fd
End Sub

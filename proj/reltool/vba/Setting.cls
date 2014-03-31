VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "環境設定"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit


Private Sub Worksheet_Activate()
    Range("E20").value = ThisWorkbook.path
End Sub

Private Sub Worksheet_BeforeDoubleClick(ByVal Target As Range, Cancel As Boolean)
    Dim FILE_PATH2               As String
    Dim FOLDER_PATH2             As String
    Dim FIL_DILOG2               As FileDialog
    
    Dim row As Integer
    Dim col As Integer
    With Target
      row = .row
      col = .Column
      If col = 5 Then
        If row = 25 Then
            Set FIL_DILOG2 = Application.FileDialog(msoFileDialogFolderPicker)
            With FIL_DILOG2
              .Title = Cells(row, col + 1).value
              .InitialFileName = getWorkDir("\")
            End With
            FIL_DILOG2.show
            If FIL_DILOG2.SelectedItems.Count <> 1 Then Exit Sub
            FILE_PATH2 = FIL_DILOG2.SelectedItems(1)
            Cells(row, col).value = FILE_PATH2
            Cancel = True
        ElseIf row = 27 Then
            Set FIL_DILOG2 = Application.FileDialog(msoFileDialogFilePicker)
            With FIL_DILOG2
              .Title = Cells(row, col + 1).value
              .InitialFileName = getWorkDir("\")
            End With
            FIL_DILOG2.show
            If FIL_DILOG2.SelectedItems.Count <> 1 Then Exit Sub
            FILE_PATH2 = FIL_DILOG2.SelectedItems(1)
            Cells(row, col).value = FILE_PATH2
            Cancel = True
        End If
      End If
    End With
End Sub

Sub vcheck()
  If Range("VCHECK").value = "" Then
    Range("VCHECK").value = getStartDateTime(" 現在")
  Else
    Range("VCHECK").value = ""
  End If
End Sub

Sub ftp_test()
    Call logWrite("FTP 設定")
    Dim ftp As FtpScript
    Set ftp = New FtpScript
    With ftp
      .Server = getHostName()
      .User = getUserName()
      .Password = getPassword()
      .Localdir = getLocalDir()
      .RemoteDir = getRmtDir()
    End With
    ftp.init
    ftp.pwd
    ftp.dir
    
    ftp.cd (getRmtBase())
    ftp.dir
    ftp.cd (getRmtRoot())
    ftp.dir
    ftp.run
    MsgBox "テスト終了　－　ログを確認してください"
End Sub

Sub ftp_release()
    Call logWrite("リモートシェルリリース")
    Dim ftp As FtpScript
    Set ftp = New FtpScript
    With ftp
      .Server = getHostName()
      .User = getUserName()
      .Password = getPassword()
      .Localdir = getWorkDir("\releaseShell")
      .RemoteDir = getRmtBase("/shell")
    End With
    ftp.init
    
    If CheckShell.value Then
      ftp.upload ("release.sh")
    End If
    
    If CheckFnc.value Then
      ftp.upload ("release.fnc")
    End If

    If CheckTbl.value Then
      ftp.upload ("release.tbl")
    End If
    ftp.pwd
    ftp.dir
    
    ftp.run
    MsgBox "テスト終了　－　ログを確認してください"
End Sub


Private Sub ButtonCheckList_Click()
    Dim chklst As ChkList
    Set chklst = New ChkList
    With chklst
      .ListName = getCheckListName()
      .Localdir = getWorkDir("\releaseShell")
    End With
    chklst.init

    If CheckShell.value Then
      Call chklst.record("release.sh", 0, "")
    End If
    
    If CheckFnc.value Then
      Call chklst.record("release.fnc", 0, "")
    End If

    If CheckTbl.value Then
      Call chklst.record("release.tbl", 0, "")
    End If

    chklst.fin
End Sub

Private Sub ButtonRelTbl_Click()
    On Error GoTo ErrProc
    '
    
    fd = FreeFile
    Close #fd
    Open getWorkDir("\") & "releaseShell\release.tnl" For Output As #fd
    Print #fd, "#keynam     #subnam     #val"
    
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


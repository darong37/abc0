Attribute VB_Name = "Config"
Option Explicit

'
' User Function
'
Function Check(value As String, formula As Variant, Optional ByVal ng As String = "NG")
  On Error GoTo ErrorHandler
  If value = "" Then
    Check = ""
  Else
    Check = IfErr(formula, ng)
  End If
  Exit Function

ErrorHandler:
  Resume Next
End Function


Function IfErr(formula As Variant, showErr As String)
  On Error GoTo ErrorHandler
  If IsError(formula) Then
    IfErr = showErr
  Else
    IfErr = formula
  End If
  Exit Function
ErrorHandler:
  Resume Next
End Function

Function ifd(path As String, Optional ByVal ok As String = "OK", Optional ByVal ng As String = "NG") As String
  If path <> "" Then
    ifd = dir(path, vbDirectory)
    If ifd <> "" Then
      ifd = ok
    Else
      ifd = ng
    End If
  Else
    ifd = ""
  End If
End Function

Function iff(path As String, Optional ByVal ok As String = "OK", Optional ByVal ng As String = "NG") As String
  If path <> "" Then
    iff = dir(path)
    If iff <> "" Then
      iff = ok
    Else
      iff = ng
    End If
  Else
    iff = ""
  End If
End Function

Function lookup(key As String, tbl As String, col As Integer) As String
  lookup = Trim(Application.WorksheetFunction.VLookup(key, Range(tbl), col, 0))
End Function

'
'Get Base
'
Function getConst(key As String, Optional ByVal postfix As String = "") As String
  getConst = Trim(lookup(key, "TBL_CONST", 2)) & postfix
End Function

Function getVar(key As String, Optional ByVal postfix As String = "") As String
  getVar = Trim(lookup(key, "TBL_VAR", 2)) & postfix
End Function

'
'Get
'
Function getWorkDir(Optional ByVal postfix As String = "") As String
  getWorkDir = getConst("WorkDir", postfix)
End Function

Function getLogDir(Optional ByVal postfix As String = "") As String
  getLogDir = getWorkDir("\") & getConst("LogDir", postfix)
End Function

Function getTTPMacroExe(Optional ByVal postfix As String = "") As String
  getTTPMacroExe = getConst("TTPMacroExe", postfix)
End Function

Function getTTPMacroTTL(Optional ByVal postfix As String = "") As String
  getTTPMacroTTL = getWorkDir("\") & getConst("TTPMacroTTL", postfix)
End Function

Function getCheckListName(Optional ByVal postfix As String = "") As String
  getCheckListName = getConst("CheckListName", postfix)
End Function

Function getResultFileName(Optional ByVal postfix As String = "") As String
  getResultFileName = getConst("ResultFileName", postfix)
End Function

Function getReportFileName(Optional ByVal postfix As String = "") As String
  getReportFileName = getConst("ReportFileName", postfix)
End Function

Function getRmtShell(Optional ByVal postfix As String = "") As String
  getRmtShell = getRmtBase("/") & getConst("RmtShell", postfix)
End Function

Function getFtpScript(Optional ByVal postfix As String = "") As String
  getFtpScript = getWorkDir("\") & getConst("FtpScript", postfix)
End Function

Function getReportFilePrefix(Optional ByVal postfix As String = "") As String
  getReportFilePrefix = getConst("ReportFilePrefix", postfix)
End Function

Function getUserReport(Optional ByVal postfix As String = "") As String
  getUserReport = getLocalDir("\") _
                & getReportFilePrefix("_") _
                & getEnvName("_") _
                & getServerCode("_") _
                & getStartDateTime(".txt") & postfix
End Function

Function getLogFilePrefix(Optional ByVal postfix As String = "") As String
  getLogFilePrefix = getConst("LogFilePrefix", postfix)
End Function

Function getLogFile(Optional ByVal postfix As String = "") As String
  getLogFile = getLogDir("\") _
             & getLogFilePrefix("_") _
             & getEnvName("_") _
             & getServerCode("_") _
             & getStartDateTime(".log") & postfix
End Function

'
'可変
'
Function getEnvNameCode(Optional ByVal postfix As String = "") As String
  getEnvNameCode = getVar("envNameCode", postfix)
End Function

Function getMode() As String
  getMode = getVar("mode")
End Function

Function getStartDateTime(Optional ByVal postfix As String = "") As String
  getStartDateTime = getVar("startDateTime", postfix)
End Function

Function getLocalDir(Optional ByVal postfix As String = "") As String
  getLocalDir = getVar("localDir", postfix)
End Function

Function getRecompOpt(Optional ByVal postfix As String = "") As String
  getRecompOpt = getVar("recompOpt", postfix)
End Function

Function getTargetNo(Optional ByVal postfix As String = "") As String
  getTargetNo = getVar("targetNo", postfix)
End Function



Function getEnvName(Optional ByVal postfix As String = "") As String
  Dim key As String
  key = getEnvNameCode("-") & getTargetNo()
  getEnvName = lookup(key, "TBL_HOSTS", 2) & postfix
End Function

Function selectServerName(ByVal no As Integer) As String
  Dim key As String
  key = getEnvNameCode("-") & no
  selectServerName = lookup(key, "TBL_HOSTS", 3)
End Function

Function getServerName(Optional ByVal postfix As String = "") As String
  getServerName = selectServerName(getTargetNo()) & postfix
End Function

Function getServerCode(Optional ByVal postfix As String = "") As String
  Dim key As String
  key = getEnvNameCode("-") & getTargetNo()
  getServerCode = lookup(key, "TBL_HOSTS", 4) & postfix
End Function

Function getSID(Optional ByVal postfix As String = "") As String
  Dim key As String
  key = getEnvNameCode("-") & getTargetNo()
  getSID = lookup(key, "TBL_HOSTS", 5) & postfix
End Function

Function getHostName(Optional ByVal postfix As String = "") As String
  Dim key As String
  key = getEnvNameCode("-") & getTargetNo()
  getHostName = lookup(key, "TBL_HOSTS", 6) & postfix
End Function

Function getUserName(Optional ByVal postfix As String = "") As String
  Dim key As String
  key = getEnvNameCode("-") & getTargetNo()
  getUserName = lookup(key, "TBL_HOSTS", 7) & postfix
End Function

Function getPassword(Optional ByVal postfix As String = "") As String
  Dim key As String
  key = getEnvNameCode("-") & getTargetNo()
  getPassword = lookup(key, "TBL_HOSTS", 8) & postfix
End Function

Function getRmtRoot(Optional ByVal postfix As String = "") As String
  Dim key As String
  key = getEnvNameCode("-") & getTargetNo()
  getRmtRoot = lookup(key, "TBL_HOSTS", 9) & postfix
End Function

Function getRmtBase(Optional ByVal postfix As String = "") As String
  Dim bn As String
  bn = "/" & getConst("RmtBaseName")
  getRmtBase = getRmtRoot(bn) & postfix
End Function

Function getRmtDir(Optional ByVal postfix As String = "") As String
  getRmtDir = getRmtBase("/") & getUserName(postfix) & postfix
End Function


'
'Set
'
Sub setVar(key As String, ByVal val)
  Dim c As Range

  Set c = Range("TBL_VAR").Find(What:=key, _
                      LookIn:=xlValues, _
                      LookAt:=xlPart, _
                      MatchCase:=False)
  If Not c Is Nothing Then
        c.Offset(0, 1).value = val
  End If
End Sub




Sub setStartDateTime()
  Call setVar("startDateTime", Format(Now(), "yyyymmdd_hhnnss"))
End Sub

Sub setMode(ByVal val)
  Call setVar("mode", val)
End Sub

Sub setLocalDir(ByVal val)
  Call setVar("localDir", val)
End Sub

'
'Sub setLogFile()
'  Range("logFile").Value = "release_" & Format(Now(), "yyyymmdd_hhnnss") & ".log"
'End Sub


'コード化
Function codファイル種別(txt As String) As Integer
  Dim key As String
  key = getTargetServer("-") & txt
  codファイル種別 = lookup(key, "TBL_TYPES", 3)
End Function
'
'Sub pcheck()
'  If Range("E9").Value = "" Then
'    Range("E9").Value = getStartDateTime(" 現在")
'  Else
'    Range("E9").Value = ""
'  End If
'End Sub



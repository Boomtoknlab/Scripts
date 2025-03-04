'Modification I: Variables with today's and yesterday's dates
dtmOntem = Date() - 1
dtmHoje = Date()

'Declarations
Dim objFSO, strPath
Const SHCONTF_NONFOLDERS = &H40
strPath = "C:\log"  
Set objFSO = CreateObject("Scripting.FileSystemObject")

'Start scanning the directory
ScanDirectory(objFSO.GetFolder(strPath)) 

Set objFSO = Nothing
wscript.quit

'Subroutine to scan directory and subdirectories
Sub ScanDirectory(objFolder)
    Scanfiles objFolder
    For Each fld In objFolder.SubFolders 
        ScanDirectory fld 
    Next
End Sub

'Subroutine to scan files in a directory
Sub Scanfiles(objFolder)
    For Each fil In objFolder.files
        'Modification II: Check if the file was created yesterday
        if fil.DateCreated > dtmOntem and fil.DateCreated <= dtmHoje then
            Compress(fil) 
        end if
    Next

    Set objFSOFILE = CreateObject("Scripting.FileSystemObject")
    objFSOFILE.MoveFile "C:\log\*.zip", "c:\teste2\"  'HERE YOU SET THE PATH TO MOVE THE ZIP FILES.
End Sub

'Subroutine to compress files
Sub Compress(fil)
    strPath = Left(fil, InStrRev(fil, "\"))     
    strFile = Mid(fil, InStrRev(fil, "\") + 1)     
    strExt = Mid(strFile, InStrRev(strFile, ".") + 1, 3)     
    If LCase(strExt) = "log" Then           
        strZip = strPath & Replace(strFile, "log", "zip")
        set zipFil = objFSO.CreateTextFile(strZip)
        zipFil.WriteLine Chr(80) & Chr(75) & Chr(5) & Chr(6) & String(18, 0)
        zipfil.Close
        Set oApp = CreateObject("Shell.Application")
        oApp.NameSpace(strZip).CopyHere strPath & strFile
        wscript.sleep 7000 '7 seconds to compress the file - increase this value depending on the file size
        set oApp = Nothing
        Set zipFil = Nothing
        If objFSO.FileExists(strZip) Then objFSO.DeleteFile(fil)
    End If
End Sub

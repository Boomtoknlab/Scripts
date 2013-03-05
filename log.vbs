'Modificação I: Variaveis com as datas de Hoje e ontem
dtmOntem = Date() -1
dtmHoje = Date()


'Declarations
Dim objFSO, strPath
Const SHCONTF_NONFOLDERS = &H40
strPath = "C:\log"  
Set objFSO = CreateObject("Scripting.FileSystemObject")

ScanDirectory (objFSO.GetFolder(strPath)) 

Set objFSO=Nothing
wscript.quit

Sub ScanDirectory(objFolder)
    Scanfiles objFolder
    For Each fld In objFolder.SubFolders 
  	ScanDirectory fld 
    Next
End Sub

Sub Scanfiles(objFolder)
    For Each fil In objFolder.files
		'Modificação II: Verificar se arquivo é de ontem
		if fil.DateCreated > dtmOntem and fil.DateCreated <= dtmHoje then
			Compress (fil) 
		end if
    Next

	Set objFSOFILE = CreateObject("Scripting.FileSystemObject")
	objFSOFILE.MoveFile "C:\log\*.zip" , "c:\teste2\"  'AQUI VOCÊ COLOCA O CAMINHO QUE QUER MOVER OS ZIP.
End Sub

Sub Compress(fil)
	strPath = Left(fil, InStrRev(fil, "\"))     
	strFile = Mid(fil, InStrRev(fil, "\") + 1)     
	strExt = Mid(strFile, InStrRev(strFile, ".") + 1, 3)     
	If LCase(strExt) = "log" Then           
		strZip = strPath & Replace(strFile, "log", "zip")
		set zipFil=objFSO.CreateTextFile(strZip)
		zipFil.WriteLine Chr(80) & Chr(75) & Chr(5) & Chr(6) & String(18, 0)
		zipfil.Close
		Set oApp = CreateObject("Shell.Application")
		oApp.NameSpace(strZip).CopyHere strPath & strFile
		wscript.sleep 7000 '7 segundos para comprimir o arquivo - dependendo do tamanho, aumente este valor
		set oApp=Nothing
		Set zipFil=Nothing
		If objFSO.FileExists(strZip) Then objFSO.DeleteFile (fil)
	End If

End sub

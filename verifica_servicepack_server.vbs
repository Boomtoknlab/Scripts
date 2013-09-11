on error resume next
Set oFSO = CreateObject("Scripting.FileSystemObject")
sFile = "C:\lista.txt"
If oFSO.FileExists(sFile) Then
Set oFile = oFSO.OpenTextFile(sFile)
 Do While Not oFile.AtEndOfStream
  strComputer= oFile.ReadLine
Set objWMIService = GetObject("winmgmts:{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")


Set colNome = objWMIService.ExecQuery("Select * From Win32_ComputerSystem")
For Each objNome in colNome
    Wscript.Echo "Hostname: " & objNome.Name
Next

Set colSO = objWMIService.ExecQuery("Select * From Win32_OperatingSystem")
For Each objSO in colSO
    Wscript.Echo "*** SOFTWARE ***" & vbCrLf & "Sistema: " & objSO.Caption & " " & objSO.Version
    Wscript.Echo "Service Pack: " & objSO.ServicePackMajorVersion

	Wscript.Echo "-----------------------------------"
Next
 Loop
oFile.Close
End If


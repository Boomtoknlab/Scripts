Option Explicit

Sub Main()
    On Error GoTo ErrorHandler

    Dim oFSO, sFile, oFile, strComputer, objWMIService
    Dim colNome, objNome, colSO, objSO

    Set oFSO = CreateObject("Scripting.FileSystemObject")
    sFile = "C:\lista.txt"

    If oFSO.FileExists(sFile) Then
        Set oFile = oFSO.OpenTextFile(sFile)
        Do While Not oFile.AtEndOfStream
            strComputer = oFile.ReadLine
            Set objWMIService = GetObject("winmgmts:{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")

            Set colNome = objWMIService.ExecQuery("Select * From Win32_ComputerSystem")
            For Each objNome In colNome
                Wscript.Echo "Hostname: " & objNome.Name
            Next

            Set colSO = objWMIService.ExecQuery("Select * From Win32_OperatingSystem")
            For Each objSO In colSO
                Wscript.Echo "*** SOFTWARE ***" & vbCrLf & "Sistema: " & objSO.Caption & " " & objSO.Version
                Wscript.Echo "Service Pack: " & objSO.ServicePackMajorVersion
                Wscript.Echo "-----------------------------------"
            Next
        Loop
        oFile.Close
    Else
        Wscript.Echo "File not found: " & sFile
    End If

    Exit Sub

ErrorHandler:
    Wscript.Echo "Error: " & Err.Description
    If Not oFile Is Nothing Then oFile.Close
End Sub

Main

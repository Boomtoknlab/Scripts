On Error Resume Next

'****************************************************************************
'Script Name: mapeia_rede.vbs
'Author : Douglas Urbano
'Date: 03/03/2013
'Purpose : Create network folders with namespace, and create user folder according to login
'****************************************************************************
'****************************************************************************

' Synchronize the machines with the time of the Domain Controller
Set wshShell = CreateObject("WScript.Shell")
wshShell.Run "NET TIME \\Server /SET /Y", 0, True

Set oShell = CreateObject("Shell.Application")

Set wshNetwork = CreateObject("WScript.Network")
Set oDrives = WshNetwork.EnumNetworkDrives

' Disconnect these network drives
WSHNetwork.RemoveNetworkDrive "G:", True, True
WSHNetwork.RemoveNetworkDrive "H:", True, True
WSHNetwork.RemoveNetworkDrive "I:", True, True
WSHNetwork.RemoveNetworkDrive "J:", True, True
WSHNetwork.RemoveNetworkDrive "K:", True, True
WSHNetwork.RemoveNetworkDrive "L:", True, True
WSHNetwork.RemoveNetworkDrive "M:", True, True
WSHNetwork.RemoveNetworkDrive "N:", True, True
WSHNetwork.RemoveNetworkDrive "O:", True, True
WSHNetwork.RemoveNetworkDrive "P:", True, True
WSHNetwork.RemoveNetworkDrive "Q:", True, True
WSHNetwork.RemoveNetworkDrive "R:", True, True
WSHNetwork.RemoveNetworkDrive "S:", True, True
WSHNetwork.RemoveNetworkDrive "T:", True, True
WSHNetwork.RemoveNetworkDrive "U:", True, True
WSHNetwork.RemoveNetworkDrive "V:", True, True
WSHNetwork.RemoveNetworkDrive "X:", True, True
WSHNetwork.RemoveNetworkDrive "Y:", True, True
WSHNetwork.RemoveNetworkDrive "W:", True, True
WSHNetwork.RemoveNetworkDrive "Z:", True, True

' If the user does not exist upon login, create in this folder
Set wshell = createobject("wscript.network")
user1 = wshell.username
Set FileClass = CreateObject("Scripting.FileSystemObject")
Directory = "\\server\folder\" & user1
If FileClass.FolderExists (Directory) = False Then
    FileClass.CreateFolder (Directory)
End If

WScript.DisconnectObject WSHNetwork

' Map the user's drive with the letter U
Dim objNetwork
Dim strDriveLetter, strRemotePath, strUserName
strDriveLetter = "U:"
strRemotePath = "\\Server\Folder_Users"

Set objNetwork = WScript.CreateObject("WScript.Network")
strUserName = objNetwork.UserName
objNetwork.MapNetworkDrive strDriveLetter, strRemotePath & "\" & strUserName

' Map other network drives
wshNetwork.MapNetworkDrive "H:", "\\Server\Folder\IT" ' Path to the IT folder
wshNetwork.MapNetworkDrive "P:", "\\Server\Folder\Public" ' Path to the Public folder
wshNetwork.MapNetworkDrive "S:", "\\Server\Folder\Scanner" ' Path to the Scanner folder

' Set namespace names for the mapped drives
oShell.NameSpace("H:\").Self.Name = "IT"
oShell.NameSpace("P:\").Self.Name = "Public"
oShell.NameSpace("U:\").Self.Name = "User"
oShell.NameSpace("S:\").Self.Name = "Scanner"

' Welcome message to the user
Set objUser = WScript.CreateObject("WScript.Network")
wuser = objUser.UserName
If Time <= "12:00:00" Then
    MsgBox ("Good Morning " + wuser + ", you have just joined the company network, please adhere to the security policies!")
ElseIf Time >= "12:00:01" And Time <= "18:00:00" Then
    MsgBox ("Good Afternoon " + wuser + ", you have just joined the company network, please adhere to the security policies!")
Else
    MsgBox ("Good Evening " + wuser + ", you have just joined the company network, please adhere to the security policies!")
End If

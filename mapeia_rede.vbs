On Error Resume Next

'****************************************************************************
'Script Name: mapeia_rede.vbs
'Author : Douglas Urbano
'Purpose : Criar pastas de rede com namespace, e criar pasta user de acordo com login
'****************************************************************************
'****************************************************************************


Set wshShell = CreateObject("WScript.Shell")
wshShell.Run "NET TIME \\Server /SET /Y", 0, True 'Sincroniza as máquinas com a hora do Domain Controller

Set oShell = CreateObject("Shell.Application")

Set wshNetwork = CreateObject("WScript.Network")
Set oDrives = WshNetwork.EnumNetworkDrives

'Desconectar estas unidades de redes

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
WSHNetwork.RemoveNetworkDrive "w:", True, True
WSHNetwork.RemoveNetworkDrive "Z:", True, True

'Se não existir o usuário ao se logar, então, crie nesta pasta

Set wshell = createobject("wscript.network")
user1 = wshell.username
Set FileClass = CreateObject("Scripting.FileSystemObject")
Directory = "\\server\folder\" & user1
If FileClass.FolderExists (Directory) = False Then
FileClass.CreateFolder (Directory)
End If

WScript.DisconnectObject WSHNetwork


Dim objNetwork
Dim strDriveLetter, strRemotePath, strUserName
strDriveLetter = "U:"
strRemotePath = "\\Server\Folder_Users" ' Mapeia a unidade do usuário com a Letra U

Set objNetwork = WScript.CreateObject("WScript.Network")

strUserName = objNetwork.UserName
objNetwork.MapNetworkDrive strDriveLetter, strRemotePath _
& "\" & strUserName


wshNetwork.MapNetworkDrive"H:","\\Server\Folder\IT" 'Caminho real da pasta
wshNetwork.MapNetworkDrive"P:","\\Server\Folder\Public" 'Caminho real da pasta
wshNetwork.MapNetworkDrive"S:","\\Server\Folder\Scanner" 'Caminho real da pasta

'Namespace, ou seja, ao ser mapeado, os nomes que serão mostrados Ex: It, Scaner...

oShell.NameSpace("H:\").Self.Name = "IT" 
oShell.NameSpace("P:\").Self.Name = "Public"
oShell.NameSpace("U:\").Self.Name = "User"
oShell.NameSpace("S:\").Self.Name = "Scanner"

Import-Module activedirectory

$usuarios = get-adUser -filter * -SearchBase "DC=lab,dc=nexa,dc=com,dc=br" -Properties * # | ft DisplayName, SamAccountName,Enabled,MemberOf

foreach($u in $usuarios){
    "==============================================================="
    "Nome      : "+ $u.DisplayName
    "Login     : "+ $u.SamAccountName
    "Habilitado: "+ $u.Enabled
    "Grupos    :"
    foreach ($g in $u.memberof){
        #Aqui coloquei duas opcoes de nome de grupo
        #Basta voce apagar a linha que vc nao quer
        "`t"+$g  #Aqui mostra o nome distinto
        "`t"+(Get-ADGroup $g).name  #Aqui mostra o nome do grupo
    }


}

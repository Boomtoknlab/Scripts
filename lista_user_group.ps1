Import-Module activedirectory

$usuarios = get-adUser -filter * -SearchBase "DC=dominio,dc=local" -Properties * # | ft DisplayName, SamAccountName,Enabled,MemberOf

foreach($u in $usuarios){
    "==============================================================="
    "Nome      : "+ $u.DisplayName
    "Login     : "+ $u.SamAccountName
    "Habilitado: "+ $u.Enabled
    "Grupos    :"
    foreach ($g in $u.memberof){
        #Aqui existe duas opcoes de nome de grupo
        #Basta apagar a linha que vc nao quer
        "`t"+$g  #Aqui mostra o nome distinto
        "`t"+(Get-ADGroup $g).name  #Aqui mostra o nome do grupo
    }


}

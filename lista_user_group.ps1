# Import the Active Directory module
Import-Module ActiveDirectory

# Retrieve all users from the specified Organizational Unit (OU)
$users = Get-ADUser -Filter * -SearchBase "DC=domain,DC=local" -Properties DisplayName, SamAccountName, Enabled, MemberOf

foreach ($user in $users) {
    Write-Host "===============================================================" -ForegroundColor Cyan
    Write-Host "Name      : " $user.DisplayName -ForegroundColor Yellow
    Write-Host "Username  : " $user.SamAccountName -ForegroundColor Green
    Write-Host "Enabled   : " ($user.Enabled -as [string]) -ForegroundColor Magenta

    Write-Host "Groups    :" -ForegroundColor Blue

    # Check if the user belongs to any group
    if ($user.MemberOf -ne $null) {
        foreach ($group in $user.MemberOf) {
            $groupName = (Get-ADGroup $group).Name  # Get the group's name
            Write-Host "`t- $groupName" -ForegroundColor White
        }
    } else {
        Write-Host "`t[No group memberships]" -ForegroundColor DarkGray
    }
}

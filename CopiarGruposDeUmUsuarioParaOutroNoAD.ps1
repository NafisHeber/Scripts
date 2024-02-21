# Pedir o nome do usuário que deseja copiar os grupos
$usuarioCopiar = Read-Host "Digite o nome do usuário que deseja copiar os grupos"

# Verificar se o usuário existe no AD
if (Get-ADUser -Filter {SamAccountName -eq $usuarioCopiar}) {
    Write-Host "Usuário selecionado: $usuarioCopiar"
} else {
    Write-Host "Usuário não encontrado no AD"
    exit
}

# Pedir o nome do usuário que deseja colar os grupos
$usuarioColar = Read-Host "Digite o nome do usuário que deseja colar os grupos"

# Verificar se o usuário existe no AD
if (Get-ADUser -Filter {SamAccountName -eq $usuarioColar}) {
    Write-Host "Usuário selecionado: $usuarioColar"
} else {
    Write-Host "Usuário não encontrado no AD"
    exit
}

# Copiar os grupos do usuário selecionado
$grupos = Get-ADUser $usuarioCopiar -Properties MemberOf | Select-Object -ExpandProperty MemberOf
foreach ($grupo in $grupos) {
    Add-ADGroupMember -Identity $grupo -Members $usuarioColar
}

Write-Host "Grupos copiados com sucesso para o usuário $usuarioColar"

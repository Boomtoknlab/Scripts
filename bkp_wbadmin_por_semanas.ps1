# Clear the screen
Clear-Host

# Define variables
$date = Get-Date -Format "yyyy-MM-dd"
$week = (Get-Date).DayOfWeek
$comp = $env:COMPUTERNAME
$user = $env:USERNAME
$share = '\\srv\testando'
$folder = "$share\$comp\$week\$date\"
$log = "$folder$comp.log"

# Map network drive
net use i: /delete /Y
$mapprocess = Start-Process -Wait -NoNewWindow -PassThru -FilePath net -ArgumentList "use i: $share"
if ($mapprocess.ExitCode -ne 0) {
    Write-Host "Failed to map drive."
    exit 1
}

# Create backup folder if not exists
if (!(Test-Path -Path $folder)) {
    New-Item -Path $folder -ItemType Directory -Force | Out-Null
}

# Create log file if not exists
if (!(Test-Path -Path $log)) {
    New-Item -Path $log -ItemType File -Force | Out-Null
}

# Start backup
$start = Get-Date
$process = Start-Process -Wait -NoNewWindow -PassThru -FilePath wbadmin.exe -ArgumentList "start backup -backuptarget:$folder -include:E: -quiet" -RedirectStandardOutput $log
$end = Get-Date

# Backup result
if ($process.ExitCode -eq 0) {
    $status = "SUCCESS"
    $result = "Backup completed on $comp by $user. Started: $start, Ended: $end`n"
} else {
    $status = "FAILED"
    $result = "Backup failed on $comp. Started: $start, Ended: $end`n"
}

# Convert log to HTML
$loghtmlfile = "$log.html"
Get-Content $log | ConvertTo-Html -Property PSObject | Out-File $loghtmlfile
$result += Get-Content $loghtmlfile -Raw

# Send email notification
$mail = New-Object system.net.Mail.MailMessage
$mail.From = "seu-email@domain.com"
$mail.To.Add("backup@domain.com")
$mail.Subject = "Backup Results: $status on $comp - $date"
$mail.IsBodyHtml = $true
$mail.Body = $result
$smtp = New-Object system.Net.Mail.SmtpClient("smtp.domain.com")
$smtp.Send($mail)

# Unmap network drive
net use i: /delete /Y

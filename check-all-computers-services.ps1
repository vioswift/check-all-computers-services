#RPC must be enabled on the computer enabled
$computer =  'computername1', 'computername2'
$username = 'username'
$credValidation = 0

try {
    $cred = get-Credential -credential $username 
    $credValidation = 1
} 
catch {
    $credValidation = 0
}

try {
    if ($credValidation) {
        foreach ($name in $computer) {
            Write-Host "`n"
            Write-Host $name -ForegroundColor Green
            (Get-WmiObject win32_service -computer $name -credential $cred -Filter "State = 'Stopped' AND StartMode = 'Auto'" | Select Name, DisplayName, State, StartMode | Sort State, Name | Out-String).Trim()
        }
    }else {
        Write-Host "The credentials were either wrong or NULL, no action was made." -ForegroundColor Red
    }
    Read-Host "`nPress any key to close"
}
catch {
    Write-Error $_.Exception.ToString()
    Read-Host -Prompt "The above error occurred. Press Enter to exit."
}
[CmdletBinding()]
param(
    [string]
    $DomainName,

    [string]
    $UserName,

    [string]
    $DomainAdminPasswordKey
)

try {
    $ErrorActionPreference = "Stop"

    $DomainAdminFullUser = $DomainName + '\' + $UserName
    $secure = (Get-SSMParameterValue -Names $DomainAdminPasswordKey -WithDecryption $True).Parameters[0].Value
    $pass = ConvertTo-SecureString $secure -AsPlainText -Force
    $cred = New-Object System.Management.Automation.PSCredential -ArgumentList $DomainAdminFullUser,$pass

    Add-Computer -DomainName $DomainName -Credential $cred -ErrorAction Stop
}
catch {
    $_ | Write-AWSLaunchWizardException
}

# restart computer to make joining domain effective
C:\cfn\scripts\Restart-Computer.ps1

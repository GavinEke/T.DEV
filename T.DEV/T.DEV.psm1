<#
    This PowerShell module uses the Cloudflare® API to manage Cloudflare services.
    This PowerShell module is a community project and not officially supported by Cloudflare.
    Make sure to read Cloudflare's Terms of Use - https://www.cloudflare.com/terms/
#>

# Set PSScriptRoot
If (-not ($PSScriptRoot)) {
    $PSScriptRoot = Split-Path $MyInvocation.MyCommand.Path -Parent
}

# Dot source the modules functions
$CFFunctions = Get-ChildItem -Path "$PSScriptRoot\Functions\*.ps1"
$CFFunctions | ForEach-Object {. $_.FullName}
Export-ModuleMember -Function $CFFunctions.BaseName

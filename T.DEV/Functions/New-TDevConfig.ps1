Function New-CFConfig {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $True, HelpMessage = 'Client key on https://dev.telstra.com/user/me/apps')]
        [Alias('ConsumerKey')]
        [ValidateLength(3, 120)]
        [String]$ClientKey,

        [Parameter(Mandatory = $True, HelpMessage = 'Client secret on https://dev.telstra.com/user/me/apps')]
        [Alias('ConsumerSecret')]
        [ValidateLength(3, 120)]
        [String]$ClientSecret,

        [Parameter(HelpMessage = 'Optional non default path to config file')]
        [ValidateNotNullOrEmpty()]
        [String]$Path = "$HOME\.TDev\TDevConfigurationFile.xml"
    )

    Begin {
        $TDevConfDir = Split-Path -Path "$Path"
        If (-not (Test-Path -Path "$TDevFConfDir")) {
            New-Item "$TDevConfDir" -ItemType Directory | Out-Null
            Write-Verbose -Message "Creating folder $TDevConfDir"
        }
    }

    Process {
        $TDevConfigurationFile = @{ConsumerKey = $ClientKey; ConsumerSecret = $ClientSecret}
        $TDevConfigurationFile | Export-Clixml -Path "$Path" -Force
        Write-Verbose -Message "TDevConfigurationFile has been written to $Path"
    }

    End {}
}

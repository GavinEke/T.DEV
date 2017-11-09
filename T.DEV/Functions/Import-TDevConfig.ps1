Function Import-TDevConfig {
    [CmdletBinding()]
    Param(
        [Parameter(HelpMessage = 'Optional non default path to config file')]
        [ValidateScript({$_ | Test-Path -PathType Leaf})]
        [System.IO.FileInfo]$Path = "$HOME\.TDev\TDevConfigurationFile.xml"
    )
    
    Begin {}

    Process {
        If (Test-Path -Path "$Path") {
            $TDevConfigurationFile = Import-Clixml -Path "$Path"
            Write-Verbose -Message "TDevConfigurationFile has been loaded from $Path"

            Try {
                [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
                
                $Uri = 'https://sapi.telstra.com/v1/oauth/token'
                $headers = @{'Content-Type' = 'application/x-www-form-urlencoded'}
                $body = 'grant_type=client_credentials&client_id={0}&client_secret={1}&scope=NSMS' -f $TDevConfigurationFile.ConsumerKey, $TDevConfigurationFile.ConsumerSecret
                $Response = Invoke-RestMethod -Method Post -Uri $Uri -Headers $headers -Body $body

                $Script:BaseUri = 'https://tapi.telstra.com/v2/messages'
                $Script:AccessToken = "Bearer $($Response.access_token)"
                $Script:ConfigImported = $True

            } Catch {
                $_.Exception.Message
            }
        }
        Else {
            Write-Warning -Message 'No Configuration File Found. Please run New-TDevConfig to create a Configuration File.'
            $Script:ConfigImported = $False
        }
    }

    End {}
}

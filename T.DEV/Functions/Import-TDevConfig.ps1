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
                $body = 'grant_type={0}&client_id={1}&client_secret={2}&scope={3}' -f $TDevConfigurationFile.GrantType, $TDevConfigurationFile.ConsumerKey, $TDevConfigurationFile.ConsumerSecret, $TDevConfigurationFile.Scope
                $Response = Invoke-RestMethod -Method Post -Uri $Uri -Headers $headers -Body $body

                $Script:BaseUri = 'https://tapi.telstra.com/v2/messages'
                $Script:AccessToken = "Bearer $($Response.access_token)"
                $Script:headers = @{
                    'Authorization' = $AccessToken;
                    'Cache-Control' = 'no-cache';
                    'Content-Type' = 'application/json'
                }
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

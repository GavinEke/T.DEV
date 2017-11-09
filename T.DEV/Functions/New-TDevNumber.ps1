Function New-TDevNumber {
    [CmdletBinding()]
    Param()
    
    Begin {
        If (-not ($AccessToken)) {Import-TDevConfig}
    }

    Process {
        If ($ConfigImported) {
            Try {
                $Uri = "$BaseUri/provisioning/subscriptions"
                $headers = @{
                    'Authorization' = $AccessToken;
                    'Cache-Control' = 'no-cache';
                    'Content-Type' = 'application/json'
                }
                $json = @{
                    'activeDays' = 30;
                    'notifyURL' = "http://example.com/callback";
                    'callbackData' = @{
                        'anything' = 'some data'
                    }
                }
                $body = $json | ConvertTo-Json
                $Response = Invoke-RestMethod -Method Post -Uri $Uri -Headers $headers -Body $body
                $Response
            } Catch {
                $_.Exception.Message
            }
        }
    }

    End {}
}

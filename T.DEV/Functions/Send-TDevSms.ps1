Function Send-TDevSms {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $True, HelpMessage = 'The number that the message should be sent to. This is a mobile number in international format.')]
        [ValidatePattern("\+(9[976]\d|8[987530]\d|6[987]\d|5[90]\d|42\d|3[875]\d|2[98654321]\d|9[8543210]|8[6421]|6[6543210]|5[87654321]|4[987654310]|3[9643210]|2[70]|7|1)\d{1,14}$")]
        [String]$To,

        [Parameter(Mandatory = $True, HelpMessage = 'This field contains the message text, this can be up to 1900 UTF-8 characters. As mobile devices rarely support the full range of UTF-8 characters, it is possible that some characters may not be translated correctly by the mobile device.')]
        [ValidateLength(0, 1900)]
        [String]$Message
    )
    
    Begin {
        If (-not ($AccessToken)) {Import-TDevConfig}
    }

    Process {
        If ($ConfigImported) {
            Try {
                $Uri = "$BaseUri/sms"
                $json = @{
                    'to' = $To;
                    'body' = $Message
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

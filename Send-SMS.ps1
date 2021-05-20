<#
.SYNOPSIS
    A PowerShell script to send SMS using a gateway
.DESCRIPTION
    A PowerShell script to send SMS using a gateway, this was designed to work with a specific gateway model, other gateways might not be supported.
    The SMS is sent using a GET request and the Uri http(s)://<Name or IP Address>:<Port>/?to=<PhoneNumber>&content=<Message Text>
    Response from the gateway must be in the format '200 <PhoneNumber>' to count as success, any other response is considered a failure.

    Use -Simulate or -WhatIf to test different scenarios
.EXAMPLE
    PS C:\> .\Send-SMS.ps1 -URL http://192.168.1.1:4040/ -PhoneNumber '0123456789','0987654321' -Content "Hello World!"
    Sends hello world to two numbers.
.Example
    PS C:\> .\Send-SMS.ps1 -URL http://192.168.1.1:4040/ -PhoneNumber '0123456789','0987654321' -Content "Hello World!" -Simulate Failure
    Simulates failure for all messages, nothing is sent. Errors are returned in console with expected URI.
.Example
    PS C:\> .\Send-SMS.ps1 -URL http://192.168.1.1:4040/ -PhoneNumber '0123456789','0987654321' -Content "Hello World!" -Simulate Success
    Simulates success for all messages, nothing is sent. Warnings are returned in console with expected URI.
#>
[CmdletBinding(SupportsShouldProcess=$true)]
param (
    # Gateway URL in the format 'http(s)://<Name or IP Address>:<Port>/'
    [Parameter(Mandatory=$true)]
    [ValidatePattern("^(http|https):\/{2}[a-z,0-9,\.,-]+:\d{1,5}\/$",ErrorMessage = 'URL must use this format: http(s)://<Name or IP Address>:<Port>/')]
    [string]
    $URL,

    # Phone number where SMS should be sent. Multiple entries will send multiple SMSs.
    [Parameter(Mandatory=$true)]
    [string[]]
    [ValidatePattern("^\d+$",ErrorMessage= 'Phone numbers must be digits only.')]
    $PhoneNumber,

    # Message text to send.
    [Parameter(Mandatory=$true)]
    [string]
    $Content,

    # Simulate success or failure for testing
    [Parameter(Mandatory=$false)]
    [ValidateSet('Success','Failure')]
    [string]
    $Simulate
)

foreach ($item in $PhoneNumber){
    try{
        $smsUri = "{0}?to={1}&content={2}" -f $URL, $item, $Content
        switch ($Simulate){
            'Success' {
                Write-Warning "Simulated success: $smsUri"
            }
            'Failure' {
                throw "Simulated failure for: $smsUri"
            }
            default {
                if($PSCmdlet.ShouldProcess($smsUri,"Send SMS")){
                    $result = (Invoke-WebRequest -Uri $smsUri -ErrorAction Stop).Content
                    if(-not ($result -match "200\s$PhoneNumber")){
                        Write-Error -Message "Sending SMS failed to $smsUri. Reply from gateway: $result"
                    }
                }
            }
        }
    }
    catch{
        Write-Error $_
    }
}

# Send-SMS
 A PowerShell script to send SMS using a gateway

# Description
A PowerShell script to send SMS using a gateway, this was designed to work with a specific gateway model, other gateways might not be supported.
The SMS is sent using a GET request and the Uri `http(s)://<Name or IP Address>:<Port>/?to=<PhoneNumber>&content=<Message Text>`
Response from the gateway must be in the format '200 <PhoneNumber>' to count as success, any other response is considered a failure.

Use -Simulate or -WhatIf to test different scenarios
# Examples
```
PS C:\> .\Send-SMS.ps1 -URL http://192.168.1.1:4040/ -PhoneNumber '0123456789','0987654321' -Content "Hello World!"
```
Sends hello world to two numbers.

```
PS C:\> .\Send-SMS.ps1 -URL http://192.168.1.1:4040/ -PhoneNumber '0123456789','0987654321' -Content "Hello World!" -Simulate Failure
```
Simulates failure for all messages, nothing is sent. Errors are returned in console with expected URI.

```
PS C:\> .\Send-SMS.ps1 -URL http://192.168.1.1:4040/ -PhoneNumber '0123456789','0987654321' -Content "Hello World!" -Simulate Success
```
Simulates success for all messages, nothing is sent. Warnings are returned in console with expected URI.
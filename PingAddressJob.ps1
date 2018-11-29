

Start-job -Name Test -ScriptBlock {DO{
    $status = Get-UrlStatusCode $site
    write-Host $status
    $site = "<address to ping>"
    $secpasswd = ConvertTo-SecureString "<Password>" -AsPlainText -Force
    $mycreds = New-Object System.Management.Automation.PSCredential ("<email address>", $secpasswd)
    $from = "<email>"
    $to = "<email>"
    $smtp = "<server>"
    if($status -ne 200){
        
        $badSub = "Website is Down"
        $body = "Status of " + $site + ": " + $status
        Write-Host $body
        Send-MailMessage -To $to -From $from -Subject $badSub -Body $body.ToString()  -SmtpServer $smtp -Credential $mycreds
    }
    Start-Sleep 60
}while ($site)}


function Get-UrlStatusCode([string] $Url)
{
    try
    {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        (Invoke-WebRequest -Uri $Url -UseBasicParsing -DisableKeepAlive -MaximumRedirection 0).StatusCode
    }
    catch [Net.WebException]
    {
        Write-Host "Error"
        [int]$_.Exception.Response.StatusCode

    }
}

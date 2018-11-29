
#$site = "https://www.testt12.com"
$site = "https://www.apc-us.com/"
$secpasswd = ConvertTo-SecureString "Dcz4848!$" -AsPlainText -Force
$mycreds = New-Object System.Management.Automation.PSCredential ("damian@48first.com", $secpasswd)

Start-job -Name Test -ScriptBlock {DO{
    $status = Get-UrlStatusCode $site
    write-Host $status
    $site = "https://www.apc-us.com/"
    $secpasswd = ConvertTo-SecureString "Dcz4848!$" -AsPlainText -Force
    $mycreds = New-Object System.Management.Automation.PSCredential ("damian@48first.com", $secpasswd)
    if($status -ne 200){
        #$badSub = "Website " + $site + "status:" + $status
        $badSub = "Website is Down"
        $body = "Status of " + $site + ": " + $status
        Write-Host $body
        Send-MailMessage -To "Help <help@48first.com>; Nathalie <n.lemaire@apc.fr>" -From "Damian  <damian@48first.com>" -Subject $badSub -Body $body.ToString()  -SmtpServer "mail.48first.com" -Credential $mycreds
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

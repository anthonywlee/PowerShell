################################################
## Created By: Anthony Lee (2016)
## Desc. Finds geoIP info from either an online source:
##         https://freegeoip.net
##       or offline from a csv:
##         http://geolite.maxmind.com/download/geoip/database/GeoIPCountryCSV.zip
################################################

[cmdletbinding()]
param(
    [Parameter(Mandatory=$True, ValueFromPipeline=$True, ValueFromPipelineByPropertyName=$True)]
    [System.Net.IPAddress]$IPAddress,
    [switch]$Offline,
    [string]$Database,
    [string]$Headers

)


## Convert the IP address into an integer.
## Ref: http://dev.maxmind.com/geoip/legacy/csv/
function get-ipint{

    $ip_int = ((16777216 * $IPAddress.GetAddressBytes()[0]) + (65536 * $IPAddress.GetAddressBytes()[1]) + (256 * $IPAddress.GetAddressBytes()[2]) + ($IPAddress.GetAddressBytes()[3]))

    return $ip_int
}


function main{
    if($Offline -eq $True){
        if($Database){
            if(!($Headers)){
                $header = "LowIP","HighIP","LowIPInt","HighIPInt","CCode","CName"
                    # Specify the headers. The file I used did not have headers included.
            }

            try{
                Write-Output "Importing Database..."
                $geoip_data = Import-Csv -Path $database -Header $header
                    #Import the geoip data from a csv.
                Write-Output "Complete."
            }
            catch{
                $_.Exception.Message
                break
            }
        }
        Else{
            Write-Error "Specify a database to use with -Offline. Download from: http://geolite.maxmind.com/download/geoip/database/GeoIPCountryCSV.zip"
            break
        }

        $ip_int = get-ipint -IP $IPAddress
        $result = @{}
    
        for($i = 0; $i -le $geoip_data.length; $i++){
            $item = $geoip_data[$i]
            if(($ip_int -ge $item.LowIPInt) -AND ($ip_int -le $item.HighIPInt)){
                $result.Add("CCode",$item.CCode)
                $result.Add("CName", $item.CName)
            }
        }

        return "IP Address: {0}`nCountry Code: {1}`nCountry Name: {2}" -f $IPAddress,$result.CCode,$result.CName
    }

    if($Offline -eq $False){
        $uri = "https://freegeoip.net/xml/"+$IPAddress

        Write-Output "Retrieving IP info..."
        try{
            [xml]$result = (Invoke-WebRequest -Uri $uri -Method GET).Content 
        }
        catch{
            $_.Exception.Message
            break
        }
        Write-Output "Complete."

        return $result.Response

    }
}

. main



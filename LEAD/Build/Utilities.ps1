function Recycle-AppPool ($Server = $(throw "Missing argument Server"),$AppPoolName=$(throw "Missing argument Application Pool Name")){
    
    <#
    .SYNOPSIS
        Recycles a named Application Pool of a given Server.

    .DESCRIPTION
        This function is used within the server. It will get all the app pools of IIS then loops in that App Pool collection to find the App Pool you want
        to recycle. Recycling App Pools minimizes the disruption of IIS service specially in Web App Servers thas has more than on Applications.

    .PARAMETER Server
        Server must be a fully qualified domain name (FQDN). For example, devappwebv01.dev.gatesfoundation.org.

    .PARAMETER AppPoolName
        The Application Pool to recycle. Please take note that this parameter is case-sensitive. For example, "SSC".        

    .EXAMPLE
        Recycle-AppPool devappwebv01.dev.gatesfoundation.org "SSC"
        Searches for the app pool in IIS then recycles it if found. Displays a message whether the operation was successful or not

    .LINK
        
    #>
    
    $mode = 0 # ManagedPipelineModes: 0 = integrated, 1 = classic   
    $iis = [adsi]"IIS://$Server/W3SVC/AppPools"
    [bool]$found = $false
    foreach($pool in $iis.psbase.children)
    {
        if($pool.name -eq $AppPoolName)
        {
            $pool.psbase.invoke("recycle")
            $found = $true
        }
    }
    if($found)
    {
        Write-Host "LEAD App Pool recycled!"
    }
    else {
        Write-Host "LEAD App Pool not found!"
    }
}
#Commandlet Inclusions
$_INC = (resolve-path $MyInvocation.InvocationName) -replace "\\[^\\]*$","";  if ($Env:Path -notmatch [regex]::escape($_INC)) {$Env:Path += ";$_INC"}
#Just add the PowerShell Scripts filename that you want to include in this script. 
. Utilities.ps1

try
{
    if ($args.Length -eq 1)
    {
        #This Relies on the structure found in the current (5/25/2010) drop location.
        $EnvPrefix = $args[0]
        $CurrentPath = Split-Path -Path $MyInvocation.MyCommand.Definition
        $Injector = $CurrentPath + "\EnvironmentInjector\EnvironmentInjector.exe"
        $AppWeb = "\\localhost\c$\Projects\GatesFoundation\LEAD"

        Write-Host "#********************************************************"
        Write-Host "#***            Environment Variables                 ***"
        Write-Host "#********************************************************"

        & $Injector -env $CurrentPath\EnvironmentInjector\Environments\$EnvPrefix.xml -package LEAD

        if($lastexitcode -ne 0)
        {
	        Throw System.Exception
        }

        Write-Host $null
        Write-Host "Replaced Environment Variables!"
        Write-Host $null

        Write-Host "#********************************************************"
        Write-Host "#***         Leadership Engagement Plan               ***"
        Write-Host "#********************************************************"

        if (!(Test-Path -path $AppWeb))
        {
	        New-Item $AppWeb -type directory
        }

        Write-Host "$CurrentPath\_PublishedWebsites\Scheduler\*.* to $AppWeb"
        Copy $CurrentPath\_PublishedWebsites\Scheduler\* $AppWeb -recurse -force

        Write-Host $null

        Write-Host "#********************************************************"
        Write-Host "#***              Recycling LEAD App Pool              ***"
        Write-Host "#********************************************************"

        Recycle-AppPool localhost "LEAD_AppPool"

        Write-Host $null

        return $null
    }
    else
    {
        Write-Host ""
		Write-Host Usage: powershell DeployLEAD.ps1 [Environment Prefix]
        Throw System.Exception
    }
}
catch [System.Exception]
{
    Write-Host "An Error has occured! Terminating deployment script."
    return $lastexitcode
}
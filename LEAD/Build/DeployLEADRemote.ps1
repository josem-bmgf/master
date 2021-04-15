Param ($DropLocation, $EnvScript, $Server)
Invoke-Command -Args ($DropLocation, $EnvScript) -Script {
	param($DropLocation, $EnvScript)
	Write-Output ([System.String]::Format("DropLocation: {0}", $DropLocation)); 
	$script = Join-Path $DropLocation $EnvScript
    . $script
} -ComputerName $Server
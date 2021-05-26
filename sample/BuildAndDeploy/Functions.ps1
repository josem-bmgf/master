
#=============================
# Functions
#=============================

function ReplaceText([string]$textfile, [string]$origtext, [string]$newtext) {

	(Get-Content $textfile) | 
	Foreach-Object {$_ -replace "$origtext", "$newtext"} |  
	Set-Content $textfile

}

function DeployDB([string]$name, [string]$DBName, [string]$DBServer, [string]$ETLServer, [string]$NoRestore)
{
    $Full_Path = (Get-Location -PSProvider FileSystem).ProviderPath
    [string]$path = $Full_Path+"\Database\"+$DBName
	[string]$modelfile = $path+".dacpac"
	[string]$manifestfile = $path+".deploymanifest"
	[string]$sqlfile = $path+".sql"
	[string]$sqlquery = "EXEC ["+$DBName+"].dbo.sp_changedbowner @loginame = N'sa', @map = false"

	# Replace DB name from the schema
	#[xml]$xml = gc $modelfile
	#$RemoveElement = $xml.DataSchemaModel.SelectSingleNode("Model")
	#$CheckElement = $RemoveElement.Element | where {$_.Type -eq "ISql90User"}
	#if ($CheckElement -ne $Null) {
	#	foreach ($item in $CheckElement) {
	#		[void]$RemoveElement.RemoveChild($RemoveElement.SelectSingleNode("Element[@Type='ISql90User']"))
	#	}
	#}
	#$CheckElement = $RemoveElement.Element | where {$_.Type -eq "ISqlRoleMembership"}
	#if ($CheckElement -ne $Null) {
	#	foreach ($item in $CheckElement) {
	#		[void]$RemoveElement.RemoveChild($RemoveElement.SelectSingleNode("Element[@Type='ISqlRoleMembership']"))
	#	}
	#}
	
	#$xml.save($modelfile)

	if ($FullDeploy -eq "True") {

		[string]$cs = "Persist Security Info=False;Integrated Security=true;Server="+$DBServer
		[string]$sqlfile = $path+".sql"

		# Update Sourcehub.dbschema
		#IF($DBName -eq "SourceHub") {
		#(Get-Content Database\SourceHub.dbschema) | Foreach-Object {$_ -replace "Level2 on PaymentType= DimGLAccount.PaymentType and Program = DimGLAccount.Program", "Level2 on Level2.PaymentType= DimGLAccount.PaymentType and Level2.Program = DimGLAccount.Program" } | Set-Content Database\SourceHub.dbschema
		#}

		# Deploy DB
		#Display("Full deployment - recreating " + $DBName + " DB to " + $DBServer)
		#.\VSDBCMD /a:Deploy /dd:- /cs:$cs /dsp:Sql /model:$modelfile /p:TargetDatabase=$DBName /p:AlwaysCreateNewDatabase=True /manifest:$manifestfile /script:$sqlfile

		sqlcmd -b -S $DBServer -i $sqlfile
		sqlcmd -b -S $DBServer -Q $sqlquery

	} else {

		[string]$cs = "Persist Security Info=False;Initial Catalog="+$DBName+";Integrated Security=true;Server="+$DBServer
		#[string]$CurrentSchema = $path+"_Current.dacpac"
		[string]$sqlfile = $Full_Path+"\DBScripts\"+$DBName+".sql"

		# No DB restore option - incremental deployment
		if ($NoRestore -eq "True") {
			# Get existing DB schema
			$sqlfile = $path+"_Incremental.sql"
			Display("Incremental deployment of " + $DBName + " DB to " + $DBServer)
			#.\VSDBCMD /a:Import /cs:$cs /dsp:sql /model:$CurrentSchema
			#.\VSDBCMD /a:Deploy /dd:- /dsp:sql /model:$modelfile /targetmodelfile:$CurrentSchema /ManifestFile:$manifestfile /DeploymentScriptFile:$sqlfile /p:TargetDatabase=$DBName /p:AlwaysCreateNewDatabase=False /p:GenerateDeployStateChecks=False /p:IgnorePermissions=True /p:BlockIncrementalDeploymentIfDataLoss=False
			#.\VSDBCMD /a:Deploy /dd:- /cs:$cs /dsp:Sql /model:$modelfile /p:TargetDatabase=$DBName /p:AlwaysCreateNewDatabase=False /manifest:$manifestfile /script:$sqlfile /p:GenerateDeployStateChecks=False /p:IgnorePermissions=True /p:BlockIncrementalDeploymentIfDataLoss=False
		}

		# Inject for FoundationEDW upserts
		if ($DBName -eq 'FoundationEDW') {
			(Get-Content $sqlfile) | Foreach-Object {$_ -replace "localhost", $ETLServer} | Set-Content $sqlfile
		}

		sqlcmd -b -S $DBServer -i $sqlfile
		sqlcmd -b -S $DBServer -Q $sqlquery
	}

	# Set recovery model to SIMPLE for lower environments only
	If (!(($EnvName -eq "STG") -or ($EnvName -eq "PRD"))) {
		Write-Output "Setting $DBName recovery mode to SIMPLE..."
		$sqlquery = 'ALTER DATABASE [' + $DBName + '] SET RECOVERY SIMPLE WITH NO_WAIT'
		sqlcmd -b -S $DBServer -Q $sqlquery
	}

}

function Display([string]$message)
{
	
	$message = $message + " - " + (Get-Date).ToString()
	
	Write-Output $("=" * ($message.length));
	Write-Output $message;
	Write-Output $("=" * ($message.length));
}


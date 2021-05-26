# ============================================================================
# Reports deployment
# ============================================================================

Param ( 
    [parameter(mandatory=$true)]
	[ValidateSet("AS1","DEV","TST","TST2","STG","PRD")]  
	[string] $Env,
    [ValidateSet("True","False")]
	[string] $FullDeploy = "False"
)

trap {"Error found: $_"; break;}

. ".\Functions.ps1"

#=============================
# MAIN
#=============================

function Main()
{
CLS

#Display("Starting Reports deployment")

# Set environment variables
# ===========================================
#Display("Getting Environment specific variables")
[xml]$EnvConfig = Get-Content "Environment.xml"

$EnvVars = $EnvConfig.Environments.Environment | Where {$_.Name -eq $Env}
[string]$EnvName = $EnvVars.Name
[string]$DomainName = $EnvVars.Domain
[string]$FOServer = $EnvVars.Svr_FO
[string]$RPTServer = $EnvVars.Svr_ReportWeb
[string]$RptDB = $EnvVars.Rpt_DBname
[string]$RPTSql = $EnvVars.Svr_ReportSQL
[string]$RptUser = $EnvVars.Rpt_User
[string]$RptPass = $EnvVars.Rpt_Pass
[string]$RptIsWin = $EnvVars.Rpt_ISWINCREDENTIAL
#Display("Deploying to: " + $EnvName)

# ===========================================

# Evironment Inject
Write-Output "Setting up Report Deployer configuration."
$Full_Path = (Get-Location -PSProvider FileSystem).ProviderPath

[string]$RptConfig = $Full_Path+"\ReportDeployer.exe.Config"

if($FullDeploy -eq $false)
{
	[string]$RptXml = $Full_Path+"\ReportDeployerConfig\reportMetadata_Incremental.xml"
}
else
{
	[string]$RptXml = $Full_Path+"\ReportDeployerConfig\reportMetadata.xml"
}
[string]$InvestmentScore = "Data Source=" + $RPTSql + ";Initial Catalog=$RptDB"

(Get-Content $RptConfig) | Foreach-Object {$_ -replace "RPTServer", $RPTServer} | Set-Content $RptConfig

#if($FullDeploy -eq $false)
#{
#    (Get-Content $RptConfig) | Foreach-Object {$_ -replace "EDWReport", "EDWReport_Incremental"} | Set-Content $RptConfig    
#}

[xml]$RptMeta = Get-Content $RptXml
$InvestmentScoreDC = $RptMeta.ROOT.DATASOURCE | Where { $_.name -eq "Scoring" }
$InvestmentScoreDC.connection = $InvestmentScore
$InvestmentScoreDC.UserName = $RptUser
$InvestmentScoreDC.UserPass = $RptPass
$InvestmentScoreDC.isWinCredential = $RptIsWin


$RptMeta.Save($RptXml)

# Deploy Reports

$Rpt_Path = $Full_Path
cd $Rpt_Path

.\ReportDeployer.exe "InvestmentScore"

cd $Full_Path

#Display("Reports Deployment Completed")
}

Main $args




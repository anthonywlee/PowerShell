###########################################################################
###########################################################################
## 
## File: New-PSScript.ps1
## Name: Anthony Lee
## Date: 8/23/2011
## Desc. One Script to Create them all!
##
###########################################################################
###########################################################################
param($Name,$Path,$Functions,[switch]$Edit,[switch]$Help)

if($Help)
{
	Write-Output "Basic Usage: .\New-PSScript.ps1 -Name -Path -Help"
	break
}

$FullName = $Path + "\" + $Name
$FunctionArchive = "FunctionArchive.txt"
	# list of archived functions
$IndexFile = "FunctionIndex.csv"
	# index of functions
$Type = "File"
$User = (Get-WMIObject -class Win32_ComputerSystem).UserName.Split("\")
$Date = (Get-Date).ToShortDateString() 
$Header = "
###########################################################################
###########################################################################
## 
## File: " + $Name + "
## Name: " + $User[1] + "
## Date: " + $Date + "
## Desc. 
##
###########################################################################
###########################################################################

########################### Change Log ####################################
##
## Modified Date:
## Mod By: 
## Changes: 
##
###########################################################################
###########################################################################

############################# Header ######################################
## DECLARE PARAMETERS, ADDINS/SNAPINS, AND GLODAL VARIABLES
##
Add-PSSnapin Quest.ActiveRoles.ADManagement -errorAction SilentlyContinue
###########################################################################
###########################################################################

############################# Notes #######################################
## 
###########################################################################
###########################################################################"

$Main = "
############################# Main ########################################
##" 

$Ending = 
"###########################################################################
###########################################################################


###########################################################################
###########################################################################

######################### End of Script ###################################

###########################################################################
###########################################################################"

#################### Function Get-FunctionContents ########################
##
Function Get-FunctionContents
{	
	$i = $FunctionBegins - 1
	$n = $FunctionEnds
	
	while($i -le $n)
	{
		[array]$FunctionContents = $FunctionContents + "`n" + $ScriptContents[$i]
		$i++
	}
}
######################### End Get-FunctionContents ########################
###########################################################################
###########################################################################

#################### Function Get-FunctionEnds ############################
##
Function Get-FunctionEnds
{
	$EndName = "End " + $FunctionName
	
	ForEach($line in $ScriptContents)
	{
		if($line.Contains($EndName))
		{
			$FunctionEnds = $line.ReadCount
		}
	}
}
######################### End Get-FunctionEnds ############################
###########################################################################
###########################################################################

#################### Function Get-FunctionBegins ##########################
##
Function Get-FunctionBegins
{
	$Begin_FunctionName = "Function " + $FunctionName
	ForEach($line in $ScriptContents)
	{
		if($line.Contains($Begin_FunctionName) -AND $line.Contains("#####"))
		{
			$FunctionBegins = $line.ReadCount
		}
	}
}
######################### End Get-FunctionBegins ############################
###########################################################################
###########################################################################

#################### Function Get-Function #################################
##
## Returns the functions name and the patht to the script it which
## it resides.
Function Get-Function
{
	ForEach($Line in $Index)
	{
		$Line_Split = $Line.Split(",")
		if($Line_Split -eq $Function)
		{
			$FunctionName = $Line_Split[0]
			[int]$FunctionBegins = $Line_Split[1]
			[int]$FunctionEnds = $Line_Split[2]
		}
	}
}
######################### End Get-Function ####################################
###########################################################################
###########################################################################


############################# Main ########################################
##
if($Functions)
{	
	$ScriptContents = Get-Content $FunctionArchive
	$Index = Get-Content $IndexFile
	
	ForEach($Function in $Functions)
	{
		. Get-Function
		## Was used when the script looked to an index file.
		#. Get-FunctionBegins
		#. Get-FunctionEnds
		. Get-FunctionContents
		[array]$Call_Functions = $Call_Functions + "`n" + $FunctionName
	}	
}
## Inserting the sections into the script
$Value = $Header + "`n" + $FunctionContents + $Main + "`n" + $Call_Functions + "`n" + $Ending

## This was used to create the Function.Archive.txt
# [string]$Value = $FunctionContents

## Create the script
New-Item -Name $Name -Path $Path -Type $Type -Value $Value

## This was used to create the FunctionArchive.txt
# $Value | Out-File $Name -Append

## If the open switch is called, open new script in notepad++
if($Edit -eq $TRUE)
{
	C:\Program` Files\Notepad++\notepad++.exe $FullName
}

###########################################################################
###########################################################################

######################### End of Script ###################################

###########################################################################
###########################################################################

###########################################################################
###########################################################################
## 
## File: Get-PhysicalMemory.ps1
## Name: anthony.lee
## Date: 4/10/2013
## Desc. Uses wmi to query for information about the physical memory 
##			from a list of machines.
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
param ([string]$InFile,[string]$OutFile,[switch]$Help)
############################# Header ######################################
## DECLARE PARAMETERS, ADDINS/SNAPINS, AND GLODAL VARIABLES
##
Add-PSSnapin Quest.ActiveRoles.ADManagement -errorAction SilentlyContinue
###########################################################################
###########################################################################

############################# Notes #######################################
## 
###########################################################################
###########################################################################

############################# Main ########################################
##
If(!($InFile) -OR $Help)
{
	Write-Host "Usage: .\Get-PhycicalMemory.ps1 -InFile [Path to file] -OutFile [File Name.csv] -Help"
	Break
}

$Computers = Get-Content $InFile

Foreach($c in $Computers)
{
	$CompName = (Get-WMIObject -class Win32_ComputerSystem -ComputerName $c).name
	If(!($CompName))
	{
		$OutPut = "Machine Not Available"
	}
	Else
	{
		$i = 0
		$Memory_Capacity = (Get-WMIObject -class Win32_ComputerSystem -ComputerName $CompName).TotalPhysicalMemory
		$Memory_Tag = (Get-WMIObject -class Win32_PhysicalMemory -ComputerName $CompName).Tag
		
		Foreach($U in $Memory_Tag)
		{
			$i++
			$Memory_Units = $i
		}
		
		$OutPut = $CompName + "," + $Memory_Capacity + "," + $Memory_Units
		$OutPut | Out-File $OutFile -Append
	}
	$OutPut = ""
	$CompName = ""
}
###########################################################################
###########################################################################


###########################################################################
###########################################################################

######################### End of Script ###################################

###########################################################################
###########################################################################
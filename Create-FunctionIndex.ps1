###########################################################################
###########################################################################
## 
## File: Create-FunctionIndex.ps1
## Name: anthony.lee
## Date: 9/2/2011
## Desc. Creates an index file of funcitons located in FunctionArchive.txt
##		 Output: FunctionIndex.csv
##		 Format: [Function_Name],[Beginning_Line_Number],[Ending_Line_Number]
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
$FunctionArchive = "FunctionArchive.txt"
$OutFile = "FunctionIndex.csv"
###########################################################################
###########################################################################

############################# Notes #######################################
## 
###########################################################################
###########################################################################
  
#################### Function Get-FunctionEnds ############################ 
##
## Searches a script for a specified function and finds the line number of
## where it ends including ending comments.
Function Get-FunctionEnds 
{ 
 	$EndName = "End " + $FunctionName 
 	 
 	ForEach($line in $Script_Contents) 
 	{ 
 		if($line.Contains($EndName)) 
 		{ 
 			$FunctionEnds = $line.ReadCount + 2
 		} 
 	} 
} 
######################### End Get-FunctionEnds ############################ 
########################################################################### 
########################################################################### 

#################### Function Get-FunctionBegins ########################## 
##
## Searches a script for a specified function and finds the line number of
## where it begins including beginning comments. 
Function Get-FunctionBegins 
{
 	$Begin_FunctionName = "Function " + $FunctionName
 	ForEach($line in $Script_Contents) 
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

#################### Function Get-Functions ###############################
## Searches the contects of a script for function statements and outputs
## those to a file
Function Get-Functions
{ 
	$Script_Contents = Get-Content $FunctionArchive

	ForEach($line in $Script_Contents)
	{
		if($line.StartsWith("Function"))
		{
			$line = $line.Split(" ")
			$FunctionName = $line[1].TrimEnd("()")
			
			. Get-FunctionBegins
			. Get-FunctionEnds
			
			## Format the output in a simple csv style
			$OutPut = $FunctionName + "," + $FunctionBegins + "," + $FunctionEnds

			## Create the outfile
			$OutPut | Out-File $OutFile -Append
		}
	}
}
######################### End Get-Functions ###############################
###########################################################################
###########################################################################
 
############################# Main ########################################
##
## If the FunctionIndex.csv exists then remove it.
if(Get-Item FunctionIndex.csv)
{
rm FunctionIndex.csv
}

	. Get-Functions
	# . Get-FunctionBegins
	# . Get-FunctionEnds

# ## Format the output in a simple csv style
# $OutPut = $FunctionName + "," + $FunctionBegins + "," + $FunctionEnds

# ## Create the outfile
# $OutPut | Out-File $OutFile -Append
###########################################################################
###########################################################################


###########################################################################
###########################################################################

######################### End of Script ###################################

###########################################################################
###########################################################################
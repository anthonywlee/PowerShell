## Set script parameters (This must be the first line if using script parameters)
param([string]$Infile, [string]$Domain, [switch]$Help)

if(($Help) -OR !($Infile -AND $Domain))
{
    "+++++++++++++++++++++++"
    "Parameters not found:"
    "-Infile [CSV file]"
    "-Domain [Domain user in CSV live]"
    "+++++++++++++++++++++++"
    break
}

## Import Active Directory PowerShell Modules
import-module activedirectory

## Import CSV file into local variable
$UserList = (Import-CSV $Infile)
$Catches = 0

## Loop through the CSV file, which is now imported into $UserList variable and execute code on each instance
Foreach($User in $UserList)
{
    ## Try to run commands. 
    Try
    {
        Set-ADUSer -server $Domain -Identity $User.'user name' -Replace @{StreetAddress=$User.Address} 
    }
    ## Catch the any errors and display custom error message.
    Catch
    {
        $Catches++ #<-- increment the Catches for error reporting
        "+++++++++++++++++++++++"
        "Error:"
        "{0} may not exist in {1}" -f $User.'user name',$Domain
        "+++++++++++++++++++++++"
    }
}

## Report number of errors
"+++++++++++++++++++++++"
"Script Summary"
"+++++++++++++++++++++++"
"Script Completed with:"
"{0} Errors" -f $Catches
"+++++++++++++++++++++++"

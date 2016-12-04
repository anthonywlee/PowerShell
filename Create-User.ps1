param([string]$Domain, [string]$OU, [string]$InFile, [switch]$Help)

# Add Quest ActiveRole AD Management if not found.
if(!(Get-PSSnapin -name "Quest.ActiveRoles.ADManagement"))
{
    Try
    {
        Add-PSSnapin Quest.ActiveRoles.ADManagement
    }
    Catch
    {
        "+++++++++++++++++++++++"
        "Error: Loading Quest.ActiveRoles.ADManagment Snapin."
        "Check that the Active Roles Management Shell for Active Directory has been properly installed"
        "+++++++++++++++++++++++"
        break
    }
}

# TODO: Uncomment when NewUser-AD is fixed and comment out above for Quest Active Roles.
<# if(!(Get-Module ActiveDirectory))
{
    Try
    {
        Import-Module ActiveDirectory
    }
    Catch
    {
        "+++++++++++++++++++++++"
        "Error: Loading Active Directory Powershell Modules."
        "Check that the Active Directory Powershell Modules are properly installed and configured on this computer."
        "+++++++++++++++++++++++"
        break
    }
} #>

if(($Help) -OR !($Domain -AND $OU -AND $InFile))
{
	Write-Host
	Write-Host "Usage: Create-User.ps1 -Domain -OU -InFile"
	Write-Host
	break
}

### Functions ###

Function FullOUPath([string]$Domain, [string]$OU)
{
	$arrOU = $OU.split("/")
	$arrDomain = $Domain.split(".")

	for($i=($arrOU.length);($i);$i--)
	{
		if($arrOU[$i])
		{
			$ParentContainer += "OU="+$arrOU[$i]+","
		}
	}
	$ParentContainer += "OU="+$arrOU[0]+","
	
	for(($i = 0);($i -lt $arrDomain.length);$i++)
	{
		if(!($i -eq ($arrDomain.length - 1)))
		{
			$ParentContainer += "DC="+$arrDomain[$i]+","
		}
		elseif($i -eq ($arrDomain.length - 1))
		{
			$ParentContainer += "DC="+$arrDomain[$i]
		}
	}

	return $ParentContainer
}

## TODO:
## Fix this function so that it creates the account with the DisplayName (last, first) as the CN instead of the UserID (first.last).
Function NewUser-AD([string]$InFile, [string]$Domain, [string]$OU) #<-- Using built in AD cmdlets. This doesn't really work so it's not used in Main.
{
	$List = Import-CSV $InFile -delimiter ","
	$Password = (Read-Host "Please enter a password" -AsSecureString)
	$Path =  (FullOUPath $Domain $OU)

	Foreach($line in $List)
	{
		Write-Host "Creating account for:" $line.Display
		
		New-QADUser -Server $Domain -Path $Path -Name $line.Display -AccountPassword $Password -ChangePasswordAtLogon $TRUE -Enabled $TRUE -OtherAttributes @{
			'company'=$line.Company; ## Company
			'department'=$line.Department; ## Department
			'displayname'=$line.Display; ## Display name taken from the "NewCN" field.
			'employeeid'=$line.EmpID; ## Employee ID
			'givenName'=$line.'First Name'; ## First Name
			'initials'=$line.Initials; ## Middle Initials
			'l'=$line.City; ## City ("l=" overwrites the city field)
			'office'=$line.Office; ## Office name
			'postalCode'=$line.'Zip Code'; ## Zip code
			'postOfficeBox'=$line.POBox; ## Post Office Box
			'sn'=$line.LastName; ## Last Name
			'st'=$line.State; ## State
			'streetAddress'=$line.Address; ## Physical Street Address
			'telephoneNumber'=$line.Phone; ## Primary Telephone
			'title'=$line.Title; ## Title
		}
	}
}

Function NewUser-QAD([string]$InFile, [string]$Domain, [string]$OU) #<-- Used in Main. Requires Quest Software Active Role AD cmdlets installed on computer running the script.
{
	$List = Import-CSV $InFile -delimiter ","
	$Password = (Read-Host "Please enter a password" -AsSecureString)
	$Path =  (FullOUPath $Domain $OU)

	Foreach($line in $List)
	{
		If(!((Get-QADUser -service $Domain -identity $line.userID) -AND ($line.userID -ne $NULL)))
		{
			Write-Host "Creating Account for:" $line.UserID
			New-QADUser -Service $Domain -ParentContainer $Path -Name $line.Display -samAccountName $line.UserID -Password $Password -ObjectAttributes @{
				'company'=$line.Company; ## Company
				'department'=$line.Department; ## Department
				'displayname'=$line.Display; ## Display name taken from the "NewCN" field.
				'employeeid'=$line.EmpID; ## Employee ID
				'givenName'=$line.'First Name'; ## First Name
				'initials'=$line.Initials; ## Middle Initials
				'l'=$line.City; ## City ("l=" overwrites the city field)
                'scriptPath'=$line.'Logon Script' ## Logon Script
				'office'=$line.Office; ## Office name
				'postalCode'=$line.'Zip Code'; ## Zip code
				'postOfficeBox'=$line.POBox; ## Post Office Box
				'sn'=$line.'Last Name'; ## Last Name
				'st'=$line.State; ## State
				'streetAddress'=$line.Address; ## Physical Street Address
				'telephoneNumber'=$line.Phone; ## Primary Telephone
				'title'=$line.Title; ## Title
				'userPrincipalName'=$($line.UserID+"@"+$Domain) ## UserPrincipalName [first.last@domain.ds.ky.gov]
			}
		}
		Else
		{
			Write-Host "Account for "$line.UserID.trim()" already exists"
			break
		}
		
		Set-QADUser -Service $Domain -Identity $line.UserID -UserMustChangePassword $TRUE
	}
}

############################################################
## Main 
############################################################

if(!($Domain -And $OU))
{
	Write-Host
	Write-Host "Create-User.ps1 -InFile -Domain -OU"
	Write-Host
	break
}

NewUser-QAD $InFile $Domain $OU
# TODO: Uncomment when this function is fixed and comment out above "NewUser-QAD"
# NewUser-AD $InFile $Domain $OU




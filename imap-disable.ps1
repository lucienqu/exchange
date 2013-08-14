$errorView = "CategoryView"
## Logging setup
function write-log([string]$info){            
    if($loginitialized -eq $false){            
        $FileHeader > $logfile            
        $script:loginitialized = $True            
    }            
    $info >> $logfile            
} 

## Logfile Info           
$script:logfile = ".\imap-disable-$(get-date -format MMddyyHHmmss).log"            
$script:Seperator = @"

"@            
$script:loginitialized = $false            
$script:FileHeader = @"
$("-" * 50)
***Application Information***
Filename:imap-disable.ps1
Created by:  Shon Miles
Last Modified:  $(Get-Date -Date (get-item .\imap-disable.ps1).LastWriteTime -f MM/dd/yyyy)
$("-" * 50)
"@

## Import data from CSV file and store it in variable 'data' array
$data = import-csv $args[0]

## Loop through data array and perform action
foreach ($i in $data)
	{
$error.clear()
## Setup some variables
$DomainUser = "DMACC\" + $i.Alias.Trim()

		Write-Host "Disabling IMAP for" $DomainUser "!" -foregroundcolor white
		Set-CASMailbox -Identity $DomainUser -ImapEnabled $false -DomainController andc08.campus.dmacc.edu -ea SilentlyContinue
		
		If ($error.count -gt 0)
			{
				write-log $("*" * 50)
				write-log "There was an error trying to disable IMAP for $($DomainUser)! The error was..."
				write-log $error
				write-log $("*" * 50)
			}
		Else
			{
				write-log "Disabled IMAP for user: $($DomainUser)."
			}
		

}
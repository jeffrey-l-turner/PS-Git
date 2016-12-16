# This is a sample startup profile for use with Posh-git
$h = (Get-Host).UI.RawUI;

$h.BackgroundColor = "Blue" # RGB equiv for Atom is: ?
$h.ForegroundColor = "White";
#cls

#start-ssh-agent.cmd # this is started by default with post-git module using -quiet
cd ~\source\PS-Git
. .\posh-git.ps1
$h.WindowTitle = "Posh Git PowerShell Session for - Jeff Turner";

$global:GitAllSettings = New-Object PSObject -Property @{
	FolderForegroundColor       = [ConsoleColor]::Cyan
}

function export-command-hist()
{
	Get-History | Export-Csv C:\temp\CommandHistory.CSV
}

function import-command-hist()
{
 	Import-Csv C:\temp\CommandHistory.CSV | Add-History
}
 
function git-all()
{
	$s = $global:GitAllSettings
	dir -r -i .git -fo | % {
 		pushd $_.fullname
 		cd ..
 		write-host -fore $s.FolderForegroundColor (get-location).Path
 		git-trackall
 		popd
 	}
}
 
function git-trackall()
{
	$branchessp = git branch | %{$_ -replace "origin/"}
	$branches = echo $branchessp | %{$_ -replace " *"}
	if($branches){
		$branches | foreach {
			# if not on current branch
			if ($_.StartsWith("*")){
				Write-Host $_ ': current branch will not be tracked'
			}else{
				Write-Host 'Tracking ' $_
				git branch --track $_ 
			}
		}
	}else{
		Write-Host 'No tracked branches for this repository'
	}
	git status
}
 
[System.Reflection.Assembly]::LoadWithPartialName("System.Diagnostics")
 
$sw = new-object system.diagnostics.stopwatch
$sw.Start()
 
#git-all
 
#git remote update 
#git pull -a

$sw.Stop()
Write-Host "Completed in " $sw.Elapsed
#git branch -v

import-command-hist


Function Get-MyHistory {
<#

.SYNOPSIS
Gets a list of the commands entered during the current session.

.DESCRIPTION
The Get-MyHistory cmdlet gets session history, that is, the list of commands entered during the current session. This is a modified version of Get-History. In addition to the parameters of the original command, this version allows you to select only unique history entries as well as filter by a regular expression pattern.
Windows PowerShell automatically maintains a history of each session. The number of entries in the session history is determined by the value of the $MaximumHistoryCount preference variable. Beginning in Windows PowerShell 3.0, the default value is 4096.
You can save the session history in XML or CSV format. By default, history files are saved in the home directory, but you can save the file in any location.


For more information about the history features in Windows PowerShell, see about_History (http://go.microsoft.com/fwlink/?LinkID=113233).

.PARAMETER Count
Displays the specified number of the most recent history entries. By, default, Get-MyHistory gets all entries in the session history. If you use both the Count and Id parameters in a command, the display ends with the command that is specified by the Id parameter.

In Windows PowerShell 2.0, by default, Get-MyHistory gets the 32 most recent entries.

.PARAMETER Id
Specifies the ID number of an entry in the session history. Get-MyHistory gets only the specified entry. If you use both the Id and Count parameters in a command, Get-MyHistory gets the most recent entries ending with the entry specified by the Id parameter.

.PARAMETER Pattern
A regular expression pattern to match something in the commandline.

.PARAMETER Unique
Only display command history items with a unique command.
.EXAMPLE
PS C:\>Get-MyHistory -unique
This command gets the unique entries in the session history. The default display shows each command and its ID, which indicates the order of execution as well as the command's start and stop time.

.EXAMPLE
PS C:\>Get-MyHistory -pattern "service"
This command gets entries in the command history that include "service". 

.NOTES
The session history is a list of the commands entered during the session. The session history represents the order of execution, the status, and the start and end times of the command. As you enter each command, Windows PowerShell adds it to the history so that you can reuse it. For more information about the command history, see about_History (http://go.microsoft.com/fwlink/?LinkID=113233).

Beginning in Windows PowerShell 3.0, the default value of the $MaximumHistoryCount preference variable is 4096. In Windows PowerShell 2.0, the default value is 64. For more information about the $MaximumHistoryCount variable, see about_Preference_Variables (http://go.microsoft.com/fwlink/?LinkID=113248).

Learn more about PowerShell:
http://jdhitsolutions.com/blog/essential-powershell-resources/

  ****************************************************************
  * DO NOT USE IN A PRODUCTION ENVIRONMENT UNTIL YOU HAVE TESTED *
  * THOROUGHLY IN A LAB ENVIRONMENT. USE AT YOUR OWN RISK.  IF   *
  * YOU DO NOT UNDERSTAND WHAT THIS SCRIPT DOES OR HOW IT WORKS, *
  * DO NOT USE IT OUTSIDE OF A SECURE, TEST SETTING.             *
  ****************************************************************

.INPUTS
Int64

.OUTPUTS
Microsoft.PowerShell.Commands.HistoryInfo
.LINK
Add-History
Clear-History
Invoke-History
.LINK
about_History
#>
[CmdletBinding()]
Param(

    [Parameter(Position=0, ValueFromPipeline=$true)]
    [ValidateRange(1, 9223372036854775807)]
    [long[]]$Id,

    [Parameter(Position=1)]
    [ValidateRange(0, 32767)]
    [int]$Count,

    #parameters that I added
    [switch]$Unique,
    [regex]$Pattern
)

Begin {
    #insert verbose messages to provide debugging and tracing information
    Write-Verbose "Starting $($MyInvocation.Mycommand)"
    Write-Verbose "Using parameter set $($PSCmdlet.ParameterSetName)"
    Write-Verbose ($PSBoundParameters | out-string)

    #remove Unique and Pattern parameters if used since they are not part of Get-History
    if ($Unique) {
        $PSBoundParameters.Remove("Unique") | Out-Null
    }
    if ($Pattern) {
        $PSBoundParameters.Remove("Pattern") | Out-Null
    }
} #begin

Process {

    #splat bound parameters to Get-History
    $all = Get-History @PSBoundParameters
    
    if ($Pattern) {
        #use v4 Where method for performance purposes
        Write-Verbose "Searching for commandlines matching $pattern"
        $all = $all.where({$_.commandline -match $pattern})
    }

    if ($Unique) {
        Write-Verbose "Selecting unique items"
        $all = $all | Select-Object -Unique 
    }

    #write results to pipeline and add a new property
    $all | Add-Member -MemberType ScriptProperty -Name "Runtime" -value {$this.EndExecutionTime - $this.StartExecutionTime} -PassThru -force
   
} #process

End {
    Write-Verbose "Ending $($MyInvocation.Mycommand)"
} #end

} #end function Get-MyHistory

#define an optional alias
Set-Alias -Name gmh -Value Get-MyHistory

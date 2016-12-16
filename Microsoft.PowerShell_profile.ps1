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

function command-hist()
{
	Get-History | Export-Csv C:\temp\CommandHistory.CSV
}

function save-command-hist()
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


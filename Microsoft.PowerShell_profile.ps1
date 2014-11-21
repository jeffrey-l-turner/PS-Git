$h = (Get-Host).UI.RawUI;

$h.BackgroundColor = "Black"
$h.ForegroundColor = "White";
cls

#start-ssh-agent.cmd
# Load posh-git example profile
. 'G:\Dev\posh-git\profile.example.ps1'
cd g:\Dev\systemx
$h.WindowTitle = "Posh Git PowerShell Session for - Jeff Turner";

$global:GitAllSettings = New-Object PSObject -Property @{
	FolderForegroundColor       = [ConsoleColor]::Cyan
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
				git branch -f --track $_ 
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
 
git-all
 
git remote update 
git pull -a

$sw.Stop()
Write-Host "Completed in " $sw.Elapsed
git branch -v


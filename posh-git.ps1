Push-Location (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent)

# Load posh-git module from current directory
#Import-Module .\posh-git

# If module is installed in a default location ($env:PSModulePath),
# use this instead (see about_Modules for more information):
Import-Module posh-git

[System.Collections.Stack]$GLOBAL:dirStack = @()
$GLOBAL:oldDir = ''
$GLOBAL:nowPath = ''
$GLOBAL:addToStack = $true

# Set up a simple prompt, adding the git prompt parts inside git repos, enable bd/back directory function
function global:prompt {
    $realLASTEXITCODE = $LASTEXITCODE
    $global:LASTEXITCODE = $realLASTEXITCODE

    $GLOBAL:nowPath = (Get-Location).Path
    if(($GLOBAL:nowPath -ne $oldDir) -AND ($GLOBAL:addToStack)){
        $GLOBAL:dirStack.Push($oldDir)
        $GLOBAL:oldDir = $GLOBAL:nowPath
    }
    $GLOBAL:AddToStack = $true

    Write-Host($pwd.ProviderPath) -nonewline

    Write-VcsStatus

    return "> "
}

function BackOneDir{
    echo $GLOBAL:addToStack
    echo $GLOBAL:dirStack
    if(($GLOBAL:nowPath -ne $oldDir) -AND $GLOBAL:addToStack -AND ($GLOBAL:oldDir -ne '')){
    	$lastDir = $GLOBAL:dirStack.Pop()
    	cd $lastDir
    }
    $GLOBAL:addToStack = $false
}
Set-Alias bd BackOneDir

Pop-Location

Start-SshAgent -Quiet


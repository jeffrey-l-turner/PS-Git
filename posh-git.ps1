Push-Location (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent)

# Load posh-git module from current directory
#Import-Module .\posh-git

# If module is installed in a default location ($env:PSModulePath),
# use this instead (see about_Modules for more information):
Import-Module posh-git

[System.Collections.Stack]$GLOBAL:dirStack = @()
$GLOBAL:oldDir = ''
$GLOBAL:addToStack = $true

# Set up a simple prompt, adding the git prompt parts inside git repos, enable bd/back directory function
function global:prompt {
    $realLASTEXITCODE = $LASTEXITCODE
    $global:LASTEXITCODE = $realLASTEXITCODE

    $GLOBAL:nowPath = (Get-Location).Path
    if(($nowPath -ne $oldDir) -AND ($GLOBAL:addToStack)){
        $GLOBAL:dirStack.Push($oldDir)
        $GLOBAL:oldDir = $nowPath
    }
    $GLOBAL:AddToStack = $true

    Write-Host($pwd.ProviderPath) -nonewline

    Write-VcsStatus

    return "> "
}

function BackOneDir{
    $lastDir = $GLOBAL:dirStack.Pop()
    $GLOBAL:addToStack = $false
    if(($nowPath -ne $oldDir) -AND $GLOBAL:addToStack){
    	cd $lastDir
    }
}
Set-Alias bd BackOneDir

Pop-Location

Start-SshAgent -Quiet


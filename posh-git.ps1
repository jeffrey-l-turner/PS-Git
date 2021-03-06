Push-Location (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent)

# Load posh-git module from current directory
#Import-Module .\posh-git

# If module is installed in a default location ($env:PSModulePath),
# use this instead (see about_Modules for more information):
Import-Module posh-git

[System.Collections.Stack]$GLOBAL:dirStack = @()
$global:LASTEXITCODE = $realLASTEXITCODE
$GLOBAL:oldDir = '~'
$GLOBAL:nowPath = '~'
$GLOBAL:addToStack = $true

# Set up a simple prompt, adding the git prompt parts inside git repos, enable bd/back directory function
function global:prompt {
    $realLASTEXITCODE = $LASTEXITCODE
    $global:LASTEXITCODE = $realLASTEXITCODE

    $GLOBAL:nowPath = $pwd.ProviderPath
    if(($GLOBAL:nowPath -ne $GLOBAL:oldDir) -AND ($GLOBAL:addToStack)){
        Write-Host(" nowPAth changed: ") -nonewline
        Write-Host($GLOBAL:nowPath) 

        if(($GLOBAL:dirStack.count) -eq 0){
            $GLOBAL:dirStack.push($GLOBAL:nowPath) 
        }
        $GLOBAL:dirStack.Push($GLOBAL:oldDir)
        $GLOBAL:oldDir = $GLOBAL:nowPath
    }
    $GLOBAL:AddToStack = $true

    Write-Host($pwd.ProviderPath) -nonewline

    Write-VcsStatus

    return "> "
}

function BackOneDir{
    if(($GLOBAL:dirStack.count) -gt 1){
        $GLOBAL:oldDir = $GLOBAL:dirStack.Pop()
        $GLOBAL:dirStack = @()
        $GLOBAL:dirStack.Push($GLOBAL:nowPath)
    } else {
        $GLOBAL:oldDir = $GLOBAL:dirStack.Pop()
        $GLOBAL:dirStack.Push($GLOBAL:nowPath)
    }
    $GLOBAL:addToStack = $false
    cd $GLOBAL:oldDir
}

Set-Alias bd BackOneDir

Pop-Location

Start-SshAgent -Quiet


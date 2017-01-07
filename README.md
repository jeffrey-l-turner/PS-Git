PS-Git
======

Git PowerShell setup

1. First install git: http://git-scm.com/download/win
2. Then, you may follow instructions from: https://github.com/dahlbyk/posh-git  or just execute:  
```Install-Module posh-git```  
_Note: this is an untrusted module per some corporate setups._ Therefore, you may need to install per: http://psget.net/  Execute from within PowerShell:  
```(new-object Net.WebClient).DownloadString("http://psget.net/GetPsGet.ps1") | iex```  
_Note: you must modify the default install script if you use the last method above._
  If you get an error stating that you must upgrade to PowerShell 3 or greater, this guide and installation may be helpful for Windows 7 and 8 users: https://www.linkedin.com/pulse/getting-powershell-5-running-windows-7-server-2008-r2-darwin-sanoy.
3. Customize the Microsoft.PowerShell_profile.ps1 in this directory to your liking. Typically, it is installed in the ~\\Documents\\WindowsPowerShell or, in my case, ~\\source\\PS-Git directories.
4. You can see if you have an existing $PROFILE by executing:
```Get-Item $PROFILE```
You can then add the customized Microsoft.PowerShell_profile.ps1 to that file or replace it. You may need to do:
```New-Item -Path $PROFILE -ItemType "file" -Force``` 
if one does not already exist
5. In corporate environments you may not have the proper execution policy to run scripts. You can determine this by running `Get-ExecutionPolicy` and then setting the policy via `Set-ExecutionPolicy RemoteSigned`. _See: https://technet.microsoft.com/en-us/library/ee176961.aspx_
6. The default PS-Readline script is used for colorization and better command line history along with bash style command completion. You must execute:   
```Install-Module PSReadline```  
  from an elevated shell to install it. The `Set-PSReadlineKeyHandler -Key Tab -Function Complete` sets up bash style completion. Change it to your liking or read the instructions at https://github.com/lzybkr/PSReadLine for more customization options.
7. There is also command completion for `npm` in the profile. You must execute, from an elevated shell:  
```Find-Module TabExpansionPlusPlus -repository PsGallery | Install-Module -Scope AllUsers```  
```Find-Module NPMTabCompletion -repository PsGallery | Install-Module -Scope AllUsers```  
  to enable.

  _Other Useful Utilities:_
    https://pscx.codeplex.com/ (```Find-Package pscx | Install-Package```)
    https://github.com/bmatzelle/gow  [GoW Installation Page](https://github.com/bmatzelle/gow/downloads "Download")



PS-Git
======

Git PowerShell setup

1. First install git: http://git-scm.com/download/win
2. Then, you may follow instructions from: https://github.com/dahlbyk/posh-git  or just execute:  
```Install-Module posh-git```  
_Note: this is an untrusted module per some corporate setups._ Therefore, you may need to install per: http://psget.net/  Execute from within PowerShell:  
```(new-object Net.WebClient).DownloadString("http://psget.net/GetPsGet.ps1") | iex```  
_Note: you must modify the default install script if you use the last method above._

3. Customize the Microsoft.PowerShell_profile.ps1 in this directory to your liking. Typically, it is installed in the ~\\Documents\\WindowsPowerShell or  ~\\source\\PS-Git directories.
4. You can see if you have an existing $PROFILE by executing:
```Get-Item $PROFILE```
You can then add the customized Microsoft.PowerShell_profile.ps1 to that file or replace it. You may need to do:
```New-Item -Path $PROFILE -ItemType "file" -Force``` 
if one does not already exist
5. In corporate environments you may not have the proper execution policy to run scripts. You can determine this by running `Get-ExecutionPolicy` and then setting the policy via `Set-ExecutionPolicy RemoteSigned`. _See: https://technet.microsoft.com/en-us/library/ee176961.aspx_

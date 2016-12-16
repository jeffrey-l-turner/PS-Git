PS-Git
======

Git PowerShell setup

1. First install git: http://git-scm.com/download/win
2. Then, to use follow instructions from: https://github.com/dahlbyk/posh-git  
```Install-Module posh-git``` 
-- _Note: this is an untrusted module per some corporate setups._
-- or, You may need to install per: http://psget.net/  
From within PowerShell:   
```(new-object Net.WebClient).DownloadString("http://psget.net/GetPsGet.ps1") | iex```
-- _Note: you must modify the default install script if you use the alternative above._

3. Customize the Microsoft.PowerShell_profile.ps1 in this directory to your liking. Typically, install in a ~/source/PS-Git directory.

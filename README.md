# InternalToolSetup
Quick setup for accessing internal tools easier

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex "&{$((New-Object System.Net.WebClient).DownloadString('https://github.com/SpringboardIT/InternalToolSetup/raw/main/setup.ps1'))} global"
```
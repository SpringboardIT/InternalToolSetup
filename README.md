# InternalToolSetup
Quick setup for accessing internal tools easier

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex "&{$((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/SpringboardIT/InternalToolSetup/main/setup.ps1'))} global"
```
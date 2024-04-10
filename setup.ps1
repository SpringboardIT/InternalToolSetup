#region Self-Elevate
# source: https://stackoverflow.com/a/60216595
# Get the ID and security principal of the current user account
$myWindowsID=[System.Security.Principal.WindowsIdentity]::GetCurrent()
$myWindowsPrincipal=new-object System.Security.Principal.WindowsPrincipal($myWindowsID)

# Get the security principal for the Administrator role
$adminRole=[System.Security.Principal.WindowsBuiltInRole]::Administrator

# Check to see if we are currently running "as Administrator"
if ($myWindowsPrincipal.IsInRole($adminRole))
{
    # We are running "as Administrator" - so change the title and background color to indicate this
    $Host.UI.RawUI.WindowTitle = $myInvocation.MyCommand.Definition + "(Elevated)"
    $Host.UI.RawUI.BackgroundColor = "DarkBlue"
    clear-host
}
else
{
    # We are not running "as Administrator" - so relaunch as administrator

    # Create a new process object that starts PowerShell
    $newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell";

    # Specify the current script path and name as a parameter
    $newProcess.Arguments = $myInvocation.MyCommand.Definition;

    # Indicate that the process should be elevated
    $newProcess.Verb = "runas";

    # Start the new process
    [System.Diagnostics.Process]::Start($newProcess);

    # Exit from the current, unelevated, process
    exit
}
#endregion Self-Elevate

$hostsFile = "$env:SystemRoot\System32\Drivers\etc\hosts";

$targetIp = "192.168.30.178";
$hosts = 'docker.sit', 'nginx.sit', 'nuget.sit', 'portainer.sit';

Write "Updating Hosts"
if ((cat $hostsFile | Select-String $targetIp) -ne "")
{
    Write " | Hosts entry exists, updating..."
    $existingRow = "$(cat $hostsFile | Select-String $targetIp)".Trim();
    $rowInfo = (("$existingRow" -split "#")[0]).Trim();
    $segments = $rowInfo -split " ";

    $existingHosts = [Collections.Generic.List[String]]$segments[1..10000];

    foreach ($_host in $hosts) {
        if (!$existingHosts.Contains($_host)) {
            $existingHosts.Add($_host);
        }
    }

    $newRow = "$targetIp $existingHosts # SIT Internal";

    if ($existingRow -ne $newRow) {
        (Get-Content $hostsFile).Replace($existingRow, $newRow) | Set-Content $hostsFile;
        Write " | Updated hosts file.";
    }
    else {
        Write " | No changes necessary.";
    }
}
else {
    $newRow = "$targetIp $hosts # SIT Internal";

    (Get-Content $hostsFile).Append($newRow) | Set-Content $hostsFile;
}

Write-Host -NoNewLine "Press any key to continue...";
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown");
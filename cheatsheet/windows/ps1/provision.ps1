# Debugging?
### Set-PSDebug -Trace 2

# "C:\Program Files\OpenSSH" is the built-in server in the pristine image;
# "C:\Program Files\OpenSSH-Win64" is the new better version that can actually
# give us a TTY. Might be good to rename/destroy the old version.

$version = "v7.7.2.0p1-Beta"
$oldssh = "C:\Program Files\OpenSSH"
$newssh = "C:\Program Files\OpenSSH-Win64"
$cfgdir = "${env:ProgramData}\ssh"

# Unrelated to SSH but definitely desirable: turn off power management that
# might cause a VM to turn itself off while we're trying to use it.

powercfg /hibernate off
powercfg /x monitor-timeout-ac 0
powercfg /x monitor-timeout-dc 0
powercfg /x disk-timeout-dc 0
powercfg /x disk-timeout-ac 0
powercfg /x standby-timeout-ac 0
powercfg /x standby-timeout-dc 0
powercfg /x hibernate-timeout-dc 0
powercfg /x hibernate-timeout-ac 0

# Download and unpack the new server.

$url = "https://github.com/PowerShell/Win32-OpenSSH/releases/download/$version/OpenSSH-Win64.zip"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
(New-Object System.Net.WebClient).DownloadFile($url, 'OpenSSH-Win64.zip')
Expand-Archive 'OpenSSH-Win64.zip' -DestinationPath "C:\Program Files\"
rm 'OpenSSH-Win64.zip'

# For convenience, copy over the existing configuration files and host keys.
# But, the Ruby net.ssh implementation can only deal with a limited set of
# host key types. The new SSH server will prefer one unsupported by Ruby
# (ED25519) if the key exists. So, hide all but the RSA key, which has the
# broadest compatibility.

mkdir $cfgdir
cp $oldssh\etc\* $cfgdir

mkdir $cfgdir\oldkeys
mv $cfgdir\ssh_host_* $cfgdir\oldkeys
mv $cfgdir\oldkeys/ssh_host_rsa_key* $cfgdir

# We also need to modify the server config for SFTP to work. By default,
# however, when doing this sort of text processing PowerShell inserts a UTF8
# Byte Order Marker that messes up SSHD. The technique below avoids it.

$cfg = Get-Content $cfgdir\sshd_config | %{ $_ -replace "^Subsystem.*sftp.*", "Subsystem sftp sftp-server.exe" }
[IO.File]::WriteAllLines("$cfgdir\sshd_config", $cfg)

# Install the new SSH daemon, and fix up permissions. Note that a prior
# Vagrant provisioning step should have created our user's authorized_keys
# file using insecure Vagrant key.

cd $newssh
powershell -ExecutionPolicy Bypass -File install-sshd.ps1
powershell -ExecutionPolicy Bypass -File FixHostFilePermissions.ps1 -Confirm:$f
powershell -ExecutionPolicy Bypass -File FixUserFilePermissions.ps1 -Confirm:$f

# Poke firewall hole, turn off the old SSH, turn on the new one.

netsh advfirewall firewall add rule name=sshd dir=in action=allow protocol=TCP localport=22

Set-Service sshd -StartupType Automatic
Set-Service OpenSSHd -StartupType Disabled
Get-Service -Name OpenSSHd |Stop-Service
net start sshd

# Have it default to PowerShell. (Need to do this after the new server has
# started so that its registry keys exist.)

New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -PropertyType String -Force
New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShellCommandOption -Value "/c" -PropertyType String -Force

# Remove old SSH binaries from $PATH and add the new ones. (If we don't add
# the new one, scp won't work.)

$k = "Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment"
$path = (Get-ItemProperty -Path $k -Name PATH).path
$path = ($path.Split(';') | Where-Object { $_ -notlike '*SSH*' }) -join ';'
$path = "$path;$newssh"
Set-ItemProperty -Path $k -Name PATH -Value $path

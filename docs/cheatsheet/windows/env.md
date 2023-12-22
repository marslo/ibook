<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [default Windows Environment Variables List](#default-windows-environment-variables-list)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


## default [Windows Environment Variables List](https://ss64.com/nt/syntax-variables.html)
| Variable                | Default value assuming the system drive is C:                                                                                                                                                 |
| -                       | -                                                                                                                                                                                             |
| ALLUSERSPROFILE         | `C:\ProgramData`                                                                                                                                                                              |
| APPDATA                 | `C:\Users\{username}\AppData\Roaming`                                                                                                                                                         |
| ClientName              | Terminal servers only - the ComputerName of a remote host.                                                                                                                                    |
| CMDEXTVERSION           | The current Command Processor Extensions version number. (NT = "1", Win2000+ = "2".)                                                                                                          |
| CMDCMDLINE              | The original command line that invoked the Command Processor.                                                                                                                                 |
| CommonProgramFiles      | `C:\Program Files\Common Files`                                                                                                                                                               |
| COMMONPROGRAMFILES(x86) | `C:\Program Files (x86)\Common Files`                                                                                                                                                         |
| COMPUTERNAME            | {computername}                                                                                                                                                                                |
| COMSPEC                 | `C:\Windows\System32\cmd.exe` or if running a 32 bit WOW - `C:\Windows\SysWOW64\cmd.exe`                                                                                                      |
| ERRORLEVEL              | The current ERRORLEVEL value, automatically set when a program exits.                                                                                                                         |
| HOMEDRIVE               | `C:`                                                                                                                                                                                          |
| HOMEPATH                | `C:\Users\{username}`                                                                                                                                                                         |
| LOCALAPPDATA            | `C:\Users\{username}\AppData\Local`                                                                                                                                                           |
| LOGONSERVER             | `\\{domain_logon_server}`                                                                                                                                                                     |
| NUMBER_OF_PROCESSORS    | The Number of processors running on the machine.                                                                                                                                              |
| OS                      | Operating system on the user's workstation.                                                                                                                                                   |
| System                  | `C:\Windows\System32\;C:\Windows\;C:\Windows\System32\Wbem;{plus program paths}`                                                                                                              |
| ProgramData             | `C:\ProgramData`                                                                                                                                                                              |
| ProgramFiles            | `C:\Program Files or C:\Program Files (x86)`                                                                                                                                                  |
| ProgramFiles(x86) 1     | `C:\Program Files (x86)`   (but only available when running under a 64 bit OS)                                                                                                                |
| RANDOM                  | A random integer number, anything from 0 to 32,767 (inclusive).                                                                                                                               |
| `%SessionName%`         | Terminal servers only - for a terminal server session, SessionName is a combination of the connection name, followed by #SessionNumber. For a console session, SessionName returns "Console". |
| SYSTEMDRIVE             | `C:`                                                                                                                                                                                          |
| SYSTEMROOT              | By default, Windows is installed to C:\Windows but there's no guarantee of that, Windows can be installed to a different folder, or a different drive letter.                                 |
| TEMP and TMP            | `C:\Users\{Username}\AppData\Local\Temp`; Under XP this was `C:\{username}\Local Settings\Temp`                                                                                               |
| TIME                    | The current time using same format as TIME.                                                                                                                                                   |
| USERPROFILE             | `%SystemDrive%`\Users\{username}. This is equivalent to the $HOME environment variable in Unix/Linux                                                                                          |
| WINDIR                  | `%windir%` is a regular User variable and can be changed, which makes it less robust than `%SystemRoot%`; Set by default as windir=`%SystemRoot%`                                             |


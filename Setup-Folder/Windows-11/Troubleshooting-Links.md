# Troubleshooting Links for Windows 11

Here are reliable resources to help you resolve common issues when setting up SSH and file transfers on Windows 11.

## SSH and OpenSSH Issues

### Official Microsoft Documentation
- **[Install OpenSSH for Windows](https://docs.microsoft.com/en-us/windows-server/administration/openssh/openssh_install_firstuse)** - Microsoft's official guide to installing and configuring OpenSSH
- **[Windows OpenSSH Key Management](https://docs.microsoft.com/en-us/windows-server/administration/openssh/openssh_keymanagement)** - Managing SSH keys on Windows

### Common SSH Problems
- **[SSH Connection Troubleshooting](https://www.ssh.com/academy/ssh/troubleshoot)** - Comprehensive SSH troubleshooting guide
- **[Windows SSH Client Issues](https://superuser.com/questions/tagged/ssh+windows)** - Community solutions on Super User
- **[Fix SSH "Connection Refused" Errors](https://linuxhint.com/fix-ssh-connection-refused-error/)** - Common connection issues and solutions

## Command Prompt and PowerShell Help

### Basic Command Line Usage
- **[Windows Command Prompt Guide](https://www.howtogeek.com/235101/10-ways-to-open-the-command-prompt-in-windows-10/)** - How to open and use Command Prompt
- **[Windows PowerShell vs Command Prompt](https://www.howtogeek.com/163127/how-powershell-differs-from-the-windows-command-line/)** - Understanding the differences
- **[Basic Command Line Commands](https://www.digitalcitizen.life/command-prompt-how-use-basic-commands/)** - Essential commands for beginners

### File Path and Directory Issues
- **[Understanding Windows File Paths](https://www.howtogeek.com/181774/why-windows-uses-backslashes-and-everything-else-uses-forward-slashes/)** - Windows path conventions
- **[Navigate Folders in Command Prompt](https://www.howtogeek.com/659411/how-to-change-directories-in-command-prompt-on-windows-10/)** - Moving between folders

## Network and Connectivity Issues

### General Network Troubleshooting
- **[Windows Network Troubleshooter](https://support.microsoft.com/en-us/windows/fix-network-connection-issues-in-windows-f25b8739-c7ad-4d6c-50e9-77c4f4a7fd3b)** - Microsoft's built-in network troubleshooting
- **[Check Network Connection](https://www.howtogeek.com/howto/windows-vista/using-ping-to-test-your-network/)** - Using ping to test connectivity

### Wi-Fi and Local Network
- **[Windows Wi-Fi Problems](https://support.microsoft.com/en-us/windows/fix-wi-fi-connection-issues-in-windows-9424a1f7-6a3b-65a6-4d78-7f07eee84d2c)** - Official Microsoft Wi-Fi troubleshooting
- **[Find Devices on Local Network](https://www.howtogeek.com/28877/how-can-i-tell-what-is-connected-to-my-wireless-network/)** - Discovering network devices

## File Transfer Issues

### SCP and File Copy Problems
- **[SCP Command Guide](https://linuxize.com/post/how-to-use-scp-command-to-securely-transfer-files/)** - Comprehensive SCP usage guide
- **[Windows SCP Tutorial](https://winscp.net/eng/docs/guide_connect)** - Alternative SCP client for Windows
- **[File Permission Issues](https://superuser.com/questions/tagged/file-permissions+windows)** - Windows file permission problems

### Alternative File Transfer Methods
- **[WinSCP - Graphical SCP Client](https://winscp.net/eng/index.php)** - User-friendly alternative to command-line SCP
- **[FileZilla SFTP Guide](https://wiki.filezilla-project.org/Using)** - Another graphical file transfer option

## Ableton Move Specific Issues

### Move Device Problems
- **[Ableton Move Support](https://help.ableton.com/hc/en-us/categories/4405796048404-Move)** - Official Ableton Move documentation
- **[Move Community Forum](https://www.ableton.com/en/community/)** - Ableton community discussions
- **[Move Reddit Community](https://www.reddit.com/r/ableton/)** - Community troubleshooting and tips

### SSH Development Mode
- **[Enable Developer Mode on Move](https://help.ableton.com/hc/en-us/articles/4405796048404)** - Official instructions (if available)
- **[Move SSH Access Guide](https://github.com/peterswimm/extending-move/wiki)** - Community documentation

## Emergency Recovery

### System Recovery Options
- **[Windows System Restore](https://support.microsoft.com/en-us/windows/use-system-restore-a5ae3ed9-07c4-fd56-45ee-096777ecd14e)** - Restore Windows to earlier state
- **[Windows Safe Mode](https://support.microsoft.com/en-us/windows/start-your-pc-in-safe-mode-in-windows-92c27cff-db89-8644-1ce4-b3e5e56fe234)** - Boot Windows in safe mode

### When All Else Fails
- **[Microsoft Support Community](https://answers.microsoft.com/en-us/windows)** - Official Microsoft support forums
- **[Windows 11 Support](https://support.microsoft.com/en-us/windows)** - Microsoft's main support page
- **[Contact Microsoft Support](https://support.microsoft.com/en-us/contactus)** - Direct support options

## Quick Reference Card

**Can't connect to move.local?**
1. Check Wi-Fi connection
2. Try `ping move.local` in Command Prompt
3. Check router settings for device blocking

**SSH key not working?**
1. Verify you copied the entire public key
2. Check the key was saved correctly on move.local/development/ssh
3. Try regenerating the key

**Command Prompt issues?**
1. Run as Administrator
2. Try PowerShell instead
3. Check if OpenSSH is installed

Remember: When in doubt, search for your specific error message along with "Windows 11" for the most current solutions!
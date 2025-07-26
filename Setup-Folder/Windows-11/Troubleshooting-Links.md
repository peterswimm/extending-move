# Windows 11 Troubleshooting Links

If you encounter issues during setup or file transfer, these resources provide reliable solutions for common problems.

## WSL (Windows Subsystem for Linux) Issues

### WSL Won't Install or Enable

**Problem:** WSL installation fails or won't enable
- **Microsoft Official Guide:** [Install WSL on Windows 11](https://docs.microsoft.com/en-us/windows/wsl/install)
- **Enable WSL Features:** [Enable Windows Features for WSL](https://docs.microsoft.com/en-us/windows/wsl/troubleshooting#installation-issues)
- **WSL Troubleshooting:** [Official WSL Troubleshooting Guide](https://docs.microsoft.com/en-us/windows/wsl/troubleshooting)

### WSL Performance Issues

**Problem:** WSL runs slowly or uses too much memory
- **WSL Performance Guide:** [Best Practices for WSL Performance](https://docs.microsoft.com/en-us/windows/wsl/compare-versions#performance-across-os-file-systems)
- **Memory Configuration:** [Configure WSL Memory Usage](https://docs.microsoft.com/en-us/windows/wsl/wsl-config#configure-global-options-with-wslconfig)

### Ubuntu/Linux Distribution Issues

**Problem:** Ubuntu won't start or has errors
- **Reset WSL Distribution:** [Reset WSL Distribution](https://docs.microsoft.com/en-us/windows/wsl/troubleshooting#reset-and-uninstall-a-distribution)
- **Change Default Distribution:** [Set Default WSL Distribution](https://docs.microsoft.com/en-us/windows/wsl/basic-commands#set-default-distribution)

## SSH Connection Problems

### Cannot Connect to move.local

**Problem:** SSH connection fails with "Host not found" or timeout
- **Network Discovery Guide:** [Windows Network Discovery Settings](https://support.microsoft.com/en-us/windows/make-your-pc-discoverable-on-networks-in-windows-windows-10-fd05dd4a-9b94-4c6a-a96b-2a85e2c5be92)
- **mDNS/Bonjour for Windows:** [Install Bonjour Print Services](https://support.apple.com/kb/DL999) (helps resolve .local addresses)
- **Check Network Settings:** [Windows Network Troubleshooter](https://support.microsoft.com/en-us/windows/fix-network-connection-issues-in-windows-f49a9b7c-99e8-4d3d-8b1f-99a2e0b6ecb6)

### SSH Key Authentication Issues

**Problem:** SSH key doesn't work, still asks for password
- **SSH Key Permissions:** [SSH Key File Permissions Guide](https://superuser.com/questions/215504/permissions-on-private-key-in-ssh-folder) (Stack Overflow)
- **SSH Troubleshooting:** [SSH Connection Troubleshooting](https://docs.github.com/en/authentication/troubleshooting-ssh) (GitHub Docs)
- **Verbose SSH Output:** [Debug SSH Connections](https://www.cyberciti.biz/faq/unix-linux-debug-ssh-client-connection/) (nixCraft)

### Permission Denied Errors

**Problem:** "Permission denied" when trying to SSH
- **SSH Client Configuration:** [OpenSSH Client Configuration](https://docs.microsoft.com/en-us/windows-server/administration/openssh/openssh_keymanagement)
- **File Permission Issues:** [Fix SSH Permission Denied](https://phoenixnap.com/kb/ssh-permission-denied-publickey) (PhoenixNAP)

## File Transfer Issues

### SCP/SFTP Command Not Found

**Problem:** scp or sftp commands don't work
- **Install OpenSSH Client:** [Windows OpenSSH Installation](https://docs.microsoft.com/en-us/windows-server/administration/openssh/openssh_install_firstuse)
- **Alternative: Use PowerShell:** [PowerShell SSH Commands](https://docs.microsoft.com/en-us/powershell/scripting/learn/remoting/ssh-remoting-in-powershell-core)

### File Transfer Fails

**Problem:** Files won't copy or transfer is interrupted
- **SCP Usage Guide:** [SCP Command Examples](https://linuxize.com/post/how-to-use-scp-command-to-securely-transfer-files/) (Linuxize)
- **SFTP Tutorial:** [SFTP Command Guide](https://www.digitalocean.com/community/tutorials/how-to-use-sftp-to-securely-transfer-files-with-a-remote-server) (DigitalOcean)
- **Large File Transfers:** [rsync for Large Files](https://www.digitalocean.com/community/tutorials/how-to-use-rsync-to-sync-local-and-remote-directories) (DigitalOcean)

### File Path Issues

**Problem:** Cannot find Windows files from WSL
- **WSL File System Guide:** [Access Windows Files from WSL](https://docs.microsoft.com/en-us/windows/wsl/filesystems)
- **Path Translation:** [WSL Path Translation](https://devblogs.microsoft.com/commandline/automatically-configuring-wsl/) (Microsoft DevBlog)

## Ableton Move Specific Issues

### Move Device Not Responding

**Problem:** Move device seems frozen or unresponsive
- **Move Recovery Guide:** [Ableton Move Recovery Procedures](https://ableton.centercode.com/) (Center Code - requires account)
- **Factory Reset:** Contact Ableton Support for guidance
- **Network Reset:** Restart your router and Move device

### extending-move Installation Fails

**Problem:** The extending-move software won't install
- **GitHub Repository:** [extending-move Issues](https://github.com/peterswimm/extending-move/issues)
- **Discord Community:** [Move Hacking Discord](https://discord.gg/yP7SjqDrZG)
- **Python Dependencies:** [pip Installation Guide](https://pip.pypa.io/en/stable/installation/) (pip documentation)

### Web Interface Not Accessible

**Problem:** Cannot access move.local:909
- **Port Issues:** Check if port 909 is blocked by Windows Firewall
- **Windows Firewall Guide:** [Configure Windows Firewall](https://support.microsoft.com/en-us/windows/turn-microsoft-defender-firewall-on-or-off-ec0844f7-aebd-0583-67fe-601ecf5d774f)
- **Browser Issues:** Try different browsers or clear cache

## Network and Connectivity

### General Network Issues

**Problem:** Device discovery or connection problems
- **Windows Network Reset:** [Reset Network Settings](https://support.microsoft.com/en-us/windows/fix-network-connection-issues-in-windows-f49a9b7c-99e8-4d3d-8b1f-99a2e0b6ecb6)
- **Router Configuration:** [Basic Router Troubleshooting](https://www.wikihow.com/Troubleshoot-a-Router) (wikiHow)
- **IP Address Issues:** [Find Device IP Address](https://www.howtogeek.com/236838/how-to-find-any-devices-ip-address-mac-address-and-other-network-connection-details/)

### WiFi Connection Problems

**Problem:** Move device not connecting to WiFi
- **WiFi Troubleshooting:** [Windows WiFi Problems](https://support.microsoft.com/en-us/windows/fix-wi-fi-connection-issues-in-windows-9424a1f7-6a3b-65a6-4d78-7f07eee84d2c)
- **Network Frequency:** Ensure your router supports 2.4GHz (Move requirement)

## General Computing Help

### Command Line Basics

**Problem:** Unfamiliar with command line interface
- **Ubuntu Command Guide:** [Ubuntu Command Line Tutorial](https://ubuntu.com/tutorials/command-line-for-beginners) (Ubuntu Official)
- **Linux Commands:** [Linux Command Cheat Sheet](https://www.digitalocean.com/community/cheatsheets/how-to-use-linux-commands) (DigitalOcean)
- **File Operations:** [Basic File Operations in Linux](https://www.geeksforgeeks.org/basic-file-operations-in-linux/) (GeeksforGeeks)

### Windows Terminal Tips

**Problem:** Need to use Windows Terminal more effectively
- **Windows Terminal Guide:** [Windows Terminal Documentation](https://docs.microsoft.com/en-us/windows/terminal/)
- **Terminal Customization:** [Customize Windows Terminal](https://docs.microsoft.com/en-us/windows/terminal/customize-settings/startup)

## Emergency Recovery

### If Things Go Wrong

**Problem:** Move device seems broken or corrupted
- **⚠️ Important:** Do NOT attempt firmware modifications
- **Contact Ableton:** [Ableton Support](https://www.ableton.com/en/help/contact-support/)
- **Recovery Information:** Available through Center Code (requires Ableton account)
- **Community Support:** [Move Discord Community](https://discord.gg/yP7SjqDrZG)

## Additional Resources

### Video Tutorials
- [YouTube: extending-move Demo](https://www.youtube.com/watch?v=MCmaCifzgbg)
- [YouTube: Quick Installation Video](https://youtu.be/gPiR7Zyu3lc)

### Documentation
- [extending-move Wiki](https://github.com/charlesvestal/extending-move/wiki)
- [Ableton Move Manual](https://www.ableton.com/en/manual/move/) (Official)

### Community
- [extending-move GitHub](https://github.com/peterswimm/extending-move)
- [Discord Community](https://discord.gg/yP7SjqDrZG)

## Disclaimer

These resources are provided for informational purposes. Always refer to official documentation when possible. The extending-move project and its contributors are not responsible for any issues that may arise from following these guides.
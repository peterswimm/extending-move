# Windows 11 Troubleshooting Links and Solutions

This guide provides solutions to common issues you might encounter while setting up Extending Move on Windows 11.

## WSL (Windows Subsystem for Linux) Issues

### Problem: WSL Installation Fails
**Symptoms**: Error messages during `wsl --install`

**Solutions**:
1. **Enable Virtualization**: Ensure virtualization is enabled in your BIOS/UEFI
   - [Microsoft Guide: Enable Virtualization](https://docs.microsoft.com/en-us/windows/wsl/troubleshooting#ensure-that-virtualization-is-enabled)

2. **Windows Version**: Ensure you have Windows 11 or Windows 10 version 2004 or higher
   - [Check Windows Version Guide](https://support.microsoft.com/en-us/windows/which-version-of-windows-operating-system-am-i-running-628bec99-476a-2c13-5296-9dd081cdd808)

3. **Manual Installation**: If automatic installation fails
   - [WSL Manual Installation Guide](https://docs.microsoft.com/en-us/windows/wsl/install-manual)

### Problem: "WSL 2 requires an update to its kernel component"
**Solution**: Download and install the WSL2 Linux kernel update
- [Download WSL2 Kernel Update](https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi)
- [Official Microsoft Instructions](https://docs.microsoft.com/en-us/windows/wsl/install-win10#step-4---download-the-linux-kernel-update-package)

### Problem: WSL Commands Not Found
**Symptoms**: `wsl: command not found` or similar errors

**Solutions**:
1. **Restart After Installation**: Restart Windows after installing WSL
2. **Check Installation**: Run `wsl --status` to verify WSL is installed
3. **Reinstall WSL**: 
   - [WSL Reinstallation Guide](https://docs.microsoft.com/en-us/windows/wsl/troubleshooting)

---

## SSH Connection Issues

### Problem: "Connection Refused" or "Host Not Found"
**Symptoms**: Cannot connect to `move.local`

**Solutions**:
1. **Check Network Connection**: Ensure both devices are on same Wi-Fi
   - [Basic Network Troubleshooting](https://support.microsoft.com/en-us/windows/fix-network-connection-issues-in-windows-f53d9b77-a8a7-3ebb-e4d2-45dc8b7f5beb)

2. **Try IP Address Instead**: 
   - Find your Move's IP address in Settings → System → Network
   - Use `ssh ableton@192.168.1.XXX` (replace with actual IP)

3. **DNS Issues**: If `move.local` doesn't work
   - [Windows DNS Troubleshooting](https://support.microsoft.com/en-us/windows/fix-network-connection-issues-in-windows-f53d9b77-a8a7-3ebb-e4d2-45dc8b7f5beb)
   - Try adding to hosts file: [Edit Windows Hosts File](https://www.howtogeek.com/howto/27350/beginner-geek-how-to-edit-your-hosts-file/)

### Problem: SSH Permission Denied
**Symptoms**: "Permission denied (publickey)" errors

**Solutions**:
1. **Check SSH Key**: Verify key was created correctly
   ```
   ls -la ~/.ssh/move_key*
   ```

2. **Re-add Public Key**: Copy public key to Move again
   ```
   cat ~/.ssh/move_key.pub
   ```
   - [SSH Key Troubleshooting Guide](https://docs.github.com/en/authentication/troubleshooting-ssh)

3. **Check Permissions**: Ensure correct file permissions
   ```
   chmod 600 ~/.ssh/move_key
   chmod 644 ~/.ssh/move_key.pub
   ```

### Problem: "Host Key Verification Failed"
**Solution**: Remove old host key and try again
```
ssh-keygen -R move.local
```
- [SSH Host Key Issues](https://www.ssh.com/academy/ssh/host-key)

---

## File Transfer Issues

### Problem: SCP/Transfer Errors
**Symptoms**: Files not copying correctly

**Solutions**:
1. **Check Permissions**: Ensure you have write access
   - [Linux File Permissions Guide](https://www.guru99.com/file-permissions.html)

2. **Disk Space**: Check available space on Move
   ```
   ssh ableton@move.local "df -h"
   ```

3. **Path Issues**: Verify correct paths
   - [WSL File System Guide](https://docs.microsoft.com/en-us/windows/wsl/filesystems)

---

## Installation Script Issues

### Problem: "Permission Denied" on Scripts
**Solution**: Make scripts executable
```
chmod +x utility-scripts/*.sh
```

### Problem: Python/Pip Installation Fails
**Solutions**:
1. **Check Internet Connection** on Move device
2. **Retry Installation**: Sometimes network issues are temporary
3. **Manual Installation**: 
   - [Python Installation Troubleshooting](https://pip.pypa.io/en/stable/installation/#troubleshooting)

---

## Browser/Web Interface Issues

### Problem: Cannot Access `move.local:909`
**Solutions**:
1. **Check Port**: Verify the correct port number was used during installation
2. **Firewall**: Check Windows Firewall settings
   - [Windows Firewall Configuration](https://support.microsoft.com/en-us/windows/turn-microsoft-defender-firewall-on-or-off-ec0844f7-aebd-0583-67fe-601ecf5d774f)

3. **Use IP Address**: Try `http://192.168.1.XXX:909` instead

### Problem: Web Interface Loads but Features Don't Work
**Solutions**:
1. **Browser Cache**: Clear browser cache and reload
2. **JavaScript**: Ensure JavaScript is enabled
3. **Try Different Browser**: Test with Chrome, Firefox, or Edge

---

## General Troubleshooting

### Problem: Command Not Found Errors
**Solution**: Verify you're in the correct directory
```
pwd
ls -la
```

### Problem: Text Editor Issues (nano)
**Alternative Editors**:
- **vim**: More advanced but powerful
  - [Vim Basics Guide](https://www.openvim.com/)
- **VS Code**: Install VS Code with WSL extension
  - [VS Code WSL Guide](https://code.visualstudio.com/docs/remote/wsl)

---

## Additional Resources

### Official Documentation
- [Windows WSL Documentation](https://docs.microsoft.com/en-us/windows/wsl/)
- [SSH.com SSH Academy](https://www.ssh.com/academy/ssh)
- [Ableton Move Manual](https://www.ableton.com/en/manual/move/)

### Community Resources
- [Extending Move Discord](https://discord.gg/yP7SjqDrZG)
- [Extending Move GitHub Issues](https://github.com/peterswimm/extending-move/issues)
- [WSL Community](https://github.com/microsoft/WSL)

### Video Tutorials
- [Windows WSL Setup](https://www.youtube.com/results?search_query=windows+wsl+setup)
- [SSH Basics](https://www.youtube.com/results?search_query=ssh+basics+tutorial)

---

## Getting More Help

If you're still having trouble:

1. **Check the Discord Community**: The Extending Move Discord is very active and helpful
2. **Search GitHub Issues**: Someone might have already solved your problem
3. **Create New Issue**: If you find a new bug, report it on GitHub
4. **Document Your Steps**: Keep track of what you tried so you can share details when asking for help

Remember: The community is friendly and wants to help! Don't hesitate to ask questions.
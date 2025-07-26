# Windows 11 Troubleshooting Links

This document provides troubleshooting resources for common issues when setting up Extending Move on Windows 11.

## WSL (Windows Subsystem for Linux) Issues

### WSL Installation Problems
- **Official WSL Documentation**: https://docs.microsoft.com/en-us/windows/wsl/install
- **WSL Installation Troubleshooting**: https://docs.microsoft.com/en-us/windows/wsl/troubleshooting
- **WSL GitHub Issues**: https://github.com/microsoft/WSL/issues

### WSL Networking Issues
- **WSL Networking Guide**: https://docs.microsoft.com/en-us/windows/wsl/networking
- **WSL Network Troubleshooting**: https://github.com/microsoft/WSL/issues/4150

## SSH Connection Issues

### Cannot Connect to move.local
**Problem**: `ssh: connect to host move.local port 22: Connection refused`

**Solutions**:
1. **Check network connectivity**:
   ```bash
   ping move.local
   ```
2. **Try IP address instead**: Find your Move's IP on your router and use it directly
3. **Check if SSH is enabled on Move**: The Move should have SSH enabled by default
4. **Windows Firewall**: Ensure Windows Firewall isn't blocking SSH connections

**Resources**:
- **SSH Connection Troubleshooting**: https://www.ssh.com/academy/ssh/troubleshoot
- **Network Discovery Issues**: https://support.microsoft.com/en-us/windows/make-your-network-and-pc-discoverable-in-windows-10-50f63ddd-b2e1-4d62-af8a-a64a326b0d8e

### Permission Denied (publickey)
**Problem**: `Permission denied (publickey)`

**Solutions**:
1. **Verify SSH key location**: Ensure key is at `~/.ssh/move_key`
2. **Check SSH config**: Verify `~/.ssh/config` points to correct key file
3. **Key permissions**: Ensure proper permissions on SSH key:
   ```bash
   chmod 600 ~/.ssh/move_key
   chmod 644 ~/.ssh/move_key.pub
   ```

**Resources**:
- **SSH Key Troubleshooting**: https://docs.github.com/en/authentication/troubleshooting-ssh
- **SSH Permission Issues**: https://superuser.com/questions/215504/permissions-on-private-key-in-ssh-folder

## File Transfer Issues

### SCP Command Not Found
**Problem**: `scp: command not found`

**Solution**: Install OpenSSH client in WSL:
```bash
sudo apt update
sudo apt install openssh-client
```

### File Transfer Permissions
**Problem**: Cannot write files to Move directories

**Solutions**:
1. **Check target directory permissions** on the Move
2. **Use correct user**: Ensure you're connecting as `ableton` user
3. **Target correct directories**: 
   - Samples: `/data/UserData/UserLibrary/Samples/`
   - Presets: `/data/UserData/UserLibrary/Track Presets/`

**Resources**:
- **SCP Usage Guide**: https://linuxize.com/post/how-to-use-scp-command-to-securely-transfer-files/
- **File Permissions in Linux**: https://www.linux.com/training-tutorials/understanding-linux-file-permissions/

## Network Discovery Issues

### Cannot Find move.local
**Problem**: `move.local` hostname doesn't resolve

**Solutions**:
1. **Check mDNS support**: Install Avahi in WSL:
   ```bash
   sudo apt install avahi-daemon libnss-mdns
   ```
2. **Use IP address**: Find Move's IP address from your router's admin panel
3. **Check network**: Ensure Move and computer are on same network

**Resources**:
- **mDNS on Linux**: https://wiki.archlinux.org/title/Avahi
- **Network Troubleshooting**: https://docs.microsoft.com/en-us/windows/wsl/networking

## Python and Dependencies

### pip Installation Issues
**Problem**: Package installation fails

**Solutions**:
1. **Update pip**:
   ```bash
   python3 -m pip install --upgrade pip
   ```
2. **Install build tools**:
   ```bash
   sudo apt install build-essential python3-dev
   ```

**Resources**:
- **Python Package Installation**: https://packaging.python.org/en/latest/tutorials/installing-packages/
- **pip Troubleshooting**: https://pip.pypa.io/en/stable/topics/authentication/

## Move-Specific Issues

### Move Not Responding
**Problem**: Move webserver not accessible

**Solutions**:
1. **Check Move's built-in server**: Navigate to `http://move.local` (without port)
2. **Restart Move**: Power cycle the device
3. **Check autostart service**: SSH into Move and check if service is running:
   ```bash
   ssh ableton@move.local "systemctl status extending-move"
   ```

### Installation Script Fails
**Problem**: Setup script encounters errors

**Solutions**:
1. **Check script permissions**: Ensure script is executable:
   ```bash
   chmod +x utility-scripts/setup-ssh-and-install-on-move.sh
   ```
2. **Run with verbose output**: Add `-x` flag to see detailed execution
3. **Manual installation**: Follow manual steps in the setup guide

**Resources**:
- **Bash Scripting Troubleshooting**: https://tldp.org/LDP/Bash-Beginners-Guide/html/sect_02_03.html

## General Resources

### Community Support
- **Extending Move Discord**: https://discord.gg/yP7SjqDrZG
- **Project GitHub Issues**: https://github.com/peterswimm/extending-move/issues
- **Ableton Community**: https://www.ableton.com/en/help/

### Official Documentation
- **Ableton Move Manual**: https://www.ableton.com/en/manual/move/
- **Project Wiki**: https://github.com/charlesvestal/extending-move/wiki

### Windows-Specific Resources
- **Windows 11 Networking**: https://support.microsoft.com/en-us/windows/fix-network-connection-issues-in-windows-f6d5e499-b4c4-b41c-c658-8e8c8b0d3c7b
- **PowerShell Documentation**: https://docs.microsoft.com/en-us/powershell/
- **Windows Terminal Guide**: https://docs.microsoft.com/en-us/windows/terminal/

## Getting Additional Help

If you're still experiencing issues after trying these solutions:

1. **Check the project's GitHub issues** to see if others have encountered similar problems
2. **Join the Discord community** for real-time help
3. **Create a detailed issue report** including:
   - Your Windows 11 version
   - WSL version and distribution
   - Complete error messages
   - Steps you've already tried

Remember: Always include specific error messages and your system configuration when asking for help!
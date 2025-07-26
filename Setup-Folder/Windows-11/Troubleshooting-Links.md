# Windows 11 Troubleshooting Links

This document provides troubleshooting resources and solutions for common issues when setting up Extending Move on Windows 11.

## Common Issues and Solutions

### SSH Connection Problems

#### "Connection refused" or "Host not found"
- **Cause**: Move device not found on network
- **Solutions**:
  - Ensure Move and computer are on same WiFi network
  - Try `ping move.local` to test connectivity
  - Check Move's network settings in System menu
  - Try using Move's IP address instead of `move.local`

#### "Permission denied (publickey)"
- **Cause**: SSH key not properly configured or authorized
- **Solutions**:
  - Verify SSH key was generated: `ls ~/.ssh/move_key*`
  - Manually copy public key to Move
  - Check SSH config file syntax
  - Try connecting with password first to debug

#### "Host key verification failed"
- **Cause**: Move's host key changed or SSH being strict
- **Solutions**:
  - Remove old host key: `ssh-keygen -R move.local`
  - Add `StrictHostKeyChecking no` to SSH config
  - Delete `~/.ssh/known_hosts` and reconnect

### Windows Subsystem for Linux (WSL) Issues

#### WSL Installation Fails
- **Microsoft Official Guide**: [Install WSL on Windows 11](https://docs.microsoft.com/en-us/windows/wsl/install)
- **Alternative**: Use WSL2 instead: `wsl --install --version 2`
- **Troubleshooting**: [WSL Troubleshooting Guide](https://docs.microsoft.com/en-us/windows/wsl/troubleshooting)

#### WSL Performance Issues
- **File System**: Store files in WSL filesystem (`/home/`) not Windows (`/mnt/c/`)
- **Memory**: Increase WSL memory limit in `.wslconfig`
- **Network**: Try `wsl --shutdown` and restart if network issues

### PowerShell/Command Prompt Issues

#### SSH Command Not Found
- **Install OpenSSH**: Settings → Apps → Optional Features → OpenSSH Client
- **PowerShell Method**: `Add-WindowsCapability -Online -Name OpenSSH.Client*`
- **Alternative**: Install Git Bash which includes SSH
- **Third-party**: Use PuTTY or other SSH clients

#### Python Command Not Found
- **Add to PATH**: Reinstall Python with "Add to PATH" checked
- **Manual PATH**: Add Python installation directory to system PATH
- **Multiple Versions**: Use `py -3` instead of `python3`

### Git and Repository Issues

#### Git Clone Fails
- **HTTPS vs SSH**: Use HTTPS URL for initial clone
- **Network**: Check corporate firewall/proxy settings
- **Credentials**: Use Git Credential Manager if prompted

#### Line Ending Issues
- **Configure Git**: `git config --global core.autocrlf true`
- **Reset Repository**: Delete and re-clone if files are corrupted

### Python and Dependencies

#### Pip Install Fails
- **Upgrade Pip**: `python -m pip install --upgrade pip`
- **Permission Issues**: Use `--user` flag: `pip install --user -r requirements.txt`
- **Compiler Errors**: Install Visual Studio Build Tools

#### Module Import Errors
- **Virtual Environment**: Create and activate venv before installing
- **Path Issues**: Ensure Python scripts directory is in PATH
- **Dependencies**: Some packages may need system libraries

### Network and Firewall

#### Windows Firewall Blocking Connections
- **Outbound Rules**: Windows typically allows outbound SSH by default
- **Inbound Rules**: Create rule if running servers locally
- **Third-party Antivirus**: Check antivirus firewall settings

#### Corporate Network Issues
- **Proxy Settings**: Configure Git and pip to use corporate proxy
- **VPN**: Some VPNs may block local network access
- **IT Policies**: Contact IT department for SSH/Git access

## Useful Resources

### Official Microsoft Documentation
- [Windows Terminal](https://docs.microsoft.com/en-us/windows/terminal/) - Modern terminal application
- [PowerShell Documentation](https://docs.microsoft.com/en-us/powershell/) - Complete PowerShell guide
- [WSL Documentation](https://docs.microsoft.com/en-us/windows/wsl/) - Windows Subsystem for Linux
- [Windows SSH Documentation](https://docs.microsoft.com/en-us/windows-server/administration/openssh/openssh_overview) - OpenSSH on Windows

### SSH and Networking
- [SSH Academy](https://www.ssh.com/academy/ssh) - Comprehensive SSH guides
- [SSH Key Management](https://www.ssh.com/academy/ssh/keygen) - SSH key generation and management
- [PuTTY Documentation](https://www.chiark.greenend.org.uk/~sgtatham/putty/docs.html) - Alternative SSH client
- [Windows Network Troubleshooting](https://support.microsoft.com/en-us/windows/fix-network-connection-issues-in-windows-f4c55ad0-4e41-4962-8c3c-23b3a7b4dcbb)

### Python and Development
- [Python on Windows](https://docs.python.org/3/using/windows.html) - Official Python Windows guide
- [Python Package Index (PyPI)](https://pypi.org/) - Python package repository
- [Visual Studio Build Tools](https://visualstudio.microsoft.com/visual-cpp-build-tools/) - For compiling Python packages
- [Python Virtual Environments](https://docs.python.org/3/tutorial/venv.html) - Virtual environment guide

### Git and Version Control
- [Git for Windows](https://gitforwindows.org/) - Git installation and documentation
- [Git Documentation](https://git-scm.com/docs) - Complete Git reference
- [GitHub Desktop](https://desktop.github.com/) - GUI alternative to command line Git
- [Git Credential Manager](https://github.com/GitCredentialManager/git-credential-manager) - Secure credential storage

### Community Resources
- [Extending Move Discord](https://discord.gg/yP7SjqDrZG) - Community support and discussion
- [Ableton Move Community](https://ableton.centercode.com/) - Official Ableton community
- [Stack Overflow](https://stackoverflow.com/questions/tagged/windows) - Programming Q&A
- [Reddit r/Windows11](https://www.reddit.com/r/Windows11/) - Windows 11 community support

### Video Tutorials
- [Quick Installation Video](https://youtu.be/gPiR7Zyu3lc) - Official setup video
- [Demo on YouTube](https://www.youtube.com/watch?v=MCmaCifzgbg) - Feature demonstration
- [WSL Setup Videos](https://www.youtube.com/results?search_query=wsl+windows+11+setup) - WSL installation guides

## Emergency Recovery

If your Move device becomes unresponsive:

1. **Soft Reset**: Hold power button for 10 seconds
2. **Factory Reset**: Refer to [Ableton's official recovery documentation](https://ableton.centercode.com/project/article/item.html?cap=ecd3942a1fe3405eb27a806608401a0b&arttypeid={e70be312-f44a-418b-bb74-ed1030e3a49a}&artid={C0A2D9E2-D52F-4DEB-8BEE-356B65C8942E})
3. **Contact Support**: Reach out to Ableton support if factory reset doesn't resolve issues

## Getting Help

1. **Check the [main README](../../README.md)** for general troubleshooting
2. **Search [existing issues](https://github.com/peterswimm/extending-move/issues)** on GitHub
3. **Join the [Discord community](https://discord.gg/yP7SjqDrZG)** for real-time help
4. **Create a new issue** on GitHub with detailed error messages and system information

Remember to include:
- Windows 11 version and build number
- WSL version (if using WSL)
- Python version
- Complete error messages
- Steps to reproduce the issue
# macOS Troubleshooting Links

This document provides troubleshooting resources and solutions for common issues when setting up Extending Move on macOS.

## Common Issues and Solutions

### SSH Connection Problems

#### "Connection refused" or "Host not found"
- **Check network connectivity**:
  ```bash
  ping move.local
  # If this fails, try finding Move's IP address
  arp -a | grep move
  # Or check your router's connected devices
  ```
- **Verify Move is on same network**: Check WiFi settings on both devices
- **Try IP address instead**: Use Move's IP address instead of `move.local`
- **Network discovery issues**: Some networks block mDNS, try `move.lan` instead

#### "Permission denied (publickey)"
- **SSH key not found**: Verify key exists: `ls -la ~/.ssh/move_key*`
- **Wrong SSH config**: Check `~/.ssh/config` file format and permissions
- **Key not added to agent**: Run `ssh-add ~/.ssh/move_key`
- **Manual key copy**: Try copying key manually:
  ```bash
  cat ~/.ssh/move_key.pub | ssh ableton@move.local "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
  ```

#### "Host key verification failed"
- **Remove old key**: `ssh-keygen -R move.local`
- **Clear known hosts**: `rm ~/.ssh/known_hosts` and reconnect
- **Bypass verification**: Add `StrictHostKeyChecking no` to SSH config

### Script Execution Issues

#### ".command file won't open" or "Permission denied"
- **Make executable**:
  ```bash
  chmod +x utility-scripts/*.command
  chmod +x utility-scripts/*.sh
  ```
- **Gatekeeper blocking**: 
  - Right-click script → "Open" → confirm opening
  - Or: System Preferences → Security & Privacy → Allow blocked app
- **Terminal not opening**: Set Terminal as default for .command files

#### "Command not found" errors
- **PATH issues**: Check if tools are in PATH:
  ```bash
  echo $PATH
  which ssh
  which python3
  which git
  ```
- **Xcode tools missing**: Install with `xcode-select --install`
- **Python not found**: Install from python.org or use `python3.x` specifically

### Python and Package Issues

#### "No module named 'xyz'" errors
- **Install requirements**:
  ```bash
  pip3 install -r requirements.txt --user
  ```
- **Virtual environment**: Create isolated environment:
  ```bash
  python3 -m venv venv
  source venv/bin/activate
  pip install -r requirements.txt
  ```
- **System vs user packages**: Use `--user` flag for user-level installs

#### "Permission denied" during pip install
- **Use user directory**: `pip3 install --user package_name`
- **Check permissions**: `ls -la $(which pip3)`
- **Homebrew conflicts**: If using Homebrew, ensure consistent Python versions

#### Python version issues
- **Check version**: `python3 --version` (needs 3.8+)
- **Multiple versions**: Use specific version like `python3.9`
- **Update Python**: Download latest from python.org or use Homebrew

### Network and Firewall Issues

#### macOS Firewall blocking connections
- **System Preferences** → Security & Privacy → Firewall
- **Allow Terminal** and **Python** through firewall
- **Add specific apps** if prompted

#### Corporate/School network restrictions
- **Proxy settings**: Configure git and pip for proxy if needed
- **VPN interference**: Some VPNs block local network access
- **Port blocking**: Try different ports (808, 707) if 909 is blocked

### Git and Repository Issues

#### Git clone/pull fails
- **Network issues**: Check internet connection
- **HTTPS vs SSH**: Use HTTPS URL: `https://github.com/peterswimm/extending-move.git`
- **Proxy settings**: Configure git proxy if behind corporate firewall
- **Credentials**: Use Personal Access Token instead of password

#### File permission issues
- **Executable permissions**: `chmod +x script_name`
- **Directory permissions**: `chmod -R 755 extending-move/`
- **Owner issues**: `chown -R $(whoami) extending-move/`

### macOS Version-Specific Issues

#### macOS Monterey/Ventura (12.x/13.x)
- **Privacy controls**: Grant Terminal "Full Disk Access" if needed
- **New Python restrictions**: May need to explicitly allow Python network access
- **Rosetta 2**: On Apple Silicon, some packages may need Rosetta 2

#### macOS Big Sur (11.x)
- **Network security**: Additional prompts for network access
- **Code signing**: May need to allow unsigned code in Privacy settings
- **Terminal permissions**: Grant necessary permissions when prompted

#### macOS Catalina (10.15)
- **32-bit compatibility**: Some older tools may not work
- **Gatekeeper strict**: More security prompts for downloaded files
- **Python 2 deprecated**: Ensure using Python 3

### Apple Silicon (M1/M2) Specific Issues

#### Package compilation failures
- **Install Rosetta 2**: `softwareupdate --install-rosetta`
- **Native packages**: Ensure packages support ARM64
- **Homebrew**: Use ARM64 version of Homebrew

#### Performance issues
- **Architecture mismatch**: Check if running under Rosetta
- **Memory limits**: Apple Silicon may have different memory constraints

## Useful Resources

### Apple Official Documentation
- [macOS User Guide](https://support.apple.com/guide/mac-help/) - Complete macOS documentation
- [Terminal User Guide](https://support.apple.com/guide/terminal/) - Terminal app documentation
- [Network Setup](https://support.apple.com/guide/mac-help/set-up-a-mac-on-a-network-mchlp2293/) - Network configuration help
- [Security and Privacy](https://support.apple.com/guide/mac-help/change-security-privacy-preferences-mh11784/) - Privacy settings guide

### SSH and Networking
- [SSH on macOS](https://support.apple.com/guide/remote-desktop/remote-login-ssh-apd5208-0b77-4c9b-a7ce-f6a2b469b7c4/mac) - Apple's SSH guide
- [SSH Academy](https://www.ssh.com/academy/ssh) - Comprehensive SSH tutorials
- [Network Utility](https://support.apple.com/guide/network-utility/) - Built-in network diagnostics
- [DNS troubleshooting](https://support.apple.com/HT202516) - Resolving DNS issues

### Python and Development
- [Python.org macOS Guide](https://docs.python.org/3/using/mac.html) - Official Python macOS documentation
- [Homebrew](https://brew.sh/) - Package manager for macOS
- [Xcode Command Line Tools](https://developer.apple.com/xcode/) - Development tools from Apple
- [Virtual Environments](https://docs.python.org/3/tutorial/venv.html) - Python virtual environment guide

### Git and Version Control
- [Git on macOS](https://git-scm.com/download/mac) - Git installation options
- [GitHub Desktop](https://desktop.github.com/) - GUI Git client
- [Tower](https://www.git-tower.com/mac) - Professional Git client
- [Sourcetree](https://www.sourcetreeapp.com/) - Free Git GUI

### Terminal and Command Line
- [Terminal Tips](https://support.apple.com/guide/terminal/keyboard-shortcuts-trmlshtcts/mac) - Keyboard shortcuts and tips
- [Zsh Guide](https://scriptingosx.com/2019/06/moving-to-zsh/) - Default shell in macOS Catalina+
- [iTerm2](https://iterm2.com/) - Enhanced terminal replacement
- [Oh My Zsh](https://ohmyz.sh/) - Zsh configuration framework

### Apple Silicon Resources
- [Apple Silicon Guide](https://developer.apple.com/documentation/apple-silicon/) - Developer documentation
- [Rosetta 2](https://support.apple.com/HT211861) - Running Intel apps on Apple Silicon
- [Universal Apps](https://developer.apple.com/universal/) - Native Apple Silicon support

### Community Resources
- [Extending Move Discord](https://discord.gg/yP7SjqDrZG) - Community support and discussion
- [Stack Overflow](https://stackoverflow.com/questions/tagged/macos) - Programming Q&A
- [Reddit r/MacOS](https://www.reddit.com/r/MacOS/) - macOS community
- [MacRumors Forums](https://forums.macrumors.com/) - Mac discussion forums

### Video Resources
- [Quick Installation Video](https://youtu.be/gPiR7Zyu3lc) - Official setup video
- [Demo Video](https://www.youtube.com/watch?v=MCmaCifzgbg) - Feature demonstration
- [Terminal Basics](https://www.youtube.com/results?search_query=macos+terminal+basics) - Terminal tutorials

## Advanced Troubleshooting

### System Information
Gather system information for support requests:
```bash
# macOS version
sw_vers

# Hardware information
system_profiler SPSoftwareDataType SPHardwareDataType

# Network configuration
ifconfig
netstat -rn

# Python environment
python3 --version
pip3 --version
which python3
```

### Log Files
Check system logs for errors:
```bash
# View system logs
log show --predicate 'eventMessage contains "ssh"' --last 1h

# Console app for GUI log viewing
open /Applications/Utilities/Console.app
```

### Network Diagnostics
```bash
# Test network connectivity
ping move.local
nslookup move.local
traceroute move.local

# Check local network
arp -a
netstat -rn | grep default
```

## Emergency Recovery

If your Move device becomes unresponsive:

1. **Power cycle**: Hold power button for 10 seconds
2. **Network reset**: Restart your router if network issues persist
3. **Factory reset**: Refer to [Ableton's recovery documentation](https://ableton.centercode.com/project/article/item.html?cap=ecd3942a1fe3405eb27a806608401a0b&arttypeid={e70be312-f44a-418b-bb74-ed1030e3a49a}&artid={C0A2D9E2-D52F-4DEB-8BEE-356B65C8942E})

## Getting Help

When seeking help, please include:

1. **macOS version**: Run `sw_vers`
2. **Hardware type**: Intel or Apple Silicon
3. **Python version**: Run `python3 --version`
4. **Complete error messages**: Copy full terminal output
5. **Steps to reproduce**: Exact commands that caused the issue

**Support channels**:
- [Discord community](https://discord.gg/yP7SjqDrZG) for real-time help
- [GitHub issues](https://github.com/peterswimm/extending-move/issues) for bug reports
- [Main README](../../README.md) for general documentation
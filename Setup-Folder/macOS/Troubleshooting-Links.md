# macOS Troubleshooting Links

This document provides troubleshooting resources for common issues when setting up Extending Move on macOS.

## SSH Connection Issues

### Cannot Connect to move.local
**Problem**: `ssh: connect to host move.local port 22: Connection refused`

**Solutions**:
1. **Check Bonjour/mDNS**: macOS uses Bonjour for local network discovery
   ```bash
   dns-sd -B _ssh._tcp local.
   ```
2. **Check network connectivity**:
   ```bash
   ping move.local
   ```
3. **Try IP address**: Use Network Utility or `arp -a` to find Move's IP
4. **Restart Bonjour**: 
   ```bash
   sudo launchctl unload /System/Library/LaunchDaemons/com.apple.mDNSResponder.plist
   sudo launchctl load /System/Library/LaunchDaemons/com.apple.mDNSResponder.plist
   ```

**Resources**:
- **Bonjour Troubleshooting**: https://support.apple.com/en-us/HT202639
- **Network Utility Guide**: https://support.apple.com/guide/network-utility/welcome/mac
- **SSH Connection Issues**: https://apple.stackexchange.com/questions/tagged/ssh

### Permission Denied (publickey)
**Problem**: `Permission denied (publickey)`

**Solutions**:
1. **Check SSH key permissions**:
   ```bash
   chmod 600 ~/.ssh/move_key
   chmod 644 ~/.ssh/move_key.pub
   chmod 700 ~/.ssh
   ```
2. **Verify SSH config**: Check `~/.ssh/config` syntax
3. **Test SSH agent**:
   ```bash
   ssh-add -l
   ssh-add ~/.ssh/move_key
   ```
4. **Clear known_hosts**: Remove conflicting entries:
   ```bash
   ssh-keygen -R move.local
   ```

**Resources**:
- **SSH Key Management on macOS**: https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#adding-your-ssh-key-to-the-ssh-agent
- **SSH Troubleshooting**: https://apple.stackexchange.com/questions/48502/how-can-i-permanently-add-my-ssh-private-key-to-keychain-so-it-is-automatically

### SSH Key Not Loading Automatically
**Problem**: Need to run `ssh-add` after every restart

**Solution**: Add key to Keychain permanently:
```bash
ssh-add --apple-use-keychain ~/.ssh/move_key
```

Add to `~/.ssh/config`:
```
Host move.local
    UseKeychain yes
    AddKeysToAgent yes
```

**Resources**:
- **SSH Agent and Keychain**: https://developer.apple.com/library/archive/technotes/tn2449/_index.html

## Network Discovery Issues

### move.local Not Resolving
**Problem**: `move.local` hostname doesn't resolve

**Solutions**:
1. **Check mDNS resolution**:
   ```bash
   nslookup move.local
   dig move.local
   ```
2. **Use Network Utility**: Applications > Utilities > Network Utility > Lookup
3. **Check for conflicts**: Multiple devices with same hostname
4. **Use Bonjour Browser**: Download from Mac App Store to see all Bonjour services

**Resources**:
- **mDNS on macOS**: https://developer.apple.com/bonjour/
- **Network Discovery**: https://support.apple.com/guide/mac-help/set-up-a-mac-to-share-files-mchlp1140/mac

### Firewall Blocking Connections
**Problem**: macOS firewall prevents SSH connections

**Solutions**:
1. **Check firewall settings**: System Preferences > Security & Privacy > Firewall
2. **Allow SSH through firewall**:
   - Add Terminal to allowed apps
   - Enable "Automatically allow built-in software to receive incoming connections"
3. **Temporary disable**: For testing only

**Resources**:
- **macOS Firewall Settings**: https://support.apple.com/en-us/HT201642
- **Network Security**: https://support.apple.com/guide/mac-help/block-connections-to-your-mac-mh34041/mac

## File Transfer Issues

### SCP Permissions
**Problem**: Cannot write files to Move directories

**Solutions**:
1. **Check target permissions**: Ensure destination directory is writable
2. **Use correct paths**: 
   ```bash
   # Correct paths for Move
   /data/UserData/UserLibrary/Samples/
   /data/UserData/UserLibrary/Track\ Presets/
   ```
3. **Escape spaces**: Use quotes or backslashes for paths with spaces

**Resources**:
- **SCP Usage**: https://www.ssh.com/academy/ssh/scp
- **File Permissions**: https://ss64.com/osx/chmod.html

### Large File Transfer Issues
**Problem**: Transfer fails for large files

**Solutions**:
1. **Use rsync instead**:
   ```bash
   rsync -avz /path/to/file ableton@move.local:/destination/
   ```
2. **Check network stability**: Use Ethernet instead of Wi-Fi
3. **Transfer in chunks**: Split large files

**Resources**:
- **rsync Guide**: https://rsync.samba.org/documentation.html

## Python and Dependencies

### Python Version Issues
**Problem**: Wrong Python version or pip not found

**Solutions**:
1. **Use Homebrew Python**:
   ```bash
   brew install python3
   python3 -m pip install --upgrade pip
   ```
2. **Check PATH**: Ensure Homebrew Python is in PATH:
   ```bash
   echo $PATH
   export PATH="/opt/homebrew/bin:$PATH"  # Apple Silicon
   export PATH="/usr/local/bin:$PATH"     # Intel Mac
   ```

**Resources**:
- **Python on macOS**: https://docs.python-guide.org/starting/install3/osx/
- **Homebrew Documentation**: https://docs.brew.sh/

### Package Installation Fails
**Problem**: pip install fails with permission errors

**Solutions**:
1. **Use user installation**:
   ```bash
   python3 -m pip install --user package_name
   ```
2. **Use virtual environment**:
   ```bash
   python3 -m venv extending-move-env
   source extending-move-env/bin/activate
   pip install -r requirements.txt
   ```

**Resources**:
- **Virtual Environments**: https://docs.python.org/3/tutorial/venv.html

## Terminal and Shell Issues

### Command Not Found
**Problem**: `./setup-ssh-and-install-on-move.sh: command not found`

**Solutions**:
1. **Make script executable**:
   ```bash
   chmod +x utility-scripts/setup-ssh-and-install-on-move.sh
   ```
2. **Check file format**: Ensure Unix line endings:
   ```bash
   dos2unix utility-scripts/setup-ssh-and-install-on-move.sh
   ```

### Permission Issues with .command Files
**Problem**: Cannot execute .command files from Finder

**Solutions**:
1. **Right-click and Open**: Instead of double-clicking
2. **Change permissions**: 
   ```bash
   chmod +x *.command
   ```
3. **System Preferences**: Security & Privacy > Allow apps downloaded from App Store and identified developers

**Resources**:
- **Gatekeeper and Security**: https://support.apple.com/en-us/HT202491

## Move-Specific Issues

### Move Web Interface Not Accessible
**Problem**: Cannot access `http://move.local` or `http://move.local:909`

**Solutions**:
1. **Check Move's built-in server**: Should respond on port 80
2. **Verify installation**: SSH in and check service status:
   ```bash
   ssh ableton@move.local "systemctl status extending-move"
   ```
3. **Restart Move**: Power cycle the device
4. **Check port**: Try different ports (808, 707, 606)

### Installation Script Hangs
**Problem**: Setup script stops responding

**Solutions**:
1. **Check for prompts**: Script may be waiting for input
2. **Use verbose mode**: Run with `-x` flag:
   ```bash
   bash -x setup-ssh-and-install-on-move.sh
   ```
3. **Monitor network**: Use Activity Monitor to check connections

**Resources**:
- **Bash Debugging**: https://tldp.org/LDP/Bash-Beginners-Guide/html/sect_02_03.html

## macOS-Specific Tools

### Using Network Utility
1. **Open Network Utility**: Applications > Utilities
2. **Ping tab**: Test connectivity to move.local
3. **Lookup tab**: Resolve move.local to IP address
4. **Port Scan tab**: Check if ports 22, 80, 909 are open

### Using Activity Monitor
1. **Network tab**: Monitor data sent/received to Move
2. **Process tab**: Check for SSH processes
3. **Energy tab**: Monitor network usage

### Console App
Check system logs for network and SSH-related errors:
1. **Open Console**: Applications > Utilities
2. **Filter**: Search for "ssh", "bonjour", or "mdns"
3. **Real-time monitoring**: Watch logs during connection attempts

## Community Resources

### Official Support
- **Extending Move Discord**: https://discord.gg/yP7SjqDrZG
- **Project GitHub**: https://github.com/peterswimm/extending-move/issues
- **Ableton Community**: https://www.ableton.com/en/help/

### macOS-Specific Forums
- **Stack Overflow macOS**: https://stackoverflow.com/questions/tagged/macos
- **Apple Developer Forums**: https://developer.apple.com/forums/
- **Mac Power Users**: https://talk.macpowerusers.com/

### Tools and Utilities
- **Homebrew**: https://brew.sh/
- **iTerm2**: https://iterm2.com/ (Better terminal)
- **SSH config generator**: https://www.ssh.com/academy/ssh/config
- **Bonjour Browser**: Available on Mac App Store

## Getting Additional Help

When seeking help, include:
1. **macOS version**: Check "About This Mac"
2. **Hardware type**: Intel or Apple Silicon Mac
3. **Network setup**: Wi-Fi or Ethernet
4. **Complete error messages**: Copy full terminal output
5. **Steps attempted**: What you've already tried

**Useful diagnostic commands**:
```bash
system_profiler SPSoftwareDataType
networksetup -listallhardwareports
scutil --dns
ssh -vvv ableton@move.local  # Verbose SSH debugging
```

Remember: macOS has excellent built-in networking and security features that usually make setup smooth, but they can sometimes interfere with custom setups. Most issues are resolved by properly configuring SSH keys and ensuring network discovery is working correctly.
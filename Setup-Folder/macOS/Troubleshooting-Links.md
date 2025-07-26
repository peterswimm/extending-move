# macOS Troubleshooting Guide - Extending Move

This guide provides solutions to common issues you might encounter when setting up extending-move on macOS.

## Common Issues and Solutions

### SSH and Connection Issues

#### Problem: "move.local" not found
**Error:** `ping: cannot resolve move.local: Unknown host`

**Solutions:**
1. **Check Bonjour service:**
   ```bash
   # Check if mDNSResponder is running
   sudo launchctl list | grep mdns
   
   # Restart if needed
   sudo launchctl unload /System/Library/LaunchDaemons/com.apple.mDNSResponder.plist
   sudo launchctl load /System/Library/LaunchDaemons/com.apple.mDNSResponder.plist
   ```

2. **Use IP address instead:**
   - Find your Move's IP from router admin or Network Utility
   - Replace `move.local` with IP in commands

3. **Reset network settings:**
   - **System Preferences** > **Network**
   - Select your Wi-Fi connection > **Advanced** > **TCP/IP**
   - Click **Renew DHCP Lease**

**Helpful Links:**
- [Apple Network Diagnostics](https://support.apple.com/guide/mac-help/diagnose-network-problems-mh14158/mac)
- [Bonjour Troubleshooting](https://support.apple.com/en-us/HT202066)

#### Problem: SSH permission denied
**Error:** `Permission denied (publickey)`

**Solutions:**
1. **Check SSH key permissions:**
   ```bash
   ls -la ~/.ssh/move_key*
   chmod 600 ~/.ssh/move_key
   chmod 644 ~/.ssh/move_key.pub
   ```

2. **Add key to SSH agent:**
   ```bash
   ssh-add --apple-use-keychain ~/.ssh/move_key
   ```

3. **Verify SSH config:**
   ```bash
   cat ~/.ssh/config
   ```

4. **Test with verbose output:**
   ```bash
   ssh -v ableton@move.local
   ```

**Helpful Links:**
- [macOS SSH Key Management](https://help.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#adding-your-ssh-key-to-the-ssh-agent)
- [SSH Troubleshooting Guide](https://docs.github.com/en/authentication/troubleshooting-ssh)

### Command Line and Development Tools

#### Problem: Command Line Tools not installed
**Error:** `xcode-select: error: tool 'git' requires Xcode`

**Solutions:**
1. **Install Command Line Tools:**
   ```bash
   xcode-select --install
   ```

2. **If above fails, download manually:**
   - Visit [Apple Developer Downloads](https://developer.apple.com/download/more/)
   - Download Command Line Tools for your macOS version

3. **Reset Command Line Tools:**
   ```bash
   sudo xcode-select --reset
   xcode-select --install
   ```

**Helpful Links:**
- [Apple Developer Documentation](https://developer.apple.com/library/archive/technotes/tn2339/_index.html)

#### Problem: Python issues
**Error:** Various Python-related errors

**Solutions:**
1. **Check Python installation:**
   ```bash
   which python3
   python3 --version
   ```

2. **Install via Homebrew (recommended):**
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   brew install python3
   ```

3. **PATH issues:**
   Add to `~/.zshrc` (or `~/.bash_profile`):
   ```bash
   export PATH="/usr/local/bin:$PATH"
   export PATH="/opt/homebrew/bin:$PATH"  # For Apple Silicon Macs
   ```

**Helpful Links:**
- [Homebrew Installation](https://brew.sh)
- [Python.org macOS Guide](https://www.python.org/downloads/mac-osx/)

### Script Execution Issues

#### Problem: Permission denied on .command files
**Error:** `Permission denied` when running `.command` files

**Solutions:**
1. **Make executable:**
   ```bash
   chmod +x setup-ssh-and-install-on-move.command
   ```

2. **Run from Terminal:**
   ```bash
   ./setup-ssh-and-install-on-move.command
   ```

3. **Double-click in Finder:**
   - Right-click the `.command` file
   - Select **Open** (first time may require this)

**Helpful Links:**
- [macOS File Permissions](https://support.apple.com/guide/terminal/change-permissions-apdd85f0a1e-4385-4735-9cf0-45b4dddfe2fc/mac)

#### Problem: Gatekeeper blocking execution
**Error:** "Cannot be opened because it is from an unidentified developer"

**Solutions:**
1. **Allow in Security Settings:**
   - **System Preferences** > **Security & Privacy**
   - Click **Allow Anyway** next to the blocked file

2. **Override Gatekeeper temporarily:**
   ```bash
   sudo spctl --master-disable  # Disable (not recommended)
   sudo spctl --master-enable   # Re-enable after use
   ```

3. **Remove quarantine attribute:**
   ```bash
   xattr -dr com.apple.quarantine setup-ssh-and-install-on-move.command
   ```

**Helpful Links:**
- [Gatekeeper Documentation](https://support.apple.com/en-us/HT202491)

### Network and Firewall Issues

#### Problem: Cannot access web interface
**Error:** Browser cannot reach `http://move.local:909`

**Solutions:**
1. **Check macOS Firewall:**
   - **System Preferences** > **Security & Privacy** > **Firewall**
   - Turn off firewall temporarily to test
   - Add exception for your browser if needed

2. **Check for proxy settings:**
   - **System Preferences** > **Network** > **Advanced** > **Proxies**
   - Ensure no proxy is configured that might block local connections

3. **Test different browsers:**
   - Try Safari, Chrome, Firefox
   - Some browsers may have different proxy/security settings

4. **Verify Move webserver:**
   ```bash
   ssh ableton@move.local "netstat -tuln | grep :909"
   ```

**Helpful Links:**
- [macOS Firewall Settings](https://support.apple.com/guide/mac-help/block-connections-to-your-mac-with-a-firewall-mh34041/mac)

### File Transfer Issues

#### Problem: SCP/rsync slow or failing
**Various transfer issues**

**Solutions:**
1. **Use compression:**
   ```bash
   scp -C -i ~/.ssh/move_key file.txt ableton@move.local:/home/ableton/
   ```

2. **Adjust SSH settings:**
   Add to `~/.ssh/config`:
   ```
   Host move.local
       Compression yes
       CompressionLevel 6
       Cipher aes128-ctr
   ```

3. **Use GUI alternative - Cyberduck:**
   - Download [Cyberduck](https://cyberduck.io)
   - Configure SFTP connection to `move.local`
   - Use SSH key for authentication

**Helpful Links:**
- [Cyberduck Documentation](https://duck.sh)
- [SCP Performance Tips](https://unix.stackexchange.com/questions/2857/ssh-easily-copy-file-to-local-system-when-logged-in-on-remote-system)

### Apple Silicon (M1/M2) Specific Issues

#### Problem: Architecture compatibility
**Issues with some Python packages**

**Solutions:**
1. **Use Rosetta for compatibility:**
   ```bash
   arch -x86_64 python3 -m pip install package_name
   ```

2. **Install native ARM versions:**
   ```bash
   brew install python3  # Installs ARM64 version
   ```

3. **Check architecture:**
   ```bash
   uname -m  # Should show arm64 on Apple Silicon
   file $(which python3)  # Check Python architecture
   ```

**Helpful Links:**
- [Apple Silicon Development](https://developer.apple.com/documentation/apple-silicon)

## macOS Version-Specific Issues

### macOS Sequoia (15.0+)
- New privacy controls may require additional permissions
- Check **Privacy & Security** settings for Terminal access

### macOS Sonoma (14.0+)
- Enhanced Gatekeeper may block more scripts
- Network permissions may be more restrictive

### macOS Ventura (13.0+)
- System Settings (vs System Preferences) interface changes
- Some network stack changes affecting mDNS

## Advanced Troubleshooting

### Detailed SSH Debugging
```bash
# Maximum verbose SSH output
ssh -vvv ableton@move.local

# Check SSH client configuration
ssh -F /dev/null -v ableton@move.local

# Test connection without config file
ssh -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" -i ~/.ssh/move_key ableton@move.local
```

### Network Diagnostics
```bash
# Check routing
traceroute move.local

# DNS lookup
nslookup move.local
dig move.local

# mDNS specific lookup
dns-sd -q move.local
```

### System Logs
```bash
# Check system logs for network issues
log show --predicate 'subsystem contains "network"' --last 1h

# SSH-specific logs
log show --predicate 'process == "ssh"' --last 1h
```

## Additional Resources

### Official Documentation
- [Ableton Move Manual](https://help.ableton.com/hc/en-us/categories/5841267827092-Move)
- [Extending Move Wiki](https://github.com/charlesvestal/extending-move/wiki)

### Community Support
- [Discord Community](https://discord.gg/yP7SjqDrZG)
- [GitHub Issues](https://github.com/peterswimm/extending-move/issues)

### Video Tutorials
- [Quick Installation Video](https://youtu.be/gPiR7Zyu3lc)
- [Demo on YouTube](https://www.youtube.com/watch?v=MCmaCifzgbg)

### macOS-Specific Tools
- [Homebrew](https://brew.sh) - Package manager for macOS
- [iTerm2](https://iterm2.com) - Enhanced terminal
- [Cyberduck](https://cyberduck.io) - GUI SFTP client
- [SSH Agent](https://www.ssh.com/academy/ssh/agent) - Key management

### Apple Resources
- [Network Utility](https://support.apple.com/guide/network-utility/welcome/mac)
- [Console.app](https://support.apple.com/guide/console/welcome/mac) - System log viewer
- [Activity Monitor](https://support.apple.com/guide/activity-monitor/welcome/mac) - Process monitoring

## Recovery Information

If something goes wrong:
- Recovery procedures are documented on [Ableton Center Code](https://ableton.centercode.com/project/article/item.html?cap=ecd3942a1fe3405eb27a806608401a0b&arttypeid={e70be312-f44a-418b-bb74-ed1030e3a49a}&artid={C0A2D9E2-D52F-4DEB-8BEE-356B65C8942E})
- Time Machine backups can restore your Mac configuration
- Always refer to official Ableton documentation for device recovery

## Still Having Issues?

If you're still experiencing problems:
1. Check the [GitHub Issues](https://github.com/peterswimm/extending-move/issues) page
2. Join the [Discord community](https://discord.gg/yP7SjqDrZG) for real-time help
3. Create a new issue with:
   - macOS version (`sw_vers`)
   - Hardware details (Intel vs Apple Silicon)
   - Complete error messages
   - Output of `ssh -v ableton@move.local`
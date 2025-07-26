# macOS Troubleshooting Links and Solutions

This guide provides solutions to common issues you might encounter while setting up Extending Move on macOS.

## Connection Issues

### Problem: "Host Not Found" or Cannot Connect to move.local
**Symptoms**: `ping move.local` fails or SSH connection refused

**Solutions**:
1. **Check Network Connection**: Ensure both devices are on same Wi-Fi
   - [Mac Network Troubleshooting](https://support.apple.com/en-us/HT203365)

2. **Use IP Address Instead**: 
   - Find your Move's IP address in Settings → System → Network
   - Use `ssh ableton@192.168.1.XXX` (replace with actual IP)
   - Bookmark `http://192.168.1.XXX:909` instead of move.local

3. **DNS Cache Issues**: 
   ```
   sudo dscacheutil -flushcache
   sudo killall -HUP mDNSResponder
   ```
   - [Mac DNS Troubleshooting](https://support.apple.com/en-us/HT202516)

4. **mDNS/Bonjour Issues**: 
   - [Bonjour Service Troubleshooting](https://support.apple.com/en-us/HT204618)

### Problem: "Connection Refused" on SSH
**Solutions**:
1. **Verify SSH is Enabled** on Move (Settings → System → SSH)
2. **Check Firewall** settings on Mac
   - [Mac Firewall Settings](https://support.apple.com/en-us/HT201642)
3. **Try Different Port**: Some networks block SSH
   ```
   ssh -p 22 ableton@move.local
   ```

---

## SSH Key Issues

### Problem: Permission Denied (publickey)
**Symptoms**: Cannot connect even after adding public key

**Solutions**:
1. **Check Key Permissions**:
   ```
   chmod 600 ~/.ssh/move_key
   chmod 644 ~/.ssh/move_key.pub
   chmod 700 ~/.ssh
   ```

2. **Verify Key was Added Correctly**:
   - Re-copy and paste the public key to Move
   - Ensure no extra spaces or line breaks
   - [SSH Key Setup Guide](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)

3. **Check SSH Config**:
   ```
   cat ~/.ssh/config
   ```
   Should contain:
   ```
   Host move.local
     AddKeysToAgent yes
     IdentityFile ~/.ssh/move_key
     HostName move.local
   ```

4. **SSH Agent Issues**:
   ```
   ssh-add ~/.ssh/move_key
   ssh-add -l
   ```

### Problem: "Host Key Verification Failed"
**Solution**: Remove old host key and try again
```
ssh-keygen -R move.local
```
Then reconnect and accept the new host key.

### Problem: SSH Key Already Exists Warning
**Solutions**:
1. **Use Existing Key**: If you already have a move_key, you can use it
2. **Overwrite Key**: If you want a fresh start:
   ```
   rm ~/.ssh/move_key*
   ssh-keygen -t ed25519 -f ~/.ssh/move_key -N ""
   ```

---

## Script Permission Issues

### Problem: "Permission Denied" When Running Scripts
**Symptoms**: `./script-name.sh` fails with permission error

**Solutions**:
1. **Make Script Executable**:
   ```
   chmod +x utility-scripts/*.sh
   chmod +x utility-scripts/*.command
   ```

2. **Alternative Execution**:
   ```
   bash utility-scripts/setup-ssh-and-install-on-move.sh
   ```

### Problem: "Command Not Found" for Scripts
**Solutions**:
1. **Check Current Directory**:
   ```
   pwd
   ls -la utility-scripts/
   ```

2. **Use Full Path**:
   ```
   bash ./utility-scripts/setup-ssh-and-install-on-move.sh
   ```

---

## Installation Issues

### Problem: Python/Pip Installation Fails on Move
**Solutions**:
1. **Check Internet Connection** on Move device
2. **Retry with Manual Steps**:
   ```
   ssh ableton@move.local
   cd /data/UserData
   wget https://bootstrap.pypa.io/get-pip.py --no-check-certificate
   python3 get-pip.py
   exit
   ```

3. **Disk Space Issues**:
   ```
   ssh ableton@move.local "df -h"
   ```
   - [Free Up Space if Needed](https://support.apple.com/en-us/HT206996)

### Problem: File Transfer Errors
**Symptoms**: `tar` or `scp` errors during installation

**Solutions**:
1. **Check SSH Connection**: Ensure stable connection
2. **Retry Installation**:
   ```
   ./utility-scripts/update-on-move.sh --overwrite
   ```

3. **Manual File Copy**:
   ```
   scp -r core handlers templates_jinja static ableton@move.local:/data/UserData/extending-move/
   ```

---

## Terminal and Command Issues

### Problem: "Command Not Found" Errors
**Common Commands and Solutions**:

1. **ssh not found**: 
   - SSH is built into macOS, try restarting Terminal
   - [macOS SSH Documentation](https://support.apple.com/en-us/guide/terminal/apd5265185d-f365-44cb-8b09-71a064a42125/mac)

2. **git not found**: Install Xcode Command Line Tools
   ```
   xcode-select --install
   ```

3. **wget not found**: Use curl instead
   ```
   curl -O https://bootstrap.pypa.io/get-pip.py
   ```

### Problem: Terminal/Bash Issues
**Solutions**:
1. **Reset Terminal**: Close and reopen Terminal app
2. **Check Shell**: 
   ```
   echo $SHELL
   ```
   Should show `/bin/bash` or `/bin/zsh`

3. **Path Issues**:
   ```
   echo $PATH
   export PATH="/usr/local/bin:/usr/bin:/bin:$PATH"
   ```

---

## Browser and Web Interface Issues

### Problem: Cannot Access Web Interface
**Symptoms**: Browser cannot load `http://move.local:909`

**Solutions**:
1. **Check Service is Running**:
   ```
   ssh ableton@move.local "ps aux | grep python"
   ```

2. **Restart Service**:
   ```
   ssh ableton@move.local "killall python3"
   ./utility-scripts/restart-webserver.sh
   ```

3. **Check Port**:
   ```
   cat port.conf
   ```
   Use the correct port number in browser

4. **Use IP Address**: Replace move.local with actual IP address

### Problem: Web Interface Loads but Features Don't Work
**Solutions**:
1. **Clear Browser Cache**: Cmd+Shift+R or clear cache in browser settings
2. **Disable Browser Extensions**: Try in private/incognito mode
3. **Try Different Browser**: Test with Safari, Chrome, or Firefox
4. **Check JavaScript**: Ensure JavaScript is enabled

---

## macOS-Specific Issues

### Problem: Gatekeeper/Security Warnings
**Symptoms**: "Cannot verify developer" warnings

**Solutions**:
1. **Allow in Security Settings**:
   - System Preferences → Security & Privacy → General
   - Click "Allow" for blocked applications

2. **Override for Specific File**:
   ```
   xattr -d com.apple.quarantine utility-scripts/setup-ssh-and-install-on-move.command
   ```

### Problem: Spotlight/Privacy Issues
**Solution**: Add Terminal to Full Disk Access if needed
- System Preferences → Security & Privacy → Privacy → Full Disk Access

### Problem: Network Issues on Apple Silicon Macs
**Solutions**:
1. **Rosetta Issues**: Most network tools work natively, but if needed:
   ```
   arch -x86_64 ssh ableton@move.local
   ```

2. **WiFi Power Management**:
   - System Preferences → Energy Saver → Prevent computer from sleeping

---

## File System Issues

### Problem: Cannot Find Downloaded Files
**Common Locations**:
- `~/Downloads/extending-move-main/`
- `~/Desktop/extending-move-main/`
- `~/Documents/extending-move-main/`

**Find Command**:
```
find ~ -name "extending-move-main" -type d 2>/dev/null
```

### Problem: Path with Spaces
**Solution**: Use quotes or escape spaces
```
cd "~/Desktop/extending move main/"
cd ~/Desktop/extending\ move\ main/
```

---

## Additional Resources

### Official Apple Documentation
- [Terminal User Guide](https://support.apple.com/en-us/guide/terminal/welcome/mac)
- [Network Troubleshooting](https://support.apple.com/en-us/HT203365)
- [SSH Setup on Mac](https://support.apple.com/en-us/guide/terminal/apd5265185d-f365-44cb-8b09-71a064a42125/mac)

### Third-Party Resources
- [SSH Academy](https://www.ssh.com/academy/ssh)
- [macOS Terminal Cheat Sheet](https://github.com/0nn0/terminal-mac-cheatsheet)
- [Homebrew Package Manager](https://brew.sh/) (if you need additional tools)

### Community Resources
- [Extending Move Discord](https://discord.gg/yP7SjqDrZG)
- [GitHub Issues](https://github.com/peterswimm/extending-move/issues)
- [Apple Communities](https://discussions.apple.com/)

### Video Tutorials
- [Terminal Basics for Mac](https://www.youtube.com/results?search_query=mac+terminal+basics)
- [SSH Tutorial for Beginners](https://www.youtube.com/results?search_query=ssh+tutorial+beginners)

---

## Getting More Help

### Gathering Information for Support
Before asking for help, collect this information:

1. **macOS Version**:
   ```
   sw_vers
   ```

2. **Error Messages**: Copy exact error text

3. **Network Info**:
   ```
   ping move.local
   nslookup move.local
   ```

4. **SSH Debug Info**:
   ```
   ssh -v ableton@move.local
   ```

### Where to Get Help
1. **Discord Community**: Fast, friendly help from experienced users
2. **GitHub Issues**: For bugs or feature requests  
3. **Apple Support**: For Mac-specific issues
4. **Stack Overflow**: For general SSH/networking questions

### Creating Good Support Requests
- Include your macOS version
- Describe what you were trying to do
- Share the exact command that failed
- Include any error messages
- Mention what you've already tried

Remember: The community wants to help! Don't hesitate to ask questions, even if they seem basic.
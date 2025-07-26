# macOS Troubleshooting Resources

This document provides reliable resources for resolving common issues when setting up SSH and file transfers to your Ableton Move on macOS.

## Quick Solutions for Common Problems

### Can't Connect to move.local?
**Problem**: Browser shows "can't connect" when trying to access `http://move.local`

**Quick Fixes**:
1. **Check network connection**: Ensure both your Mac and Move are on the same Wi-Fi network
2. **Try the IP address instead**: 
   - Go to System Settings → Wi-Fi → Details (next to your network)
   - Look for your Move device or check your router's device list
   - Use `http://[IP ADDRESS]/development/ssh` instead of `move.local`
3. **Restart network services**: 
   - Turn Wi-Fi off and on
   - Restart your Move and try again

### SSH Connection Fails?
**Problem**: Get "Connection refused" or "Permission denied" errors

**Quick Fixes**:
1. **Check the public key**: Ensure you copied the entire key correctly (including `ssh-ed25519` at the start)
2. **Verify key permissions**:
   ```bash
   chmod 600 ~/.ssh/move_key
   chmod 644 ~/.ssh/move_key.pub
   ```
3. **Test with verbose output**: `ssh -v move` to see detailed connection info

### File Transfer Not Working?
**Problem**: SCP commands fail or files don't appear on Move

**Quick Fixes**:
1. **Check file paths**: Use drag-and-drop to ensure correct paths
2. **Use quotes**: Always put file paths with spaces in quotes
3. **Check Move storage**: Your Move might be full
4. **Verify destination directories exist**: Some paths might need to be created first

---

## Detailed Help Resources

### SSH and Key Management
- **Apple's SSH Guide**: [https://support.apple.com/guide/terminal/create-ssh-keys-apda8016ced-4b7c-4a1b-b441-2077b8b0bc04/mac](https://support.apple.com/guide/terminal/create-ssh-keys-apda8016ced-4b7c-4a1b-b441-2077b8b0bc04/mac)
- **SSH Key Generation Tutorial**: [https://www.ssh.com/academy/ssh/keygen](https://www.ssh.com/academy/ssh/keygen)
- **macOS Terminal User Guide**: [https://support.apple.com/guide/terminal/welcome/mac](https://support.apple.com/guide/terminal/welcome/mac)
- **SSH Config File Guide**: [https://linuxize.com/post/using-the-ssh-config-file/](https://linuxize.com/post/using-the-ssh-config-file/)

### File Transfer (SCP) Help
- **SCP Command Tutorial**: [https://linuxize.com/post/how-to-use-scp-command-to-securely-transfer-files/](https://linuxize.com/post/how-to-use-scp-command-to-securely-transfer-files/)
- **macOS Command Line Primer**: [https://developer.apple.com/library/archive/documentation/OpenSource/Conceptual/ShellScripting/CommandLnePrimer/CommandLine.html](https://developer.apple.com/library/archive/documentation/OpenSource/Conceptual/ShellScripting/CommandLnePrimer/CommandLine.html)

### Network and Connectivity
- **macOS Network Troubleshooting**: [https://support.apple.com/HT202663](https://support.apple.com/HT202663)
- **Find Device IP Addresses on Mac**: [https://support.apple.com/guide/mac-help/find-your-computers-name-and-network-address-mchlp1177/mac](https://support.apple.com/guide/mac-help/find-your-computers-name-and-network-address-mchlp1177/mac)
- **Bonjour and .local Addresses**: [https://support.apple.com/HT201275](https://support.apple.com/HT201275)

### Terminal and Command Line
- **Terminal User Guide**: [https://support.apple.com/guide/terminal/welcome/mac](https://support.apple.com/guide/terminal/welcome/mac)
- **macOS Command Line Tools**: [https://developer.apple.com/library/archive/technotes/tn2339/_index.html](https://developer.apple.com/library/archive/technotes/tn2339/_index.html)

---

## Step-by-Step Problem Solving

### Issue: "Permission denied (publickey)" error
**What it means**: Your SSH key isn't being accepted by the Move.

**Solutions**:
1. **Verify the public key was added correctly**:
   - Go back to `http://move.local/development/ssh`
   - Make sure your key appears in the list
   - Check that the entire key was copied (no line breaks or missing parts)

2. **Check key file permissions**:
   ```bash
   ls -la ~/.ssh/move_key*
   ```
   - Private key should be `-rw-------` (600)
   - Public key should be `-rw-r--r--` (644)

3. **Fix permissions if needed**:
   ```bash
   chmod 600 ~/.ssh/move_key
   chmod 644 ~/.ssh/move_key.pub
   ```

**Helpful Links**:
- [SSH Permission Issues](https://stackoverflow.com/questions/9270734/ssh-permissions-are-too-open-error)

### Issue: "Host key verification failed"
**What it means**: Your Mac doesn't recognize the Move's identity.

**Solutions**:
1. **Remove old host key**:
   ```bash
   ssh-keygen -R move.local
   ```

2. **Try connecting again** and type "yes" when prompted

3. **If using IP address**, also remove that:
   ```bash
   ssh-keygen -R [IP_ADDRESS]
   ```

**Helpful Links**:
- [SSH Host Key Verification](https://www.ssh.com/academy/ssh/host-key)

### Issue: "No such file or directory" errors
**What it means**: The file path you specified doesn't exist.

**Solutions**:
1. **Use drag and drop**: Drag files from Finder into Terminal to get exact paths
2. **Use tab completion**: Type part of a path and press Tab to auto-complete
3. **Check with ls command**: `ls -la /path/to/directory/` to see what's actually there
4. **Use quotes**: Always quote paths with spaces: `"~/My Documents/file.wav"`

**Example of getting the correct path**:
```bash
# Wrong - spaces cause issues
scp ~/My Documents/sample.wav move:/data/UserData/UserLibrary/Samples/

# Right - quoted path
scp "~/My Documents/sample.wav" move:/data/UserData/UserLibrary/Samples/

# Also right - escaped spaces
scp ~/My\ Documents/sample.wav move:/data/UserData/UserLibrary/Samples/
```

### Issue: File uploads seem to work but files don't appear
**What it means**: The upload succeeded but files went to the wrong location or have permission issues.

**Solutions**:
1. **Check if the file actually transferred**:
   ```bash
   ssh move "ls -la /data/UserData/UserLibrary/Samples/"
   ```

2. **Verify the destination path** - common correct paths:
   - Samples: `/data/UserData/UserLibrary/Samples/`
   - Presets: `/data/UserData/UserLibrary/Track Presets/`

3. **Check Move storage space**:
   ```bash
   ssh move "df -h /data"
   ```

---

## macOS-Specific Tips

### Using Finder Integration
1. **Get path from Finder**:
   - Right-click file in Finder
   - Hold Option key
   - Click "Copy [filename] as Pathname"

2. **View hidden files in Finder**:
   - Press `Command + Shift + .` to toggle hidden files
   - This helps you see the `.ssh` folder

### Terminal Shortcuts
- **Clear screen**: `Command + K`
- **New tab**: `Command + T`
- **Close tab**: `Command + W`
- **Scroll up**: `Page Up` or `Command + Up Arrow`
- **Auto-complete**: Press `Tab` to complete file names and paths

### Keychain and SSH Agent
If you're having persistent authentication issues:

1. **Check if ssh-agent is running**:
   ```bash
   ps aux | grep ssh-agent
   ```

2. **Start ssh-agent if needed**:
   ```bash
   eval "$(ssh-agent -s)"
   ```

3. **Add key to agent**:
   ```bash
   ssh-add ~/.ssh/move_key
   ```

---

## Video Tutorials

### SSH Setup on macOS
- **SSH Keys on macOS Tutorial**: [https://www.youtube.com/watch?v=lmAFzSMg9ds](https://www.youtube.com/watch?v=lmAFzSMg9ds)
- **Terminal for Beginners**: [https://www.youtube.com/watch?v=aKRYQsKR46I](https://www.youtube.com/watch?v=aKRYQsKR46I)

### File Management
- **macOS Terminal File Management**: [https://www.youtube.com/watch?v=jDINUSK7rXE](https://www.youtube.com/watch?v=jDINUSK7rXE)
- **SCP File Transfer Guide**: [https://www.youtube.com/watch?v=fmMg6gywbR4](https://www.youtube.com/watch?v=fmMg6gywbR4)

---

## Community Support

### Official Ableton Resources
- **Ableton Move Support**: [https://help.ableton.com/hc/en-us/categories/4415914838162-Move](https://help.ableton.com/hc/en-us/categories/4415914838162-Move)
- **Ableton Community Forum**: [https://www.ableton.com/en/community/](https://www.ableton.com/en/community/)

### Project-Specific Help
- **Extending Move GitHub**: [https://github.com/charlesvestal/extending-move](https://github.com/charlesvestal/extending-move)
- **Extending Move Discord**: [https://discord.gg/yP7SjqDrZG](https://discord.gg/yP7SjqDrZG)

### General macOS Support
- **Apple Support Communities**: [https://discussions.apple.com/](https://discussions.apple.com/)
- **Reddit r/MacOS**: [https://www.reddit.com/r/MacOS/](https://www.reddit.com/r/MacOS/)
- **Stack Overflow (Terminal/SSH)**: [https://stackoverflow.com/questions/tagged/macos+ssh](https://stackoverflow.com/questions/tagged/macos+ssh)

---

## Advanced Tips

### Creating Aliases for Common Commands
Add these to your `~/.zshrc` or `~/.bash_profile` file:

```bash
# Quick aliases for Move operations
alias move-connect="ssh move"
alias move-samples="ssh move 'ls -la /data/UserData/UserLibrary/Samples/'"
alias move-presets="ssh move 'ls -la /data/UserData/UserLibrary/Track\ Presets/'"

# Function to quickly upload samples
upload-sample() {
    scp "$1" move:/data/UserData/UserLibrary/Samples/
}
```

After adding these, restart Terminal or run `source ~/.zshrc`

### Monitoring File Transfers
For large files, use SCP with progress indicator:
```bash
scp -v "large-file.wav" move:/data/UserData/UserLibrary/Samples/
```

### Batch Operations
Upload multiple files at once:
```bash
scp *.wav move:/data/UserData/UserLibrary/Samples/
```

---

## When All Else Fails

### Reset SSH Configuration
If you're completely stuck, start fresh:

1. **Remove SSH configuration**:
   ```bash
   rm ~/.ssh/move_key*
   rm ~/.ssh/config
   ```

2. **Clear known hosts**:
   ```bash
   ssh-keygen -R move.local
   ```

3. **Start over** with the setup guide

### Alternative Tools
- **Cyberduck**: GUI-based SFTP client for macOS
- **FileZilla**: Cross-platform FTP/SFTP client
- **Transmit**: Popular macOS file transfer app

---

## Important Reminders

### Safety First
- **Always backup your Move data** before making changes
- **Never share your private SSH key** (the file without .pub)
- **Test with small files first** before transferring large collections

### Getting Additional Help
1. **Use verbose SSH output**: `ssh -v move` shows detailed connection info
2. **Check Console app**: Look for system-level error messages
3. **Ask in the community**: The extending-move Discord is very helpful
4. **Include details** when asking for help:
   - Your macOS version
   - Exact error messages
   - What you were trying to do
   - Steps you've already tried

---

*macOS has excellent built-in SSH support, making it one of the easiest platforms for connecting to your Move. Most issues are related to network connectivity or file path problems, which are easily resolved with the tips above.*
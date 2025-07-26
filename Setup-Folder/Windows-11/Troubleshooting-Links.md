# Windows 11 Troubleshooting Resources

This document provides reliable resources for resolving common issues when setting up SSH and file transfers to your Ableton Move on Windows 11.

## Quick Solutions for Common Problems

### Can't Connect to move.local?
**Problem**: Browser shows "can't reach this page" when trying to access `http://move.local`

**Quick Fixes**:
1. **Check network connection**: Make sure both your computer and Move are on the same Wi-Fi network
2. **Try the IP address instead**: 
   - Find your Move's IP address in your router's settings or Wi-Fi settings
   - Use `http://[IP ADDRESS]/development/ssh` instead of `move.local`
3. **Restart your Move and try again**

### SSH Connection Fails?
**Problem**: Get "Connection refused" or "Host key verification failed" errors

**Quick Fixes**:
1. **Double-check the public key**: Make sure you copied the entire key correctly
2. **Wait a moment**: Sometimes it takes a few seconds for the Move to recognize new keys
3. **Try again with verbose output**: `ssh -v -i ~/.ssh/move_key ableton@move.local`

### File Transfer Not Working?
**Problem**: SCP commands fail or files don't appear on Move

**Quick Fixes**:
1. **Check file paths**: Make sure your local file path is correct
2. **Use quotes**: Always put file paths with spaces in quotes
3. **Check permissions**: Some directories might need different permissions

---

## Detailed Help Resources

### Windows Subsystem for Linux (WSL)
- **Official Microsoft WSL Guide**: [https://docs.microsoft.com/en-us/windows/wsl/install](https://docs.microsoft.com/en-us/windows/wsl/install)
- **WSL Troubleshooting**: [https://docs.microsoft.com/en-us/windows/wsl/troubleshooting](https://docs.microsoft.com/en-us/windows/wsl/troubleshooting)
- **WSL FAQ**: [https://docs.microsoft.com/en-us/windows/wsl/faq](https://docs.microsoft.com/en-us/windows/wsl/faq)

### SSH and Key Management
- **SSH Key Generation Tutorial**: [https://www.ssh.com/academy/ssh/keygen](https://www.ssh.com/academy/ssh/keygen)
- **Understanding SSH Keys (Beginner Guide)**: [https://jumpcloud.com/blog/what-are-ssh-keys](https://jumpcloud.com/blog/what-are-ssh-keys)
- **SSH Config File Guide**: [https://linuxize.com/post/using-the-ssh-config-file/](https://linuxize.com/post/using-the-ssh-config-file/)

### File Transfer (SCP) Help
- **SCP Command Tutorial**: [https://linuxize.com/post/how-to-use-scp-command-to-securely-transfer-files/](https://linuxize.com/post/how-to-use-scp-command-to-securely-transfer-files/)
- **SCP Examples and Tips**: [https://www.cyberciti.biz/faq/linux-unix-scp-file-transfer-examples/](https://www.cyberciti.biz/faq/linux-unix-scp-file-transfer-examples/)

### Network and Connectivity
- **Finding Device IP Addresses on Windows**: [https://support.microsoft.com/en-us/windows/find-your-ip-address-in-windows-f21a9bbc-c582-251d-240e-b776a0079a07](https://support.microsoft.com/en-us/windows/find-your-ip-address-in-windows-f21a9bbc-c582-251d-240e-b776a0079a07)
- **Windows Network Troubleshooting**: [https://support.microsoft.com/en-us/windows/fix-network-connection-issues-in-windows-213c4dae-9318-6a7b-191a-ccb86ac65b55](https://support.microsoft.com/en-us/windows/fix-network-connection-issues-in-windows-213c4dae-9318-6a7b-191a-ccb86ac65b55)

### Git for Windows (Alternative to WSL)
- **Git for Windows Installation**: [https://git-scm.com/download/win](https://git-scm.com/download/win)
- **Git Bash Tutorial**: [https://www.atlassian.com/git/tutorials/git-bash](https://www.atlassian.com/git/tutorials/git-bash)

---

## Step-by-Step Problem Solving

### Issue: "Command not found" errors
**What it means**: The system can't find the command you're trying to run.

**Solutions**:
1. **Make sure you're in the right terminal**: Use Ubuntu (WSL) or Git Bash, not regular Command Prompt
2. **Check your typing**: Commands are case-sensitive
3. **Install missing tools**: Some commands might need additional software

**Helpful Links**:
- [WSL Command Reference](https://docs.microsoft.com/en-us/windows/wsl/reference)

### Issue: Permission denied errors
**What it means**: You don't have the right permissions to access a file or directory.

**Solutions**:
1. **Check file ownership**: Make sure you own the files you're trying to access
2. **Use correct paths**: Double-check your file paths
3. **Check SSH key permissions**: Your private key should have restricted permissions

**Helpful Links**:
- [Understanding File Permissions](https://www.guru99.com/file-permissions.html)

### Issue: File paths with spaces cause errors
**What it means**: Spaces in file names confuse the command line.

**Solutions**:
1. **Use quotes**: Always wrap paths with spaces in quotes
2. **Use escape characters**: Add backslashes before spaces
3. **Use short paths**: Consider moving files to simpler locations

**Example**:
```bash
# Good - using quotes
scp "C:/Users/My Name/My File.wav" move:/data/UserData/UserLibrary/Samples/

# Also good - using escape characters  
scp C:/Users/My\ Name/My\ File.wav move:/data/UserData/UserLibrary/Samples/
```

---

## Video Tutorials

### General SSH Setup
- **SSH Keys Explained (Simple)**: [https://www.youtube.com/watch?v=hQWRp-FdTpc](https://www.youtube.com/watch?v=hQWRp-FdTpc)
- **Windows SSH Setup Tutorial**: [https://www.youtube.com/watch?v=p4jNfFKd8d8](https://www.youtube.com/watch?v=p4jNfFKd8d8)

### WSL Installation and Setup
- **WSL Installation Guide**: [https://www.youtube.com/watch?v=X-DHaQLrBi8](https://www.youtube.com/watch?v=X-DHaQLrBi8)
- **WSL for Beginners**: [https://www.youtube.com/watch?v=DC5fYY6SgWo](https://www.youtube.com/watch?v=DC5fYY6SgWo)

---

## Community Support

### Official Ableton Resources
- **Ableton Move Support**: [https://help.ableton.com/hc/en-us/categories/4415914838162-Move](https://help.ableton.com/hc/en-us/categories/4415914838162-Move)
- **Ableton Community Forum**: [https://www.ableton.com/en/community/](https://www.ableton.com/en/community/)

### Project-Specific Help
- **Extending Move GitHub**: [https://github.com/charlesvestal/extending-move](https://github.com/charlesvestal/extending-move)
- **Extending Move Discord**: [https://discord.gg/yP7SjqDrZG](https://discord.gg/yP7SjqDrZG)

### General Tech Support
- **Reddit r/Windows11**: [https://www.reddit.com/r/Windows11/](https://www.reddit.com/r/Windows11/)
- **Stack Overflow**: [https://stackoverflow.com/questions/tagged/ssh](https://stackoverflow.com/questions/tagged/ssh)

---

## Important Reminders

### Safety First
- **Always backup your Move data** before making changes
- **Never share your private SSH key** (the file without .pub)
- **Use trusted sources** for downloads and software

### Getting Additional Help
1. **Check this guide first** - many common issues are covered here
2. **Search the error message** - copy and paste error messages into search engines
3. **Ask in the community** - the extending-move Discord is very helpful
4. **Be specific** - when asking for help, include:
   - What you were trying to do
   - The exact error message
   - What steps you've already tried

### When All Else Fails
If you're completely stuck:
1. **Try the alternative method** (Git Bash instead of WSL, or vice versa)
2. **Start fresh** - sometimes starting over with clean SSH keys helps
3. **Ask for help** - the community is friendly and helpful!

---

*Remember: Everyone was a beginner once. Don't be afraid to ask questions or try again if something doesn't work the first time.*
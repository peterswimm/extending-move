# Windows 11 Troubleshooting Guide - Extending Move

This guide provides solutions to common issues you might encounter when setting up extending-move on Windows 11.

## Common Issues and Solutions

### SSH and Connection Issues

#### Problem: "move.local" not found
**Error:** `ping: cannot resolve move.local: Unknown host`

**Solutions:**
1. **Check network connection:**
   - Ensure both your computer and Move are on the same Wi-Fi network
   - Try accessing Move's web interface at `http://move.local` first

2. **Use IP address instead:**
   - Find your Move's IP address from your router's admin panel
   - Replace `move.local` with the IP address in commands
   - Example: `ssh ableton@192.168.1.100`

3. **Windows network discovery:**
   - Open **Settings** > **Network & Internet** > **Advanced network settings**
   - Turn on **Network discovery**
   - Restart your computer

**Helpful Links:**
- [Windows Network Troubleshooter](https://support.microsoft.com/en-us/windows/fix-network-connection-issues-in-windows-f575b1b2-7c90-4f2c-be8a-83a67bb0d451)
- [Bonjour for Windows](https://support.apple.com/kb/DL999) (enables .local domains)

#### Problem: SSH permission denied
**Error:** `Permission denied (publickey)`

**Solutions:**
1. **Check SSH key location:**
   ```bash
   ls -la ~/.ssh/move_key*
   ```

2. **Fix key permissions:**
   ```bash
   chmod 600 ~/.ssh/move_key
   chmod 644 ~/.ssh/move_key.pub
   ```

3. **Verify SSH config:**
   ```bash
   cat ~/.ssh/config
   ```
   Should contain entry for move.local

4. **Test connection:**
   ```bash
   ssh -v -i ~/.ssh/move_key ableton@move.local
   ```

**Helpful Links:**
- [SSH Key Troubleshooting Guide](https://docs.github.com/en/authentication/troubleshooting-ssh)
- [Windows SSH Client Documentation](https://docs.microsoft.com/en-us/windows-server/administration/openssh/openssh_keymanagement)

### Git and Installation Issues

#### Problem: Git command not found
**Error:** `'git' is not recognized as an internal or external command`

**Solutions:**
1. **Install Git for Windows:**
   - Download from [git-scm.com](https://git-scm.com/download/win)
   - During installation, select "Git from the command line and also from 3rd-party software"

2. **Add Git to PATH manually:**
   - Right-click "This PC" > Properties > Advanced system settings
   - Click "Environment Variables"
   - Edit PATH and add: `C:\Program Files\Git\bin`

3. **Use Git Bash:**
   - Launch "Git Bash" instead of Command Prompt
   - Git commands will work in Git Bash

**Helpful Links:**
- [Git for Windows Installation Guide](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
- [Windows PATH Configuration](https://www.architectryan.com/2018/03/17/add-to-the-path-on-windows-10/)

#### Problem: Python not found
**Error:** `'python' is not recognized as an internal or external command`

**Solutions:**
1. **Install Python:**
   - Download from [python.org](https://www.python.org/downloads/windows/)
   - **Important:** Check "Add Python to PATH" during installation

2. **Verify installation:**
   ```cmd
   python --version
   pip --version
   ```

3. **Manually add to PATH:**
   - Find Python installation (usually `C:\Users\YourName\AppData\Local\Programs\Python\Python3x\`)
   - Add both Python folder and Scripts folder to PATH

**Helpful Links:**
- [Python Windows Installation Guide](https://docs.python.org/3/using/windows.html)
- [Python PATH Setup](https://realpython.com/add-python-to-path/)

### Script Execution Issues

#### Problem: Script execution disabled
**Error:** `cannot be loaded because running scripts is disabled on this system`

**Solutions:**
1. **Enable script execution (temporary):**
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

2. **Use Git Bash instead:**
   - Run scripts in Git Bash rather than PowerShell
   - Git Bash uses bash scripting, not PowerShell

**Helpful Links:**
- [PowerShell Execution Policies](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_execution_policies)

### Web Interface Issues

#### Problem: Cannot access web interface
**Error:** Browser cannot reach `http://move.local:909`

**Solutions:**
1. **Check webserver status:**
   ```bash
   ssh -i ~/.ssh/move_key ableton@move.local "ps aux | grep python"
   ```

2. **Restart webserver:**
   ```bash
   ssh -i ~/.ssh/move_key ableton@move.local "sudo systemctl restart extending-move"
   ```

3. **Check firewall:**
   - Windows Defender might be blocking the connection
   - Add exception for port 909 in Windows Firewall

4. **Try different ports:**
   - Some networks block certain ports
   - Try ports 808, 707, or 606

**Helpful Links:**
- [Windows Firewall Configuration](https://support.microsoft.com/en-us/windows/turn-microsoft-defender-firewall-on-or-off-ec0844f7-aebd-0583-67fe-601ecf5d774f)

### File Transfer Issues

#### Problem: SCP transfer fails
**Error:** Various SCP connection errors

**Solutions:**
1. **Use WinSCP (GUI alternative):**
   - Download [WinSCP](https://winscp.net/eng/download.php)
   - Configure with Move connection details
   - Provides visual file transfer interface

2. **Alternative transfer methods:**
   ```bash
   # Using rsync (if available)
   rsync -avz -e "ssh -i ~/.ssh/move_key" file.txt ableton@move.local:/home/ableton/
   ```

**Helpful Links:**
- [WinSCP Documentation](https://winscp.net/eng/docs/)
- [SCP Command Tutorial](https://linuxize.com/post/how-to-use-scp-command-to-securely-transfer-files/)

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

### Windows-Specific Tools
- [Windows Subsystem for Linux (WSL)](https://docs.microsoft.com/en-us/windows/wsl/) - Alternative Unix-like environment
- [PuTTY](https://www.putty.org/) - Alternative SSH client
- [Windows Terminal](https://github.com/microsoft/terminal) - Enhanced command line experience

## Recovery Information

If something goes wrong:
- Recovery procedures are documented on [Ableton Center Code](https://ableton.centercode.com/project/article/item.html?cap=ecd3942a1fe3405eb27a806608401a0b&arttypeid={e70be312-f44a-418b-bb74-ed1030e3a49a}&artid={C0A2D9E2-D52F-4DEB-8BEE-356B65C8942E})
- Always refer to official Ableton documentation for device recovery

## Still Having Issues?

If you're still experiencing problems:
1. Check the [GitHub Issues](https://github.com/peterswimm/extending-move/issues) page
2. Join the [Discord community](https://discord.gg/yP7SjqDrZG) for real-time help
3. Create a new issue with detailed error messages and system information
# Linux Troubleshooting Resources

This document provides reliable resources for resolving common issues when setting up SSH and file transfers to your Ableton Move on Linux.

## Quick Solutions for Common Problems

### Can't Connect to move.local?
**Problem**: Browser shows "can't connect" when trying to access `http://move.local`

**Quick Fixes**:
1. **Check network connection**: Ensure both your Linux computer and Move are on the same Wi-Fi network
2. **Try the IP address instead**: 
   - Find Move's IP: `nmap -sn 192.168.1.0/24` (adjust subnet for your network)
   - Or check your router's device list
   - Use `http://[IP ADDRESS]/development/ssh` instead of `move.local`
3. **Install Avahi for .local resolution**:
   - Ubuntu/Debian: `sudo apt install avahi-daemon avahi-utils`
   - Fedora: `sudo dnf install avahi avahi-tools`
   - Test with: `avahi-resolve -n move.local`

### SSH Connection Fails?
**Problem**: Get "Connection refused" or "Permission denied" errors

**Quick Fixes**:
1. **Check the public key**: Ensure you copied the entire key correctly
2. **Verify key permissions**:
   ```bash
   chmod 600 ~/.ssh/move_key
   chmod 644 ~/.ssh/move_key.pub
   chmod 700 ~/.ssh
   ```
3. **Test with verbose output**: `ssh -v move` to see detailed connection info
4. **Check SSH service**: `systemctl status ssh` (some distributions require starting SSH)

### File Transfer Not Working?
**Problem**: SCP commands fail or files don't appear on Move

**Quick Fixes**:
1. **Check file paths**: Use tab completion to ensure correct paths
2. **Use quotes**: Always put file paths with spaces in quotes
3. **Check Move storage**: `ssh move "df -h /data"` to see available space
4. **Verify file permissions**: Some files might not be readable

---

## Detailed Help Resources

### SSH and Key Management
- **SSH Key Generation Guide**: [https://www.ssh.com/academy/ssh/keygen](https://www.ssh.com/academy/ssh/keygen)
- **SSH Config File Guide**: [https://linuxize.com/post/using-the-ssh-config-file/](https://linuxize.com/post/using-the-ssh-config-file/)
- **OpenSSH Manual**: [https://www.openssh.com/manual.html](https://www.openssh.com/manual.html)
- **SSH Troubleshooting**: [https://www.cyberciti.biz/faq/ssh-connection-refused-on-linux/](https://www.cyberciti.biz/faq/ssh-connection-refused-on-linux/)

### File Transfer (SCP) Help
- **SCP Command Tutorial**: [https://linuxize.com/post/how-to-use-scp-command-to-securely-transfer-files/](https://linuxize.com/post/how-to-use-scp-command-to-securely-transfer-files/)
- **SFTP vs SCP Guide**: [https://www.ssh.com/academy/ssh/sftp-vs-scp](https://www.ssh.com/academy/ssh/sftp-vs-scp)
- **Linux File Permissions**: [https://www.redhat.com/en/blog/linux-file-permissions-explained](https://www.redhat.com/en/blog/linux-file-permissions-explained)

### Network and Connectivity
- **Network Troubleshooting**: [https://ubuntu.com/server/docs/network-configuration](https://ubuntu.com/server/docs/network-configuration)
- **Avahi (mDNS) Configuration**: [https://wiki.archlinux.org/title/Avahi](https://wiki.archlinux.org/title/Avahi)
- **Finding Device IP Addresses**: [https://www.cyberciti.biz/faq/linux-ip-command-examples-usage-syntax/](https://www.cyberciti.biz/faq/linux-ip-command-examples-usage-syntax/)

### Distribution-Specific Resources
- **Ubuntu SSH Guide**: [https://ubuntu.com/server/docs/service-openssh](https://ubuntu.com/server/docs/service-openssh)
- **Fedora SSH Configuration**: [https://docs.fedoraproject.org/en-US/fedora/f36/system-administrators-guide/infrastructure-services/OpenSSH/](https://docs.fedoraproject.org/en-US/fedora/f36/system-administrators-guide/infrastructure-services/OpenSSH/)
- **Arch Linux SSH Guide**: [https://wiki.archlinux.org/title/OpenSSH](https://wiki.archlinux.org/title/OpenSSH)

---

## Step-by-Step Problem Solving

### Issue: "Permission denied (publickey)" error
**What it means**: Your SSH key isn't being accepted by the Move.

**Solutions**:
1. **Verify the public key was added correctly**:
   - Check `http://move.local/development/ssh`
   - Ensure the entire key was copied (no line breaks or missing parts)

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
   chmod 700 ~/.ssh
   ```

4. **Test with different authentication methods**:
   ```bash
   ssh -o PreferredAuthentications=publickey -o PubkeyAuthentication=yes -i ~/.ssh/move_key ableton@move.local
   ```

**Helpful Links**:
- [SSH Key Permissions](https://stackoverflow.com/questions/9270734/ssh-permissions-are-too-open-error)

### Issue: "Host key verification failed"
**What it means**: Your Linux system doesn't recognize the Move's identity.

**Solutions**:
1. **Remove old host key**:
   ```bash
   ssh-keygen -R move.local
   ```

2. **If using IP address**, also remove that:
   ```bash
   ssh-keygen -R [IP_ADDRESS]
   ```

3. **Try connecting again** and type "yes" when prompted

4. **Disable strict host checking** (temporarily):
   ```bash
   ssh -o StrictHostKeyChecking=no move
   ```

**Helpful Links**:
- [SSH Host Key Verification](https://www.ssh.com/academy/ssh/host-key)

### Issue: "No such file or directory" errors
**What it means**: The file path you specified doesn't exist.

**Solutions**:
1. **Use tab completion**: Type part of a path and press Tab to auto-complete
2. **Check with ls command**: `ls -la /path/to/directory/` to see what's actually there
3. **Use quotes**: Always quote paths with spaces: `"/home/user/My Music/file.wav"`
4. **Use find command**: `find ~ -name "*.wav"` to locate files

**Example of getting the correct path**:
```bash
# Wrong - spaces cause issues
scp ~/My Music/sample.wav move:/data/UserData/UserLibrary/Samples/

# Right - quoted path
scp "~/My Music/sample.wav" move:/data/UserData/UserLibrary/Samples/

# Also right - escaped spaces
scp ~/My\ Music/sample.wav move:/data/UserData/UserLibrary/Samples/
```

### Issue: move.local doesn't resolve
**What it means**: Your system can't find the Move device by name.

**Solutions**:
1. **Install Avahi**:
   ```bash
   # Ubuntu/Debian
   sudo apt install avahi-daemon avahi-utils
   
   # Fedora
   sudo dnf install avahi avahi-tools
   
   # Arch
   sudo pacman -S avahi nss-mdns
   ```

2. **Start Avahi service**:
   ```bash
   sudo systemctl enable avahi-daemon
   sudo systemctl start avahi-daemon
   ```

3. **Test mDNS resolution**:
   ```bash
   avahi-resolve -n move.local
   ```

4. **Find IP manually**:
   ```bash
   nmap -sn 192.168.1.0/24 | grep -B2 -A2 "ableton\|move"
   ```

**Helpful Links**:
- [Avahi Configuration](https://wiki.archlinux.org/title/Avahi)

---

## Distribution-Specific Troubleshooting

### Ubuntu/Debian Issues

**SSH not starting**:
```bash
sudo systemctl enable ssh
sudo systemctl start ssh
```

**Firewall blocking connections**:
```bash
sudo ufw allow ssh
sudo ufw status
```

**Network manager issues**:
```bash
sudo systemctl restart NetworkManager
```

**Package installation problems**:
```bash
sudo apt update
sudo apt install --fix-missing openssh-client
```

### Fedora/CentOS/RHEL Issues

**SELinux blocking SSH**:
```bash
sudo setsebool -P ssh_keygen_exec_transition off
sudo ausearch -m AVC -ts recent | grep ssh
```

**Firewall configuration**:
```bash
sudo firewall-cmd --permanent --add-service=ssh
sudo firewall-cmd --reload
```

**Package manager issues**:
```bash
sudo dnf clean all
sudo dnf update
```

### Arch Linux Issues

**Missing SSH client**:
```bash
sudo pacman -S openssh
```

**Network configuration**:
```bash
sudo systemctl enable systemd-networkd
sudo systemctl start systemd-networkd
```

**mDNS not working**:
```bash
sudo pacman -S avahi nss-mdns
sudo systemctl enable avahi-daemon
sudo systemctl start avahi-daemon
```

Edit `/etc/nsswitch.conf` and change:
```
hosts: files myhostname dns
```
to:
```
hosts: files myhostname mdns_minimal [NOTFOUND=return] dns
```

---

## Audio Format and Conversion Issues

### File format not supported
**Problem**: Your audio files aren't in WAV format

**Solutions**:
1. **Install FFmpeg**:
   ```bash
   # Ubuntu/Debian
   sudo apt install ffmpeg
   
   # Fedora
   sudo dnf install ffmpeg
   
   # Arch
   sudo pacman -S ffmpeg
   ```

2. **Convert files**:
   ```bash
   ffmpeg -i input.mp3 output.wav
   ffmpeg -i input.flac output.wav
   ```

3. **Batch conversion**:
   ```bash
   for file in *.mp3; do ffmpeg -i "$file" "${file%.mp3}.wav"; done
   ```

**Helpful Links**:
- [FFmpeg Documentation](https://ffmpeg.org/documentation.html)

---

## Advanced Troubleshooting

### Using SFTP instead of SCP
If SCP isn't working, try SFTP:

```bash
sftp -i ~/.ssh/move_key ableton@move.local
```

Then use SFTP commands:
```
put /local/file.wav /data/UserData/UserLibrary/Samples/
get /data/UserData/UserLibrary/Samples/file.wav ~/Downloads/
ls /data/UserData/UserLibrary/Samples/
quit
```

### Debugging SSH with verbose output
```bash
ssh -vvv move
```
This shows very detailed connection information.

### Testing network connectivity
```bash
# Test if Move is reachable
ping move.local

# Test specific port
nc -zv move.local 22

# Scan for SSH services on network
nmap -p 22 192.168.1.0/24
```

### Checking SSH configuration
```bash
# Test SSH config syntax
ssh -T move

# Show what SSH would do without connecting
ssh -vvv -o BatchMode=yes move 2>&1 | head -20
```

---

## GUI Alternative Tools

If command line isn't working, try these graphical tools:

### File Transfer Clients
- **FileZilla**: Cross-platform SFTP client
  ```bash
  # Ubuntu/Debian
  sudo apt install filezilla
  
  # Fedora
  sudo dnf install filezilla
  ```
  Use protocol: SFTP, host: move.local, user: ableton

- **Nautilus (GNOME Files)**: Connect to server
  - Open Files → Other Locations
  - Connect to Server: `sftp://move.local`

- **Dolphin (KDE)**: Network folder
  - Open Dolphin → Network → Add Network Folder
  - Use SFTP protocol

### SSH Clients with GUI
- **Remmina**: Remote desktop client with SSH support
- **Terminator**: Advanced terminal with SSH profiles
- **PuTTY**: Classic SSH client (also available on Linux)

---

## Community Support

### Official Ableton Resources
- **Ableton Move Support**: [https://help.ableton.com/hc/en-us/categories/4415914838162-Move](https://help.ableton.com/hc/en-us/categories/4415914838162-Move)
- **Ableton Community Forum**: [https://www.ableton.com/en/community/](https://www.ableton.com/en/community/)

### Project-Specific Help
- **Extending Move GitHub**: [https://github.com/charlesvestal/extending-move](https://github.com/charlesvestal/extending-move)
- **Extending Move Discord**: [https://discord.gg/yP7SjqDrZG](https://discord.gg/yP7SjqDrZG)

### Linux Community Support
- **r/linux4noobs**: [https://www.reddit.com/r/linux4noobs/](https://www.reddit.com/r/linux4noobs/)
- **Stack Overflow**: [https://stackoverflow.com/questions/tagged/linux+ssh](https://stackoverflow.com/questions/tagged/linux+ssh)
- **Linux Questions**: [https://www.linuxquestions.org/](https://www.linuxquestions.org/)

### Distribution-Specific Forums
- **Ubuntu Forums**: [https://ubuntuforums.org/](https://ubuntuforums.org/)
- **Fedora Discussion**: [https://discussion.fedoraproject.org/](https://discussion.fedoraproject.org/)
- **Arch Linux Forums**: [https://bbs.archlinux.org/](https://bbs.archlinux.org/)

---

## Security Best Practices

### SSH Key Security
- **Keep your private key secure**: Never share `~/.ssh/move_key`
- **Use strong file permissions**: `chmod 600 ~/.ssh/move_key`
- **Regular key rotation**: Consider generating new keys periodically
- **Backup your keys**: Store copies in a secure location

### Network Security
- **Use secure networks**: Avoid public Wi-Fi for file transfers
- **Monitor connections**: Check who's connected to your network
- **Keep software updated**: Regular system updates improve security

### Move Device Security
- **Change default passwords**: If your Move has web authentication
- **Regular backups**: Always backup your Move's data
- **Limit access**: Only add trusted SSH keys

---

## Performance Tips

### Faster File Transfers
```bash
# Use compression for large files
scp -C large-file.wav move:/data/UserData/UserLibrary/Samples/

# Transfer multiple files efficiently
tar czf - *.wav | ssh move "cd /data/UserData/UserLibrary/Samples/ && tar xzf -"
```

### Monitoring Transfer Progress
```bash
# Use rsync for progress indication
rsync -avz --progress file.wav move:/data/UserData/UserLibrary/Samples/
```

---

## When All Else Fails

### Complete SSH Reset
If you're completely stuck, start fresh:

1. **Remove all SSH configuration**:
   ```bash
   rm -rf ~/.ssh/move_key*
   rm ~/.ssh/config
   rm ~/.ssh/known_hosts
   ```

2. **Clear any cached keys**:
   ```bash
   ssh-add -D
   ```

3. **Start over** with the setup guide

### Alternative Methods
- **USB transfer**: If you can mount your Move as USB storage
- **Web interface**: Some operations might be possible through move.local
- **Different computer**: Try the setup on another machine to isolate issues

---

## Important Reminders

### Safety First
- **Always backup your Move data** before making changes
- **Test with small files first** before transferring large collections
- **Never share your private SSH key**
- **Use trusted software sources** for additional tools

### Getting Additional Help
1. **Use verbose output**: Add `-v` to SSH commands for detailed info
2. **Check system logs**: `journalctl -u ssh` or `/var/log/auth.log`
3. **Include details** when asking for help:
   - Your Linux distribution and version
   - Exact error messages
   - Output of `ssh -v move`
   - Steps you've already tried

### Performance Considerations
- **Move has limited storage**: Monitor disk usage regularly
- **Network speed affects transfers**: Large files take time
- **Consider file compression**: For large collections

---

*Linux has excellent SSH support built-in, making it one of the most reliable platforms for connecting to your Move. Most issues are related to network configuration or file permissions, which are easily resolved with the tips above.*
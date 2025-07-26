# Linux Troubleshooting Links and Solutions

This guide provides solutions to common issues you might encounter while setting up Extending Move on Linux.

## Package Installation Issues

### Problem: "sudo: command not found" or Permission Denied
**Solutions**:

**For distributions without sudo by default (Debian minimal):**
```bash
su -
apt update && apt install sudo
usermod -aG sudo YOUR_USERNAME
exit
```
Log out and back in for changes to take effect.

**Alternative without sudo:**
```bash
su -c "apt update && apt install openssh-client git curl wget tar"
```

### Problem: Package Manager Not Found or Different Commands
**Common package managers by distribution:**

- **Ubuntu/Debian**: `apt` or `apt-get`
- **Fedora/RHEL/CentOS**: `dnf` (older: `yum`)
- **Arch Linux**: `pacman`
- **openSUSE**: `zypper`
- **Alpine Linux**: `apk`
- **Gentoo**: `emerge`

**Unknown distribution?** Check your distribution:
```bash
cat /etc/os-release
lsb_release -a
```

### Problem: Package Installation Fails
**Solutions**:
1. **Update package lists first**:
   ```bash
   sudo apt update          # Debian/Ubuntu
   sudo dnf update          # Fedora
   sudo pacman -Sy          # Arch
   ```

2. **Check internet connection**:
   ```bash
   ping 8.8.8.8
   ```

3. **Try alternative repositories**:
   - [Ubuntu Package Search](https://packages.ubuntu.com/)
   - [Debian Package Search](https://www.debian.org/distrib/packages)
   - [Arch Package Search](https://archlinux.org/packages/)

---

## SSH and Connection Issues

### Problem: "Host not found" or Cannot Connect to move.local
**Solutions**:

1. **Install mDNS/Avahi** for .local domain resolution:
   ```bash
   # Ubuntu/Debian
   sudo apt install avahi-daemon avahi-utils
   sudo systemctl enable avahi-daemon
   sudo systemctl start avahi-daemon
   
   # Fedora
   sudo dnf install avahi avahi-tools
   sudo systemctl enable avahi-daemon
   sudo systemctl start avahi-daemon
   
   # Arch
   sudo pacman -S avahi nss-mdns
   sudo systemctl enable avahi-daemon
   sudo systemctl start avahi-daemon
   ```

2. **Configure NSS for mDNS** (if .local still doesn't work):
   Edit `/etc/nsswitch.conf`:
   ```bash
   sudo nano /etc/nsswitch.conf
   ```
   Change the hosts line to:
   ```
   hosts: files mdns4_minimal [NOTFOUND=return] dns
   ```

3. **Use IP address instead**:
   ```bash
   ssh ableton@192.168.1.XXX
   ```

4. **Check network configuration**:
   ```bash
   ip route show
   nmcli connection show  # NetworkManager systems
   ```

### Problem: SSH Connection Refused
**Solutions**:

1. **Check if SSH client is installed**:
   ```bash
   which ssh
   ssh -V
   ```

2. **Test network connectivity**:
   ```bash
   nmap -p 22 move.local
   telnet move.local 22
   ```

3. **Check firewall settings**:
   ```bash
   # Ubuntu/Debian (ufw)
   sudo ufw status
   sudo ufw allow ssh
   
   # Fedora/RHEL (firewalld)
   sudo firewall-cmd --list-all
   sudo firewall-cmd --add-service=ssh --permanent
   sudo firewall-cmd --reload
   
   # Arch/manual iptables
   sudo iptables -L
   ```

### Problem: Permission Denied (publickey)
**Solutions**:

1. **Check SSH key permissions**:
   ```bash
   chmod 700 ~/.ssh
   chmod 600 ~/.ssh/move_key
   chmod 644 ~/.ssh/move_key.pub
   chmod 600 ~/.ssh/config
   ```

2. **Verify key was created correctly**:
   ```bash
   ls -la ~/.ssh/move_key*
   ssh-keygen -lf ~/.ssh/move_key.pub
   ```

3. **Test SSH connection with debug**:
   ```bash
   ssh -v ableton@move.local
   ```

4. **Re-add public key to Move**:
   ```bash
   cat ~/.ssh/move_key.pub
   # Copy output and add to Move again
   ```

---

## Script and File Permission Issues

### Problem: "Permission denied" When Running Scripts
**Solutions**:

1. **Make scripts executable**:
   ```bash
   chmod +x utility-scripts/*.sh
   chmod +x utility-scripts/*.command
   ```

2. **Check file system permissions**:
   ```bash
   ls -la utility-scripts/
   ```

3. **Run with bash explicitly**:
   ```bash
   bash utility-scripts/install-on-move.sh
   ```

### Problem: "No such file or directory"
**Solutions**:

1. **Check current directory**:
   ```bash
   pwd
   ls -la
   ```

2. **Verify you're in the project directory**:
   ```bash
   find . -name "move-webserver.py"
   ```

3. **Check file exists**:
   ```bash
   ls -la utility-scripts/install-on-move.sh
   ```

---

## Network and DNS Issues

### Problem: Slow or Unstable Connection
**Solutions**:

1. **Check WiFi signal strength**:
   ```bash
   iwconfig  # Shows wireless interface info
   nmcli dev wifi list  # NetworkManager
   ```

2. **Use wired connection if available**:
   ```bash
   ip link show  # Show all network interfaces
   ```

3. **Optimize SSH connection**:
   Add to `~/.ssh/config`:
   ```
   Host move.local
     ServerAliveInterval 60
     ServerAliveCountMax 3
     TCPKeepAlive yes
   ```

### Problem: DNS Resolution Issues
**Solutions**:

1. **Test DNS resolution**:
   ```bash
   nslookup move.local
   dig move.local
   systemd-resolve move.local  # systemd systems
   ```

2. **Try different DNS servers**:
   ```bash
   # Temporarily use Google DNS
   echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf
   ```

3. **Restart network services**:
   ```bash
   # NetworkManager
   sudo systemctl restart NetworkManager
   
   # systemd-networkd
   sudo systemctl restart systemd-networkd
   sudo systemctl restart systemd-resolved
   ```

---

## Installation and Python Issues

### Problem: Python/Pip Installation Fails on Move
**Solutions**:

1. **Check Move's internet connection**:
   ```bash
   ssh ableton@move.local "ping 8.8.8.8"
   ```

2. **Manual pip installation**:
   ```bash
   ssh ableton@move.local
   cd /data/UserData
   curl -O https://bootstrap.pypa.io/get-pip.py --insecure
   python3 get-pip.py
   exit
   ```

3. **Check disk space on Move**:
   ```bash
   ssh ableton@move.local "df -h"
   ```

### Problem: File Transfer Errors
**Solutions**:

1. **Test SCP manually**:
   ```bash
   scp move-webserver.py ableton@move.local:/data/UserData/extending-move/
   ```

2. **Use rsync instead**:
   ```bash
   rsync -avz --exclude='.git' . ableton@move.local:/data/UserData/extending-move/
   ```

3. **Check for interrupted transfers**:
   ```bash
   ssh ableton@move.local "ls -la /data/UserData/extending-move/"
   ```

---

## Distribution-Specific Issues

### Ubuntu/Debian Issues

**Problem: Snap SSH conflicts**:
```bash
sudo snap remove openssh-client  # if installed via snap
sudo apt install openssh-client
```

**Problem: Missing universe repository**:
```bash
sudo add-apt-repository universe
sudo apt update
```

### Fedora/RHEL Issues

**Problem: SELinux blocking SSH**:
```bash
sudo setsebool -P ssh_chroot_rw_homedirs on
sudo restorecon -R ~/.ssh
```

**Problem: DNF/YUM slow**:
```bash
sudo dnf update --refresh
sudo dnf clean all
```

### Arch Linux Issues

**Problem: Missing base-devel**:
```bash
sudo pacman -S base-devel
```

**Problem: AUR packages needed**:
```bash
# Install yay AUR helper
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

### openSUSE Issues

**Problem: Patterns not installed**:
```bash
sudo zypper install -t pattern devel_basis
```

**Problem: Firewall blocking**:
```bash
sudo firewall-cmd --add-service=ssh --permanent
sudo firewall-cmd --reload
```

---

## Browser and Web Interface Issues

### Problem: Cannot Access Web Interface
**Solutions**:

1. **Check if service is running**:
   ```bash
   ssh ableton@move.local "ps aux | grep python"
   ssh ableton@move.local "netstat -tulpn | grep :909"
   ```

2. **Restart the service**:
   ```bash
   ./utility-scripts/restart-webserver.sh
   ```

3. **Check firewall on Linux client**:
   ```bash
   # Test if port is reachable
   telnet move.local 909
   nc -zv move.local 909
   ```

### Problem: Web Interface Slow or Unresponsive
**Solutions**:

1. **Check system resources**:
   ```bash
   htop
   free -h
   df -h
   ```

2. **Browser cache issues**:
   - Clear browser cache (Ctrl+Shift+Delete)
   - Try incognito/private mode
   - Test with different browser

3. **Network optimization**:
   ```bash
   # Check for packet loss
   ping -c 10 move.local
   
   # Check network speed
   iperf3 -c move.local  # if iperf3 is available
   ```

---

## Command Line and Terminal Issues

### Problem: "Command not found" Errors
**Common missing commands and solutions**:

1. **curl not found**:
   ```bash
   sudo apt install curl  # Debian/Ubuntu
   sudo dnf install curl  # Fedora
   sudo pacman -S curl    # Arch
   ```

2. **wget not found**:
   ```bash
   # Use curl as alternative
   curl -O URL
   # Or install wget
   sudo apt install wget
   ```

3. **git not found**:
   ```bash
   sudo apt install git
   ```

4. **nano/vim not found**:
   ```bash
   sudo apt install nano vim
   ```

### Problem: Terminal Encoding Issues
**Solutions**:
```bash
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
```

Add to `~/.bashrc` to make permanent.

---

## Advanced Troubleshooting

### Problem: Complex Network Setup (VPN, Corporate, etc.)
**Solutions**:

1. **Check routing**:
   ```bash
   ip route show
   traceroute move.local
   ```

2. **Test with direct IP**:
   ```bash
   # Find Move IP with nmap
   nmap -sn 192.168.1.0/24
   ```

3. **SSH tunneling**:
   ```bash
   ssh -L 909:localhost:909 ableton@move.local
   # Then access http://localhost:909
   ```

### Problem: Multiple SSH Keys
**Solution**: Specify key explicitly:
```bash
ssh -i ~/.ssh/move_key ableton@move.local
```

Or add to `~/.ssh/config`:
```
Host move.local
  IdentitiesOnly yes
  IdentityFile ~/.ssh/move_key
```

---

## Getting Help and Resources

### Linux Distribution Resources
- **Ubuntu**: [Ubuntu Community Help](https://help.ubuntu.com/community)
- **Debian**: [Debian Wiki](https://wiki.debian.org/)
- **Fedora**: [Fedora Documentation](https://docs.fedoraproject.org/)
- **Arch**: [Arch Wiki](https://wiki.archlinux.org/)
- **openSUSE**: [openSUSE Documentation](https://doc.opensuse.org/)

### Network and SSH Resources
- [Linux Network Configuration Guide](https://tldp.org/LDP/nag2/index.html)
- [SSH Academy](https://www.ssh.com/academy/ssh)
- [Linux Command Line Cheat Sheet](https://cheatography.com/davechild/cheat-sheets/linux-command-line/)

### Community Resources
- [Extending Move Discord](https://discord.gg/yP7SjqDrZG)
- [GitHub Issues](https://github.com/peterswimm/extending-move/issues)
- [r/Linux4Noobs](https://reddit.com/r/linux4noobs)
- [Unix & Linux Stack Exchange](https://unix.stackexchange.com/)

### Diagnostic Commands
When asking for help, include output from these commands:

```bash
# System information
uname -a
cat /etc/os-release
lsb_release -a

# Network information
ip addr show
ip route show
cat /etc/resolv.conf

# SSH debug information
ssh -v ableton@move.local

# Service status
systemctl status NetworkManager
systemctl status avahi-daemon
```

### Creating Good Support Requests
Include:
- Your Linux distribution and version
- Exact command that failed
- Complete error message
- What you've already tried
- Output from diagnostic commands above

Remember: The Linux community is generally very helpful! Don't hesitate to ask questions, and always be prepared to share specific error messages and system information.
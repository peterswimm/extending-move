# Linux Troubleshooting Guide - Extending Move

This guide provides solutions to common issues you might encounter when setting up extending-move on Linux systems.

## Common Issues and Solutions

### Network and DNS Issues

#### Problem: "move.local" not found
**Error:** `ping: move.local: Name or service not known`

**Solutions:**
1. **Install and configure Avahi (mDNS resolver):**
   ```bash
   # Ubuntu/Debian
   sudo apt install avahi-daemon avahi-utils
   sudo systemctl enable --now avahi-daemon
   
   # Fedora
   sudo dnf install avahi avahi-tools
   sudo systemctl enable --now avahi-daemon
   
   # Arch Linux
   sudo pacman -S avahi
   sudo systemctl enable --now avahi-daemon
   ```

2. **Test mDNS resolution:**
   ```bash
   avahi-resolve -n move.local
   dig @224.0.0.251 -p 5353 move.local
   ```

3. **Use IP address instead:**
   ```bash
   # Find Move's IP address
   nmap -sn 192.168.1.0/24 | grep -B2 -A2 "Ableton"
   # Or check your router's admin panel
   ```

4. **Add to /etc/hosts (temporary fix):**
   ```bash
   echo "192.168.1.100 move.local" | sudo tee -a /etc/hosts
   ```

**Helpful Links:**
- [Avahi Documentation](https://www.avahi.org/doxygen/html/)
- [mDNS Troubleshooting](https://wiki.archlinux.org/title/Avahi)

#### Problem: Network firewall blocking connections
**Error:** Connection timeouts or refused connections

**Solutions:**
1. **Check firewall status:**
   ```bash
   # UFW (Ubuntu)
   sudo ufw status
   
   # firewalld (Fedora/RHEL)
   sudo firewall-cmd --state
   sudo firewall-cmd --list-all
   
   # iptables
   sudo iptables -L
   ```

2. **Allow SSH and Move ports:**
   ```bash
   # UFW
   sudo ufw allow out 22
   sudo ufw allow out 909
   
   # firewalld
   sudo firewall-cmd --permanent --add-service=ssh
   sudo firewall-cmd --permanent --add-port=909/tcp
   sudo firewall-cmd --reload
   
   # iptables
   sudo iptables -A OUTPUT -p tcp --dport 22 -j ACCEPT
   sudo iptables -A OUTPUT -p tcp --dport 909 -j ACCEPT
   ```

3. **Temporarily disable firewall for testing:**
   ```bash
   # UFW
   sudo ufw disable
   
   # firewalld
   sudo systemctl stop firewalld
   
   # iptables
   sudo iptables -F
   ```

**Helpful Links:**
- [UFW Documentation](https://help.ubuntu.com/community/UFW)
- [firewalld Documentation](https://firewalld.org/documentation/)

### SSH Connection Issues

#### Problem: SSH permission denied
**Error:** `Permission denied (publickey)`

**Solutions:**
1. **Check SSH key permissions:**
   ```bash
   ls -la ~/.ssh/move_key*
   chmod 600 ~/.ssh/move_key
   chmod 644 ~/.ssh/move_key.pub
   chmod 600 ~/.ssh/config
   ```

2. **Verify SSH config:**
   ```bash
   cat ~/.ssh/config
   ssh -F ~/.ssh/config -v ableton@move.local
   ```

3. **Test with explicit key:**
   ```bash
   ssh -i ~/.ssh/move_key -v ableton@move.local
   ```

4. **Check SSH agent:**
   ```bash
   eval $(ssh-agent)
   ssh-add ~/.ssh/move_key
   ssh-add -l
   ```

**Helpful Links:**
- [SSH Key Troubleshooting](https://docs.github.com/en/authentication/troubleshooting-ssh)
- [OpenSSH Manual](https://www.openssh.com/manual.html)

#### Problem: SSH host key verification failed
**Error:** `Host key verification failed`

**Solutions:**
1. **Remove old host key:**
   ```bash
   ssh-keygen -R move.local
   ssh-keygen -R [move.local]:22
   ```

2. **Accept new host key:**
   ```bash
   ssh -o "StrictHostKeyChecking=no" ableton@move.local
   ```

3. **Clear known_hosts completely (if needed):**
   ```bash
   rm ~/.ssh/known_hosts
   ```

**Helpful Links:**
- [SSH Host Key Management](https://www.ssh.com/academy/ssh/host-key)

### Package Management Issues

#### Problem: Missing dependencies
**Various package-related errors**

**Solutions by Distribution:**

**Ubuntu/Debian:**
```bash
# Update package lists
sudo apt update

# Install build essentials
sudo apt install build-essential

# Install Python development headers
sudo apt install python3-dev

# Install audio libraries
sudo apt install libsndfile1-dev libffi-dev
```

**Fedora:**
```bash
# Install development tools
sudo dnf groupinstall "Development Tools"

# Install Python development
sudo dnf install python3-devel

# Install audio libraries
sudo dnf install libsndfile-devel libffi-devel
```

**Arch Linux:**
```bash
# Install base development
sudo pacman -S base-devel

# Install Python and audio libraries
sudo pacman -S python python-pip libsndfile
```

**openSUSE:**
```bash
# Install development pattern
sudo zypper install -t pattern devel_basis

# Install specific packages
sudo zypper install python3-devel libsndfile-devel
```

**Helpful Links:**
- [Ubuntu Packages](https://packages.ubuntu.com/)
- [Fedora Packages](https://packages.fedoraproject.org/)
- [Arch Packages](https://archlinux.org/packages/)

### Python and pip Issues

#### Problem: pip installation fails
**Error:** Various pip-related errors

**Solutions:**
1. **Upgrade pip:**
   ```bash
   python3 -m pip install --upgrade pip
   ```

2. **Install in user directory:**
   ```bash
   python3 -m pip install --user package_name
   ```

3. **Use virtual environment:**
   ```bash
   python3 -m venv extending-move-env
   source extending-move-env/bin/activate
   pip install package_name
   ```

4. **Install system packages instead:**
   ```bash
   # Ubuntu/Debian
   sudo apt install python3-numpy python3-flask
   
   # Fedora
   sudo dnf install python3-numpy python3-flask
   ```

**Helpful Links:**
- [pip Documentation](https://pip.pypa.io/en/stable/)
- [Python Virtual Environments](https://docs.python.org/3/tutorial/venv.html)

#### Problem: Permission denied when installing packages
**Error:** `Permission denied` during pip install

**Solutions:**
1. **Install for user only:**
   ```bash
   pip install --user package_name
   ```

2. **Use virtual environment:**
   ```bash
   python3 -m venv venv
   source venv/bin/activate
   pip install package_name
   ```

3. **Check pip configuration:**
   ```bash
   pip config list
   pip config set global.user true
   ```

### Audio and Media Libraries

#### Problem: Audio library installation fails
**Error:** Issues with `soundfile`, `librosa`, or audio dependencies

**Solutions:**
1. **Install system audio libraries first:**
   ```bash
   # Ubuntu/Debian
   sudo apt install libsndfile1-dev libfftw3-dev
   
   # Fedora
   sudo dnf install libsndfile-devel fftw-devel
   
   # Arch
   sudo pacman -S libsndfile fftw
   ```

2. **Install with conda (alternative):**
   ```bash
   # Install miniconda
   wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
   bash Miniconda3-latest-Linux-x86_64.sh
   
   # Install packages
   conda install -c conda-forge librosa soundfile
   ```

**Helpful Links:**
- [SoundFile Documentation](https://python-soundfile.readthedocs.io/)
- [Librosa Installation](https://librosa.org/doc/latest/install.html)

### SELinux Issues (RHEL/CentOS/Fedora)

#### Problem: SELinux blocking SSH or network connections
**Error:** Various SELinux denials

**Solutions:**
1. **Check SELinux status:**
   ```bash
   sestatus
   getenforce
   ```

2. **View SELinux denials:**
   ```bash
   sudo ausearch -m AVC -ts recent
   sudo journalctl | grep -i selinux
   ```

3. **Temporarily set permissive:**
   ```bash
   sudo setenforce 0
   ```

4. **Create custom policy (advanced):**
   ```bash
   sudo audit2allow -a -M extending-move
   sudo semodule -i extending-move.pp
   ```

**Helpful Links:**
- [SELinux Documentation](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/using_selinux/)
- [SELinux Troubleshooting](https://wiki.centos.org/HowTos/SELinux)

### Systemd Service Issues

#### Problem: Auto-start service not working
**Error:** Service fails to start or stops unexpectedly

**Solutions:**
1. **Check service status:**
   ```bash
   systemctl --user status extending-move
   systemctl --user list-unit-files | grep extending-move
   ```

2. **View service logs:**
   ```bash
   journalctl --user -u extending-move -f
   journalctl --user -u extending-move --since "1 hour ago"
   ```

3. **Reload systemd configuration:**
   ```bash
   systemctl --user daemon-reload
   systemctl --user enable extending-move
   systemctl --user start extending-move
   ```

4. **Check user lingering (for auto-start):**
   ```bash
   sudo loginctl enable-linger ableton
   ```

**Helpful Links:**
- [Systemd User Services](https://wiki.archlinux.org/title/Systemd/User)
- [Systemd Troubleshooting](https://freedesktop.org/software/systemd/man/systemd.html)

### Display and GUI Issues

#### Problem: Browser not opening or X11 forwarding issues
**Various GUI-related problems**

**Solutions:**
1. **For headless servers, use text-based browsers:**
   ```bash
   # Install text browser
   sudo apt install lynx  # Ubuntu/Debian
   lynx http://move.local:909
   ```

2. **Set up X11 forwarding:**
   ```bash
   ssh -X ableton@move.local
   # Then run GUI applications
   ```

3. **Use remote desktop:**
   ```bash
   # Install VNC server on remote machine
   sudo apt install tightvncserver
   vncserver :1
   
   # Connect with VNC viewer
   ```

4. **Forward port to access from another machine:**
   ```bash
   ssh -L 8080:localhost:909 ableton@move.local
   # Then access http://localhost:8080 on your local machine
   ```

## Distribution-Specific Issues

### Ubuntu/Debian Specific

#### Problem: Package conflicts or unmet dependencies
**Solutions:**
```bash
# Fix broken packages
sudo apt --fix-broken install

# Update package database
sudo apt update && sudo apt upgrade

# Remove conflicting packages
sudo apt autoremove

# Clean package cache
sudo apt autoclean
```

#### Problem: Snap vs apt package conflicts
**Solutions:**
```bash
# List snap packages
snap list

# Remove snap version if conflicting
sudo snap remove package_name

# Install apt version
sudo apt install package_name
```

### Fedora/RHEL Specific

#### Problem: DNF/YUM package issues
**Solutions:**
```bash
# Clean DNF cache
sudo dnf clean all

# Rebuild package database
sudo dnf makecache

# Check for duplicate packages
package-cleanup --dupes

# Update system
sudo dnf update
```

### Arch Linux Specific

#### Problem: AUR package build failures
**Solutions:**
```bash
# Update keyring
sudo pacman -S archlinux-keyring

# Clear package cache
sudo pacman -Scc

# Rebuild AUR package
cd /path/to/aur/package
makepkg -Ccsi
```

## Advanced Debugging

### Network Debugging
```bash
# Monitor network traffic
sudo tcpdump -i any host move.local

# Check open ports
ss -tuln
netstat -tuln

# Trace network path
traceroute move.local
mtr move.local
```

### SSH Debugging
```bash
# Maximum verbose SSH
ssh -vvv ableton@move.local

# SSH client configuration test
ssh -F /dev/null -o "StrictHostKeyChecking=no" -v ableton@move.local

# Check SSH server logs (on Move)
ssh ableton@move.local "sudo journalctl -u sshd -f"
```

### System Resource Monitoring
```bash
# Monitor system resources
htop
iotop
nethogs

# Check disk space
df -h
du -sh ~/.ssh/

# Monitor processes
ps aux | grep python
pgrep -fl extending-move
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

### Linux Resources
- [ArchWiki](https://wiki.archlinux.org/) - Excellent Linux documentation
- [Ubuntu Community Help](https://help.ubuntu.com/community/)
- [Fedora Documentation](https://docs.fedoraproject.org/)
- [Linux Command Line Reference](https://ss64.com/bash/)

### Networking Tools
- [Wireshark](https://www.wireshark.org/) - Network protocol analyzer
- [nmap](https://nmap.org/) - Network discovery and security auditing
- [iperf3](https://iperf.fr/) - Network performance testing

### Development Tools
- [Git Documentation](https://git-scm.com/doc)
- [Python Documentation](https://docs.python.org/3/)
- [Flask Documentation](https://flask.palletsprojects.com/)

## Recovery Information

If something goes wrong:
- Recovery procedures are documented on [Ableton Center Code](https://ableton.centercode.com/project/article/item.html?cap=ecd3942a1fe3405eb27a806608401a0b&arttypeid={e70be312-f44a-418b-bb74-ed1030e3a49a}&artid={C0A2D9E2-D52F-4DEB-8BEE-356B65C8942E})
- Most Linux distributions have recovery modes accessible during boot
- Always refer to official Ableton documentation for device recovery

## Still Having Issues?

If you're still experiencing problems:
1. Check the [GitHub Issues](https://github.com/peterswimm/extending-move/issues) page
2. Join the [Discord community](https://discord.gg/yP7SjqDrZG) for real-time help
3. Create a new issue with:
   - Linux distribution and version (`cat /etc/os-release`)
   - Kernel version (`uname -a`)
   - Complete error messages
   - Output of `ssh -v ableton@move.local`
   - Network configuration (`ip a`, `ip r`)
   - Relevant log entries (`journalctl` output)
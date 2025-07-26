# Linux Troubleshooting Links

This document provides troubleshooting resources for common issues when setting up Extending Move on Linux distributions.

## mDNS/Avahi Issues

### move.local Not Resolving
**Problem**: `ping: move.local: Name or service not known`

**Solutions**:

1. **Install and configure Avahi**:
   ```bash
   # Ubuntu/Debian
   sudo apt install avahi-daemon avahi-utils libnss-mdns
   
   # Fedora/CentOS
   sudo dnf install avahi avahi-tools nss-mdns
   
   # Arch Linux
   sudo pacman -S avahi nss-mdns
   ```

2. **Enable Avahi daemon**:
   ```bash
   sudo systemctl enable --now avahi-daemon
   ```

3. **Configure NSS for mDNS**:
   Edit `/etc/nsswitch.conf` and ensure the hosts line includes `mdns4_minimal [NOTFOUND=return]`:
   ```
   hosts: files mdns4_minimal [NOTFOUND=return] dns
   ```

4. **Test mDNS resolution**:
   ```bash
   avahi-resolve -n move.local
   getent hosts move.local
   ```

**Resources**:
- **Avahi Documentation**: https://avahi.org/
- **Arch Wiki Avahi**: https://wiki.archlinux.org/title/Avahi
- **Ubuntu Avahi Guide**: https://help.ubuntu.com/community/HowToZeroconf

### Avahi Daemon Not Starting
**Problem**: `systemctl status avahi-daemon` shows failed state

**Solutions**:
1. **Check configuration**:
   ```bash
   sudo avahi-daemon --check
   avahi-daemon -D --debug
   ```

2. **Reset configuration**:
   ```bash
   sudo systemctl stop avahi-daemon
   sudo rm /etc/avahi/services/*
   sudo systemctl start avahi-daemon
   ```

3. **Check for conflicts**: Ensure no other mDNS services are running

**Resources**:
- **Avahi Troubleshooting**: https://wiki.archlinux.org/title/Avahi#Troubleshooting
- **systemd Service Debugging**: https://www.freedesktop.org/software/systemd/man/systemctl.html

## SSH Connection Issues

### Permission Denied (publickey)
**Problem**: `Permission denied (publickey)`

**Solutions**:
1. **Check SSH key permissions**:
   ```bash
   chmod 700 ~/.ssh
   chmod 600 ~/.ssh/move_key
   chmod 644 ~/.ssh/move_key.pub
   chmod 600 ~/.ssh/config
   ```

2. **Debug SSH connection**:
   ```bash
   ssh -vvv ableton@move.local
   ```

3. **Test SSH agent**:
   ```bash
   ssh-add -l
   ssh-add ~/.ssh/move_key
   ```

4. **Verify SSH config syntax**:
   ```bash
   ssh -F ~/.ssh/config -T move.local
   ```

**Resources**:
- **SSH Troubleshooting**: https://www.ssh.com/academy/ssh/troubleshoot
- **OpenSSH Manual**: https://man.openbsd.org/ssh_config

### SSH Connection Timeout
**Problem**: `ssh: connect to host move.local port 22: Connection timed out`

**Solutions**:
1. **Check network connectivity**:
   ```bash
   ping move.local
   traceroute move.local
   ```

2. **Scan for SSH port**:
   ```bash
   nmap -p 22 move.local
   ```

3. **Check firewall rules**:
   ```bash
   # UFW (Ubuntu/Debian)
   sudo ufw status
   sudo ufw allow ssh
   
   # Firewalld (Fedora/CentOS)
   sudo firewall-cmd --list-all
   sudo firewall-cmd --permanent --add-service=ssh
   sudo firewall-cmd --reload
   
   # iptables (general)
   sudo iptables -L
   ```

**Resources**:
- **Network Debugging**: https://www.cyberciti.biz/faq/linux-unix-tcp-port-scanner-nmap/
- **UFW Documentation**: https://help.ubuntu.com/community/UFW
- **Firewalld Guide**: https://firewalld.org/documentation/

## Network Configuration Issues

### DNS Resolution Problems
**Problem**: Inconsistent hostname resolution

**Solutions**:
1. **Check DNS configuration**:
   ```bash
   # systemd-resolved (modern systems)
   systemd-resolve --status
   
   # Traditional DNS
   cat /etc/resolv.conf
   ```

2. **Flush DNS cache**:
   ```bash
   # systemd-resolved
   sudo systemd-resolve --flush-caches
   
   # dnsmasq
   sudo systemctl restart dnsmasq
   
   # NetworkManager
   sudo systemctl restart NetworkManager
   ```

3. **Test DNS servers**:
   ```bash
   dig @8.8.8.8 google.com
   nslookup move.local
   ```

**Resources**:
- **systemd-resolved**: https://www.freedesktop.org/software/systemd/man/systemd-resolved.service.html
- **DNS Troubleshooting**: https://www.cloudflare.com/learning/dns/dns-troubleshooting/

### Network Interface Issues
**Problem**: No network connectivity to Move

**Solutions**:
1. **Check network interfaces**:
   ```bash
   ip addr show
   nmcli device status  # NetworkManager
   ```

2. **Restart networking**:
   ```bash
   # systemd-networkd
   sudo systemctl restart systemd-networkd
   
   # NetworkManager
   sudo systemctl restart NetworkManager
   
   # Traditional (older systems)
   sudo systemctl restart networking
   ```

3. **Check routing**:
   ```bash
   ip route show
   route -n
   ```

**Resources**:
- **NetworkManager**: https://networkmanager.dev/
- **systemd-networkd**: https://www.freedesktop.org/software/systemd/man/systemd-networkd.service.html

## File Transfer Issues

### SCP/rsync Permission Errors
**Problem**: `Permission denied` when transferring files

**Solutions**:
1. **Check destination permissions**: SSH into Move and verify directory permissions
2. **Use correct user**: Ensure connecting as `ableton` user
3. **Test with simple file**:
   ```bash
   echo "test" | ssh ableton@move.local 'cat > /tmp/test.txt'
   ```

### Large File Transfer Failures
**Problem**: Transfers fail for large files

**Solutions**:
1. **Use rsync with resume**:
   ```bash
   rsync -avz --partial --progress file.wav ableton@move.local:/destination/
   ```

2. **Check network stability**: Use `iperf3` to test network performance:
   ```bash
   # On Move (if iperf3 available)
   ssh ableton@move.local "iperf3 -s"
   
   # On local machine
   iperf3 -c move.local
   ```

3. **Split large files**:
   ```bash
   split -b 100M largefile.wav parts/
   ```

**Resources**:
- **rsync Documentation**: https://rsync.samba.org/documentation.html
- **Network Performance Testing**: https://iperf.fr/

## Package Management Issues

### Python Dependencies
**Problem**: pip install fails or wrong Python version

**Solutions**:
1. **Use virtual environment**:
   ```bash
   python3 -m venv extending-move-env
   source extending-move-env/bin/activate
   pip install -r requirements.txt
   ```

2. **Install development packages**:
   ```bash
   # Ubuntu/Debian
   sudo apt install python3-dev build-essential
   
   # Fedora/CentOS
   sudo dnf groupinstall "Development Tools"
   sudo dnf install python3-devel
   
   # Arch Linux
   sudo pacman -S base-devel python
   ```

3. **Update pip and setuptools**:
   ```bash
   python3 -m pip install --upgrade pip setuptools wheel
   ```

**Resources**:
- **Python Virtual Environments**: https://docs.python.org/3/tutorial/venv.html
- **pip Troubleshooting**: https://pip.pypa.io/en/stable/topics/troubleshooting/

### Repository Access Issues
**Problem**: Cannot access package repositories

**Solutions**:
1. **Update package lists**:
   ```bash
   # Ubuntu/Debian
   sudo apt update
   
   # Fedora/CentOS
   sudo dnf check-update
   
   # Arch Linux
   sudo pacman -Sy
   ```

2. **Check repository configuration**:
   ```bash
   # Ubuntu/Debian
   cat /etc/apt/sources.list
   
   # Fedora
   ls /etc/yum.repos.d/
   
   # Arch Linux
   cat /etc/pacman.conf
   ```

## SELinux Issues (Fedora/CentOS/RHEL)

### SELinux Blocking SSH
**Problem**: SELinux prevents SSH connections or file operations

**Solutions**:
1. **Check SELinux status**:
   ```bash
   sestatus
   getenforce
   ```

2. **Check for denials**:
   ```bash
   sudo ausearch -m AVC -ts recent
   sudo sealert -a /var/log/audit/audit.log
   ```

3. **Temporary disable** (for testing only):
   ```bash
   sudo setenforce 0  # Permissive mode
   ```

4. **Create custom policy** (preferred):
   ```bash
   sudo audit2allow -M extending-move < /var/log/audit/audit.log
   sudo semodule -i extending-move.pp
   ```

**Resources**:
- **SELinux User Guide**: https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/using_selinux/index
- **SELinux Troubleshooting**: https://wiki.centos.org/HowTos/SELinux

## Distribution-Specific Issues

### Ubuntu/Debian
**Snap Package Conflicts**:
```bash
# Remove conflicting snaps
sudo snap remove package-name

# Use apt instead
sudo apt install package-name
```

**AppArmor Issues**:
```bash
# Check AppArmor status
sudo aa-status

# Check for denials
sudo dmesg | grep -i apparmor
```

**Resources**:
- **Ubuntu Networking**: https://ubuntu.com/server/docs/network-configuration
- **Debian Network Setup**: https://wiki.debian.org/NetworkConfiguration

### Fedora/CentOS
**FirewallD Configuration**:
```bash
# List services
sudo firewall-cmd --list-services

# Add SSH permanently
sudo firewall-cmd --permanent --add-service=ssh
sudo firewall-cmd --reload
```

**NetworkManager Issues**:
```bash
# Check connection status
nmcli connection show

# Restart connection
nmcli connection down "connection-name"
nmcli connection up "connection-name"
```

**Resources**:
- **Fedora Networking**: https://docs.fedoraproject.org/en-US/fedora/latest/system-administrators-guide/servers/Network_Security/
- **CentOS Network Configuration**: https://wiki.centos.org/FAQ/CentOSAppConfigs

### Arch Linux
**systemd-networkd Configuration**:
```bash
# Check network status
networkctl status

# Example configuration /etc/systemd/network/20-ethernet.network
[Match]
Name=enp*

[Network]
DHCP=yes
```

**pacman Issues**:
```bash
# Update keyring
sudo pacman -S archlinux-keyring

# Clear package cache
sudo pacman -Scc
```

**Resources**:
- **Arch Wiki Networking**: https://wiki.archlinux.org/title/Network_configuration
- **systemd-networkd**: https://wiki.archlinux.org/title/Systemd-networkd

## System Monitoring and Debugging

### Network Monitoring Tools
```bash
# Monitor network connections
sudo netstat -tulpn | grep ssh
sudo ss -tulpn | grep ssh

# Monitor network traffic
sudo tcpdump -i any host move.local

# Check ARP table
arp -a | grep move
ip neighbor show
```

### System Log Monitoring
```bash
# Monitor system logs
sudo journalctl -f

# SSH-specific logs
sudo journalctl -u ssh
sudo journalctl -f | grep ssh

# Network-related logs
sudo journalctl -u NetworkManager
sudo journalctl -u systemd-networkd
```

### Performance Monitoring
```bash
# CPU and memory usage
top
htop

# Disk I/O
iotop
iostat

# Network statistics
iftop
nethogs
```

**Resources**:
- **Linux Performance Tools**: https://www.brendangregg.com/linuxperf.html
- **System Monitoring**: https://www.tecmint.com/linux-performance-monitoring-tools/

## Community Resources

### General Linux Support
- **Stack Overflow Linux**: https://stackoverflow.com/questions/tagged/linux
- **Unix & Linux Stack Exchange**: https://unix.stackexchange.com/
- **r/linuxquestions**: https://reddit.com/r/linuxquestions

### Distribution-Specific
- **Ubuntu Forums**: https://ubuntuforums.org/
- **Fedora Forum**: https://ask.fedoraproject.org/
- **Arch Linux Forums**: https://bbs.archlinux.org/
- **openSUSE Forums**: https://forums.opensuse.org/

### Documentation
- **Linux Documentation Project**: https://tldp.org/
- **Arch Wiki** (excellent for all distributions): https://wiki.archlinux.org/
- **Gentoo Wiki**: https://wiki.gentoo.org/

## Getting Additional Help

When seeking help, provide:
1. **Distribution and version**: `cat /etc/os-release`
2. **Kernel version**: `uname -a`
3. **Network configuration**: `ip addr show`
4. **Error messages**: Complete output from failed commands
5. **Logs**: Relevant entries from `journalctl` or log files

**Useful diagnostic commands**:
```bash
# System information
hostnamectl
systemctl --failed
dmesg | tail -20

# Network diagnostics
ss -tulpn
ip route show
systemd-resolve --status

# SSH debugging
ssh -vvv ableton@move.local
```

Remember: Linux distributions vary significantly in their networking and service management approaches. The solution that works for Ubuntu might not apply to Arch Linux or Fedora. Always check your distribution's specific documentation when in doubt.
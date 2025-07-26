# Linux Troubleshooting Links

This document provides troubleshooting resources and solutions for common issues when setting up Extending Move on Linux distributions.

## Common Issues and Solutions

### SSH Connection Problems

#### "Connection refused" or "Network unreachable"
- **Test basic connectivity**:
  ```bash
  ping move.local
  # If this fails, try IP address
  nmap -sn 192.168.1.0/24 | grep -i move
  ```
- **mDNS/DNS issues**:
  ```bash
  # Install avahi for mDNS support
  sudo apt install avahi-utils  # Ubuntu/Debian
  sudo dnf install avahi-tools  # Fedora
  avahi-resolve -n move.local
  ```
- **Network configuration**: Check if both devices are on same subnet
- **Firewall blocking**: Temporarily disable firewall to test

#### "Permission denied (publickey)"
- **SSH key issues**:
  ```bash
  # Check key exists and has correct permissions
  ls -la ~/.ssh/move_key*
  chmod 600 ~/.ssh/move_key
  chmod 644 ~/.ssh/move_key.pub
  ```
- **SSH agent not running**:
  ```bash
  eval "$(ssh-agent -s)"
  ssh-add ~/.ssh/move_key
  ```
- **Key not authorized on Move**:
  ```bash
  ssh-copy-id -i ~/.ssh/move_key.pub ableton@move.local
  ```

#### "Host key verification failed"
- **Remove old host key**:
  ```bash
  ssh-keygen -R move.local
  ssh-keygen -R [IP_ADDRESS]
  ```
- **Clear known hosts**: `rm ~/.ssh/known_hosts`
- **Bypass verification**: Add `StrictHostKeyChecking no` to SSH config

### Package Installation Issues

#### "Package not found" errors
- **Update package lists**:
  ```bash
  sudo apt update        # Ubuntu/Debian
  sudo dnf check-update  # Fedora
  sudo pacman -Sy        # Arch
  ```
- **Enable repositories**:
  ```bash
  # Ubuntu: Enable universe repository
  sudo add-apt-repository universe
  
  # Fedora: Enable RPM Fusion
  sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
  ```

#### "Permission denied" during installation
- **Use sudo**: `sudo apt install package_name`
- **Check user groups**: `groups $USER`
- **Add user to sudo group**:
  ```bash
  sudo usermod -aG sudo $USER  # Ubuntu/Debian
  sudo usermod -aG wheel $USER # Fedora/CentOS
  ```

### Python and Pip Issues

#### "python3: command not found"
- **Install Python**:
  ```bash
  sudo apt install python3 python3-pip  # Ubuntu/Debian
  sudo dnf install python3 python3-pip  # Fedora
  sudo pacman -S python python-pip      # Arch
  ```
- **Check alternatives**:
  ```bash
  which python3.8
  which python3.9
  update-alternatives --list python3
  ```

#### "pip: command not found"
- **Install pip**:
  ```bash
  sudo apt install python3-pip
  # Or download get-pip.py
  curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
  python3 get-pip.py --user
  ```

#### "Permission denied" during pip install
- **Use user installation**: `pip3 install --user package_name`
- **Virtual environment**: 
  ```bash
  python3 -m venv venv
  source venv/bin/activate
  pip install package_name
  ```

#### Package compilation failures
- **Install build dependencies**:
  ```bash
  # Ubuntu/Debian
  sudo apt install build-essential python3-dev libffi-dev
  
  # Fedora
  sudo dnf groupinstall "Development Tools"
  sudo dnf install python3-devel libffi-devel
  
  # Arch
  sudo pacman -S base-devel python
  ```

### Audio Library Issues

#### "PortAudio not found" errors
```bash
# Ubuntu/Debian
sudo apt install portaudio19-dev libasound2-dev

# Fedora
sudo dnf install portaudio-devel alsa-lib-devel

# Arch
sudo pacman -S portaudio alsa-lib
```

#### "ALSA errors" or sound issues
```bash
# Check ALSA configuration
aplay -l
alsamixer

# Install ALSA utilities
sudo apt install alsa-utils  # Ubuntu/Debian

# Reset ALSA configuration
sudo alsactl restore
```

### Network and Firewall Issues

#### UFW Firewall (Ubuntu/Debian)
```bash
# Check status
sudo ufw status verbose

# Allow SSH
sudo ufw allow ssh
sudo ufw allow out 22

# Allow web interface port
sudo ufw allow 909

# Reset if needed
sudo ufw --force reset
```

#### Firewalld (Fedora/CentOS/RHEL)
```bash
# Check status
sudo firewall-cmd --state
sudo firewall-cmd --list-all

# Allow SSH
sudo firewall-cmd --permanent --add-service=ssh
sudo firewall-cmd --permanent --add-port=909/tcp
sudo firewall-cmd --reload

# Disable temporarily for testing
sudo systemctl stop firewalld
```

#### iptables
```bash
# Check current rules
sudo iptables -L -n

# Allow SSH outbound
sudo iptables -A OUTPUT -p tcp --dport 22 -j ACCEPT

# Save rules (varies by distribution)
sudo iptables-save > /etc/iptables/rules.v4  # Ubuntu/Debian
```

### Distribution-Specific Issues

#### Ubuntu/Debian
- **Snap package conflicts**: Remove snap python if installed
- **PPAs**: Be cautious with third-party repositories
- **WSL**: Use native Linux instructions, not Windows

#### Fedora/CentOS/RHEL
- **SELinux**: May block SSH or network connections
  ```bash
  # Check SELinux status
  getenforce
  
  # Temporarily disable for testing
  sudo setenforce 0
  
  # Check denials
  sudo ausearch -m avc -ts recent
  ```

#### Arch Linux
- **AUR packages**: Use AUR helper like `yay` for additional packages
- **Rolling release**: Ensure system is up to date before installing

#### Alpine Linux
- **musl vs glibc**: Some Python packages may need special versions
- **Package availability**: Fewer packages available compared to other distros

### Git and Repository Issues

#### "Git command not found"
```bash
sudo apt install git  # Ubuntu/Debian
sudo dnf install git  # Fedora
sudo pacman -S git    # Arch
```

#### Clone/pull failures
- **Network issues**: Check internet connectivity
- **Proxy settings**: Configure git for corporate proxy
- **Certificate issues**: 
  ```bash
  git config --global http.sslverify false  # Not recommended for production
  ```

#### Permission issues
```bash
# Fix repository permissions
chmod -R 755 extending-move/
chown -R $USER:$USER extending-move/
```

### Virtual Environment Issues

#### "venv module not found"
```bash
# Install venv module
sudo apt install python3-venv  # Ubuntu/Debian
sudo dnf install python3-venv  # Fedora
```

#### Virtual environment won't activate
- **Path issues**: Use full path to activate script
- **Shell compatibility**: Ensure using bash/zsh, not fish/csh
- **Permissions**: Check execute permissions on activate script

## Useful Resources

### Distribution Documentation
- **Ubuntu**: [Official Documentation](https://help.ubuntu.com/)
- **Debian**: [Debian Documentation](https://www.debian.org/doc/)
- **Fedora**: [Fedora Documentation](https://docs.fedoraproject.org/)
- **Arch Linux**: [Arch Wiki](https://wiki.archlinux.org/)
- **CentOS**: [CentOS Documentation](https://docs.centos.org/)
- **openSUSE**: [openSUSE Documentation](https://doc.opensuse.org/)

### Package Management
- **APT (Debian/Ubuntu)**: [APT User Guide](https://help.ubuntu.com/community/AptGet/Howto)
- **DNF (Fedora)**: [DNF Guide](https://docs.fedoraproject.org/en-US/quick-docs/dnf/)
- **Pacman (Arch)**: [Pacman Rosetta](https://wiki.archlinux.org/title/Pacman/Rosetta)
- **Zypper (openSUSE)**: [Zypper Guide](https://doc.opensuse.org/documentation/leap/reference/html/book-reference/cha-sw-cl.html)

### SSH and Networking
- **SSH**: [OpenSSH Manual](https://www.openssh.com/manual.html)
- **Network Configuration**: [Linux Network Administrator's Guide](https://tldp.org/LDP/nag2/index.html)
- **Firewall**: [Linux Firewall Tutorial](https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-with-ufw-on-ubuntu-18-04)
- **mDNS/Avahi**: [Avahi Documentation](https://avahi.org/documentation/)

### Python and Development
- **Python.org**: [Python Developer's Guide](https://devguide.python.org/)
- **Pip**: [Pip User Guide](https://pip.pypa.io/en/stable/user_guide/)
- **Virtual Environments**: [Python venv Guide](https://docs.python.org/3/tutorial/venv.html)
- **Build Tools**: [Linux From Scratch](http://linuxfromscratch.org/lfs/view/stable/chapter02/hostreqs.html)

### Audio on Linux
- **ALSA**: [ALSA Project](https://www.alsa-project.org/wiki/Main_Page)
- **PulseAudio**: [PulseAudio Documentation](https://www.freedesktop.org/wiki/Software/PulseAudio/Documentation/)
- **JACK**: [JACK Audio Connection Kit](https://jackaudio.org/documentation/)
- **Linux Audio**: [Linux Audio Wiki](https://wiki.linuxaudio.org/)

### Security
- **SELinux**: [SELinux User Guide](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/selinux_users_and_administrators_guide/)
- **AppArmor**: [AppArmor Documentation](https://gitlab.com/apparmor/apparmor/-/wikis/Documentation)
- **SSH Security**: [SSH Security Best Practices](https://infosec.mozilla.org/guidelines/openssh)

### Command Line Tools
- **Bash**: [Bash Manual](https://www.gnu.org/software/bash/manual/)
- **Core Utils**: [GNU Coreutils Manual](https://www.gnu.org/software/coreutils/manual/)
- **Network Tools**: [Linux Network Commands](https://www.tutorialspoint.com/unix_commands/index.htm)

### Community Resources
- **Extending Move Discord**: [Join Discord](https://discord.gg/yP7SjqDrZG)
- **Stack Overflow**: [Linux Questions](https://stackoverflow.com/questions/tagged/linux)
- **Reddit**: [r/linux](https://www.reddit.com/r/linux/) and distribution-specific subreddits
- **Linux Questions**: [LinuxQuestions.org](https://www.linuxquestions.org/)

### Video Tutorials
- **Installation Video**: [Quick setup guide](https://youtu.be/gPiR7Zyu3lc)
- **Linux Basics**: Search for "[Distribution] basics tutorial" on YouTube
- **SSH Tutorials**: "Linux SSH tutorial" on YouTube
- **Python on Linux**: "Python Linux installation" tutorials

## Advanced Troubleshooting

### System Information Collection
```bash
# Distribution and version
cat /etc/os-release
uname -a

# Python environment
python3 --version
pip3 --version
which python3

# Network configuration
ip addr show
ip route show
cat /etc/resolv.conf

# SSH configuration
ssh -V
ls -la ~/.ssh/

# Firewall status
sudo ufw status        # Ubuntu/Debian
sudo firewall-cmd --list-all  # Fedora
sudo iptables -L       # General
```

### Log File Analysis
```bash
# System logs
journalctl -f
tail -f /var/log/syslog         # Ubuntu/Debian
tail -f /var/log/messages       # Fedora/CentOS

# SSH logs
grep ssh /var/log/auth.log      # Ubuntu/Debian
grep ssh /var/log/secure        # Fedora/CentOS

# Network logs
dmesg | grep -i network
```

### Performance Diagnostics
```bash
# System resources
top
htop
free -h
df -h

# Network performance
iperf3 -c move.local
ping -c 10 move.local

# Disk I/O
iostat
iotop
```

## Emergency Recovery

### Move Device Recovery
If your Move becomes unresponsive:
1. **Power cycle**: Hold power button for 10 seconds
2. **Network reset**: Check Move's network settings
3. **Factory reset**: Refer to [Ableton's recovery guide](https://ableton.centercode.com/project/article/item.html?cap=ecd3942a1fe3405eb27a806608401a0b&arttypeid={e70be312-f44a-418b-bb74-ed1030e3a49a}&artid={C0A2D9E2-D52F-4DEB-8BEE-356B65C8942E})

### System Recovery
If your Linux system has issues:
1. **Boot from live USB**: Use distribution's live media
2. **Chroot rescue**: Mount filesystems and chroot for repairs
3. **Backup important data**: Always backup before major changes

## Getting Help

When asking for help, please provide:

1. **Distribution and version**: `cat /etc/os-release`
2. **Kernel version**: `uname -r`
3. **Python version**: `python3 --version`
4. **Complete error messages**: Copy full terminal output
5. **Commands that failed**: Exact commands you ran
6. **Network setup**: Basic network configuration
7. **Firewall status**: Current firewall rules

**Where to get help**:
- [Discord community](https://discord.gg/yP7SjqDrZG) - Real-time support
- [GitHub Issues](https://github.com/peterswimm/extending-move/issues) - Bug reports
- Distribution forums - OS-specific issues
- [Stack Overflow](https://stackoverflow.com/questions/tagged/linux) - Programming questions
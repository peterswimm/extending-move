# Troubleshooting Links for Linux

Here are reliable resources to help you resolve common issues when setting up SSH and file transfers on Linux.

## SSH and Terminal Issues

### General SSH Documentation
- **[SSH Academy](https://www.ssh.com/academy/)** - Comprehensive SSH learning resource
- **[OpenSSH Manual Pages](https://man.openbsd.org/ssh)** - Official OpenSSH documentation
- **[SSH Troubleshooting Guide](https://www.cyberciti.biz/tips/linux-unix-bsd-openssh-server-best-practices.html)** - Security and troubleshooting best practices

### Distribution-Specific SSH Setup
- **[Ubuntu SSH Documentation](https://help.ubuntu.com/community/SSH)** - Ubuntu community SSH guide
- **[Red Hat SSH Guide](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/securing_networks/using-secure-communications-between-two-systems-with-openssh_securing-networks)** - Enterprise Linux SSH setup
- **[Arch Linux SSH Wiki](https://wiki.archlinux.org/title/OpenSSH)** - Comprehensive Arch Linux SSH documentation
- **[Debian SSH Setup](https://wiki.debian.org/SSH)** - Debian-specific SSH configuration

## Terminal and Command Line Help

### Basic Terminal Usage
- **[Linux Command Line Basics](https://ubuntu.com/tutorials/command-line-for-beginners)** - Ubuntu's beginner tutorial
- **[Essential Linux Commands](https://www.digitalocean.com/community/tutorials/linux-commands)** - DigitalOcean's command reference
- **[Bash Shell Scripting Guide](https://tldp.org/LDP/Bash-Beginners-Guide/html/)** - The Linux Documentation Project

### File System and Permissions
- **[Linux File Permissions](https://www.guru99.com/file-permissions.html)** - Understanding chmod and file permissions
- **[Hidden Files in Linux](https://linuxize.com/post/show-hidden-files-linux/)** - Working with dotfiles and hidden directories
- **[Linux Directory Structure](https://www.howtogeek.com/117435/htg-explains-the-linux-directory-structure-explained/)** - Understanding the Linux filesystem

## Network and Connectivity Issues

### Network Troubleshooting by Distribution

#### Ubuntu/Debian
- **[Ubuntu Network Configuration](https://ubuntu.com/server/docs/network-configuration)** - Official Ubuntu networking guide
- **[NetworkManager on Ubuntu](https://help.ubuntu.com/community/NetworkManager)** - GUI network management
- **[Netplan Configuration](https://netplan.io/examples/)** - Modern Ubuntu network configuration

#### Red Hat/Fedora/CentOS
- **[Red Hat Network Scripts](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/configuring_and_managing_networking/)** - Enterprise Linux networking
- **[Fedora Network Configuration](https://docs.fedoraproject.org/en-US/fedora/latest/system-administrators-guide/infrastructure-services/NetworkManager/)** - Fedora-specific networking
- **[SystemD Network Configuration](https://www.freedesktop.org/software/systemd/man/systemd.network.html)** - Modern systemd networking

#### Arch Linux
- **[Arch Linux Network Configuration](https://wiki.archlinux.org/title/Network_configuration)** - Comprehensive networking guide
- **[Wireless Configuration](https://wiki.archlinux.org/title/Network_configuration/Wireless)** - Wi-Fi setup on Arch

### General Network Tools
- **[Network Troubleshooting Commands](https://www.tecmint.com/linux-network-configuration-and-troubleshooting-commands/)** - Essential networking commands
- **[Using netstat and ss](https://www.cyberciti.biz/tips/netstat-command-tutorial-examples.html)** - Network connection monitoring
- **[Network Discovery with nmap](https://nmap.org/book/man.html)** - Network scanning and discovery

## Package Management Issues

### Distribution-Specific Package Managers

#### Debian/Ubuntu (APT)
- **[APT Package Management](https://ubuntu.com/server/docs/package-management)** - Official Ubuntu package guide
- **[Fix Broken Packages](https://askubuntu.com/questions/39371/how-to-fix-broken-packages)** - Ubuntu package troubleshooting
- **[APT Sources Configuration](https://help.ubuntu.com/community/Repositories)** - Managing software repositories

#### Red Hat/Fedora (DNF/YUM)
- **[DNF Package Manager](https://docs.fedoraproject.org/en-US/quick-docs/dnf/)** - Fedora package management
- **[YUM to DNF Migration](https://fedoraproject.org/wiki/DNF)** - Understanding the transition
- **[EPEL Repository Setup](https://docs.fedoraproject.org/en-US/epel/)** - Additional packages for Enterprise Linux

#### Arch Linux (Pacman)
- **[Pacman Package Manager](https://wiki.archlinux.org/title/Pacman)** - Arch Linux package management
- **[AUR Helper Tools](https://wiki.archlinux.org/title/AUR_helpers)** - Managing AUR packages
- **[Pacman Troubleshooting](https://wiki.archlinux.org/title/Pacman/Troubleshooting)** - Common pacman issues

## File Transfer Issues

### SCP and SFTP Problems
- **[SCP Command Examples](https://linuxize.com/post/how-to-use-scp-command-to-securely-transfer-files/)** - Comprehensive SCP tutorial
- **[SFTP Tutorial](https://www.digitalocean.com/community/tutorials/how-to-use-sftp-to-securely-transfer-files-with-a-remote-server)** - Secure file transfer protocol
- **[Rsync vs SCP](https://www.tecmint.com/rsync-vs-scp/)** - Choosing the right file transfer tool

### Alternative File Transfer Tools
- **[FileZilla for Linux](https://filezilla-project.org/)** - Graphical FTP/SFTP client
- **[WinSCP Alternative for Linux](https://winscp.net/eng/docs/guide_linux)** - Windows-like file transfer tools
- **[Midnight Commander](https://midnight-commander.org/)** - Text-based file manager with network support

## Desktop Environment Specific Issues

### GNOME
- **[GNOME Network Settings](https://help.gnome.org/users/gnome-help/stable/net.html.en)** - GNOME network configuration
- **[GNOME Terminal Issues](https://help.gnome.org/users/gnome-terminal/stable/)** - Terminal application troubleshooting
- **[GNOME Keyring SSH](https://wiki.gnome.org/Projects/GnomeKeyring)** - SSH key management in GNOME

### KDE Plasma
- **[KDE Network Management](https://userbase.kde.org/Network_Management)** - KDE networking tools
- **[Konsole Terminal](https://konsole.kde.org/)** - KDE terminal application
- **[KDE Wallet SSH Keys](https://docs.kde.org/trunk5/en/kdeutils/kwallet5/index.html)** - SSH key management in KDE

### XFCE
- **[XFCE Network Configuration](https://docs.xfce.org/xfce/thunar/start)** - XFCE networking setup
- **[XFCE Terminal](https://docs.xfce.org/apps/terminal/start)** - XFCE terminal application

## Firewall and Security Issues

### Firewall Configuration
- **[UFW Firewall Guide](https://help.ubuntu.com/community/UFW)** - Ubuntu's Uncomplicated Firewall
- **[Firewalld Configuration](https://firewalld.org/documentation/)** - Red Hat/Fedora firewall management
- **[iptables Tutorial](https://www.digitalocean.com/community/tutorials/iptables-essentials-common-firewall-rules-and-commands)** - Low-level firewall rules

### SELinux and AppArmor
- **[SELinux Troubleshooting](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/using_selinux/troubleshooting-problems-related-to-selinux_using-selinux)** - Red Hat security troubleshooting
- **[AppArmor on Ubuntu](https://ubuntu.com/server/docs/security-apparmor)** - Ubuntu security profiles
- **[Disable SELinux Temporarily](https://www.cyberciti.biz/faq/disable-selinux-on-centos-7-rhel-7-fedora-linux/)** - Emergency SELinux troubleshooting

## Ableton Move Specific Issues

### Move Device Problems
- **[Ableton Move Support](https://help.ableton.com/hc/en-us/categories/4405796048404-Move)** - Official Ableton documentation
- **[Linux Audio Configuration](https://wiki.archlinux.org/title/Professional_audio)** - Audio setup for music production
- **[ALSA and PulseAudio](https://wiki.ubuntu.com/Audio/Troubleshooting)** - Linux audio troubleshooting

### Development Tools
- **[Git on Linux](https://git-scm.com/download/linux)** - Version control for development
- **[Python Development on Linux](https://realpython.com/installing-python/)** - Python setup for scripting
- **[Text Editors for Development](https://itsfoss.com/best-modern-open-source-code-editors-for-linux/)** - Code editing tools

## System Recovery and Maintenance

### Boot and Recovery Issues
- **[GRUB Bootloader Recovery](https://help.ubuntu.com/community/Grub2/Troubleshooting)** - Boot troubleshooting
- **[Single User Mode](https://www.cyberciti.biz/faq/grub-boot-into-single-user-mode/)** - Emergency system access
- **[Live USB Recovery](https://ubuntu.com/tutorials/try-ubuntu-before-you-install)** - Boot from external media

### System Maintenance
- **[Log File Analysis](https://www.digitalocean.com/community/tutorials/how-to-view-and-configure-linux-logs-on-ubuntu-and-centos)** - System troubleshooting with logs
- **[Disk Space Management](https://www.howtogeek.com/409611/how-to-view-free-disk-space-and-disk-usage-from-the-linux-terminal/)** - Managing storage space
- **[Process Management](https://www.tecmint.com/linux-process-management/)** - Monitor and control running processes

## Community Resources

### Forums and Communities
- **[Ubuntu Forums](https://ubuntuforums.org/)** - Ubuntu community support
- **[Fedora Forum](https://ask.fedoraproject.org/)** - Fedora community discussions
- **[Arch Linux Forums](https://bbs.archlinux.org/)** - Arch Linux community
- **[Linux.org Forums](https://www.linux.org/forums/)** - General Linux discussions
- **[Stack Overflow Linux](https://stackoverflow.com/questions/tagged/linux)** - Programming and technical questions

### Documentation Projects
- **[The Linux Documentation Project](https://tldp.org/)** - Comprehensive Linux guides
- **[DistroWatch](https://distrowatch.com/)** - Linux distribution information
- **[Linux Foundation](https://www.linuxfoundation.org/resources/)** - Professional Linux resources

## Quick Reference Card

**Can't connect to move.local?**
1. Check network: `ping move.local`
2. Try IP directly: `nmap -sn 192.168.1.0/24`
3. Check DNS: `nslookup move.local`

**SSH issues?**
1. Verify SSH client: `which ssh` or `ssh -V`
2. Check key permissions: `chmod 600 ~/.ssh/move_key`
3. Debug connection: `ssh -v -i ~/.ssh/move_key ableton@move.local`

**Package installation problems?**
1. Update package lists: `sudo apt update` (Ubuntu/Debian)
2. Check available packages: `apt search openssh-client`
3. Install missing dependencies: `sudo apt install -f`

**Permission errors?**
1. Check file ownership: `ls -la ~/.ssh/`
2. Fix permissions: `chmod 700 ~/.ssh && chmod 600 ~/.ssh/*`
3. Check SELinux/AppArmor if applicable

Remember: Most Linux distributions have excellent man pages. Try `man ssh`, `man scp`, or `man command-name` for detailed help on any command!
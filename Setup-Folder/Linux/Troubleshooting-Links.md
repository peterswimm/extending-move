# Linux Troubleshooting Links

If you encounter issues during setup or file transfer, these resources provide reliable solutions for common problems on Linux.

## SSH Connection Problems

### Cannot Connect to move.local

**Problem:** SSH connection fails with "Host not found" or timeout
- **Network Configuration:** [Ubuntu Network Configuration](https://ubuntu.com/server/docs/network-configuration) (Ubuntu Official)
- **DNS Resolution:** [Configure DNS on Linux](https://www.digitalocean.com/community/tutorials/how-to-configure-bind-as-a-private-network-dns-server-on-ubuntu-18-04) (DigitalOcean)
- **mDNS/Avahi Setup:** [Avahi mDNS Configuration](https://wiki.archlinux.org/title/Avahi) (Arch Wiki)
- **Network Troubleshooting:** [Linux Network Debugging](https://www.cyberciti.biz/tips/linux-network-configuration-cheat-sheet.html) (nixCraft)

### SSH Key Authentication Issues

**Problem:** SSH key doesn't work, still asks for password
- **SSH Key Setup:** [SSH Key Authentication Guide](https://www.digitalocean.com/community/tutorials/how-to-set-up-ssh-keys-on-ubuntu-20-04) (DigitalOcean)
- **SSH Agent Configuration:** [Using SSH Agent](https://wiki.archlinux.org/title/SSH_keys#SSH_agents) (Arch Wiki)
- **File Permissions:** [SSH File Permissions](https://superuser.com/questions/215504/permissions-on-private-key-in-ssh-folder) (Super User)
- **SSH Troubleshooting:** [SSH Debug and Troubleshooting](https://www.ssh.com/academy/ssh/troubleshoot) (SSH Academy)

### Permission Denied Errors

**Problem:** "Permission denied" when trying to SSH
- **SSH Permissions Guide:** [Fix SSH Permission Issues](https://phoenixnap.com/kb/ssh-permission-denied-publickey) (PhoenixNAP)
- **SELinux Issues:** [SELinux and SSH](https://wiki.centos.org/HowTos/Network/SecuringSSH) (CentOS Wiki)
- **File Ownership:** [Linux File Permissions](https://www.guru99.com/file-permissions.html) (Guru99)

## Package Management Issues

### Package Installation Failures

**Problem:** Cannot install openssh-client or git

#### Ubuntu/Debian:
- **APT Troubleshooting:** [Fix APT Package Manager](https://itsfoss.com/unable-to-locate-package-error-ubuntu/) (It's FOSS)
- **Update Package Lists:** [APT Update and Upgrade](https://phoenixnap.com/kb/how-to-update-upgrade-ubuntu) (PhoenixNAP)
- **Repository Issues:** [Ubuntu Package Repository Guide](https://help.ubuntu.com/community/Repositories) (Ubuntu Community)

#### Fedora:
- **DNF Troubleshooting:** [DNF Package Manager Guide](https://docs.fedoraproject.org/en-US/quick-docs/dnf/) (Fedora Documentation)
- **Repository Configuration:** [Fedora Repository Management](https://docs.fedoraproject.org/en-US/fedora/f34/system-administrators-guide/package-management/DNF/) (Fedora Docs)

#### Arch Linux:
- **Pacman Issues:** [Pacman Troubleshooting](https://wiki.archlinux.org/title/Pacman/Troubleshooting) (Arch Wiki)
- **Package Conflicts:** [Pacman Package Conflicts](https://wiki.archlinux.org/title/Pacman#Reason_for_a_package_upgrade_being_held) (Arch Wiki)

### Dependency Issues

**Problem:** Package dependencies cannot be resolved
- **Dependency Hell:** [Linux Dependency Management](https://www.tecmint.com/solve-package-dependencies-in-linux/) (Tecmint)
- **AppImage Alternative:** [AppImage for Portable Apps](https://appimage.org/) (AppImage)
- **Flatpak Alternative:** [Flatpak Universal Packages](https://flatpak.org/setup/) (Flatpak)

## Terminal and Command Line Issues

### Terminal Won't Open

**Problem:** Terminal application crashes or won't start
- **Alternative Terminals:** 
  - [Terminator](https://gnome-terminator.org/) (Feature-rich terminal)
  - [Alacritty](https://alacritty.org/) (GPU-accelerated terminal)
  - [Kitty](https://sw.kovidgoyal.net/kitty/) (Fast terminal emulator)
- **TTY Access:** [Use TTY when GUI fails](https://www.cyberciti.biz/faq/ubuntu-linux-switching-between-tty-and-graphical-mode/) (nixCraft)

### Command Not Found Errors

**Problem:** `ssh`, `scp`, or other commands not working
- **PATH Configuration:** [Linux PATH Environment Variable](https://linuxize.com/post/how-to-add-directory-to-path-in-linux/) (Linuxize)
- **Package Installation:** [Find Package for Command](https://command-not-found.com/) (Command Not Found)
- **Alternative Installation:** [Install from Source](https://www.gnu.org/software/make/manual/html_node/Installing.html) (GNU Make Manual)

### Shell Configuration Issues

**Problem:** Shell settings or aliases not working
- **Bash Configuration:** [Bash Startup Files](https://www.gnu.org/software/bash/manual/html_node/Bash-Startup-Files.html) (GNU Bash Manual)
- **Zsh Configuration:** [Oh My Zsh Setup](https://ohmyz.sh/) (Oh My Zsh)
- **Shell Switching:** [Change Default Shell](https://www.cyberciti.biz/faq/how-to-change-shell-to-bash/) (nixCraft)

## File Transfer Issues

### SCP/SFTP Transfer Failures

**Problem:** Files won't copy or transfer is interrupted
- **SCP Examples:** [SCP Command Examples](https://linuxize.com/post/how-to-use-scp-command-to-securely-transfer-files/) (Linuxize)
- **SFTP Tutorial:** [SFTP File Transfer Guide](https://www.digitalocean.com/community/tutorials/how-to-use-sftp-to-securely-transfer-files-with-a-remote-server) (DigitalOcean)
- **rsync for Reliability:** [rsync Tutorial](https://www.digitalocean.com/community/tutorials/how-to-use-rsync-to-sync-local-and-remote-directories) (DigitalOcean)

### Large File Transfer Issues

**Problem:** Transfers fail with large files or directories
- **rsync with Progress:** [rsync Progress Bar](https://www.cyberciti.biz/faq/show-progress-during-file-transfer/) (nixCraft)
- **Screen/Tmux:** [Keep Sessions Running](https://linuxize.com/post/how-to-use-linux-screen/) (Linuxize)
- **Network Bandwidth:** [Monitor Network Usage](https://www.tecmint.com/linux-network-bandwidth-monitoring-tools/) (Tecmint)

### File System Mounting Issues

**Problem:** SSHFS won't mount or has errors
- **SSHFS Installation:** [SSHFS Setup Guide](https://www.digitalocean.com/community/tutorials/how-to-use-sshfs-to-mount-remote-file-systems-over-ssh) (DigitalOcean)
- **FUSE Permissions:** [FUSE Configuration](https://wiki.archlinux.org/title/FUSE) (Arch Wiki)
- **Mount Point Issues:** [Linux Mount Troubleshooting](https://www.cyberciti.biz/faq/linux-mount-an-iso-image-using-loop-device/) (nixCraft)

## Network and Connectivity

### mDNS Resolution Problems

**Problem:** .local addresses don't resolve

#### Ubuntu/Debian:
```bash
sudo apt install avahi-daemon avahi-utils
sudo systemctl enable avahi-daemon
sudo systemctl start avahi-daemon
```
- **Avahi Configuration:** [Configure Avahi on Ubuntu](https://ubuntu.com/server/docs/service-avahi) (Ubuntu Server Guide)

#### Fedora:
```bash
sudo dnf install avahi avahi-tools
sudo systemctl enable avahi-daemon
sudo systemctl start avahi-daemon
```
- **Fedora Avahi:** [Avahi on Fedora](https://docs.fedoraproject.org/en-US/fedora/f34/system-administrators-guide/network-services/Avahi/) (Fedora Docs)

#### Arch Linux:
```bash
sudo pacman -S avahi
sudo systemctl enable avahi-daemon
sudo systemctl start avahi-daemon
```
- **Arch Avahi Guide:** [Avahi Configuration](https://wiki.archlinux.org/title/Avahi) (Arch Wiki)

### Firewall Issues

**Problem:** Connection blocked by firewall

#### UFW (Ubuntu):
- **UFW Configuration:** [UFW Firewall Guide](https://help.ubuntu.com/community/UFW) (Ubuntu Community)
- **Allow SSH:** [Configure UFW for SSH](https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-with-ufw-on-ubuntu-20-04) (DigitalOcean)

#### Firewalld (Fedora/CentOS):
- **Firewalld Guide:** [Firewalld Configuration](https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-using-firewalld-on-centos-7) (DigitalOcean)
- **SSH Service:** [Enable SSH in Firewalld](https://www.cyberciti.biz/faq/how-to-open-firewall-port-on-ubuntu-linux-12-04-14-04-lts/) (nixCraft)

#### IPTables:
- **IPTables Rules:** [IPTables Configuration](https://www.cyberciti.biz/tips/linux-iptables-examples.html) (nixCraft)
- **SSH Port:** [Allow SSH in IPTables](https://www.cyberciti.biz/faq/how-to-open-firewall-port-on-ubuntu-linux-12-04-14-04-lts/) (nixCraft)

### WiFi and Network Drivers

**Problem:** Network hardware not working properly
- **Network Manager:** [NetworkManager Troubleshooting](https://wiki.archlinux.org/title/NetworkManager#Troubleshooting) (Arch Wiki)
- **WiFi Drivers:** [Linux WiFi Driver Issues](https://help.ubuntu.com/community/WifiDocs/WirelessTroubleShootingGuide) (Ubuntu Community)
- **USB WiFi:** [USB WiFi Adapter Issues](https://askubuntu.com/questions/tagged/wireless) (Ask Ubuntu)

## Distribution-Specific Issues

### Ubuntu/Debian Specific

**Problem:** Ubuntu-specific configuration issues
- **Ubuntu Forums:** [Ubuntu Community Forum](https://ubuntuforums.org/) (Community Support)
- **Ask Ubuntu:** [Ubuntu Q&A Site](https://askubuntu.com/) (Stack Exchange)
- **Ubuntu Documentation:** [Official Ubuntu Help](https://help.ubuntu.com/) (Ubuntu Official)

### Fedora Specific

**Problem:** Fedora-specific issues
- **Fedora Forums:** [Fedora Discussion](https://discussion.fedoraproject.org/) (Fedora Community)
- **Fedora Documentation:** [Fedora Docs](https://docs.fedoraproject.org/) (Fedora Official)
- **RPM Fusion:** [Additional Packages](https://rpmfusion.org/) (Third-party Repository)

### Arch Linux Specific

**Problem:** Arch-specific configuration
- **Arch Wiki:** [Arch Linux Wiki](https://wiki.archlinux.org/) (Comprehensive Documentation)
- **Arch Forums:** [Arch Linux Forums](https://bbs.archlinux.org/) (Community Support)
- **AUR Issues:** [Arch User Repository](https://wiki.archlinux.org/title/Arch_User_Repository) (AUR Guide)

### openSUSE Specific

**Problem:** openSUSE configuration issues
- **openSUSE Forums:** [openSUSE Community](https://forums.opensuse.org/) (Community Support)
- **openSUSE Documentation:** [openSUSE Docs](https://doc.opensuse.org/) (Official Documentation)
- **YaST Configuration:** [YaST Control Center](https://en.opensuse.org/Portal:YaST) (System Configuration)

## Development and Build Issues

### Git and Version Control

**Problem:** Git installation or configuration issues
- **Git Installation:** [Install Git on Linux](https://git-scm.com/download/linux) (Official Git)
- **Git Configuration:** [First-Time Git Setup](https://git-scm.com/book/en/v2/Getting-Started-First-Time-Git-Setup) (Git Documentation)
- **SSH Keys for Git:** [Git SSH Keys](https://docs.github.com/en/authentication/connecting-to-github-with-ssh) (GitHub Docs)

### Python and Dependencies

**Problem:** extending-move installation fails due to Python issues
- **Python Installation:** [Python Setup on Linux](https://docs.python-guide.org/starting/install3/linux/) (Python Guide)
- **Virtual Environments:** [Python venv Tutorial](https://docs.python.org/3/tutorial/venv.html) (Python.org)
- **pip Issues:** [pip Troubleshooting](https://pip.pypa.io/en/stable/user_guide/#troubleshooting) (pip Documentation)

### Build Tools and Compilers

**Problem:** Compilation errors during installation
- **Build Essentials (Ubuntu/Debian):**
  ```bash
  sudo apt install build-essential
  ```
- **Development Tools (Fedora):**
  ```bash
  sudo dnf groupinstall "Development Tools"
  ```
- **Base-devel (Arch):**
  ```bash
  sudo pacman -S base-devel
  ```

## File System and Storage Issues

### Disk Space Problems

**Problem:** Not enough space for files or installations
- **Check Disk Usage:** [Linux Disk Space Commands](https://www.cyberciti.biz/faq/linux-check-disk-space-command/) (nixCraft)
- **Clean Package Cache:** [Clean Package Manager Cache](https://www.tecmint.com/clean-up-linux-system/) (Tecmint)
- **Find Large Files:** [Find Large Files in Linux](https://www.cyberciti.biz/faq/how-do-i-find-the-largest-filesdirectories-on-a-linuxunixbsd-filesystem/) (nixCraft)

### File Permissions and Ownership

**Problem:** Permission denied errors with files
- **Linux Permissions:** [Understanding Linux Permissions](https://www.guru99.com/file-permissions.html) (Guru99)
- **Change Ownership:** [chown Command Guide](https://linuxize.com/post/linux-chown-command/) (Linuxize)
- **UMASK Settings:** [Linux UMASK Guide](https://www.cyberciti.biz/tips/understanding-linux-unix-umask-value-usage.html) (nixCraft)

### File System Types

**Problem:** File system compatibility issues
- **File System Support:** [Linux File Systems](https://wiki.archlinux.org/title/File_systems) (Arch Wiki)
- **Mount Options:** [Linux Mount Command](https://www.cyberciti.biz/faq/mount-filesystem-in-linux/) (nixCraft)
- **NTFS Support:** [NTFS on Linux](https://wiki.archlinux.org/title/NTFS-3G) (Arch Wiki)

## Performance and System Issues

### System Performance

**Problem:** System runs slowly during file transfers
- **System Monitoring:** [Linux System Monitoring Tools](https://www.cyberciti.biz/tips/top-linux-monitoring-tools.html) (nixCraft)
- **Process Management:** [Linux Process Management](https://www.tecmint.com/linux-process-management/) (Tecmint)
- **Memory Usage:** [Linux Memory Management](https://www.cyberciti.biz/faq/linux-check-memory-usage/) (nixCraft)

### Hardware Compatibility

**Problem:** Hardware not recognized or working properly
- **Hardware Detection:** [Linux Hardware Information](https://www.cyberciti.biz/faq/linux-list-hardware-information/) (nixCraft)
- **Driver Issues:** [Linux Hardware Drivers](https://wiki.archlinux.org/title/Hardware_detection) (Arch Wiki)
- **Kernel Modules:** [Linux Kernel Modules](https://www.cyberciti.biz/faq/linux-show-loaded-kernel-modules/) (nixCraft)

## Ableton Move Specific Issues

### Move Device Not Responding

**Problem:** Move device seems frozen or unresponsive
- **Move Recovery Guide:** [Ableton Move Recovery Procedures](https://ableton.centercode.com/) (Center Code - requires account)
- **Network Diagnostics:** [Linux Network Troubleshooting](https://www.cyberciti.biz/tips/linux-network-configuration-cheat-sheet.html) (nixCraft)
- **Device Reset:** Power cycle both router and Move device

### extending-move Installation Issues

**Problem:** extending-move software installation fails
- **GitHub Issues:** [extending-move Issues](https://github.com/peterswimm/extending-move/issues) (GitHub)
- **Discord Community:** [Move Hacking Discord](https://discord.gg/yP7SjqDrZG) (Community Support)
- **Log Analysis:** Check installation logs for specific error messages

## Security and Access Control

### SELinux Issues (RHEL/Fedora/CentOS)

**Problem:** SELinux blocking SSH connections
- **SELinux SSH:** [Configure SELinux for SSH](https://wiki.centos.org/HowTos/Network/SecuringSSH) (CentOS Wiki)
- **SELinux Troubleshooting:** [SELinux Troubleshooting Guide](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/selinux_users_and_administrators_guide/sect-security-enhanced_linux-troubleshooting-fixing_problems) (Red Hat)

### AppArmor Issues (Ubuntu/Debian)

**Problem:** AppArmor blocking applications
- **AppArmor Configuration:** [AppArmor on Ubuntu](https://help.ubuntu.com/community/AppArmor) (Ubuntu Community)
- **AppArmor Profiles:** [AppArmor Profile Management](https://wiki.debian.org/AppArmor/HowToUse) (Debian Wiki)

## Emergency Recovery

### System Recovery

**Problem:** System becomes unbootable or corrupted
- **Linux Recovery:** [Linux System Recovery](https://www.cyberciti.biz/faq/howto-boot-linux-rescue-mode/) (nixCraft)
- **Grub Rescue:** [Fix GRUB Bootloader](https://help.ubuntu.com/community/Grub2/Troubleshooting) (Ubuntu Community)
- **Live USB/CD:** [Create Linux Recovery Media](https://ubuntu.com/tutorials/create-a-usb-stick-on-ubuntu) (Ubuntu Tutorial)

### Data Recovery

**Problem:** Important files lost or corrupted
- **File Recovery:** [Linux Data Recovery Tools](https://www.cyberciti.biz/tips/linux-recover-deleted-files-howto.html) (nixCraft)
- **Backup Strategies:** [Linux Backup Solutions](https://www.tecmint.com/linux-system-backup-tools/) (Tecmint)

## Additional Resources

### Video Tutorials
- [YouTube: extending-move Demo](https://www.youtube.com/watch?v=MCmaCifzgbg)
- [YouTube: Quick Installation Video](https://youtu.be/gPiR7Zyu3lc)
- [YouTube: Linux Terminal Basics](https://www.youtube.com/results?search_query=linux+terminal+basics)

### Documentation and Wikis
- [extending-move Wiki](https://github.com/charlesvestal/extending-move/wiki)
- [Arch Wiki](https://wiki.archlinux.org/) (Comprehensive Linux documentation)
- [Ubuntu Documentation](https://help.ubuntu.com/) (Ubuntu Official)
- [Ableton Move Manual](https://www.ableton.com/en/manual/move/) (Official)

### Community Support
- [extending-move GitHub](https://github.com/peterswimm/extending-move)
- [Discord Community](https://discord.gg/yP7SjqDrZG)
- [r/linux4noobs](https://www.reddit.com/r/linux4noobs/) (Beginner-friendly)
- [Unix & Linux Stack Exchange](https://unix.stackexchange.com/) (Expert Q&A)

### Distribution Communities
- [Ubuntu Forums](https://ubuntuforums.org/)
- [Fedora Discussion](https://discussion.fedoraproject.org/)
- [Arch Linux Forums](https://bbs.archlinux.org/)
- [openSUSE Forums](https://forums.opensuse.org/)
- [Debian User Forums](https://forums.debian.net/)

## Disclaimer

These resources are provided for informational purposes. Always refer to official documentation when possible. The extending-move project and its contributors are not responsible for any issues that may arise from following these guides. Always backup important data before making system changes.
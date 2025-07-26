# Linux Setup Guide for Extending Move

This guide will walk you through setting up the Extending Move tools on Linux distributions.

## Prerequisites

The exact commands may vary depending on your Linux distribution. Examples are provided for Ubuntu/Debian, Fedora/CentOS, and Arch Linux.

### 1. Update Your System

**Ubuntu/Debian:**
```bash
sudo apt update && sudo apt upgrade
```

**Fedora/CentOS:**
```bash
sudo dnf update
# or for older versions:
sudo yum update
```

**Arch Linux:**
```bash
sudo pacman -Syu
```

### 2. Install Git

**Ubuntu/Debian:**
```bash
sudo apt install git
```

**Fedora/CentOS:**
```bash
sudo dnf install git
```

**Arch Linux:**
```bash
sudo pacman -S git
```

### 3. Install SSH Client
Most Linux distributions include SSH by default, but ensure it's installed:

**Ubuntu/Debian:**
```bash
sudo apt install openssh-client
```

**Fedora/CentOS:**
```bash
sudo dnf install openssh-clients
```

**Arch Linux:**
```bash
sudo pacman -S openssh
```

### 4. Install Python 3 and pip

**Ubuntu/Debian:**
```bash
sudo apt install python3 python3-pip
```

**Fedora/CentOS:**
```bash
sudo dnf install python3 python3-pip
```

**Arch Linux:**
```bash
sudo pacman -S python python-pip
```

### 5. Install Avahi (for mDNS/Bonjour support)

**Ubuntu/Debian:**
```bash
sudo apt install avahi-daemon avahi-utils libnss-mdns
```

**Fedora/CentOS:**
```bash
sudo dnf install avahi avahi-tools nss-mdns
```

**Arch Linux:**
```bash
sudo pacman -S avahi nss-mdns
sudo systemctl enable --now avahi-daemon
```

## Setup Process

### Step 1: Clone the Repository
```bash
git clone https://github.com/peterswimm/extending-move.git
cd extending-move
```

### Step 2: Ensure Your Move is Connected
1. Connect your Ableton Move to the same network as your Linux machine
2. Verify you can reach it:
   ```bash
   ping move.local
   ```
3. Check if the Move's web interface is accessible:
   ```bash
   curl -I http://move.local
   ```

### Step 3: Test mDNS Resolution
Ensure your system can resolve .local addresses:
```bash
getent hosts move.local
# or
avahi-resolve -n move.local
```

If this doesn't work, you may need to configure NSS for mDNS resolution (see troubleshooting).

### Step 4: Run the Setup Script
```bash
cd utility-scripts
chmod +x setup-ssh-and-install-on-move.sh
./setup-ssh-and-install-on-move.sh
```

### Step 5: Follow the Interactive Setup
The script will guide you through:
1. **SSH Key Generation**: Creates a dedicated SSH key at `~/.ssh/move_key`
2. **SSH Configuration**: Updates `~/.ssh/config` with Move-specific settings
3. **Key Exchange**: Helps you add the public key to your Move
4. **Installation**: Installs the extending-move webserver on your Move
5. **Autostart Configuration**: Sets up the server to start automatically

### Step 6: Access the Webserver
Once setup is complete:
1. Open your web browser
2. Navigate to `http://move.local:909` (or the port you selected)
3. You should see the Extending Move interface

## File Transfer Using SCP

After setup, you can transfer files to your Move using SCP:

### Transfer a file to the Move:
```bash
scp /path/to/local/file.wav ableton@move.local:/data/UserData/UserLibrary/Samples/
```

### Transfer from the Move to your computer:
```bash
scp ableton@move.local:/data/UserData/UserLibrary/Samples/file.wav ~/Downloads/
```

### Transfer entire directories:
```bash
scp -r /path/to/local/directory ableton@move.local:/data/UserData/UserLibrary/
```

### Using rsync (recommended for large transfers):
```bash
rsync -avz --progress /path/to/local/files/ ableton@move.local:/data/UserData/UserLibrary/Samples/
```

## Manual SSH Configuration (Alternative)

If you prefer to set up SSH manually:

### 1. Generate SSH Key
```bash
ssh-keygen -t ed25519 -f ~/.ssh/move_key -N "" -C "move_key_for_ableton_move"
```

### 2. Configure SSH
Create or edit `~/.ssh/config`:
```bash
cat >> ~/.ssh/config << EOF
Host move.local
    HostName move.local
    User ableton
    IdentityFile ~/.ssh/move_key
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null
EOF
```

### 3. Set Correct Permissions
```bash
chmod 600 ~/.ssh/move_key
chmod 644 ~/.ssh/move_key.pub
chmod 700 ~/.ssh
chmod 600 ~/.ssh/config
```

### 4. Copy Public Key to Move
Display your public key:
```bash
cat ~/.ssh/move_key.pub
```

Then add it to the Move following the setup script's guidance.

## Distribution-Specific Notes

### Ubuntu/Debian
- UFW firewall may need configuration for SSH
- Snap packages might interfere with networking
- Consider using `resolvconf` for DNS management

### Fedora/CentOS
- SELinux may require additional configuration
- Firewalld rules might need adjustment
- Use `systemd-resolved` for DNS

### Arch Linux
- NetworkManager configuration may be needed
- Consider using `systemd-networkd` for networking
- Check that `avahi-daemon` is running

### openSUSE
- YaST can be used for network configuration
- Ensure `avahi-daemon` is enabled

## Advanced Configuration

### Setting up SSH Agent
For automatic key loading:
```bash
# Add to ~/.bashrc or ~/.zshrc
if [ -z "$SSH_AUTH_SOCK" ]; then
    eval $(ssh-agent -s)
    ssh-add ~/.ssh/move_key
fi
```

### Creating Desktop Shortcuts
Create a desktop entry for easy access:
```bash
cat > ~/.local/share/applications/extending-move.desktop << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Extending Move
Comment=Access Move tools
Exec=xdg-open http://move.local:909
Icon=applications-multimedia
Terminal=false
Categories=AudioVideo;Audio;
EOF
```

### File Manager Integration
For GUI file transfers, you can mount the Move using SSHFS:

**Install SSHFS:**
```bash
# Ubuntu/Debian
sudo apt install sshfs

# Fedora/CentOS
sudo dnf install sshfs

# Arch Linux
sudo pacman -S sshfs
```

**Mount Move filesystem:**
```bash
mkdir ~/move-samples
sshfs ableton@move.local:/data/UserData/UserLibrary/ ~/move-samples
```

**Unmount when done:**
```bash
fusermount -u ~/move-samples
```

## Verification

Test your setup:
```bash
# Test SSH connection
ssh ableton@move.local "ls -la"

# Test web interface
curl -I http://move.local:909

# Check service status
ssh ableton@move.local "systemctl status extending-move"
```

## Automation Scripts

Create helpful scripts for common tasks:

### Upload Script
```bash
#!/bin/bash
# Save as ~/bin/move-upload
if [ $# -eq 0 ]; then
    echo "Usage: move-upload <file1> [file2] ..."
    exit 1
fi

for file in "$@"; do
    echo "Uploading $file..."
    scp "$file" ableton@move.local:/data/UserData/UserLibrary/Samples/
done
```

### Quick Connect Script
```bash
#!/bin/bash
# Save as ~/bin/move-ssh
ssh ableton@move.local "$@"
```

Make scripts executable:
```bash
chmod +x ~/bin/move-upload ~/bin/move-ssh
```

## Troubleshooting

If you encounter issues, check the [Troubleshooting Links](Troubleshooting-Links.md) for common problems and solutions specific to Linux.

## Next Steps

Once setup is complete, you can:
- Upload MIDI files and create new sets
- Edit presets and parameters  
- Create drum kits from WAV files
- Slice audio samples
- Restore Move sets

Visit `http://move.local:909` to explore all available features!

## Tips for Linux Users

1. **Use aliases**: Add helpful aliases to your shell config:
   ```bash
   alias move-ssh="ssh ableton@move.local"
   alias move-web="xdg-open http://move.local:909"
   alias move-upload="scp -r"
   ```

2. **Systemd integration**: Create systemd user services for automation

3. **Firewall configuration**: Ensure SSH and web ports are accessible

4. **Network monitoring**: Use tools like `netstat`, `ss`, or `nmap` to debug connections

5. **Log monitoring**: Check logs with `journalctl` or `/var/log/` for issues

6. **GUI tools**: Consider using file managers with SSH support like Nautilus, Dolphin, or Thunar
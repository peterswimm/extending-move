# Linux Setup Guide for Extending Move

This guide will walk you through setting up the Extending Move tools on Linux to connect to your Ableton Move device.

## Prerequisites

Before starting, ensure you have:

1. **Linux distribution** (Ubuntu 18.04+, Debian 10+, Fedora 30+, or equivalent)
2. **Python 3.8+** installed
3. **SSH client** (usually pre-installed)
4. **Git** installed
5. **Ableton Move** connected to the same network as your computer
6. **sudo privileges** for package installation

## Quick Setup (Ubuntu/Debian)

### Step 1: Install Dependencies
```bash
# Update package lists
sudo apt update

# Install required packages
sudo apt install python3 python3-pip git openssh-client build-essential

# Optional: Install additional audio libraries
sudo apt install portaudio19-dev libasound2-dev
```

### Step 2: Clone Repository
```bash
# Navigate to your preferred directory (e.g., home)
cd ~

# Clone the repository
git clone https://github.com/peterswimm/extending-move.git
cd extending-move
```

### Step 3: Install Python Dependencies
```bash
# Install Python packages
pip3 install --user -r requirements.txt

# Or use virtual environment (recommended)
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

### Step 4: Run Setup Script
```bash
# Navigate to utility scripts
cd utility-scripts

# Make script executable
chmod +x setup-ssh-and-install-on-move.sh

# Run the setup script
./setup-ssh-and-install-on-move.sh
```

Follow the prompts to:
- Generate SSH keys
- Configure SSH for your Move
- Install the server on your Move device
- Set up auto-start

## Distribution-Specific Instructions

### Fedora/CentOS/RHEL
```bash
# Install dependencies
sudo dnf install python3 python3-pip git openssh-clients gcc gcc-c++ make

# Or for older versions
sudo yum install python3 python3-pip git openssh-clients gcc gcc-c++ make

# Continue with standard steps
```

### Arch Linux
```bash
# Install dependencies
sudo pacman -S python python-pip git openssh gcc make

# Continue with standard steps
```

### openSUSE
```bash
# Install dependencies
sudo zypper install python3 python3-pip git openssh gcc gcc-c++ make

# Continue with standard steps
```

## Manual Setup (Alternative Method)

If you prefer manual setup or encounter issues with the automated script:

### Step 1: Verify Prerequisites
```bash
# Check Python version (should be 3.8+)
python3 --version

# Check SSH client
which ssh

# Check Git
git --version
```

### Step 2: Generate SSH Key
```bash
# Generate SSH key for Move
ssh-keygen -t ed25519 -f ~/.ssh/move_key -N "" -C "move_key_for_ableton_move"

# Add key to SSH agent
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/move_key
```

### Step 3: Configure SSH
Create or edit `~/.ssh/config`:
```bash
# Create SSH config if it doesn't exist
touch ~/.ssh/config
chmod 600 ~/.ssh/config

# Add Move configuration
cat >> ~/.ssh/config << EOF
Host move.local
    HostName move.local
    User ableton
    IdentityFile ~/.ssh/move_key
    StrictHostKeyChecking no
    AddKeysToAgent yes
EOF
```

### Step 4: Connect to Move
```bash
# Copy SSH key to Move (you'll be prompted for password)
ssh-copy-id -i ~/.ssh/move_key.pub ableton@move.local

# Test SSH connection
ssh ableton@move.local
# You should connect without password prompt
exit
```

### Step 5: Install on Move
```bash
# Transfer project files
scp -r extending-move ableton@move.local:~/

# Connect and install
ssh ableton@move.local
cd extending-move/utility-scripts
chmod +x install-on-move.sh
./install-on-move.sh
```

Select your preferred port when prompted (909 is recommended).

## Linux Distribution Differences

### Package Managers
- **Debian/Ubuntu**: `apt` / `apt-get`
- **Fedora/CentOS**: `dnf` / `yum`
- **Arch**: `pacman`
- **openSUSE**: `zypper`
- **Alpine**: `apk`

### Python Installation
Some distributions may require:
```bash
# Python development headers
sudo apt install python3-dev  # Debian/Ubuntu
sudo dnf install python3-devel  # Fedora
sudo pacman -S python  # Arch (includes dev headers)
```

### Audio Libraries (Optional)
For enhanced audio processing:
```bash
# Ubuntu/Debian
sudo apt install libportaudio2 libportaudiocpp0 portaudio19-dev libasound2-dev

# Fedora
sudo dnf install portaudio-devel alsa-lib-devel

# Arch
sudo pacman -S portaudio alsa-lib
```

## Firewall Configuration

### UFW (Ubuntu/Debian)
```bash
# Check firewall status
sudo ufw status

# Allow outbound SSH (usually allowed by default)
sudo ufw allow out 22

# Allow access to Move web interface (if running locally)
sudo ufw allow 909
```

### Firewalld (Fedora/CentOS)
```bash
# Check firewall status
sudo firewall-cmd --state

# Allow SSH outbound (usually allowed)
sudo firewall-cmd --permanent --add-service=ssh
sudo firewall-cmd --reload
```

### iptables
```bash
# Check current rules
sudo iptables -L

# Generally, outbound SSH is allowed by default
# Add rules if needed for your specific setup
```

## Network Configuration

### Finding Your Move Device
```bash
# Try to ping Move
ping move.local

# If that fails, scan local network
nmap -sn 192.168.1.0/24  # Adjust network range as needed

# Or use avahi utilities
avahi-browse -at
```

### DNS Resolution Issues
```bash
# Install avahi for mDNS support
sudo apt install avahi-utils  # Ubuntu/Debian
sudo dnf install avahi-tools  # Fedora

# Test mDNS resolution
avahi-resolve -n move.local
```

## Virtual Environment Setup (Recommended)

Using a virtual environment prevents conflicts with system packages:

```bash
# Create virtual environment
python3 -m venv extending-move-env

# Activate virtual environment
source extending-move-env/bin/activate

# Install dependencies
pip install -r requirements.txt

# When done, deactivate
deactivate
```

## Systemd Service (Optional)

To run Extending Move as a system service:

```bash
# Create service file
sudo tee /etc/systemd/system/extending-move.service << EOF
[Unit]
Description=Extending Move Web Server
After=network.target

[Service]
Type=simple
User=$(whoami)
WorkingDirectory=$(pwd)
Environment=PATH=$(pwd)/venv/bin
ExecStart=$(pwd)/venv/bin/python move-webserver.py
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Enable and start service
sudo systemctl enable extending-move
sudo systemctl start extending-move

# Check status
sudo systemctl status extending-move
```

## Testing Your Installation

### Verify SSH Connection
```bash
# Test SSH connection
ssh ableton@move.local 'echo "SSH connection successful"'
```

### Test Web Interface
```bash
# Open web browser
xdg-open http://move.local:909

# Or use curl to test
curl -I http://move.local:909
```

### Check Python Dependencies
```bash
# Test imports
python3 -c "import numpy, soundfile, mido, flask; print('All dependencies imported successfully')"
```

## Common Linux Commands

### File Operations
```bash
# List files with permissions
ls -la

# Change permissions
chmod +x script_name

# Change ownership
chown user:group file_name

# Copy files
cp source destination
scp source user@host:destination
```

### Process Management
```bash
# Find running processes
ps aux | grep python

# Kill process by PID
kill PID

# Kill process by name
pkill -f "move-webserver"
```

### Network Debugging
```bash
# Check network connections
netstat -an | grep 909

# Check routing
ip route

# Test connectivity
telnet move.local 22
```

## Troubleshooting Quick Fixes

### Permission Errors
```bash
# Fix script permissions
chmod +x utility-scripts/*.sh

# Fix SSH key permissions
chmod 600 ~/.ssh/move_key
chmod 644 ~/.ssh/move_key.pub
```

### Python Import Errors
```bash
# Reinstall dependencies
pip3 install --user -r requirements.txt --force-reinstall

# Check Python path
python3 -c "import sys; print('\n'.join(sys.path))"
```

### SSH Issues
```bash
# Remove old host key
ssh-keygen -R move.local

# Debug SSH connection
ssh -v ableton@move.local
```

### Network Issues
```bash
# Restart networking
sudo systemctl restart networking  # Debian/Ubuntu
sudo systemctl restart NetworkManager  # Most modern distros

# Flush DNS cache
sudo systemctl flush-dns  # systemd-resolved
```

## Security Considerations

### SSH Key Security
- Keep private keys secure (`~/.ssh/move_key`)
- Use strong passphrases if sharing the computer
- Regularly rotate keys if needed

### Network Security
- Ensure you're on a trusted network
- Consider using VPN if on public WiFi
- Monitor network traffic if suspicious

### Firewall Rules
- Keep firewall enabled
- Only open necessary ports
- Regularly review firewall rules

## Next Steps

Once installation is complete:

1. **Access the interface**: Open `http://move.local:909` in your browser
2. **Explore features**: Try the sample slicing, chord generation, etc.
3. **Read documentation**: Check the [main README](../../README.md)
4. **Join community**: Connect on [Discord](https://discord.gg/yP7SjqDrZG)
5. **Contribute**: Consider contributing to the project

## Additional Resources

- **Troubleshooting**: See [Troubleshooting-Links.md](./Troubleshooting-Links.md)
- **Video Guide**: [Installation video](https://youtu.be/gPiR7Zyu3lc)
- **Community**: [Discord server](https://discord.gg/yP7SjqDrZG)
- **Documentation**: [Project Wiki](https://github.com/charlesvestal/extending-move/wiki)

---

⚠️ **Important**: This tool provides SSH access to your Move device and is not officially supported by Ableton. Use at your own risk and refer to official recovery documentation if issues arise.
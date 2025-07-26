# Linux Setup Guide - Extending Move

This guide will help you set up the extending-move companion webserver on your Linux system to work with your Ableton Move device.

## Prerequisites

Before you begin, ensure you have the following installed on your Linux system:

### Required Software

#### For Ubuntu/Debian-based distributions:
```bash
sudo apt update
sudo apt install git openssh-client python3 python3-pip python3-venv curl
```

#### For RHEL/CentOS/Fedora-based distributions:
```bash
# For Fedora
sudo dnf install git openssh-clients python3 python3-pip curl

# For CentOS/RHEL
sudo yum install git openssh-clients python3 python3-pip curl
```

#### For Arch Linux:
```bash
sudo pacman -S git openssh python python-pip curl
```

#### For openSUSE:
```bash
sudo zypper install git openssh python3 python3-pip curl
```

### Network Requirements
- Your Move device and Linux computer must be on the same network
- The Move device must be accessible at `move.local` (test with `ping move.local`)
- If `move.local` doesn't resolve, you may need to install Avahi:

```bash
# Ubuntu/Debian
sudo apt install avahi-utils

# Fedora
sudo dnf install avahi-tools

# Arch
sudo pacman -S avahi
```

## Step-by-Step Installation

### Step 1: Download the Repository

1. Open your terminal
2. Navigate to where you want to download the project:
   ```bash
   cd ~/Documents
   ```
3. Clone the repository:
   ```bash
   git clone https://github.com/peterswimm/extending-move.git
   cd extending-move
   ```

### Step 2: Configure SSH Access

#### Generate SSH Key Pair
```bash
ssh-keygen -t ed25519 -f ~/.ssh/move_key -N "" -C "move_key_for_ableton_move"
```

#### Configure SSH Client
Add the following to `~/.ssh/config` (create if it doesn't exist):
```bash
cat >> ~/.ssh/config << 'EOF'
Host move.local
    HostName move.local
    User ableton
    IdentityFile ~/.ssh/move_key
    IdentitiesOnly yes
EOF
```

Set correct permissions:
```bash
chmod 600 ~/.ssh/config ~/.ssh/move_key
chmod 644 ~/.ssh/move_key.pub
```

### Step 3: Add SSH Key to Move Device

You'll need to manually add your public key to the Move device:

1. Display your public key:
   ```bash
   cat ~/.ssh/move_key.pub
   ```

2. Copy the entire output (the long line starting with `ssh-ed25519`)

3. Connect to your Move device and add the key:
   ```bash
   # First time connection (will ask for password)
   ssh ableton@move.local
   
   # On the Move device, create .ssh directory if it doesn't exist
   mkdir -p ~/.ssh
   chmod 700 ~/.ssh
   
   # Add your public key to authorized_keys
   echo "YOUR_PUBLIC_KEY_HERE" >> ~/.ssh/authorized_keys
   chmod 600 ~/.ssh/authorized_keys
   
   # Exit from Move
   exit
   ```

### Step 4: Test SSH Connection

Verify that key-based authentication works:
```bash
ssh ableton@move.local
```

You should connect without being prompted for a password.

### Step 5: Install on Move Device

1. Navigate to the utility-scripts folder:
   ```bash
   cd utility-scripts
   ```

2. Make the script executable and run it:
   ```bash
   chmod +x install-on-move.sh
   ./install-on-move.sh
   ```

3. Choose your preferred port (default is 909)

4. The script will:
   - Transfer files to your Move device
   - Install Python dependencies
   - Set up the webserver

### Step 6: Access the Webserver

1. Once installation is complete, open your web browser
2. Navigate to: `http://move.local:909` (or your chosen port)
3. You should see the extending-move interface

### Step 7: Optional - Set Up Auto-Start

To have the webserver start automatically when your Move boots:

```bash
./setup-autostart-on-move.sh
```

## File Transfer via SCP

Linux has excellent built-in SCP and rsync support:

### Basic SCP Commands
```bash
# Copy a file to Move
scp -i ~/.ssh/move_key your-file.txt ableton@move.local:/home/ableton/

# Copy a directory recursively
scp -i ~/.ssh/move_key -r your-directory/ ableton@move.local:/home/ableton/

# Copy from Move to your Linux system
scp -i ~/.ssh/move_key ableton@move.local:/home/ableton/remote-file.txt ~/Downloads/
```

### Using rsync (Recommended)
```bash
# Sync a directory with progress and compression
rsync -avz --progress -e "ssh -i ~/.ssh/move_key" your-directory/ ableton@move.local:/home/ableton/

# Exclude certain files
rsync -avz --exclude="*.tmp" --exclude="*.log" -e "ssh -i ~/.ssh/move_key" your-directory/ ableton@move.local:/home/ableton/

# Dry run to see what would be transferred
rsync -avz --dry-run -e "ssh -i ~/.ssh/move_key" your-directory/ ableton@move.local:/home/ableton/
```

## Verification

To verify everything is working:

1. SSH into your Move:
   ```bash
   ssh ableton@move.local
   ```

2. Check if the webserver is running:
   ```bash
   ps aux | grep python3
   ```

3. Check systemd service status (if auto-start was configured):
   ```bash
   systemctl --user status extending-move
   ```

4. Test the web interface at `http://move.local:909`

5. Check logs if needed:
   ```bash
   ssh ableton@move.local "journalctl --user -u extending-move -f"
   ```

## Linux Distribution-Specific Notes

### Ubuntu/Debian
- Uses `apt` package manager
- Python virtual environments work well
- Avahi usually pre-installed for mDNS resolution

### Fedora/RHEL/CentOS
- Uses `dnf`/`yum` package manager
- SELinux may require additional configuration:
  ```bash
  # Check SELinux status
  sestatus
  
  # If needed, set SELinux to permissive temporarily
  sudo setenforce 0
  ```

### Arch Linux
- Uses `pacman` package manager
- Very up-to-date packages
- May need to enable Avahi daemon:
  ```bash
  sudo systemctl enable --now avahi-daemon
  ```

### openSUSE
- Uses `zypper` package manager
- Firewall configuration may be needed:
  ```bash
  sudo firewall-cmd --permanent --add-port=909/tcp
  sudo firewall-cmd --reload
  ```

## Advanced Configuration

### SSH Key Management with ssh-agent
```bash
# Start ssh-agent
eval $(ssh-agent)

# Add your key
ssh-add ~/.ssh/move_key

# List loaded keys
ssh-add -l
```

### Multiple Move Devices
Configure different SSH hosts in `~/.ssh/config`:
```
Host move1
    HostName move.local
    User ableton
    IdentityFile ~/.ssh/move_key_1

Host move2
    HostName 192.168.1.100
    User ableton
    IdentityFile ~/.ssh/move_key_2
```

### Shell Aliases and Functions
Add to your `~/.bashrc` or `~/.zshrc`:
```bash
# Convenience aliases
alias move-ssh="ssh ableton@move.local"
alias move-logs="ssh ableton@move.local 'journalctl --user -u extending-move -f'"

# Function to quickly transfer files
move-send() {
    rsync -avz --progress -e "ssh -i ~/.ssh/move_key" "$1" ableton@move.local:/home/ableton/
}

# Function to restart the webserver
move-restart() {
    ssh ableton@move.local "systemctl --user restart extending-move"
}
```

### Python Virtual Environment
For development or isolated Python environments:
```bash
# Create virtual environment
python3 -m venv ~/extending-move-env

# Activate
source ~/extending-move-env/bin/activate

# Install requirements
pip install -r requirements.txt

# Deactivate when done
deactivate
```

## Firewall Configuration

If you have a firewall enabled, you may need to configure it:

### UFW (Ubuntu)
```bash
# Allow outgoing SSH
sudo ufw allow out 22

# Allow access to Move webserver
sudo ufw allow out 909
```

### firewalld (Fedora/RHEL)
```bash
# Allow SSH
sudo firewall-cmd --permanent --add-service=ssh

# Allow custom port for Move
sudo firewall-cmd --permanent --add-port=909/tcp
sudo firewall-cmd --reload
```

### iptables (General)
```bash
# Allow outgoing SSH
sudo iptables -A OUTPUT -p tcp --dport 22 -j ACCEPT

# Allow outgoing HTTP to Move
sudo iptables -A OUTPUT -p tcp --dport 909 -j ACCEPT
```

## Important Notes

- **Use at your own risk**: This tool is not officially supported by Ableton
- **Backup your Move**: Consider backing up your Move device before installation
- **Recovery information**: Available on Ableton Center Code (link in main README)
- **File permissions**: Be careful with SSH key permissions (600 for private, 644 for public)
- **Network security**: The Move device will be accessible via SSH with your key

## Next Steps

Once installed, you can:
- Upload and restore Move Sets
- Edit presets and macros
- Create chord and sliced kits
- Import MIDI files
- Inspect and modify drum racks
- Edit clips with the piano roll interface
- And much more!

See the main README for a complete feature list and documentation.

## Linux Desktop Integration

### Creating Desktop Shortcuts
Create a `.desktop` file for easy access:
```bash
cat > ~/.local/share/applications/extending-move.desktop << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Extending Move
Comment=Access Extending Move Web Interface
Exec=xdg-open http://move.local:909
Icon=applications-multimedia
Terminal=false
Categories=AudioVideo;Music;
EOF
```

### File Manager Integration
Most Linux file managers support SFTP:
- **Nautilus (GNOME)**: Other Locations → Connect to Server → `sftp://ableton@move.local`
- **Dolphin (KDE)**: Network → Add Network Folder → SFTP
- **Thunar (XFCE)**: Browse Network → SSH FTP

## Command Line Productivity Tips

### Bash Completion
Add SSH host completion to your bash:
```bash
echo "complete -W 'move.local' ssh scp" >> ~/.bashrc
```

### Terminal Multiplexing
Use `tmux` or `screen` for persistent SSH sessions:
```bash
# Install tmux
sudo apt install tmux  # Ubuntu/Debian
sudo dnf install tmux  # Fedora

# Start tmux session
tmux new-session -s move

# SSH to Move in tmux
ssh ableton@move.local

# Detach: Ctrl+b, d
# Reattach: tmux attach -t move
```
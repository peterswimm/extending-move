#!/bin/bash
set -euo pipefail

# Linux Setup Script for Extending Move
# This script automates the setup process for various Linux distributions

clear
echo "=========================================="
echo "   Extending Move - Linux Setup"
echo "=========================================="
echo ""
echo "This script will help you set up extending-move on Linux."
echo "It will guide you through:"
echo "1. Detecting your distribution and installing prerequisites"
echo "2. Setting up SSH access to your Move device" 
echo "3. Installing the webserver on your Move"
echo "4. Verifying the installation"
echo ""
echo "Supported distributions:"
echo "- Ubuntu/Debian-based (apt)"
echo "- Fedora/RHEL/CentOS (dnf/yum)"
echo "- Arch Linux (pacman)"
echo "- openSUSE (zypper)"
echo ""
echo "YOU ARE PROCEEDING AT YOUR OWN RISK."
echo "Neither the authors nor Ableton are responsible for any damage."
echo ""
read -p "Ready to proceed? (y/N): " user_ready
if [[ ! "$user_ready" =~ ^[Yy]$ ]]; then
    echo "Setup aborted by user."
    exit 1
fi

echo ""
echo "Step 1: Detecting Distribution and Prerequisites..."
echo "================================================="

# Detect distribution
DISTRO=""
PACKAGE_MANAGER=""
INSTALL_CMD=""

if command -v apt &> /dev/null; then
    DISTRO="Ubuntu/Debian"
    PACKAGE_MANAGER="apt"
    INSTALL_CMD="sudo apt update && sudo apt install -y"
elif command -v dnf &> /dev/null; then
    DISTRO="Fedora"
    PACKAGE_MANAGER="dnf"
    INSTALL_CMD="sudo dnf install -y"
elif command -v yum &> /dev/null; then
    DISTRO="RHEL/CentOS"
    PACKAGE_MANAGER="yum"
    INSTALL_CMD="sudo yum install -y"
elif command -v pacman &> /dev/null; then
    DISTRO="Arch Linux"
    PACKAGE_MANAGER="pacman"
    INSTALL_CMD="sudo pacman -S --noconfirm"
elif command -v zypper &> /dev/null; then
    DISTRO="openSUSE"
    PACKAGE_MANAGER="zypper"
    INSTALL_CMD="sudo zypper install -y"
else
    echo "WARNING: Could not detect a supported package manager."
    echo "This script supports apt, dnf, yum, pacman, and zypper."
    echo "You may need to install prerequisites manually."
    DISTRO="Unknown"
fi

echo "Detected distribution: $DISTRO"

# Define required packages for each distribution
declare -A PACKAGES
PACKAGES[apt]="git openssh-client python3 python3-pip python3-venv curl avahi-utils"
PACKAGES[dnf]="git openssh-clients python3 python3-pip curl avahi-tools"
PACKAGES[yum]="git openssh-clients python3 python3-pip curl avahi-tools"
PACKAGES[pacman]="git openssh python python-pip curl avahi"
PACKAGES[zypper]="git openssh python3 python3-pip curl avahi-utils"

# Check and install prerequisites
if [[ "$DISTRO" != "Unknown" ]]; then
    echo ""
    echo "Checking for required packages..."
    
    MISSING_PACKAGES=()
    
    # Check for git
    if ! command -v git &> /dev/null; then
        MISSING_PACKAGES+=("git")
    else
        echo "✓ Git is installed"
    fi
    
    # Check for SSH
    if ! command -v ssh &> /dev/null; then
        if [[ "$PACKAGE_MANAGER" == "apt" ]]; then
            MISSING_PACKAGES+=("openssh-client")
        else
            MISSING_PACKAGES+=("openssh-clients")
        fi
    else
        echo "✓ SSH is installed"
    fi
    
    # Check for Python
    if ! command -v python3 &> /dev/null; then
        MISSING_PACKAGES+=("python3")
    else
        echo "✓ Python 3 is installed"
    fi
    
    # Check for pip
    if ! command -v pip3 &> /dev/null && ! python3 -m pip --version &> /dev/null; then
        if [[ "$PACKAGE_MANAGER" == "pacman" ]]; then
            MISSING_PACKAGES+=("python-pip")
        else
            MISSING_PACKAGES+=("python3-pip")
        fi
    else
        echo "✓ Python pip is installed"
    fi
    
    # Check for curl
    if ! command -v curl &> /dev/null; then
        MISSING_PACKAGES+=("curl")
    else
        echo "✓ curl is installed"
    fi
    
    # Check for Avahi (for mDNS resolution)
    if ! command -v avahi-resolve &> /dev/null && ! systemctl is-active avahi-daemon &> /dev/null; then
        if [[ "$PACKAGE_MANAGER" == "apt" ]]; then
            MISSING_PACKAGES+=("avahi-utils")
        elif [[ "$PACKAGE_MANAGER" == "dnf" || "$PACKAGE_MANAGER" == "yum" ]]; then
            MISSING_PACKAGES+=("avahi-tools")
        elif [[ "$PACKAGE_MANAGER" == "pacman" ]]; then
            MISSING_PACKAGES+=("avahi")
        elif [[ "$PACKAGE_MANAGER" == "zypper" ]]; then
            MISSING_PACKAGES+=("avahi-utils")
        fi
    else
        echo "✓ Avahi/mDNS is available"
    fi
    
    # Install missing packages
    if [[ ${#MISSING_PACKAGES[@]} -gt 0 ]]; then
        echo ""
        echo "Missing packages: ${MISSING_PACKAGES[*]}"
        read -p "Install missing packages? (Y/n): " install_packages
        
        if [[ ! "$install_packages" =~ ^[Nn]$ ]]; then
            echo "Installing missing packages..."
            case "$PACKAGE_MANAGER" in
                "apt")
                    sudo apt update
                    sudo apt install -y "${MISSING_PACKAGES[@]}"
                    ;;
                "dnf")
                    sudo dnf install -y "${MISSING_PACKAGES[@]}"
                    ;;
                "yum")
                    sudo yum install -y "${MISSING_PACKAGES[@]}"
                    ;;
                "pacman")
                    sudo pacman -S --noconfirm "${MISSING_PACKAGES[@]}"
                    ;;
                "zypper")
                    sudo zypper install -y "${MISSING_PACKAGES[@]}"
                    ;;
            esac
            echo "✓ Packages installed"
        else
            echo "WARNING: Some packages may be missing. Installation may fail."
        fi
    else
        echo "✓ All required packages are installed"
    fi
    
    # Start Avahi daemon if needed
    if command -v systemctl &> /dev/null && ! systemctl is-active avahi-daemon &> /dev/null; then
        echo "Starting Avahi daemon for mDNS resolution..."
        sudo systemctl start avahi-daemon
        sudo systemctl enable avahi-daemon 2>/dev/null || true
    fi
else
    echo "Please ensure you have the following installed:"
    echo "- git"
    echo "- openssh-client/openssh-clients"
    echo "- python3"
    echo "- python3-pip" 
    echo "- curl"
    echo "- avahi-utils/avahi-tools (for mDNS resolution)"
fi

# Check network connectivity to Move
echo ""
echo "Testing connection to Move device..."
if ping -c 1 move.local &> /dev/null; then
    echo "✓ Move device is reachable at move.local"
elif command -v avahi-resolve &> /dev/null && avahi-resolve -n move.local &> /dev/null; then
    echo "✓ Move device found via Avahi"
else
    echo "WARNING: Cannot reach move.local"
    echo "Please ensure:"
    echo "- Your Move device is on and connected to the same network"
    echo "- Your Linux computer is on the same network"
    echo "- Avahi/mDNS is working (avahi-daemon service is running)"
    echo "- No firewall is blocking the connection"
    echo ""
    echo "Try these troubleshooting steps:"
    echo "- sudo systemctl start avahi-daemon"
    echo "- avahi-resolve -n move.local"
    echo "- Check firewall: sudo ufw status (Ubuntu) or sudo firewall-cmd --state (Fedora)"
    echo ""
    read -p "Continue anyway? (y/N): " continue_network
    if [[ ! "$continue_network" =~ ^[Yy]$ ]]; then
        echo "Please check your network connection and try again."
        echo "See Troubleshooting-Links.md for network troubleshooting help."
        exit 1
    fi
fi

echo ""
echo "Step 2: Repository Setup..."
echo "==========================="

# Determine where to clone the repository
if [[ -f "../../move-webserver.py" ]]; then
    echo "You're already in the extending-move repository directory."
    REPO_DIR="$(pwd)/../.."
    cd "$REPO_DIR"
else
    echo "Current directory: $(pwd)"
    echo "Recommended location: ~/Documents/extending-move"
    echo ""
    read -p "Where would you like to download extending-move? [~/Documents]: " repo_location
    if [[ -z "$repo_location" ]]; then
        repo_location="~/Documents"
    fi
    
    # Expand tilde
    repo_location="${repo_location/#\~/$HOME}"
    
    # Create directory if it doesn't exist
    mkdir -p "$repo_location"
    cd "$repo_location"
    
    if [[ -d "extending-move" ]]; then
        echo "extending-move directory already exists."
        read -p "Update existing repository? (y/N): " update_repo
        if [[ "$update_repo" =~ ^[Yy]$ ]]; then
            cd extending-move
            git pull
        else
            cd extending-move
        fi
    else
        echo "Cloning extending-move repository..."
        git clone https://github.com/peterswimm/extending-move.git
        cd extending-move
    fi
    REPO_DIR="$(pwd)"
fi

echo "✓ Repository ready at: $REPO_DIR"

echo ""
echo "Step 3: SSH Setup..."
echo "==================="

# SSH key path
MOVE_KEY_PATH="$HOME/.ssh/move_key"

# Create .ssh directory if it doesn't exist
mkdir -p "$HOME/.ssh"

# Generate SSH key if it doesn't exist
if [[ -f "$MOVE_KEY_PATH" ]]; then
    echo "SSH key already exists at $MOVE_KEY_PATH"
    read -p "Use existing key? (Y/n): " use_existing
    if [[ "$use_existing" =~ ^[Nn]$ ]]; then
        echo "Generating new SSH key..."
        ssh-keygen -t ed25519 -f "$MOVE_KEY_PATH" -N "" -C "move_key_for_ableton_move"
    fi
else
    echo "Generating SSH key for Move device..."
    ssh-keygen -t ed25519 -f "$MOVE_KEY_PATH" -N "" -C "move_key_for_ableton_move"
fi

echo "✓ SSH key ready"

# Configure SSH
SSH_CONFIG="$HOME/.ssh/config"
if ! grep -q "Host move.local" "$SSH_CONFIG" 2>/dev/null; then
    echo "Configuring SSH for move.local..."
    cat >> "$SSH_CONFIG" << 'EOF'

Host move.local
    HostName move.local
    User ableton
    IdentityFile ~/.ssh/move_key
    IdentitiesOnly yes
EOF
    chmod 600 "$SSH_CONFIG"
    echo "✓ SSH configuration updated"
else
    echo "✓ SSH configuration already exists"
fi

# Set correct permissions
chmod 600 "$MOVE_KEY_PATH" "$SSH_CONFIG" 2>/dev/null || true
chmod 644 "$MOVE_KEY_PATH.pub" 2>/dev/null || true

echo ""
echo "Step 4: SSH Key Installation..."
echo "==============================="
echo ""
echo "Your SSH public key:"
echo "--------------------"
cat "$MOVE_KEY_PATH.pub"
echo "--------------------"
echo ""
echo "You need to add this key to your Move device."
echo ""
echo "OPTION 1 - Automatic (if password login works):"
echo "Run this command and enter your Move password when prompted:"
echo "  ssh-copy-id -i $MOVE_KEY_PATH ableton@move.local"
echo ""
echo "OPTION 2 - Manual:"
echo "1. Connect to your Move: ssh ableton@move.local"
echo "2. Create .ssh directory: mkdir -p ~/.ssh && chmod 700 ~/.ssh"
echo "3. Add the key: echo 'YOUR_PUBLIC_KEY_ABOVE' >> ~/.ssh/authorized_keys"
echo "4. Set permissions: chmod 600 ~/.ssh/authorized_keys"
echo "5. Exit: exit"
echo ""
echo "OPTION 3 - Copy to clipboard (if xclip/wl-clipboard is available):"
if command -v xclip &> /dev/null; then
    echo "Key copied to clipboard (X11):"
    cat "$MOVE_KEY_PATH.pub" | xclip -selection clipboard
    echo "Paste this into your Move's authorized_keys file"
elif command -v wl-copy &> /dev/null; then
    echo "Key copied to clipboard (Wayland):"
    cat "$MOVE_KEY_PATH.pub" | wl-copy
    echo "Paste this into your Move's authorized_keys file"
fi
echo ""
read -p "Try automatic installation? (Y/n): " try_auto
if [[ ! "$try_auto" =~ ^[Nn]$ ]]; then
    echo "Attempting automatic SSH key installation..."
    if ssh-copy-id -i "$MOVE_KEY_PATH" ableton@move.local; then
        echo "✓ SSH key installed automatically"
    else
        echo "Automatic installation failed. Please use manual method above."
        read -p "Press Enter when you've manually installed the SSH key..." manual_done
    fi
else
    echo "Please manually install the SSH key using one of the methods above."
    read -p "Press Enter when you've manually installed the SSH key..." manual_done
fi

# Test SSH connection
echo ""
echo "Testing SSH connection..."
if ssh -i "$MOVE_KEY_PATH" -o ConnectTimeout=10 -o BatchMode=yes ableton@move.local "echo 'SSH connection successful'" 2>/dev/null; then
    echo "✓ SSH connection works!"
else
    echo "ERROR: SSH connection failed."
    echo "Please check:"
    echo "- The SSH key was added correctly to your Move device"
    echo "- Your Move device is reachable at move.local"
    echo "- No firewall is blocking the connection"
    echo "- SELinux is not blocking SSH (run: sudo setsebool -P ssh_use_dns off)"
    echo ""
    echo "See Troubleshooting-Links.md for more help."
    exit 1
fi

echo ""
echo "Step 5: Installation..."
echo "======================"

cd "$REPO_DIR/utility-scripts"

echo "Running installation script..."
if [[ -x "./install-on-move.sh" ]]; then
    ./install-on-move.sh
else
    echo "ERROR: install-on-move.sh not found or not executable"
    echo "Please check that you're in the correct repository directory."
    exit 1
fi

echo ""
echo "Step 6: Verification..."
echo "======================"

echo "Testing webserver connection..."
sleep 2  # Give the server a moment to start

# Try to detect the port from the installation
PORT="909"
if [[ -f "../port.conf" ]]; then
    PORT=$(cat "../port.conf" 2>/dev/null || echo "909")
fi

echo "Checking webserver at http://move.local:$PORT ..."
if curl -s --connect-timeout 10 "http://move.local:$PORT" > /dev/null; then
    echo "✓ Webserver is running!"
    echo ""
    echo "SUCCESS! Setup complete."
    echo "========================"
    echo ""
    echo "You can now access extending-move at:"
    echo "  http://move.local:$PORT"
    echo ""
    echo "Open this URL in your web browser to start using extending-move."
    
    # Offer to open in browser
    if command -v xdg-open &> /dev/null; then
        read -p "Open in your default browser now? (Y/n): " open_browser
        if [[ ! "$open_browser" =~ ^[Nn]$ ]]; then
            xdg-open "http://move.local:$PORT" &
        fi
    fi
else
    echo "WARNING: Could not connect to webserver."
    echo "The installation may still be successful. Please try:"
    echo "1. Wait a few more seconds and try: http://move.local:$PORT"
    echo "2. Check if the webserver is running: ssh ableton@move.local 'ps aux | grep python'"
    echo "3. Restart the webserver: ssh ableton@move.local 'cd extending-move && python3 move-webserver.py'"
fi

echo ""
echo "Optional: Auto-start Setup"
echo "========================="
read -p "Would you like to set up auto-start so the webserver runs automatically? (y/N): " setup_autostart
if [[ "$setup_autostart" =~ ^[Yy]$ ]]; then
    if [[ -x "./setup-autostart-on-move.sh" ]]; then
        ./setup-autostart-on-move.sh
        echo "✓ Auto-start configured"
    else
        echo "WARNING: setup-autostart-on-move.sh not found"
    fi
fi

echo ""
echo "Optional: Desktop Integration"
echo "============================"
read -p "Create a desktop shortcut? (y/N): " create_shortcut
if [[ "$create_shortcut" =~ ^[Yy]$ ]]; then
    DESKTOP_DIR="$HOME/Desktop"
    if [[ ! -d "$DESKTOP_DIR" ]]; then
        DESKTOP_DIR="$HOME/.local/share/applications"
        mkdir -p "$DESKTOP_DIR"
    fi
    
    SHORTCUT_PATH="$DESKTOP_DIR/extending-move.desktop"
    cat > "$SHORTCUT_PATH" << EOF
[Desktop Entry]
Name=Extending Move
Comment=Open Extending Move webserver
Exec=xdg-open http://move.local:$PORT
Icon=applications-internet
Terminal=false
Type=Application
Categories=Network;Audio;
EOF
    chmod +x "$SHORTCUT_PATH"
    echo "✓ Desktop shortcut created: $SHORTCUT_PATH"
fi

echo ""
echo "Setup complete! Enjoy extending-move!"
echo ""
echo "Useful commands:"
echo "- Open extending-move: xdg-open http://move.local:$PORT"
echo "- SSH to Move: ssh ableton@move.local"
echo "- Update extending-move: cd $REPO_DIR && git pull"
echo "- Check Move webserver: ssh ableton@move.local 'ps aux | grep python'"
echo ""
echo "Troubleshooting:"
echo "- Check the Step-by-Step-Guide.md for detailed instructions"
echo "- See Troubleshooting-Links.md for common issues"
echo "- Check firewall: sudo ufw status (Ubuntu) or sudo firewall-cmd --list-all (Fedora)"
echo "- Check Avahi: sudo systemctl status avahi-daemon"
echo "- Visit: https://github.com/peterswimm/extending-move"
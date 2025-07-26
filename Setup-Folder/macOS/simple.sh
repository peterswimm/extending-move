#!/bin/bash
set -euo pipefail

# macOS Setup Script for Extending Move
# This script automates the setup process for macOS users

clear
echo "=========================================="
echo "   Extending Move - macOS Setup"
echo "=========================================="
echo ""
echo "This script will help you set up extending-move on macOS."
echo "It will guide you through:"
echo "1. Checking and installing prerequisites"
echo "2. Setting up SSH access to your Move device"
echo "3. Installing the webserver on your Move"
echo "4. Verifying the installation"
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
echo "Step 1: Checking Prerequisites..."
echo "================================="

# Check for Xcode Command Line Tools
if ! xcode-select -p &> /dev/null; then
    echo "Xcode Command Line Tools not found."
    echo "Installing Xcode Command Line Tools..."
    xcode-select --install
    echo ""
    echo "Please complete the Xcode Command Line Tools installation in the popup,"
    echo "then run this script again."
    exit 1
fi
echo "✓ Xcode Command Line Tools installed"

# Check for Git
if ! command -v git &> /dev/null; then
    echo "ERROR: Git is not installed."
    echo "Git should be included with Xcode Command Line Tools."
    echo "Please reinstall Xcode Command Line Tools or install Git separately."
    exit 1
fi
echo "✓ Git is installed (version: $(git --version | cut -d' ' -f3))"

# Check for Python
PYTHON_CMD=""
if command -v python3 &> /dev/null; then
    PYTHON_CMD="python3"
elif command -v python &> /dev/null; then
    # Check if it's Python 3
    if python -c "import sys; sys.exit(0 if sys.version_info >= (3, 8) else 1)" 2>/dev/null; then
        PYTHON_CMD="python"
    fi
fi

if [[ -z "$PYTHON_CMD" ]]; then
    echo "Python 3.8+ not found."
    echo ""
    echo "Would you like to install Python using Homebrew? (Recommended)"
    read -p "Install Homebrew and Python? (Y/n): " install_python
    
    if [[ ! "$install_python" =~ ^[Nn]$ ]]; then
        # Check for Homebrew
        if ! command -v brew &> /dev/null; then
            echo "Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            
            # Add Homebrew to PATH for this session
            if [[ -f "/opt/homebrew/bin/brew" ]]; then
                # Apple Silicon Mac
                eval "$(/opt/homebrew/bin/brew shellenv)"
            elif [[ -f "/usr/local/bin/brew" ]]; then
                # Intel Mac
                eval "$(/usr/local/bin/brew shellenv)"
            fi
        fi
        
        echo "Installing Python 3 using Homebrew..."
        brew install python3
        PYTHON_CMD="python3"
    else
        echo "Please install Python 3.8+ manually from https://www.python.org/downloads/mac-osx/"
        echo "or use Homebrew: brew install python3"
        exit 1
    fi
fi

# Verify Python version
PYTHON_VERSION=$($PYTHON_CMD -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')")
echo "✓ Python is installed (version: $PYTHON_VERSION)"

# Check for SSH
if ! command -v ssh &> /dev/null; then
    echo "ERROR: SSH is not available."
    echo "SSH should be included with macOS. Please check your system."
    exit 1
fi
echo "✓ SSH is available"

# Check network connectivity to Move
echo ""
echo "Testing connection to Move device..."
if ping -c 1 move.local &> /dev/null; then
    echo "✓ Move device is reachable at move.local"
else
    echo "WARNING: Cannot reach move.local"
    echo "Please ensure:"
    echo "- Your Move device is on and connected to the same network"
    echo "- Your Mac is on the same network"
    echo "- Bonjour/mDNS is working (usually enabled by default on macOS)"
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

# Add to keychain on macOS
echo "Adding SSH key to macOS Keychain..."
ssh-add --apple-use-keychain "$MOVE_KEY_PATH" 2>/dev/null || ssh-add -K "$MOVE_KEY_PATH" 2>/dev/null || true

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
    UseKeychain yes
    AddKeysToAgent yes
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
echo "OPTION 3 - Use Finder (macOS specific):"
echo "1. In Finder, press Cmd+K and connect to: sftp://move.local"
echo "2. Navigate to the home folder and create .ssh folder if needed"
echo "3. Copy the public key content to .ssh/authorized_keys"
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
    echo ""
    echo "See Troubleshooting-Links.md for more help."
    exit 1
fi

echo ""
echo "Step 5: Installation..."
echo "======================"

cd "$REPO_DIR/utility-scripts"

echo "Running installation script..."
if [[ -x "./setup-ssh-and-install-on-move.command" ]]; then
    echo "Using macOS-optimized installation script..."
    ./setup-ssh-and-install-on-move.command
elif [[ -x "./install-on-move.sh" ]]; then
    ./install-on-move.sh
else
    echo "ERROR: Installation scripts not found or not executable"
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
    read -p "Open in your default browser now? (Y/n): " open_browser
    if [[ ! "$open_browser" =~ ^[Nn]$ ]]; then
        open "http://move.local:$PORT"
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
    if [[ -x "./setup-autostart-on-move.command" ]]; then
        ./setup-autostart-on-move.command
        echo "✓ Auto-start configured"
    elif [[ -x "./setup-autostart-on-move.sh" ]]; then
        ./setup-autostart-on-move.sh
        echo "✓ Auto-start configured"
    else
        echo "WARNING: Auto-start scripts not found"
    fi
fi

echo ""
echo "Optional: Create Desktop Shortcut"
echo "================================="
read -p "Create a .command file on Desktop for easy access? (y/N): " create_shortcut
if [[ "$create_shortcut" =~ ^[Yy]$ ]]; then
    SHORTCUT_PATH="$HOME/Desktop/Open Extending Move.command"
    cat > "$SHORTCUT_PATH" << EOF
#!/bin/bash
open "http://move.local:$PORT"
EOF
    chmod +x "$SHORTCUT_PATH"
    echo "✓ Shortcut created: $SHORTCUT_PATH"
    echo "You can double-click this file to open extending-move in your browser."
fi

echo ""
echo "Setup complete! Enjoy extending-move!"
echo ""
echo "Useful commands:"
echo "- Open extending-move: open http://move.local:$PORT"
echo "- SSH to Move: ssh ableton@move.local" 
echo "- Update extending-move: cd $REPO_DIR && git pull"
echo ""
echo "Troubleshooting:"
echo "- Check the Step-by-Step-Guide.md for detailed instructions"
echo "- See Troubleshooting-Links.md for common issues"
echo "- Visit: https://github.com/peterswimm/extending-move"
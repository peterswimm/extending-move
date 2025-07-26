#!/bin/bash
# Linux Setup Helper for Extending Move
# This script automates the setup process for Linux distributions

set -euo pipefail

# Configuration
MOVE_ADDRESS="${1:-move.local}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${CYAN}=== Extending Move Setup Helper for Linux ===${NC}"
echo ""
echo -e "${YELLOW}This script will automate the setup process by:${NC}"
echo "1. Detecting your Linux distribution"
echo "2. Installing required dependencies (Git, SSH, Python 3, Avahi)"
echo "3. Configuring mDNS resolution for .local addresses"
echo "4. Cloning the extending-move repository"
echo "5. Running the automated installation"
echo ""
echo -e "${YELLOW}Move address: ${MOVE_ADDRESS}${NC}"
echo ""

# Function to detect Linux distribution
detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        DISTRO=$ID
        VERSION=$VERSION_ID
    elif [ -f /etc/redhat-release ]; then
        DISTRO="centos"
    elif [ -f /etc/debian_version ]; then
        DISTRO="debian"
    else
        DISTRO="unknown"
    fi
    
    echo -e "${GREEN}Detected distribution: ${DISTRO}${NC}"
}

# Function to update system packages
update_system() {
    echo -e "${YELLOW}Updating system packages...${NC}"
    
    case "$DISTRO" in
        ubuntu|debian)
            sudo apt update && sudo apt upgrade -y
            ;;
        fedora)
            sudo dnf update -y
            ;;
        centos|rhel)
            if command -v dnf >/dev/null 2>&1; then
                sudo dnf update -y
            else
                sudo yum update -y
            fi
            ;;
        arch|manjaro)
            sudo pacman -Syu --noconfirm
            ;;
        opensuse*|sles)
            sudo zypper refresh && sudo zypper update -y
            ;;
        *)
            echo -e "${YELLOW}⚠ Unknown distribution. Please update your system manually.${NC}"
            ;;
    esac
    
    echo -e "${GREEN}✓ System updated${NC}"
}

# Function to install dependencies
install_dependencies() {
    echo -e "${YELLOW}Installing dependencies...${NC}"
    
    case "$DISTRO" in
        ubuntu|debian)
            sudo apt install -y git openssh-client python3 python3-pip avahi-daemon avahi-utils
            # Enable and start avahi-daemon for mDNS
            sudo systemctl enable avahi-daemon
            sudo systemctl start avahi-daemon
            ;;
        fedora)
            sudo dnf install -y git openssh-clients python3 python3-pip avahi avahi-tools
            sudo systemctl enable avahi-daemon
            sudo systemctl start avahi-daemon
            ;;
        centos|rhel)
            if command -v dnf >/dev/null 2>&1; then
                sudo dnf install -y git openssh-clients python3 python3-pip avahi avahi-tools
            else
                sudo yum install -y git openssh-clients python3 python3-pip avahi avahi-tools
            fi
            sudo systemctl enable avahi-daemon
            sudo systemctl start avahi-daemon
            ;;
        arch|manjaro)
            sudo pacman -S --noconfirm git openssh python python-pip avahi nss-mdns
            sudo systemctl enable avahi-daemon
            sudo systemctl start avahi-daemon
            ;;
        opensuse*|sles)
            sudo zypper install -y git openssh python3 python3-pip avahi avahi-utils
            sudo systemctl enable avahi-daemon
            sudo systemctl start avahi-daemon
            ;;
        *)
            echo -e "${RED}✗ Unsupported distribution: ${DISTRO}${NC}"
            echo "Please install the following packages manually:"
            echo "- git"
            echo "- openssh-client"
            echo "- python3"
            echo "- python3-pip"
            echo "- avahi-daemon (for .local address resolution)"
            exit 1
            ;;
    esac
    
    echo -e "${GREEN}✓ Dependencies installed${NC}"
}

# Function to configure mDNS resolution
configure_mdns() {
    echo -e "${YELLOW}Configuring mDNS resolution for .local addresses...${NC}"
    
    # Check if nsswitch.conf needs to be updated
    if ! grep -q "mdns" /etc/nsswitch.conf; then
        echo "Updating /etc/nsswitch.conf to support .local addresses..."
        
        # Backup original file
        sudo cp /etc/nsswitch.conf /etc/nsswitch.conf.backup
        
        # Update hosts line to include mdns
        sudo sed -i 's/^hosts:.*/hosts:          files mdns4_minimal [NOTFOUND=return] dns/' /etc/nsswitch.conf
        
        echo -e "${GREEN}✓ mDNS resolution configured${NC}"
    else
        echo -e "${GREEN}✓ mDNS resolution already configured${NC}"
    fi
}

# Function to test Move connection
test_move_connection() {
    echo ""
    echo -e "${YELLOW}Testing connection to Move...${NC}"
    
    # Wait a moment for avahi to start up
    sleep 2
    
    if ping -c 1 "$MOVE_ADDRESS" > /dev/null 2>&1; then
        echo -e "${GREEN}✓ Successfully connected to Move at ${MOVE_ADDRESS}${NC}"
        return 0
    else
        echo -e "${YELLOW}⚠ Warning: Could not reach Move at ${MOVE_ADDRESS}${NC}"
        echo "  This might be normal if:"
        echo "  - Your Move is not connected to the network"
        echo "  - mDNS resolution needs more time to work"
        echo "  - Your firewall is blocking the connection"
        echo ""
        echo "  You can continue with setup and test the connection later"
        return 1
    fi
}

# Function to clone repository
clone_repository() {
    echo ""
    echo -e "${YELLOW}Setting up extending-move repository...${NC}"
    
    if [ -d "extending-move" ]; then
        echo "Repository already exists, updating..."
        cd extending-move
        git pull
    else
        echo "Cloning extending-move repository..."
        git clone https://github.com/peterswimm/extending-move.git
        cd extending-move
    fi
    
    echo -e "${GREEN}✓ Repository ready${NC}"
}

# Function to run the automated installation
run_installation() {
    echo ""
    echo -e "${YELLOW}Running the automated SSH setup and installation...${NC}"
    echo "This will:"
    echo "- Generate SSH keys for secure connection to your Move"
    echo "- Configure SSH settings"
    echo "- Install extending-move on your Move"
    echo ""
    
    # Check if the setup script exists
    if [ ! -f "utility-scripts/setup-ssh-and-install-on-move.sh" ]; then
        echo -e "${RED}✗ Setup script not found. Please ensure you're in the extending-move directory.${NC}"
        exit 1
    fi
    
    # Make the setup script executable and run it
    chmod +x utility-scripts/setup-ssh-and-install-on-move.sh
    ./utility-scripts/setup-ssh-and-install-on-move.sh
}

# Function to configure firewall if needed
configure_firewall() {
    echo -e "${YELLOW}Checking firewall configuration...${NC}"
    
    # Check if firewalld is running
    if systemctl is-active --quiet firewalld; then
        echo "Firewalld detected. You may need to allow SSH connections."
        echo "Run this if you have connection issues:"
        echo "  sudo firewall-cmd --permanent --add-service=ssh"
        echo "  sudo firewall-cmd --reload"
    fi
    
    # Check if ufw is running
    if command -v ufw >/dev/null 2>&1 && ufw status | grep -q "Status: active"; then
        echo "UFW firewall detected. You may need to allow SSH connections."
        echo "Run this if you have connection issues:"
        echo "  sudo ufw allow ssh"
    fi
    
    echo -e "${GREEN}✓ Firewall check complete${NC}"
}

# Main execution
main() {
    # Detect distribution
    detect_distro
    
    # Update system
    update_system
    
    # Install dependencies
    install_dependencies
    
    # Configure mDNS
    configure_mdns
    
    # Configure firewall
    configure_firewall
    
    # Test Move connection
    test_move_connection
    
    # Clone repository
    clone_repository
    
    # Run installation
    run_installation
    
    echo ""
    echo -e "${GREEN}=== Linux Setup Complete! ===${NC}"
    echo ""
    echo -e "${CYAN}Your extending-move installation should now be ready.${NC}"
    echo -e "${YELLOW}You can access the web interface by opening a browser and going to:${NC}"
    echo "  http://${MOVE_ADDRESS}:909"
    echo ""
    echo -e "${YELLOW}Useful commands:${NC}"
    echo "- Restart server: ssh ableton@${MOVE_ADDRESS} 'sudo systemctl restart extending-move'"
    echo "- Check server status: ssh ableton@${MOVE_ADDRESS} 'sudo systemctl status extending-move'"
    echo "- Upload files: scp your-file.wav ableton@${MOVE_ADDRESS}:/data/UserData/UserLibrary/Samples/"
    echo ""
    echo -e "${YELLOW}If you have connection issues:${NC}"
    echo "- Check firewall settings (see above)"
    echo "- Verify mDNS is working: avahi-resolve -n ${MOVE_ADDRESS}"
    echo "- Try using the Move's IP address instead of ${MOVE_ADDRESS}"
    echo ""
    echo -e "${CYAN}For troubleshooting, see: Setup-Folder/Linux/Troubleshooting-Links.md${NC}"
}

# Check if script is being sourced or executed
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
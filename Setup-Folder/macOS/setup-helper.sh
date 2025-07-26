#!/bin/bash
# macOS Setup Helper for Extending Move
# This script automates the setup process for macOS users

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

echo -e "${CYAN}=== Extending Move Setup Helper for macOS ===${NC}"
echo ""
echo -e "${YELLOW}This script will automate the setup process by:${NC}"
echo "1. Installing Homebrew (if not already installed)"
echo "2. Installing required dependencies (Git, Python 3)"
echo "3. Cloning the extending-move repository"
echo "4. Running the automated installation"
echo ""
echo -e "${YELLOW}Move address: ${MOVE_ADDRESS}${NC}"
echo ""

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install Homebrew
install_homebrew() {
    if command_exists brew; then
        echo -e "${GREEN}✓ Homebrew is already installed${NC}"
        return 0
    fi
    
    echo -e "${YELLOW}Installing Homebrew...${NC}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for the current session
    if [[ -f "/opt/homebrew/bin/brew" ]]; then
        # Apple Silicon
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -f "/usr/local/bin/brew" ]]; then
        # Intel
        eval "$(/usr/local/bin/brew shellenv)"
    fi
    
    echo -e "${GREEN}✓ Homebrew installed successfully${NC}"
}

# Function to install dependencies
install_dependencies() {
    echo -e "${YELLOW}Installing dependencies...${NC}"
    
    # Update Homebrew
    brew update
    
    # Install Git if not present
    if ! command_exists git; then
        echo "Installing Git..."
        brew install git
    else
        echo -e "${GREEN}✓ Git is already installed${NC}"
    fi
    
    # Install Python 3 if not present
    if ! command_exists python3; then
        echo "Installing Python 3..."
        brew install python3
    else
        echo -e "${GREEN}✓ Python 3 is already installed${NC}"
    fi
    
    # Verify SSH is available (should be pre-installed on macOS)
    if ! command_exists ssh; then
        echo -e "${RED}✗ SSH not found. Please install Xcode Command Line Tools:${NC}"
        echo "  xcode-select --install"
        exit 1
    else
        echo -e "${GREEN}✓ SSH is available${NC}"
    fi
    
    echo -e "${GREEN}✓ All dependencies installed${NC}"
}

# Function to test Move connection
test_move_connection() {
    echo ""
    echo -e "${YELLOW}Testing connection to Move...${NC}"
    
    if ping -c 1 "$MOVE_ADDRESS" > /dev/null 2>&1; then
        echo -e "${GREEN}✓ Successfully connected to Move at ${MOVE_ADDRESS}${NC}"
        return 0
    else
        echo -e "${YELLOW}⚠ Warning: Could not reach Move at ${MOVE_ADDRESS}${NC}"
        echo "  Make sure your Move is connected to the same network"
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

# Main execution
main() {
    # Install Homebrew
    install_homebrew
    
    # Install dependencies
    install_dependencies
    
    # Test Move connection
    test_move_connection
    
    # Clone repository
    clone_repository
    
    # Run installation
    run_installation
    
    echo ""
    echo -e "${GREEN}=== macOS Setup Complete! ===${NC}"
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
    echo -e "${CYAN}For troubleshooting, see: Setup-Folder/macOS/Troubleshooting-Links.md${NC}"
}

# Check if script is being sourced or executed
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
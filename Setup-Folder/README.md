# Setup Folder - Extending Move

This folder contains platform-specific setup guides and automation scripts for installing extending-move on your desktop computer.

## Quick Setup

Each platform folder contains a `simple.sh` script that automates the entire setup process:

### Windows 11
```bash
cd Setup-Folder/Windows-11/
./simple.sh
```
**Requirements:** Git Bash (included with Git for Windows)

### macOS  
```bash
cd Setup-Folder/macOS/
./simple.sh
```
**Requirements:** Terminal (built-in)

### Linux
```bash
cd Setup-Folder/Linux/
./simple.sh  
```
**Requirements:** Any terminal emulator

## What the Scripts Do

The automation scripts will:

1. **Check Prerequisites** - Verify required software is installed
2. **Install Missing Dependencies** - Use your system's package manager to install what's needed
3. **Generate SSH Keys** - Create secure keys for connecting to your Move device  
4. **Configure SSH** - Set up your SSH client for easy Move access
5. **Install SSH Key on Move** - Guide you through adding the key to your Move device
6. **Download Repository** - Clone or update the extending-move code
7. **Run Installation** - Execute the installation scripts on your Move device
8. **Verify Setup** - Test that everything is working correctly
9. **Optional Setup** - Configure auto-start and create shortcuts

## Manual Setup

If you prefer manual control or the automated scripts don't work for your system, each folder also contains:

- **Step-by-Step-Guide.md** - Detailed manual instructions
- **Troubleshooting-Links.md** - Common issues and solutions

## Platform-Specific Features

### Windows 11
- Uses Git Bash for Unix-like commands
- Supports WinSCP for GUI file transfers  
- Windows Terminal integration
- Firewall configuration guidance

### macOS
- Homebrew integration for package management
- Keychain SSH key management
- Finder SFTP integration
- .command file shortcuts
- Apple Silicon (M1/M2) support

### Linux
- Multi-distribution support (Ubuntu, Fedora, Arch, openSUSE, etc.)
- Automatic package manager detection
- Avahi/mDNS configuration
- Desktop integration (.desktop files)
- Systemd service management

## Troubleshooting

If you encounter issues:

1. Check the platform-specific **Troubleshooting-Links.md** file
2. Run the setup script again - it's designed to be re-runnable
3. Try the manual setup instructions
4. Check the main project README for additional help
5. Visit the GitHub issues page for community support

## Getting Started

1. Choose your platform folder
2. Run `./simple.sh` for automated setup
3. Or follow the Step-by-Step-Guide.md for manual setup
4. Access extending-move at `http://move.local:909` (or your chosen port)

The simple.sh scripts are designed to be user-friendly and will guide you through each step with clear prompts and feedback.
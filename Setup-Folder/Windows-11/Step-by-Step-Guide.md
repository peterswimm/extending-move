# Windows 11 Setup Guide - Extending Move

This guide will help you set up the extending-move companion webserver on your Windows 11 system to work with your Ableton Move device.

## Quick Start (Recommended)

For an automated setup experience, run the simple setup script:

1. Download this repository
2. Open **Git Bash** and navigate to `Setup-Folder/Windows-11/`
3. Run: `./simple.sh`

The script will guide you through the entire setup process automatically.

## Manual Setup Instructions

If you prefer manual setup or the automated script doesn't work for your system, follow the detailed instructions below:

## Prerequisites

Before you begin, ensure you have the following installed on your Windows 11 system:

### Required Software
1. **Git for Windows** - [Download here](https://git-scm.com/download/win)
   - This includes Git Bash, which provides SSH functionality
2. **Python 3.8 or newer** - [Download here](https://www.python.org/downloads/windows/)
   - Make sure to check "Add Python to PATH" during installation
3. **Windows Terminal** (recommended) - Available from Microsoft Store or [GitHub](https://github.com/microsoft/terminal)

### Network Requirements
- Your Move device and Windows computer must be on the same network
- The Move device must be accessible at `move.local` (check by running `ping move.local` in Command Prompt)

## Step-by-Step Installation

### Step 1: Download the Repository

1. Open **Git Bash** (search for it in Start menu after installing Git for Windows)
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

The installation process requires SSH access to your Move device. 

1. In Git Bash, navigate to the utility-scripts folder:
   ```bash
   cd utility-scripts
   ```

2. Run the SSH setup script:
   ```bash
   ./setup-ssh-and-install-on-move.sh
   ```

3. Follow the prompts to:
   - Generate an SSH key pair
   - Configure your SSH client
   - Add the public key to your Move device

**Note:** You'll need to manually add the SSH public key to your Move device. The script will provide instructions for this step.

### Step 3: Install on Move Device

After SSH is configured:

1. Run the installation script:
   ```bash
   ./install-on-move.sh
   ```

2. Choose your preferred port (default is 909)

3. The script will:
   - Transfer files to your Move device
   - Install Python dependencies
   - Set up the webserver

### Step 4: Access the Webserver

1. Once installation is complete, open your web browser
2. Navigate to: `http://move.local:909` (or your chosen port)
3. You should see the extending-move interface

### Step 5: Optional - Set Up Auto-Start

To have the webserver start automatically when your Move boots:

1. Run the auto-start setup script:
   ```bash
   ./setup-autostart-on-move.sh
   ```

## File Transfer via SCP (Alternative Method)

If you prefer to manually transfer files or need to troubleshoot:

### Using Git Bash (SCP)
```bash
# Copy a file to Move
scp -i ~/.ssh/move_key your-file.txt ableton@move.local:/home/ableton/

# Copy a directory recursively
scp -i ~/.ssh/move_key -r your-directory/ ableton@move.local:/home/ableton/
```

### Using WinSCP (GUI Option)
1. Download and install [WinSCP](https://winscp.net/eng/download.php)
2. Create a new session with:
   - File protocol: SCP
   - Host name: move.local
   - User name: ableton
   - Private key file: `%USERPROFILE%\.ssh\move_key`

## Verification

To verify everything is working:

1. SSH into your Move:
   ```bash
   ssh -i ~/.ssh/move_key ableton@move.local
   ```

2. Check if the webserver is running:
   ```bash
   ps aux | grep python
   ```

3. Test the web interface at `http://move.local:909`

## Important Notes

- **Use at your own risk**: This tool is not officially supported by Ableton
- **Backup your Move**: Consider backing up your Move device before installation
- **Recovery information**: Available on Ableton Center Code (link in main README)
- **Network connectivity**: Ensure your Move and computer are on the same network

## Next Steps

Once installed, you can:
- Upload and restore Move Sets
- Edit presets and macros
- Create chord and sliced kits
- Import MIDI files
- And much more!

See the main README for a complete feature list and documentation.
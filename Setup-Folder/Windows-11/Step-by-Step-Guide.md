# Windows 11 Setup Guide for Extending Move

This guide will walk you through setting up the Extending Move tools on Windows 11 to connect to your Ableton Move device.

## Prerequisites

Before starting, ensure you have:

1. **Windows 11** with Windows Subsystem for Linux (WSL) or native SSH client
2. **Python 3.8+** installed (available from Microsoft Store or python.org)
3. **Git** installed (download from git-scm.com)
4. **Ableton Move** connected to the same network as your computer
5. **Administrator privileges** for software installation

## Installation Options

Choose one of these options based on your preference:

### Option A: Using Windows Subsystem for Linux (WSL) - Recommended

WSL provides the most reliable experience and is closest to the native Linux environment.

#### Step 1: Install WSL
1. Open PowerShell as Administrator
2. Run: `wsl --install`
3. Restart your computer when prompted
4. Complete Ubuntu setup (create username/password)

#### Step 2: Setup in WSL
1. Open Ubuntu from Start Menu
2. Update system: `sudo apt update && sudo apt upgrade -y`
3. Install required packages:
   ```bash
   sudo apt install python3 python3-pip git openssh-client
   ```

#### Step 3: Clone and Setup
1. Clone the repository:
   ```bash
   git clone https://github.com/peterswimm/extending-move.git
   cd extending-move
   ```

2. Install Python dependencies:
   ```bash
   pip3 install -r requirements.txt
   ```

3. Run the setup script:
   ```bash
   cd utility-scripts
   chmod +x setup-ssh-and-install-on-move.sh
   ./setup-ssh-and-install-on-move.sh
   ```

### Option B: Using Windows PowerShell/Command Prompt

#### Step 1: Install OpenSSH Client
1. Open Settings → Apps → Optional Features
2. Click "Add an optional feature"
3. Find and install "OpenSSH Client"
4. Or use PowerShell: `Add-WindowsCapability -Online -Name OpenSSH.Client*`

#### Step 2: Install Python and Git
1. Download Python from python.org (ensure "Add to PATH" is checked)
2. Download Git from git-scm.com
3. Restart PowerShell/Command Prompt after installation

#### Step 3: Clone and Setup
1. Open PowerShell
2. Navigate to desired folder (e.g., `cd C:\Users\YourName\Documents`)
3. Clone repository:
   ```powershell
   git clone https://github.com/peterswimm/extending-move.git
   cd extending-move
   ```

4. Install Python dependencies:
   ```powershell
   pip install -r requirements.txt
   ```

#### Step 4: SSH Key Setup (Manual)
Since the automated script is designed for Unix-like systems, you'll need to set up SSH manually:

1. Generate SSH key:
   ```powershell
   ssh-keygen -t ed25519 -f "$env:USERPROFILE\.ssh\move_key" -C "move_key_for_ableton_move"
   ```

2. Create SSH config file at `%USERPROFILE%\.ssh\config`:
   ```
   Host move.local
       HostName move.local
       User ableton
       IdentityFile ~/.ssh/move_key
       StrictHostKeyChecking no
   ```

3. Copy public key to Move device:
   ```powershell
   Get-Content "$env:USERPROFILE\.ssh\move_key.pub" | ssh ableton@move.local "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
   ```

## Connecting to Your Move

### Test SSH Connection
1. Test connection:
   ```bash
   # WSL or PowerShell
   ssh ableton@move.local
   ```

2. You should connect without password prompt
3. Type `exit` to disconnect

### Transfer Files
Use SCP to transfer the project files:

```bash
# From the extending-move directory
scp -r . ableton@move.local:~/extending-move/
```

### Run Installation on Move
1. SSH into your Move:
   ```bash
   ssh ableton@move.local
   ```

2. Navigate to the project:
   ```bash
   cd extending-move/utility-scripts
   ```

3. Run the installation:
   ```bash
   chmod +x install-on-move.sh
   ./install-on-move.sh
   ```

4. Follow the prompts to select your preferred port (909 recommended)

## Access the Web Interface

1. Open your web browser
2. Navigate to `http://move.local:909` (or your chosen port)
3. You should see the Extending Move interface

## Windows-Specific Notes

- **File Paths**: Use forward slashes `/` in WSL, backslashes `\` in native Windows
- **Line Endings**: Git should handle this automatically, but if you encounter issues, run `git config core.autocrlf true`
- **Antivirus**: Some antivirus software may flag SSH connections; add exceptions if needed
- **Firewall**: Windows Firewall should allow outbound SSH connections by default
- **Network**: Ensure both your computer and Move are on the same network/subnet

## Troubleshooting

If you encounter issues:

1. **SSH Connection Issues**: Check [Troubleshooting-Links.md](./Troubleshooting-Links.md)
2. **Python Issues**: Ensure Python is in your PATH and version is 3.8+
3. **Permission Issues**: Run PowerShell as Administrator when needed
4. **WSL Issues**: Try `wsl --update` or reinstall WSL

## Next Steps

Once installation is complete:
- Explore the web interface at `move.local:909`
- Check out the [main README](../../README.md) for feature documentation
- Join the [Discord community](https://discord.gg/yP7SjqDrZG) for support

---

⚠️ **Warning**: This tool requires SSH access to your Move device and is not officially supported by Ableton. Use at your own risk. Always refer to the official recovery documentation if issues arise.
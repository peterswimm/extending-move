# macOS Setup Guide for Extending Move

This guide will walk you through setting up the Extending Move tools on macOS to connect to your Ableton Move device.

## Prerequisites

Before starting, ensure you have:

1. **macOS 10.15** (Catalina) or later
2. **Python 3.8+** (pre-installed on recent macOS versions)
3. **Xcode Command Line Tools** or Xcode installed
4. **Ableton Move** connected to the same network as your Mac
5. **Administrator privileges** for software installation

## Quick Setup (Recommended)

The easiest way to set up Extending Move on macOS is using the provided automated script:

### Step 1: Download and Prepare
1. **Download** or **clone** the repository:
   ```bash
   git clone https://github.com/peterswimm/extending-move.git
   ```
   Or download the ZIP file from GitHub and extract it.

2. **Open Terminal** (Applications → Utilities → Terminal)

3. **Navigate to the project directory**:
   ```bash
   cd path/to/extending-move
   ```

### Step 2: Run Automated Setup
1. **Make the script executable**:
   ```bash
   chmod +x utility-scripts/setup-ssh-and-install-on-move.command
   ```

2. **Double-click** the `setup-ssh-and-install-on-move.command` file in Finder
   
   OR
   
   **Run from Terminal**:
   ```bash
   cd utility-scripts
   ./setup-ssh-and-install-on-move.command
   ```

3. **Follow the prompts**:
   - The script will generate SSH keys
   - Configure SSH for your Move device
   - Install the Extending Move server on your Move
   - Set up auto-start functionality

### Step 3: Complete Setup
1. **Choose your port** when prompted (909 is recommended)
2. **Wait for installation** to complete
3. **Test the connection** by opening `http://move.local:909` in your browser

## Manual Setup (Alternative)

If you prefer to set up manually or encounter issues with the automated script:

### Step 1: Install Prerequisites
1. **Install Xcode Command Line Tools**:
   ```bash
   xcode-select --install
   ```

2. **Verify Python installation**:
   ```bash
   python3 --version
   ```
   If Python 3.8+ is not available, install from [python.org](https://www.python.org/downloads/)

3. **Install pip if needed**:
   ```bash
   python3 -m ensurepip --upgrade
   ```

### Step 2: Prepare the Project
1. **Clone repository** (if not already done):
   ```bash
   git clone https://github.com/peterswimm/extending-move.git
   cd extending-move
   ```

2. **Install Python dependencies**:
   ```bash
   pip3 install -r requirements.txt
   ```

### Step 3: SSH Key Setup
1. **Generate SSH key** for your Move:
   ```bash
   ssh-keygen -t ed25519 -f ~/.ssh/move_key -N "" -C "move_key_for_ableton_move"
   ```

2. **Add SSH key to ssh-agent**:
   ```bash
   eval "$(ssh-agent -s)"
   ssh-add ~/.ssh/move_key
   ```

3. **Configure SSH** by adding to `~/.ssh/config`:
   ```
   Host move.local
       HostName move.local
       User ableton
       IdentityFile ~/.ssh/move_key
       StrictHostKeyChecking no
       AddKeysToAgent yes
   ```

### Step 4: Connect to Move
1. **Copy SSH key to Move** (you'll be prompted for password):
   ```bash
   ssh-copy-id -i ~/.ssh/move_key.pub ableton@move.local
   ```

2. **Test SSH connection**:
   ```bash
   ssh ableton@move.local
   ```
   You should connect without being prompted for a password.

3. **Exit the SSH session**:
   ```bash
   exit
   ```

### Step 5: Install on Move
1. **Transfer files to Move**:
   ```bash
   scp -r . ableton@move.local:~/extending-move/
   ```

2. **Connect to Move and install**:
   ```bash
   ssh ableton@move.local
   cd extending-move/utility-scripts
   chmod +x install-on-move.sh
   ./install-on-move.sh
   ```

3. **Follow installation prompts** and select your preferred port

## macOS-Specific Features

### Using .command Files
The project includes `.command` files that can be double-clicked in Finder:

- `setup-ssh-and-install-on-move.command` - Complete setup process
- `install-on-move.command` - Install only (if SSH is already configured)
- `update-on-move.command` - Update existing installation
- `setup-autostart-on-move.command` - Configure auto-start

### Terminal Tips
- **Open Terminal**: `Cmd + Space`, type "Terminal", press Enter
- **Navigate in Terminal**: Use `cd` to change directories, `ls` to list files
- **Copy/Paste**: `Cmd + C` and `Cmd + V` work in Terminal
- **Tab Completion**: Press Tab to autocomplete file/directory names

### Security Considerations
- **Gatekeeper**: You may need to allow the scripts to run in System Preferences → Security & Privacy
- **SSH Keys**: Keys are stored securely in `~/.ssh/` with appropriate permissions
- **Network**: Ensure your Mac and Move are on the same trusted network

## Verification

### Test Your Setup
1. **Open your web browser**
2. **Navigate to** `http://move.local:909` (or your chosen port)
3. **Verify** you can see the Extending Move web interface
4. **Test a feature** like "Refresh Library" to ensure everything works

### Check SSH Connection
```bash
ssh ableton@move.local 'echo "SSH connection successful"'
```
This should print "SSH connection successful" without prompting for a password.

## macOS Version-Specific Notes

### macOS Monterey (12.x) and Later
- SSH client is included by default
- Python 3 is pre-installed
- May require allowing Terminal full disk access for some operations

### macOS Big Sur (11.x)
- SSH client is included
- Python 3 is available, may need to install via Xcode tools
- Security prompts may appear for network access

### macOS Catalina (10.15)
- Minimum supported version
- May need to manually install Python 3
- Additional security prompts for downloaded files

## Troubleshooting Quick Fixes

### Permission Denied Errors
```bash
chmod +x utility-scripts/*.command
chmod +x utility-scripts/*.sh
```

### Python Module Not Found
```bash
python3 -m pip install --upgrade pip
pip3 install -r requirements.txt --user
```

### SSH Connection Issues
```bash
ssh-keygen -R move.local  # Remove old host key
ssh ableton@move.local    # Test connection
```

### Network Issues
1. Check WiFi connection
2. Verify Move is on same network: `ping move.local`
3. Try using Move's IP address instead of `move.local`

## Next Steps

Once installation is complete:
- **Explore features** through the web interface
- **Read the [main documentation](../../README.md)** for detailed feature guides
- **Join the community** on [Discord](https://discord.gg/yP7SjqDrZG)
- **Check out examples** in the `examples/` directory

## Additional Resources

- **Troubleshooting**: See [Troubleshooting-Links.md](./Troubleshooting-Links.md) for detailed help
- **Video Guide**: [Quick installation video](https://youtu.be/gPiR7Zyu3lc)
- **Community**: [Discord server](https://discord.gg/yP7SjqDrZG) for support and discussion

---

⚠️ **Important**: This tool provides SSH access to your Move device and is not officially supported by Ableton. Use at your own risk and refer to official recovery documentation if needed.
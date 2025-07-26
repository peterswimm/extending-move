# macOS Setup Guide - Extending Move

This guide will help you set up the extending-move companion webserver on your macOS system to work with your Ableton Move device.

## Prerequisites

Before you begin, ensure you have the following installed on your macOS system:

### Required Software
1. **Xcode Command Line Tools** - Run in Terminal:
   ```bash
   xcode-select --install
   ```
2. **Git** - Usually included with Xcode Command Line Tools, verify with:
   ```bash
   git --version
   ```
3. **Python 3.8 or newer** - Check if already installed:
   ```bash
   python3 --version
   ```
   If not installed, download from [python.org](https://www.python.org/downloads/mac-osx/) or use Homebrew:
   ```bash
   brew install python3
   ```

### Optional but Recommended
- **Homebrew** - Package manager for macOS: [brew.sh](https://brew.sh)
- **iTerm2** - Enhanced terminal: [iterm2.com](https://iterm2.com)

### Network Requirements
- Your Move device and Mac must be on the same network
- The Move device must be accessible at `move.local` (test with `ping move.local`)

## Step-by-Step Installation

### Step 1: Download the Repository

1. Open **Terminal** (found in Applications > Utilities)
2. Navigate to where you want to download the project:
   ```bash
   cd ~/Documents
   ```
3. Clone the repository:
   ```bash
   git clone https://github.com/peterswimm/extending-move.git
   cd extending-move
   ```

### Step 2: Run the Automated Setup (Recommended)

The project includes a convenient setup script for macOS:

1. Navigate to the utility-scripts folder:
   ```bash
   cd utility-scripts
   ```

2. Make the setup script executable and run it:
   ```bash
   chmod +x setup-ssh-and-install-on-move.command
   ./setup-ssh-and-install-on-move.command
   ```

   **Alternatively**, you can double-click the `.command` file in Finder.

3. The script will guide you through:
   - Generating an SSH key pair
   - Configuring your SSH client
   - Adding the public key to your Move device
   - Installing the webserver on your Move
   - Setting up auto-start (optional)

### Step 3: Manual Setup (Alternative)

If you prefer manual control over each step:

#### Generate SSH Key
```bash
ssh-keygen -t ed25519 -f ~/.ssh/move_key -N "" -C "move_key_for_ableton_move"
```

#### Configure SSH
Add to `~/.ssh/config`:
```
Host move.local
    HostName move.local
    User ableton
    IdentityFile ~/.ssh/move_key
    IdentitiesOnly yes
```

#### Add SSH key to Move
1. Display your public key:
   ```bash
   cat ~/.ssh/move_key.pub
   ```
2. Copy the output and add it to `/home/ableton/.ssh/authorized_keys` on your Move device

#### Install on Move
```bash
./install-on-move.sh
```

### Step 4: Access the Webserver

1. Once installation is complete, open your web browser
2. Navigate to: `http://move.local:909` (or your chosen port)
3. You should see the extending-move interface

### Step 5: Optional - Set Up Auto-Start

To have the webserver start automatically when your Move boots:

```bash
./setup-autostart-on-move.sh
```

## File Transfer via SCP

macOS has excellent built-in SCP support:

### Basic SCP Commands
```bash
# Copy a file to Move
scp -i ~/.ssh/move_key your-file.txt ableton@move.local:/home/ableton/

# Copy a directory recursively
scp -i ~/.ssh/move_key -r your-directory/ ableton@move.local:/home/ableton/

# Copy from Move to your Mac
scp -i ~/.ssh/move_key ableton@move.local:/home/ableton/remote-file.txt ~/Downloads/
```

### Using rsync (More Powerful)
```bash
# Sync a directory with progress
rsync -avz --progress -e "ssh -i ~/.ssh/move_key" your-directory/ ableton@move.local:/home/ableton/

# Exclude certain files
rsync -avz --exclude="*.tmp" -e "ssh -i ~/.ssh/move_key" your-directory/ ableton@move.local:/home/ableton/
```

## Verification

To verify everything is working:

1. SSH into your Move:
   ```bash
   ssh ableton@move.local
   ```

2. Check if the webserver is running:
   ```bash
   ps aux | grep python
   ```

3. Test the web interface at `http://move.local:909`

4. Check the logs if needed:
   ```bash
   ssh ableton@move.local "journalctl -u extending-move -f"
   ```

## macOS-Specific Features

### Using Shortcuts App
You can create macOS Shortcuts for common tasks:
1. Open **Shortcuts** app
2. Create new shortcut with "Run Shell Script" action
3. Add your SSH commands for quick access

### Finder Integration
Add the Move as a network location:
1. **Finder** > **Go** > **Connect to Server**
2. Enter: `sftp://ableton@move.local`
3. Use your SSH key for authentication

### SSH Key Management with Keychain
Add your SSH key to the SSH agent:
```bash
ssh-add --apple-use-keychain ~/.ssh/move_key
```

This stores the key in your keychain for automatic authentication.

## Advanced Configuration

### Custom SSH Config
For multiple Move devices or advanced setups, customize `~/.ssh/config`:

```
Host move1
    HostName move.local
    User ableton
    IdentityFile ~/.ssh/move_key
    Port 22

Host move2
    HostName 192.168.1.100
    User ableton
    IdentityFile ~/.ssh/move_key_2
    Port 22
```

### Environment Variables
Add to your shell profile (`~/.zshrc` or `~/.bash_profile`):
```bash
export MOVE_HOST="move.local"
export MOVE_USER="ableton"
export MOVE_KEY="$HOME/.ssh/move_key"

# Convenience alias
alias move-ssh="ssh -i $MOVE_KEY $MOVE_USER@$MOVE_HOST"
alias move-scp="scp -i $MOVE_KEY"
```

## Important Notes

- **Use at your own risk**: This tool is not officially supported by Ableton
- **Backup your Move**: Consider backing up your Move device before installation
- **Recovery information**: Available on Ableton Center Code (link in main README)
- **macOS Security**: You may need to allow the terminal app in Security & Privacy settings
- **Gatekeeper**: The first time running .command files, you may need to right-click and select "Open"

## Next Steps

Once installed, you can:
- Upload and restore Move Sets
- Edit presets and macros
- Create chord and sliced kits
- Import MIDI files
- Inspect and modify drum racks
- And much more!

See the main README for a complete feature list and documentation.

## macOS Version Compatibility

This guide is tested on:
- macOS Monterey (12.0+)
- macOS Ventura (13.0+)
- macOS Sonoma (14.0+)
- macOS Sequoia (15.0+)

Older versions may work but are not actively tested.
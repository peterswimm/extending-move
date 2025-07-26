# macOS Setup Guide for Extending Move

This guide will walk you through setting up the Extending Move tools on macOS.

## Prerequisites

Before starting, ensure you have the following installed:

### 1. Install Homebrew (Recommended)
Homebrew makes it easy to install required tools on macOS:

1. Open Terminal
2. Install Homebrew:
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```
3. Follow the installation prompts

### 2. Install Git
If not already installed:
```bash
brew install git
```

Or use Xcode Command Line Tools:
```bash
xcode-select --install
```

### 3. Install Python 3
```bash
brew install python3
```

### 4. Verify SSH is Available
SSH is pre-installed on macOS. Verify it's working:
```bash
ssh -V
```

## Setup Process

### Step 1: Clone the Repository
```bash
git clone https://github.com/peterswimm/extending-move.git
cd extending-move
```

### Step 2: Ensure Your Move is Connected
1. Connect your Ableton Move to the same network as your Mac
2. Verify you can reach it by opening a web browser and going to `http://move.local`
3. The Move should appear on your network automatically due to Bonjour

### Step 3: Run the Setup Script
The project includes an automated setup script optimized for macOS:

```bash
cd utility-scripts
./setup-ssh-and-install-on-move.command
```

Alternatively, you can run the shell script directly:
```bash
./setup-ssh-and-install-on-move.sh
```

### Step 4: Follow the Interactive Setup
The script will guide you through:
1. **SSH Key Generation**: Creates a dedicated SSH key for your Move at `~/.ssh/move_key`
2. **SSH Configuration**: Updates `~/.ssh/config` with Move-specific settings
3. **Key Exchange**: Helps you add the public key to your Move
4. **Installation**: Installs the extending-move webserver on your Move
5. **Autostart Configuration**: Sets up the server to start automatically

### Step 5: Manual Key Addition (When Prompted)
The script will guide you through adding your public key to the Move:
1. The script will display your public key
2. You'll need to SSH into the Move and add it to the authorized_keys file
3. Follow the on-screen instructions carefully

### Step 6: Access the Webserver
Once setup is complete:
1. Open your web browser
2. Navigate to `http://move.local:909` (or the port you selected)
3. You should see the Extending Move interface

## File Transfer Using SCP

After setup, you can transfer files to your Move using SCP:

### Transfer a file to the Move:
```bash
scp /path/to/local/file.wav ableton@move.local:/data/UserData/UserLibrary/Samples/
```

### Transfer from the Move to your computer:
```bash
scp ableton@move.local:/data/UserData/UserLibrary/Samples/file.wav ~/Desktop/
```

### Transfer entire directories:
```bash
scp -r /path/to/local/directory ableton@move.local:/data/UserData/UserLibrary/
```

### Using Drag and Drop with SCP
You can create a simple script for easier file transfers:

```bash
#!/bin/bash
# Save as ~/bin/move-upload.sh and make executable
for file in "$@"; do
    scp "$file" ableton@move.local:/data/UserData/UserLibrary/Samples/
done
```

Then drag files onto the script in Finder to upload them.

## Manual SSH Configuration (Alternative)

If you prefer to set up SSH manually:

### 1. Generate SSH Key
```bash
ssh-keygen -t ed25519 -f ~/.ssh/move_key -N "" -C "move_key_for_ableton_move"
```

### 2. Configure SSH
Add to `~/.ssh/config`:
```
Host move.local
    HostName move.local
    User ableton
    IdentityFile ~/.ssh/move_key
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null
    AddKeysToAgent yes
```

### 3. Add Key to SSH Agent
```bash
ssh-add ~/.ssh/move_key
```

### 4. Copy Public Key to Move
Display your public key:
```bash
cat ~/.ssh/move_key.pub
```

Then add it to the Move's authorized_keys file (follow the setup script's guidance).

## Using Built-in Commands (macOS Specific)

### Using .command Files
The project includes `.command` files optimized for macOS:
- `install-on-move.command`: Direct installation
- `setup-ssh-and-install-on-move.command`: Complete setup
- `setup-autostart-on-move.command`: Autostart configuration
- `update-on-move.command`: Update existing installation

Double-click these files in Finder to run them, or execute from Terminal.

## Verification

Test your setup:
```bash
ssh ableton@move.local "ls -la"
```

If successful, you should see a directory listing from your Move.

## macOS-Specific Features

### Keychain Integration
Your SSH key can be stored in the macOS Keychain for automatic loading:
```bash
ssh-add --apple-use-keychain ~/.ssh/move_key
```

### Finder Integration
You can set up Finder sidebar shortcuts to your Move for easy file browsing using tools like SSHFS:
```bash
brew install macfuse
brew install gromgit/fuse/sshfs-mac
```

### Shortcut Automation
Create macOS Shortcuts for common tasks:
1. Open Shortcuts app
2. Create shortcuts for file uploads, server restarts, etc.
3. Use SSH commands within shortcuts

## Troubleshooting

If you encounter issues, check the [Troubleshooting Links](Troubleshooting-Links.md) for common problems and solutions specific to macOS.

## Next Steps

Once setup is complete, you can:
- Upload MIDI files and create new sets
- Edit presets and parameters
- Create drum kits from WAV files
- Slice audio samples
- Restore Move sets

Visit `http://move.local:909` to explore all available features!

## Tips for macOS Users

1. **Use Terminal profiles**: Create a dedicated Terminal profile for Move work
2. **Set up aliases**: Add helpful aliases to your shell profile:
   ```bash
   alias move-ssh="ssh ableton@move.local"
   alias move-upload="scp -r"
   ```
3. **Use Quick Actions**: Create Finder Quick Actions for uploading files to Move
4. **Monitor connections**: Use Activity Monitor to check network connections to your Move
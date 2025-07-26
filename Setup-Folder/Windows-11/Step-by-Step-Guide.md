# Windows 11 Setup Guide for Extending Move

This guide will walk you through setting up the Extending Move tools on Windows 11.

## Prerequisites

Before starting, ensure you have the following installed:

### 1. Install Windows Subsystem for Linux (WSL)
The easiest way to work with Extending Move on Windows is through WSL:

1. Open PowerShell as Administrator
2. Run: `wsl --install`
3. Restart your computer when prompted
4. Open the new Ubuntu terminal and create a user account

### 2. Install Git (in WSL)
```bash
sudo apt update
sudo apt install git
```

### 3. Install SSH Client (in WSL)
SSH is typically pre-installed in WSL, but you can ensure it's available:
```bash
sudo apt install openssh-client
```

### 4. Install Python and pip (in WSL)
```bash
sudo apt install python3 python3-pip
```

## Setup Process

### Step 1: Clone the Repository
```bash
git clone https://github.com/peterswimm/extending-move.git
cd extending-move
```

### Step 2: Ensure Your Move is Connected
1. Connect your Ableton Move to the same network as your computer
2. Verify you can reach it by opening a web browser and going to `http://move.local`
3. If that doesn't work, try finding the Move's IP address on your network

### Step 3: Run the Setup Script
The project includes an automated setup script that will:
- Generate SSH keys
- Configure SSH for the Move
- Install the webserver on your Move
- Set up autostart

```bash
cd utility-scripts
./setup-ssh-and-install-on-move.sh
```

### Step 4: Follow the Interactive Setup
The script will guide you through:
1. **SSH Key Generation**: Creates a dedicated SSH key for your Move
2. **Key Exchange**: Helps you add the public key to your Move
3. **Installation**: Installs the extending-move webserver on your Move
4. **Autostart Configuration**: Sets up the server to start automatically

### Step 5: Access the Webserver
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
scp ableton@move.local:/data/UserData/UserLibrary/Samples/file.wav /path/to/local/destination/
```

### Transfer entire directories:
```bash
scp -r /path/to/local/directory ableton@move.local:/data/UserData/UserLibrary/
```

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
```

### 3. Copy Public Key to Move
You'll need to manually add the public key to the Move. Follow the interactive setup script for guidance on this step.

## Verification

Test your setup:
```bash
ssh ableton@move.local "ls -la"
```

If successful, you should see a directory listing from your Move.

## Troubleshooting

If you encounter issues, check the [Troubleshooting Links](Troubleshooting-Links.md) for common problems and solutions.

## Next Steps

Once setup is complete, you can:
- Upload MIDI files and create new sets
- Edit presets and parameters
- Create drum kits from WAV files
- Slice audio samples
- Restore Move sets

Visit `http://move.local:909` to explore all available features!
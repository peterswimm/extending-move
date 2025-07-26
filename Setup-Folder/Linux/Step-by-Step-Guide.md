# Step-by-Step Setup Guide for Linux

This guide will help you set up SSH access to your Ableton Move and transfer files. No technical experience required!

## What You'll Need

- A Linux computer (Ubuntu, Fedora, Debian, etc.)
- Your Ableton Move connected to the same Wi-Fi network
- The extending-move project files (already downloaded if you're reading this!)

## Step 1: Open Terminal

The method depends on your Linux distribution:

- **Ubuntu/Debian**: Press `Ctrl + Alt + T` or search for "Terminal" in applications
- **Fedora**: Press `Ctrl + Alt + T` or find "Terminal" in activities
- **Other distros**: Look for "Terminal" or "Console" in your applications menu

## Step 2: Install SSH (if not already installed)

Most Linux distributions include SSH, but just in case:

**Ubuntu/Debian:**
```
sudo apt update && sudo apt install openssh-client
```

**Fedora:**
```
sudo dnf install openssh-clients
```

**Arch Linux:**
```
sudo pacman -S openssh
```

## Step 3: Generate SSH Key

In Terminal, type these commands one at a time and press Enter after each:

1. Create a folder for SSH keys:
   ```
   mkdir -p ~/.ssh
   ```
   ✅ **What this does**: Creates a hidden folder called `.ssh` in your home directory

2. Set proper permissions (important for security):
   ```
   chmod 700 ~/.ssh
   ```
   ✅ **What this does**: Makes sure only you can access your SSH folder

3. Generate your SSH key:
   ```
   ssh-keygen -t ed25519 -f ~/.ssh/move_key -N ""
   ```
   ⚠️ **Important**: Those are two quote marks at the end (""), not one
   
   ✅ **What this creates**: Two files - `move_key` (your private key - keep this secret!) and `move_key.pub` (your public key - safe to share)

## Step 4: View Your Public Key

Type this command to see your public key:
```
cat ~/.ssh/move_key.pub
```

Copy the entire output (it starts with `ssh-ed25519`). You'll need this in the next step.

## Step 5: Add Your Key to the Move

1. Open your web browser (Firefox, Chrome, Chromium - any will work)
2. Type this address: `http://move.local/development/ssh`
   
   ⚠️ **Can't find move.local?** Try the troubleshooting section for finding your Move's IP address
   
3. Paste your public key (the long text from Step 4) into the text box
   
   ✅ **Double-check**: Your key should start with `ssh-ed25519` and be one long line
   
4. Click "Save" to store your key on the Move

## Step 6: Test SSH Connection

Back in Terminal, test the connection:
```
ssh -i ~/.ssh/move_key ableton@move.local
```

If this is your first time connecting, type `yes` when asked about the host fingerprint.

You should see a welcome message from your Move. Type `exit` to disconnect.

## Step 7: Transfer Files to Your Move

To copy the extending-move project to your Move:

1. In Terminal, navigate to where you downloaded extending-move:
   ```
   cd /path/to/your/extending-move/folder
   ```
   
   **Tip**: You can often drag the folder from your file manager into the terminal to get the path!

2. Copy all files to your Move:
   ```
   scp -i ~/.ssh/move_key -r . ableton@move.local:/data/UserData/extending-move/
   ```

## Step 8: Start the Web Server

Connect to your Move and start the server:

1. Connect via SSH:
   ```
   ssh -i ~/.ssh/move_key ableton@move.local
   ```

2. Navigate to the project folder:
   ```
   cd /data/UserData/extending-move
   ```

3. Start the web server:
   ```
   python3 move-webserver.py
   ```

4. Open your browser and go to: `http://move.local:909`

## Alternative: Using Package Managers

If you're comfortable with package managers, you might prefer:

**Using Git to download:**
```
git clone https://github.com/peterswimm/extending-move.git
cd extending-move
```

**Using rsync instead of scp (often faster):**
```
rsync -avz -e "ssh -i ~/.ssh/move_key" . ableton@move.local:/data/UserData/extending-move/
```

## Quick Tips

- **Terminal keyboard shortcuts**: `Ctrl+C` stops running commands, `Ctrl+L` clears the screen
- **Can't find move.local?** Try `ping move.local` to test network connectivity
- **Permission denied?** Make sure your SSH key has correct permissions: `chmod 600 ~/.ssh/move_key`
- **File manager integration**: Most Linux file managers let you press `F4` or `Ctrl+Alt+T` to open terminal in current folder
- **Tab completion**: Press `Tab` to auto-complete file and folder names
- **Command history**: Use arrow keys ↑↓ to navigate through previous commands

## Troubleshooting Network Issues

If `move.local` doesn't work, try finding your Move's IP address:

1. Check your router's admin page for connected devices
2. Try: `nmap -sn 192.168.1.0/24` (adjust IP range for your network)
3. Look for a device named "Move" or with Ableton in the manufacturer

Then use the IP address instead of `move.local` in all commands.

You're all set! Your Move now has the extending-move tools installed and ready to use.
# Step-by-Step Setup Guide for macOS

This guide will help you set up SSH access to your Ableton Move and transfer files. No technical experience required!

## What You'll Need

- A Mac computer (any version of macOS)
- Your Ableton Move connected to the same Wi-Fi network
- The extending-move project files (already downloaded if you're reading this!)

## Step 1: Open Terminal

1. Press `Command (⌘) + Space` to open Spotlight search
2. Type `Terminal` and press Enter
3. A window with a black or white background will open - this is Terminal

## Step 2: Generate SSH Key

In Terminal, type these commands one at a time and press Enter after each:

1. Create a folder for SSH keys:
   ```
   mkdir -p ~/.ssh
   ```
   ✅ **What this does**: Creates a hidden folder called `.ssh` in your home directory

2. Generate your SSH key:
   ```
   ssh-keygen -t ed25519 -f ~/.ssh/move_key -N ""
   ```
   ⚠️ **Important**: Those are two quote marks at the end (""), not one
   
   ✅ **What this creates**: Two files - `move_key` (your private key - keep this secret!) and `move_key.pub` (your public key - safe to share)

## Step 3: View Your Public Key

Type this command to see your public key:
```
cat ~/.ssh/move_key.pub
```

Copy the entire output (it starts with `ssh-ed25519`). You'll need this in the next step.

## Step 4: Add Your Key to the Move

1. Open your web browser (Safari, Chrome, Firefox - any will work)
2. Type this address: `http://move.local/development/ssh`
   
   ⚠️ **Can't find move.local?** Make sure your Move and Mac are on the same Wi-Fi network
   
3. Paste your public key (the long text from Step 3) into the text box
   
   ✅ **Double-check**: Your key should start with `ssh-ed25519` and be one long line
   
4. Click "Save" to store your key on the Move

## Step 5: Test SSH Connection

Back in Terminal, test the connection:
```
ssh -i ~/.ssh/move_key ableton@move.local
```

If this is your first time connecting, type `yes` when asked about the host fingerprint.

You should see a welcome message from your Move. Type `exit` to disconnect.

## Step 6: Transfer Files to Your Move

To copy the extending-move project to your Move:

1. In Terminal, navigate to where you downloaded extending-move:
   ```
   cd /path/to/your/extending-move/folder
   ```
   
   **Tip**: You can drag the folder from Finder into Terminal to automatically type the path!

2. Copy all files to your Move:
   ```
   scp -i ~/.ssh/move_key -r . ableton@move.local:/data/UserData/extending-move/
   ```

## Step 7: Start the Web Server

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

## Alternative: Using the Automated Script

If you prefer, you can use the included automated script:

1. In Terminal, navigate to the extending-move folder
2. Go to the utility-scripts folder:
   ```
   cd utility-scripts
   ```
3. Run the setup script:
   ```
   ./setup-ssh-and-install-on-move.command
   ```

This script will guide you through the entire process automatically.

## Quick Tips

- **Terminal feels scary?** Don't worry! Just type the commands exactly as shown
- **Can't find move.local?** Make sure your Move is on the same Wi-Fi network as your Mac
- **SSH key issues?** Make sure you copied the entire public key, including `ssh-ed25519` at the beginning
- **Dragging folders:** You can drag files and folders from Finder into Terminal to automatically type their paths
- **Command not found?** Make sure you're typing the commands exactly as shown, including the dots and dashes

You're all set! Your Move now has the extending-move tools installed and ready to use.
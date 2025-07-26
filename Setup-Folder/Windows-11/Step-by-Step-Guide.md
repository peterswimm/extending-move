# Windows 11 Setup Guide for Extending Move

This guide will help you set up the Extending Move tools on your Ableton Move device using Windows 11. No previous SSH or terminal experience is required - we'll walk you through every step!

## Important Safety Notice

⚠️ **Before You Begin**: 
- This process involves accessing your Move device in ways it wasn't originally designed for
- While the risk is low, there's a small chance something could go wrong
- You are proceeding at your own risk
- Ableton cannot provide support if issues occur
- Recovery information is available on Center Code (linked in the main README)

## What You'll Need

- Windows 11 computer
- Ableton Move device connected to the same Wi-Fi network
- About 30 minutes of time

## Overview

We'll complete these main steps:
1. Enable Windows Subsystem for Linux (WSL)
2. Set up SSH access to your Move device
3. Install the Extending Move tools
4. Access your new tools through a web browser

---

## Step 1: Enable Windows Subsystem for Linux (WSL)

WSL lets us use Linux commands on Windows, which we need to communicate with your Move device.

### 1.1 Open PowerShell as Administrator
1. Press `Windows key + X`
2. Click "Windows PowerShell (Admin)" or "Terminal (Admin)"
3. If prompted by User Account Control, click "Yes"

### 1.2 Install WSL
1. In the PowerShell window, type this command and press Enter:
   ```
   wsl --install
   ```
2. Wait for the installation to complete (this may take several minutes)
3. When prompted, restart your computer
4. After restart, WSL will continue setting up automatically

### 1.3 Complete WSL Setup
1. When prompted, create a username for your Linux environment (use lowercase letters only)
2. Create a password (you won't see the characters as you type - this is normal)
3. Re-enter your password to confirm

---

## Step 2: Download and Prepare the Extending Move Files

### 2.1 Download the Project
1. Open your web browser and go to: https://github.com/peterswimm/extending-move
2. Click the green "Code" button
3. Click "Download ZIP"
4. Save the file to your Downloads folder
5. Right-click the downloaded ZIP file and select "Extract All"
6. Choose a location like your Desktop and click "Extract"

### 2.2 Open WSL Terminal
1. Press `Windows key + R`
2. Type `wsl` and press Enter
3. A terminal window will open with a Linux command prompt

---

## Step 3: Prepare Your Move Device

### 3.1 Enable SSH on Your Move
1. On your Move device, go to Settings
2. Navigate to System → SSH
3. Enable SSH access
4. Note the IP address shown (you'll need this if move.local doesn't work)

### 3.2 Make Sure Your Move is Connected
1. Your Move and computer must be on the same Wi-Fi network
2. Test the connection by typing this in your WSL terminal:
   ```
   ping move.local
   ```
3. If you see responses like "64 bytes from...", your connection is working
4. Press `Ctrl + C` to stop the ping test

---

## Step 4: Set Up SSH Access

### 4.1 Navigate to the Project Files
In your WSL terminal, navigate to where you extracted the files. If you extracted to your Desktop:
```
cd /mnt/c/Users/YourUsername/Desktop/extending-move-main
```
Replace "YourUsername" with your actual Windows username.

### 4.2 Generate SSH Key
1. Create an SSH key that will let you securely connect to your Move:
   ```
   ssh-keygen -t ed25519 -f ~/.ssh/move_key -N ""
   ```
2. This creates two files: a private key (move_key) and public key (move_key.pub)

### 4.3 Configure SSH
1. Create or edit the SSH configuration file:
   ```
   mkdir -p ~/.ssh
   nano ~/.ssh/config
   ```
2. Add these lines to the file:
   ```
   Host move.local
     AddKeysToAgent yes
     IdentityFile ~/.ssh/move_key
     HostName move.local
   ```
3. Save and exit: Press `Ctrl + X`, then `Y`, then `Enter`

### 4.4 Add Your Public Key to the Move
1. Display your public key:
   ```
   cat ~/.ssh/move_key.pub
   ```
2. Copy the entire output (it should start with "ssh-ed25519")
3. Connect to your Move for the first time:
   ```
   ssh ableton@move.local
   ```
4. When prompted "Are you sure you want to continue connecting?", type `yes` and press Enter
5. Enter the default password: `move`
6. Once connected to your Move, add your public key:
   ```
   mkdir -p ~/.ssh
   echo "YOUR_PUBLIC_KEY_HERE" >> ~/.ssh/authorized_keys
   chmod 600 ~/.ssh/authorized_keys
   exit
   ```
   Replace "YOUR_PUBLIC_KEY_HERE" with the key you copied in step 2

---

## Step 5: Install Extending Move Tools

### 5.1 Test SSH Key Access
1. Try connecting again - this time it should not ask for a password:
   ```
   ssh ableton@move.local
   ```
2. If successful, you'll see the Move's command prompt
3. Type `exit` to return to your local terminal

### 5.2 Run the Installation
1. Make sure you're in the extending-move project directory
2. Make the installation script executable:
   ```
   chmod +x utility-scripts/install-on-move.sh
   ```
3. Run the installation:
   ```
   ./utility-scripts/install-on-move.sh
   ```
4. When prompted:
   - Type `yes` to proceed with installation
   - Choose a port number (909 is recommended for first-time users)
   - Wait for the installation to complete

### 5.3 Verify Installation
The installation will show a success message with a web address like `http://move.local:909`

---

## Step 6: Access Your New Tools

### 6.1 Open in Browser
1. Open your favorite web browser on Windows
2. Go to the address shown in the installation success message (usually `http://move.local:909`)
3. You should see the Extending Move web interface!

### 6.2 Explore the Features
You now have access to powerful tools for:
- Creating drum kits from audio files
- Editing Drift synthesizer presets
- Reversing audio samples
- Importing MIDI files
- And much more!

---

## What's Next?

- Explore the different tools available in the web interface
- Check out the examples folder for sample files to practice with
- Join the Discord community for tips and support
- Read the main README for detailed feature explanations

## Getting Help

If you run into issues:
1. Check the Troubleshooting Links guide in this folder
2. Join the Discord community mentioned in the main README
3. Review the installation video linked in the main README

Congratulations! You've successfully set up Extending Move on your Windows 11 system! 🎉
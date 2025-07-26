# macOS Setup Guide for Extending Move

This guide will help you set up the Extending Move tools on your Ableton Move device using macOS. No previous SSH or terminal experience is required - we'll walk you through every step!

## Important Safety Notice

⚠️ **Before You Begin**: 
- This process involves accessing your Move device in ways it wasn't originally designed for
- While the risk is low, there's a small chance something could go wrong
- You are proceeding at your own risk
- Ableton cannot provide support if issues occur
- Recovery information is available on Center Code (linked in the main README)

## What You'll Need

- Mac computer (any recent macOS version)
- Ableton Move device connected to the same Wi-Fi network
- About 20 minutes of time

## Overview

We'll complete these main steps:
1. Download the Extending Move project
2. Open Terminal and navigate to the project
3. Set up SSH access to your Move device
4. Install the Extending Move tools
5. Access your new tools through a web browser

---

## Step 1: Download and Prepare the Project

### 1.1 Download the Project
1. Open your web browser and go to: https://github.com/peterswimm/extending-move
2. Click the green "Code" button
3. Click "Download ZIP"
4. The file will download to your Downloads folder
5. Double-click the ZIP file to extract it
6. You'll see a folder called "extending-move-main"

### 1.2 Move to Easy Location (Optional)
For easier access, drag the "extending-move-main" folder to your Desktop or Documents folder.

---

## Step 2: Prepare Your Move Device

### 2.1 Enable SSH on Your Move
1. On your Move device, go to Settings
2. Navigate to System → SSH
3. Enable SSH access
4. Note the IP address shown (you'll need this if move.local doesn't work)

### 2.2 Make Sure Your Move is Connected
1. Your Move and Mac must be on the same Wi-Fi network
2. You can test this later in the setup process

---

## Step 3: Open Terminal and Navigate to Project

### 3.1 Open Terminal
1. Press `Cmd + Space` to open Spotlight search
2. Type "Terminal" and press Enter
3. A Terminal window will open with a command prompt

### 3.2 Navigate to the Project Folder
If you placed the folder on your Desktop:
```
cd ~/Desktop/extending-move-main
```

If you placed it in Downloads:
```
cd ~/Downloads/extending-move-main
```

If you placed it in Documents:
```
cd ~/Documents/extending-move-main
```

**Tip**: You can also drag the folder from Finder directly into Terminal after typing `cd ` (with a space).

---

## Step 4: Test Connection to Your Move

Before setting up SSH keys, let's make sure your Mac can reach your Move:

```
ping move.local
```

You should see responses like "64 bytes from move.local". Press `Ctrl + C` to stop the test.

If this doesn't work, try using your Move's IP address instead:
```
ping 192.168.1.XXX
```
(Replace XXX with the numbers from your Move's network settings)

---

## Step 5: Set Up SSH Access (The Easy Way)

The project includes an automated setup script that handles most of the work for you.

### 5.1 Run the Automated Setup
```
./utility-scripts/setup-ssh-and-install-on-move.command
```

**If you get a "Permission denied" error**, make the script executable first:
```
chmod +x utility-scripts/setup-ssh-and-install-on-move.command
./utility-scripts/setup-ssh-and-install-on-move.command
```

### 5.2 Follow the Script Instructions
The script will guide you through:

1. **Risk Warning**: Type `y` to proceed
2. **SSH Key Generation**: The script creates a secure key for your Move
3. **SSH Configuration**: Automatically configures your Mac to use the key
4. **Public Key Display**: You'll see a long string starting with "ssh-ed25519"
5. **Manual Key Addition**: Follow the on-screen instructions to add this key to your Move

### 5.3 Add the Key to Your Move
When prompted by the script:

1. **Copy the public key** displayed on screen (starts with "ssh-ed25519")
2. **Connect to your Move** using the command shown:
   ```
   ssh ableton@move.local
   ```
3. **Enter password** when prompted: `move`
4. **Add your key** by running these commands on the Move:
   ```
   mkdir -p ~/.ssh
   echo "PASTE_YOUR_KEY_HERE" >> ~/.ssh/authorized_keys
   chmod 600 ~/.ssh/authorized_keys
   exit
   ```
   (Replace "PASTE_YOUR_KEY_HERE" with the actual key you copied)

5. **Return to the script** and press Enter to continue

---

## Step 6: Complete the Installation

### 6.1 Installation Process
The script will now:
1. Test the SSH connection (should work without a password now)
2. Install necessary components on your Move
3. Transfer the Extending Move files
4. Set up the web server

### 6.2 Choose Installation Options
During installation you'll be asked:
- **Confirm installation**: Type `yes`
- **Choose a port**: We recommend `909` for first-time users
- **Version warning**: If your Move has a newer version than tested, you can usually safely continue

### 6.3 Wait for Completion
The installation process will:
- Download and install Python packages on your Move
- Copy all necessary files
- Set up the web server
- Show a success message with your web address

---

## Step 7: Access Your New Tools

### 7.1 Open in Browser
1. Look for the success message showing an address like `http://move.local:909`
2. Open your favorite web browser
3. Go to that address
4. You should see the Extending Move web interface!

### 7.2 Automatic Browser Opening (Optional)
The script may ask if you want to open the tools automatically. Type `y` if you'd like it to open your browser for you.

---

## Alternative Manual Setup (If Automated Script Fails)

If the automated script doesn't work, you can set up SSH manually:

### Manual SSH Setup
1. **Generate SSH key**:
   ```
   ssh-keygen -t ed25519 -f ~/.ssh/move_key -N ""
   ```

2. **Configure SSH**:
   ```
   echo "Host move.local" >> ~/.ssh/config
   echo "  AddKeysToAgent yes" >> ~/.ssh/config
   echo "  IdentityFile ~/.ssh/move_key" >> ~/.ssh/config
   echo "  HostName move.local" >> ~/.ssh/config
   chmod 600 ~/.ssh/config
   ```

3. **Copy public key**:
   ```
   cat ~/.ssh/move_key.pub
   ```

4. **Add key to Move** (follow Step 5.3 above)

5. **Run installation**:
   ```
   ./utility-scripts/install-on-move.sh
   ```

---

## Step 8: Explore Your New Tools

### 8.1 Available Features
You now have access to powerful tools for:
- **Sliced Kit Creation**: Turn any audio file into a drum kit
- **Chord Kit Generation**: Create chord variations from samples
- **Drift Preset Editor**: Modify synthesizer parameters and macros
- **Sample Reversal**: Create reversed audio effects
- **MIDI Import**: Upload MIDI files to create new sets
- **Set Restoration**: Upload and restore Move Sets
- And much more!

### 8.2 Getting Started
- Start with the Slice tool to create your first drum kit
- Check out the examples folder for sample files to practice with
- Try the Chord tool to create harmonic variations

---

## What's Next?

- **Explore Features**: Each tool has its own interface and capabilities
- **Join Community**: Connect with other users on Discord (link in main README)
- **Read Documentation**: Check the main README for detailed feature explanations
- **Watch Videos**: The main README links to tutorial videos

## Updating Your Installation

To update to the latest version:
```
./utility-scripts/update-on-move.sh
```

## Getting Help

If you run into issues:
1. Check the Troubleshooting Links guide in this folder
2. Join the Discord community mentioned in the main README
3. Review the installation video linked in the main README
4. Search or create an issue on the GitHub repository

Congratulations! You've successfully set up Extending Move on your Mac! 🎉

**Pro Tip**: Bookmark `http://move.local:909` in your browser for easy access to your tools!
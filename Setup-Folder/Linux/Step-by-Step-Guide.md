# Linux Setup Guide for Extending Move

This guide will help you set up the Extending Move tools on your Ableton Move device using Linux. No previous SSH or terminal experience is required - we'll walk you through every step!

## Important Safety Notice

⚠️ **Before You Begin**: 
- This process involves accessing your Move device in ways it wasn't originally designed for
- While the risk is low, there's a small chance something could go wrong
- You are proceeding at your own risk
- Ableton cannot provide support if issues occur
- Recovery information is available on Center Code (linked in the main README)

## What You'll Need

- Linux computer (Ubuntu, Debian, Fedora, or similar)
- Ableton Move device connected to the same Wi-Fi network
- About 20 minutes of time

## Overview

We'll complete these main steps:
1. Install required tools (if not already present)
2. Download the Extending Move project
3. Set up SSH access to your Move device
4. Install the Extending Move tools
5. Access your new tools through a web browser

---

## Step 1: Install Required Tools

Most Linux distributions include the tools we need, but let's make sure they're installed.

### 1.1 Open Terminal
- **Ubuntu/Debian**: Press `Ctrl + Alt + T` or search for "Terminal"
- **Fedora**: Press `Super key` and type "Terminal"
- **Other distributions**: Look for "Terminal" or "Console" in your applications

### 1.2 Install Required Packages

**For Ubuntu/Debian:**
```bash
sudo apt update
sudo apt install openssh-client git curl wget tar
```

**For Fedora/RHEL/CentOS:**
```bash
sudo dnf install openssh-clients git curl wget tar
```

**For Arch Linux:**
```bash
sudo pacman -S openssh git curl wget tar
```

**For openSUSE:**
```bash
sudo zypper install openssh git curl wget tar
```

Enter your password when prompted (you won't see the characters as you type - this is normal).

---

## Step 2: Download and Prepare the Project

### 2.1 Download the Project
1. Open your web browser and go to: https://github.com/peterswimm/extending-move
2. Click the green "Code" button
3. Click "Download ZIP"
4. Save to your Downloads folder (usually `~/Downloads`)

### 2.2 Extract and Navigate to Project
```bash
cd ~/Downloads
unzip extending-move-main.zip
cd extending-move-main
```

**Alternative: Clone with Git (if you prefer)**
```bash
cd ~
git clone https://github.com/peterswimm/extending-move.git
cd extending-move
```

---

## Step 3: Prepare Your Move Device

### 3.1 Enable SSH on Your Move
1. On your Move device, go to Settings
2. Navigate to System → SSH
3. Enable SSH access
4. Note the IP address shown (you'll need this if move.local doesn't work)

### 3.2 Test Connection to Your Move
```bash
ping move.local
```

You should see responses like "64 bytes from move.local". Press `Ctrl + C` to stop the test.

If this doesn't work, try using your Move's IP address instead:
```bash
ping 192.168.1.XXX
```
(Replace XXX with the numbers from your Move's network settings)

---

## Step 4: Set Up SSH Access

### 4.1 Generate SSH Key
Create a secure key that will let you connect to your Move without passwords:

```bash
ssh-keygen -t ed25519 -f ~/.ssh/move_key -N ""
```

This creates two files:
- `~/.ssh/move_key` (private key - keep this secret!)
- `~/.ssh/move_key.pub` (public key - safe to share)

### 4.2 Configure SSH
Set up your SSH client to use the key automatically:

```bash
mkdir -p ~/.ssh
cat << EOF >> ~/.ssh/config
Host move.local
  AddKeysToAgent yes
  IdentityFile ~/.ssh/move_key
  HostName move.local
EOF
chmod 600 ~/.ssh/config
```

### 4.3 Add Your Public Key to the Move

1. **Display your public key**:
   ```bash
   cat ~/.ssh/move_key.pub
   ```

2. **Copy the entire output** (it starts with "ssh-ed25519")

3. **Connect to your Move for the first time**:
   ```bash
   ssh ableton@move.local
   ```

4. When prompted "Are you sure you want to continue connecting?", type `yes` and press Enter

5. **Enter the default password**: `move`

6. **Once connected to your Move**, add your public key:
   ```bash
   mkdir -p ~/.ssh
   echo "YOUR_PUBLIC_KEY_HERE" >> ~/.ssh/authorized_keys
   chmod 600 ~/.ssh/authorized_keys
   exit
   ```
   Replace "YOUR_PUBLIC_KEY_HERE" with the key you copied in step 2

---

## Step 5: Install Extending Move Tools

### 5.1 Test SSH Key Access
Try connecting again - this time it should not ask for a password:
```bash
ssh ableton@move.local
```

If successful, you'll see the Move's command prompt. Type `exit` to return to your local terminal.

### 5.2 Run the Installation
```bash
chmod +x utility-scripts/install-on-move.sh
./utility-scripts/install-on-move.sh
```

### 5.3 Follow Installation Prompts
During installation you'll be asked:

1. **Confirm installation**: Type `yes` and press Enter
2. **Choose a port**: 
   - Press `1` and Enter for port 909 (recommended for beginners)
   - Or choose another option if you prefer
3. **Version warning**: If your Move has a newer version than tested, you can usually safely type `y` to continue

### 5.4 Wait for Installation to Complete
The script will:
- Install Python and necessary packages on your Move
- Copy all Extending Move files
- Set up the web server
- Display a success message with your web address

---

## Step 6: Access Your New Tools

### 6.1 Open in Browser
1. Look for the success message showing an address like `http://move.local:909`
2. Open your web browser
3. Navigate to that address
4. You should see the Extending Move web interface!

### 6.2 Bookmark for Easy Access
Save the address in your browser bookmarks for quick access later.

---

## Alternative: Automated Setup Script

The project includes an automated script that can handle the SSH setup for you:

### Using the Automated Script
```bash
chmod +x utility-scripts/setup-ssh-and-install-on-move.sh
./utility-scripts/setup-ssh-and-install-on-move.sh
```

This script will:
1. Generate SSH keys automatically
2. Configure SSH
3. Guide you through adding the key to your Move
4. Run the installation
5. Open your browser to the web interface

---

## Step 7: Explore Your New Tools

### 7.1 Available Features
You now have access to powerful tools for:

- **Sliced Kit Creation**: Turn any audio file into a drum kit with visual slicing
- **Chord Kit Generation**: Create chord variations from samples
- **Drift Preset Editor**: Modify synthesizer parameters and macro assignments
- **Sample Reversal**: Create reversed audio effects
- **MIDI Import**: Upload MIDI files to create new sets
- **Set Restoration**: Upload and restore Move Sets (.ablbundle files)
- **Drum Rack Inspector**: View, download, and modify drum rack samples
- **Time Stretching**: Adjust tempo and pitch of audio samples

### 7.2 Getting Started Tips
- Start with the **Slice** tool to create your first drum kit from an audio file
- Try the **Chord** tool to generate harmonic variations
- Explore the **examples** folder for sample files to experiment with
- Each tool has its own interface with helpful tooltips

---

## What's Next?

### Learning More
- **Read the Main Documentation**: Check the README.md file for detailed feature explanations
- **Watch Tutorial Videos**: Links are provided in the main README
- **Join the Community**: Connect with other users on Discord (link in main README)

### Keeping Updated
To update to the latest version:
```bash
cd ~/Downloads/extending-move-main  # or wherever you extracted the project
./utility-scripts/update-on-move.sh
```

### Advanced Usage
- Explore the `examples` folder for sample presets and MIDI files
- Check out the `docs` folder for technical documentation
- Try the `offline-tools` for standalone utilities

---

## Distribution-Specific Notes

### Ubuntu/Debian
- The setup should work out of the box on most recent versions
- If you encounter permission issues, you may need to add your user to the `audio` group

### Fedora/RHEL
- SELinux may interfere with SSH connections. If you have issues:
  ```bash
  sudo setsebool -P ssh_chroot_rw_homedirs on
  ```

### Arch Linux
- Ensure `openssh` is installed and enabled:
  ```bash
  sudo systemctl enable sshd
  sudo systemctl start sshd
  ```

### Raspberry Pi
- This setup works great on Raspberry Pi!
- Consider using a wired connection if WiFi is unstable
- The Pi can act as a dedicated Move companion device

---

## Getting Help

If you run into issues:

1. **Check the Troubleshooting Guide**: See `Troubleshooting-Links.md` in this folder
2. **Discord Community**: Join the active Discord community (link in main README)
3. **GitHub Issues**: Search or create issues on the project repository
4. **Linux Community**: Your distribution's forums or subreddits can help with Linux-specific issues

### Common Quick Fixes
- **Permission denied**: Try `chmod +x` on script files
- **Command not found**: Check if required packages are installed
- **Connection refused**: Verify both devices are on same network
- **Host key verification failed**: Run `ssh-keygen -R move.local`

Congratulations! You've successfully set up Extending Move on your Linux system! 🎉

**Pro Tip**: You can run the web interface on your Linux computer and access your Move's enhanced capabilities from anywhere on your network!
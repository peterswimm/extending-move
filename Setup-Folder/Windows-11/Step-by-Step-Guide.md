# Windows 11 Setup Guide for Extending Move

This guide will help you set up your Windows 11 computer to connect and transfer files to your Ableton Move device.

## What You'll Need
- A Windows 11 computer
- Your Ableton Move device connected to the same network
- About 15-20 minutes of time

## Before You Start
- Make sure your Ableton Move is connected to your Wi-Fi network
- Ensure your computer and Move are on the same network
- Have your Move powered on and ready

---

## Step 1: Install Required Software

### Install Windows Subsystem for Linux (WSL)
WSL makes it easier to work with SSH and file transfers.

1. **Open PowerShell as Administrator**
   - Press `Windows key + X`
   - Click "Terminal (Admin)" or "PowerShell (Admin)"
   - Click "Yes" when prompted

2. **Install WSL**
   - Type this command and press Enter:
   ```
   wsl --install
   ```
   - Wait for the installation to complete (this may take a few minutes)
   - Restart your computer when prompted

3. **Set up Ubuntu**
   - After restart, Ubuntu will open automatically
   - Create a username and password when prompted
   - Remember these - you'll need them later!

### Alternative: Install Git for Windows (if you prefer not to use WSL)
If you don't want to use WSL, you can install Git for Windows which includes SSH tools:

1. Go to [https://git-scm.com/download/win](https://git-scm.com/download/win)
2. Download and install Git for Windows
3. During installation, choose "Use Git and optional Unix tools from the Command Prompt"

---

## Step 2: Generate SSH Keys

SSH keys are like a secure password that lets your computer talk to your Move safely.

### Using WSL (Recommended)
1. **Open Ubuntu (WSL)**
   - Press `Windows key`
   - Type "Ubuntu" and press Enter

2. **Create SSH directory**
   ```bash
   mkdir -p ~/.ssh
   chmod 700 ~/.ssh
   ```

3. **Generate your SSH key**
   ```bash
   ssh-keygen -t ed25519 -f ~/.ssh/move_key -N ""
   ```
   - This creates two files: a private key (keep secret) and a public key (share with Move)

4. **View your public key**
   ```bash
   cat ~/.ssh/move_key.pub
   ```
   - Copy this entire line - you'll need it in the next step

### Using Git Bash (Alternative)
1. **Open Git Bash**
   - Press `Windows key`
   - Type "Git Bash" and press Enter

2. **Follow the same commands as above** (they work the same way in Git Bash)

---

## Step 3: Add Your Key to the Move

1. **Open your web browser**
2. **Go to your Move's web interface**
   - Type this address: `http://move.local/development/ssh`
   - If that doesn't work, try finding your Move's IP address and use `http://[IP ADDRESS]/development/ssh`

3. **Add your public key**
   - Paste the public key you copied earlier into the text box
   - Click "Save" or "Add Key"
   - You should see a confirmation message

---

## Step 4: Test Your Connection

### Using WSL
1. **Test SSH connection**
   ```bash
   ssh -i ~/.ssh/move_key ableton@move.local
   ```
   - Type "yes" if asked about fingerprint
   - You should see a welcome message from your Move
   - Type `exit` to disconnect

### Using Git Bash
1. **Test SSH connection**
   ```bash
   ssh -i ~/.ssh/move_key ableton@move.local
   ```
   - Follow the same steps as above

---

## Step 5: Transfer Files to Your Move

Now you can send files to your Move! Here are common examples:

### Upload a WAV file to Move's Samples folder
```bash
scp -i ~/.ssh/move_key "C:/path/to/your/file.wav" ableton@move.local:/data/UserData/UserLibrary/Samples/
```

### Upload a preset file
```bash
scp -i ~/.ssh/move_key "C:/path/to/your/preset.ablpreset" ableton@move.local:/data/UserData/UserLibrary/Track\ Presets/
```

### Download a file from Move
```bash
scp -i ~/.ssh/move_key ableton@move.local:/data/UserData/UserLibrary/Samples/filename.wav "C:/Users/YourName/Downloads/"
```

### Important Notes:
- Replace `"C:/path/to/your/file.wav"` with the actual path to your file
- Replace `YourName` with your Windows username
- Use quotes around paths that contain spaces
- On Windows, use forward slashes (/) in paths for SCP commands

---

## Step 6: Make File Transfers Easier

### Create a config file to simplify commands
1. **Create SSH config file**
   ```bash
   nano ~/.ssh/config
   ```

2. **Add this configuration**
   ```
   Host move
       HostName move.local
       User ableton
       IdentityFile ~/.ssh/move_key
   ```

3. **Save and exit**
   - Press `Ctrl+X`, then `Y`, then Enter

4. **Now you can use simpler commands**
   ```bash
   scp "C:/path/to/file.wav" move:/data/UserData/UserLibrary/Samples/
   ```

---

## Quick Reference

### Common Move Directories
- **Samples**: `/data/UserData/UserLibrary/Samples/`
- **Track Presets**: `/data/UserData/UserLibrary/Track Presets/`
- **Sets**: `/data/UserData/UserLibrary/Sets/`

### Basic Commands
- **Test connection**: `ssh move`
- **Upload file**: `scp "local/file" move:/remote/path/`
- **Download file**: `scp move:/remote/file "local/path/"`
- **List files on Move**: `ssh move "ls /data/UserData/UserLibrary/Samples/"`

---

## Next Steps

1. **Try uploading a test file** to make sure everything works
2. **Bookmark your Move's web interface** at `http://move.local`
3. **Check out the Troubleshooting guide** if you run into issues
4. **Explore the extending-move project** for additional tools and features

## Important Safety Notes

- Always backup your Move's data before making changes
- Only transfer files you trust to your Move
- Keep your SSH private key secure and never share it
- If something goes wrong, check the Troubleshooting guide

---

*This guide is designed to be beginner-friendly. If technical terms are confusing, the Troubleshooting guide has additional explanations and help resources.*
# macOS Setup Guide for Extending Move

This guide will help you set up your macOS computer to connect and transfer files to your Ableton Move device.

## What You'll Need
- A Mac computer (any recent version of macOS)
- Your Ableton Move device connected to the same network
- About 10-15 minutes of time

## Before You Start
- Make sure your Ableton Move is connected to your Wi-Fi network
- Ensure your Mac and Move are on the same network
- Have your Move powered on and ready

---

## Step 1: Open Terminal

The Terminal app is built into macOS and gives you access to all the tools you need.

1. **Open Terminal**
   - Press `Command + Space` to open Spotlight search
   - Type "Terminal" and press Enter
   - Or go to Applications → Utilities → Terminal

2. **Get familiar with Terminal**
   - Terminal is where you'll type commands
   - Each command ends with pressing Enter
   - Don't worry - we'll guide you through each step!

---

## Step 2: Generate SSH Keys

SSH keys are like a secure password that lets your Mac talk to your Move safely.

1. **Create SSH directory** (if it doesn't exist)
   ```bash
   mkdir -p ~/.ssh
   chmod 700 ~/.ssh
   ```

2. **Generate your SSH key**
   ```bash
   ssh-keygen -t ed25519 -f ~/.ssh/move_key -N ""
   ```
   - This creates two files: a private key (keep secret) and a public key (share with Move)
   - The `-N ""` means no password is needed

3. **View your public key**
   ```bash
   cat ~/.ssh/move_key.pub
   ```
   - Copy this entire line - you'll need it in the next step
   - It should start with `ssh-ed25519` and end with `move_key_for_ableton_move`

---

## Step 3: Add Your Key to the Move

1. **Open your web browser** (Safari, Chrome, Firefox, etc.)

2. **Go to your Move's web interface**
   - Type this address: `http://move.local/development/ssh`
   - Press Enter

3. **Add your public key**
   - Paste the public key you copied earlier into the text box
   - Click "Save" or "Add Key"
   - You should see a confirmation message

**If move.local doesn't work:**
- Find your Move's IP address in your Wi-Fi settings
- Use `http://[IP ADDRESS]/development/ssh` instead

---

## Step 4: Configure SSH for Easy Access

This step makes future connections much simpler.

1. **Add the key to SSH agent**
   ```bash
   ssh-add ~/.ssh/move_key
   ```

2. **Create SSH config file**
   ```bash
   nano ~/.ssh/config
   ```
   - This opens a text editor in Terminal

3. **Add this configuration**
   ```
   Host move
       HostName move.local
       User ableton
       IdentityFile ~/.ssh/move_key
       AddKeysToAgent yes
   ```

4. **Save and exit**
   - Press `Control + X`
   - Press `Y` to confirm
   - Press Enter to save

---

## Step 5: Test Your Connection

1. **Test SSH connection**
   ```bash
   ssh move
   ```
   - Type "yes" if asked about the fingerprint
   - You should see a welcome message from your Move
   - Type `exit` to disconnect

If this works, you're all set! If not, check the troubleshooting guide.

---

## Step 6: Transfer Files to Your Move

Now you can send files to your Move! Here are common examples:

### Upload a WAV file to Move's Samples folder
```bash
scp "/path/to/your/file.wav" move:/data/UserData/UserLibrary/Samples/
```

### Upload a preset file
```bash
scp "/path/to/your/preset.ablpreset" move:"/data/UserData/UserLibrary/Track Presets/"
```

### Download a file from Move
```bash
scp move:/data/UserData/UserLibrary/Samples/filename.wav ~/Downloads/
```

### Important Notes:
- Replace `/path/to/your/file.wav` with the actual path to your file
- Use quotes around paths that contain spaces
- `~/Downloads/` is your Downloads folder

---

## Step 7: Find File Paths Easily on Mac

### Using Finder to get file paths:
1. **Find your file** in Finder
2. **Right-click the file**
3. **Hold the Option key** 
4. **Click "Copy [filename] as Pathname"**
5. **Paste this into your Terminal command**

### Drag and drop method:
1. **Type the start of your command**: `scp `
2. **Drag the file** from Finder into Terminal
3. **Add the destination**: ` move:/data/UserData/UserLibrary/Samples/`
4. **Press Enter**

---

## Quick Reference

### Common Move Directories
- **Samples**: `/data/UserData/UserLibrary/Samples/`
- **Track Presets**: `/data/UserData/UserLibrary/Track Presets/`
- **Sets**: `/data/UserData/UserLibrary/Sets/`

### Basic Commands
- **Test connection**: `ssh move`
- **Upload file**: `scp "local/file" move:/remote/path/`
- **Download file**: `scp move:/remote/file ~/Downloads/`
- **List files on Move**: `ssh move "ls /data/UserData/UserLibrary/Samples/"`

### Useful Mac Shortcuts
- **Copy**: `Command + C`
- **Paste**: `Command + V`
- **New Terminal window**: `Command + N`
- **Clear Terminal**: `Command + K`

---

## Example Commands

### Upload an audio file from Desktop
```bash
scp ~/Desktop/my-sample.wav move:/data/UserData/UserLibrary/Samples/
```

### Upload a preset from Downloads
```bash
scp ~/Downloads/my-preset.ablpreset move:"/data/UserData/UserLibrary/Track Presets/"
```

### Create a backup of Move's samples
```bash
mkdir ~/move-backup
scp -r move:/data/UserData/UserLibrary/Samples/ ~/move-backup/
```

### Check what's on your Move
```bash
ssh move "ls -la /data/UserData/UserLibrary/Samples/"
```

---

## Automated Setup Option

If you prefer an automated setup, the extending-move project includes setup scripts:

1. **Download the project**
   ```bash
   git clone https://github.com/charlesvestal/extending-move.git
   cd extending-move
   ```

2. **Run the setup script**
   ```bash
   ./utility-scripts/setup-ssh-and-install-on-move.command
   ```

This script will do most of the setup automatically, but it's good to understand the manual process too!

---

## Next Steps

1. **Try uploading a test file** to make sure everything works
2. **Bookmark your Move's web interface** at `http://move.local`
3. **Explore the extending-move tools** for additional features like:
   - Web-based preset editor
   - Sample slicing tools
   - Set restoration utilities
4. **Check out the Troubleshooting guide** if you run into issues

## Important Safety Notes

- Always backup your Move's data before making changes
- Only transfer files you trust to your Move
- Keep your SSH private key secure and never share it
- If something goes wrong, check the Troubleshooting guide
- The Move has limited storage space - manage your files carefully

---

## Understanding File Locations

### On Your Mac
- **Home folder**: `~` (shortcut for /Users/YourName)
- **Desktop**: `~/Desktop/`
- **Downloads**: `~/Downloads/`
- **Music**: `~/Music/`

### On Your Move
- **Main library**: `/data/UserData/UserLibrary/`
- **Samples folder**: `/data/UserData/UserLibrary/Samples/`
- **Presets folder**: `/data/UserData/UserLibrary/Track Presets/`

---

*This guide is designed to be beginner-friendly. macOS has excellent built-in SSH support, making the setup process straightforward. If you run into any issues, the Troubleshooting guide has additional help resources.*
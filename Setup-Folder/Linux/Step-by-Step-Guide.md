# Linux Setup Guide for Extending Move

This guide will help you set up your Linux computer to connect and transfer files to your Ableton Move device.

## What You'll Need
- A Linux computer (Ubuntu, Debian, Fedora, Arch, or any distribution)
- Your Ableton Move device connected to the same network
- About 10-15 minutes of time

## Before You Start
- Make sure your Ableton Move is connected to your Wi-Fi network
- Ensure your Linux computer and Move are on the same network
- Have your Move powered on and ready

---

## Step 1: Open Terminal and Install Required Tools

Most Linux distributions come with SSH tools pre-installed, but let's make sure you have everything you need.

### For Ubuntu/Debian-based distributions:
```bash
sudo apt update
sudo apt install openssh-client
```

### For Fedora/CentOS/RHEL:
```bash
sudo dnf install openssh-clients
```
or for older versions:
```bash
sudo yum install openssh-clients
```

### For Arch Linux:
```bash
sudo pacman -S openssh
```

### For openSUSE:
```bash
sudo zypper install openssh
```

**Note**: Most distributions already have SSH client installed, so you might see "already installed" messages - that's perfectly fine!

---

## Step 2: Generate SSH Keys

SSH keys are like a secure password that lets your Linux computer talk to your Move safely.

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
   - The `-N ""` means no password is needed for simplicity

3. **View your public key**
   ```bash
   cat ~/.ssh/move_key.pub
   ```
   - Copy this entire line - you'll need it in the next step
   - It should start with `ssh-ed25519` and end with your username@hostname

---

## Step 3: Add Your Key to the Move

1. **Open your web browser** (Firefox, Chrome, Chromium, etc.)

2. **Go to your Move's web interface**
   - Type this address: `http://move.local/development/ssh`
   - Press Enter

3. **Add your public key**
   - Paste the public key you copied earlier into the text box
   - Click "Save" or "Add Key"
   - You should see a confirmation message

**If move.local doesn't work:**
- Find your Move's IP address: `nmap -sn 192.168.1.0/24` (adjust subnet as needed)
- Or check your router's admin interface
- Use `http://[IP ADDRESS]/development/ssh` instead

---

## Step 4: Configure SSH for Easy Access

This step makes future connections much simpler.

1. **Add the key to SSH agent** (optional but recommended)
   ```bash
   eval "$(ssh-agent -s)"
   ssh-add ~/.ssh/move_key
   ```

2. **Create SSH config file**
   ```bash
   nano ~/.ssh/config
   ```
   - This opens a text editor in Terminal (you can also use vim, gedit, or any text editor)

3. **Add this configuration**
   ```
   Host move
       HostName move.local
       User ableton
       IdentityFile ~/.ssh/move_key
       AddKeysToAgent yes
   ```

4. **Save and exit**
   - In nano: Press `Ctrl + X`, then `Y`, then Enter
   - In vim: Press `Esc`, type `:wq`, press Enter

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
- `~/Downloads/` is your Downloads folder (usually `/home/username/Downloads/`)

---

## Step 7: Find File Paths Easily on Linux

### Using tab completion:
1. **Start typing a path**: `scp ~/Mus` then press Tab
2. **It will auto-complete**: `~/Music/`
3. **Continue typing and pressing Tab** to navigate

### Using file manager integration:
Many Linux file managers let you:
1. **Right-click a file**
2. **Look for "Copy Path" or "Properties"**
3. **Paste the path into your terminal**

### Using find command:
```bash
find ~ -name "*.wav" -type f | head -10
```
This shows the first 10 WAV files in your home directory.

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

### Useful Linux Commands
- **Current directory**: `pwd`
- **List files**: `ls -la`
- **Change directory**: `cd /path/to/directory`
- **Copy file**: `cp source destination`
- **Find files**: `find /path -name "filename"`

---

## Example Commands

### Upload an audio file from Music folder
```bash
scp ~/Music/my-sample.wav move:/data/UserData/UserLibrary/Samples/
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

### Upload all WAV files from a directory
```bash
scp ~/Music/samples/*.wav move:/data/UserData/UserLibrary/Samples/
```

---

## Distribution-Specific Notes

### Ubuntu/Debian (with GUI)
- **File manager**: Nautilus (Files app)
- **Terminal shortcut**: `Ctrl + Alt + T`
- **Additional packages**: You might want `nautilus-open-terminal` for right-click terminal access

### Fedora (with GNOME)
- **File manager**: Nautilus (Files app)  
- **Terminal shortcut**: `Ctrl + Alt + T`
- **Additional packages**: `gnome-terminal-nautilus` for integration

### KDE-based distributions (Kubuntu, openSUSE, etc.)
- **File manager**: Dolphin
- **Terminal shortcut**: `Ctrl + Alt + T` or `F4` in Dolphin
- **Integration**: Dolphin has built-in terminal support

### Arch Linux
- **Terminal**: Usually already available, depends on desktop environment
- **AUR helpers**: If you use `yay` or `paru`, SSH tools are usually installed
- **Minimal installs**: You might need to install a text editor: `sudo pacman -S nano`

---

## Automated Setup Option

If you prefer an automated setup and have git installed:

1. **Download the project**
   ```bash
   git clone https://github.com/charlesvestal/extending-move.git
   cd extending-move
   ```

2. **Run the setup script**
   ```bash
   ./utility-scripts/setup-ssh-and-install-on-move.sh
   ```

This script will do most of the setup automatically!

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

### On Your Linux System
- **Home folder**: `~` (shortcut for /home/username)
- **Downloads**: `~/Downloads/`
- **Music**: `~/Music/`
- **Documents**: `~/Documents/`
- **Desktop**: `~/Desktop/`

### Common Audio Software Directories
- **Audacity**: `~/audacity-data/`
- **LMMS**: `~/lmms/samples/`
- **Ardour**: `~/Documents/Ardour/`

### On Your Move
- **Main library**: `/data/UserData/UserLibrary/`
- **Samples folder**: `/data/UserData/UserLibrary/Samples/`
- **Presets folder**: `/data/UserData/UserLibrary/Track Presets/`

---

## Working with Different Audio Formats

Your Move primarily works with WAV files, but you might have other formats:

### Convert audio files using FFmpeg
```bash
# Install FFmpeg (Ubuntu/Debian)
sudo apt install ffmpeg

# Convert MP3 to WAV
ffmpeg -i input.mp3 output.wav

# Convert FLAC to WAV
ffmpeg -i input.flac output.wav
```

### Convert using SoX
```bash
# Install SoX (Ubuntu/Debian)
sudo apt install sox

# Convert various formats
sox input.mp3 output.wav
sox input.flac output.wav
```

---

*This guide is designed to work with most Linux distributions. Linux has excellent built-in SSH support, making the setup process straightforward. The main differences between distributions are package manager commands and desktop environments, but the core SSH functionality is identical.*
# Linux Setup Guide for Ableton Move

This guide will help you set up SSH access and file transfer to your Ableton Move device using Linux's built-in terminal and tools.

## What You'll Need

- A Linux computer (Ubuntu, Debian, Fedora, Arch, etc.)
- Your Ableton Move device connected to the same network
- About 10-15 minutes

## Step 1: Open Terminal

1. **Open Terminal using one of these methods:**
   - Press `Ctrl + Alt + T` (most distributions)
   - Press `Super` key and type "Terminal"
   - Click Activities → Terminal (GNOME)
   - Click Applications → Terminal (other desktop environments)

2. **Terminal is now ready** - you'll use this for all the following steps

## Step 2: Install Required Tools (if needed)

Most Linux distributions include SSH tools by default, but let's make sure:

### Ubuntu/Debian:
```bash
sudo apt update
sudo apt install openssh-client git
```

### Fedora:
```bash
sudo dnf install openssh-clients git
```

### Arch Linux:
```bash
sudo pacman -S openssh git
```

### Other Distributions:
Use your distribution's package manager to install `openssh-client` and `git`.

## Step 3: Generate SSH Key

1. **Generate an SSH key for your Move:**
   ```bash
   ssh-keygen -t ed25519 -f ~/.ssh/move_key -N "" -C "move_key_for_ableton_move"
   ```
   - This creates a secure key pair specifically for your Move device
   - The files will be saved in your home directory's .ssh folder

2. **View your public key:**
   ```bash
   cat ~/.ssh/move_key.pub
   ```
   - Copy this entire output - you'll need it in the next step
   - Use `Ctrl + Shift + C` to copy in most terminals

## Step 4: Add SSH Key to Your Move Device

1. **Connect to your Move via SSH (first time):**
   ```bash
   ssh ableton@move.local
   ```
   - Type `yes` when asked about fingerprint authenticity
   - Enter the default password: `movemove`

2. **Add your public key to the Move:**
   ```bash
   mkdir -p ~/.ssh
   echo "YOUR_PUBLIC_KEY_HERE" >> ~/.ssh/authorized_keys
   chmod 600 ~/.ssh/authorized_keys
   chmod 700 ~/.ssh
   ```
   - Replace `YOUR_PUBLIC_KEY_HERE` with the key you copied in Step 3
   - This allows password-free access in the future

3. **Exit the SSH session:**
   ```bash
   exit
   ```

## Step 5: Configure SSH for Easy Access

1. **Create SSH config file:**
   ```bash
   nano ~/.ssh/config
   ```
   - Or use your preferred editor: `vim`, `gedit`, `kate`, etc.

2. **Add this configuration:**
   ```
   Host move
       HostName move.local
       User ableton
       IdentityFile ~/.ssh/move_key
       StrictHostKeyChecking no
   ```

3. **Save the file:**
   - **In nano:** Press `Ctrl + X`, then `Y`, then `Enter`
   - **In vim:** Press `Esc`, type `:wq`, press `Enter`
   - **In graphical editors:** Use `Ctrl + S`

4. **Test the connection:**
   ```bash
   ssh move
   ```
   - You should now connect without entering a password
   - Type `exit` to disconnect

## Step 6: Transfer Files to Your Move

### Using SCP (Secure Copy)

1. **Copy a file TO your Move:**
   ```bash
   scp /path/to/your/file.wav move:/data/UserData/UserLibrary/Samples/
   ```

2. **Copy a file FROM your Move:**
   ```bash
   scp move:/data/UserData/UserLibrary/Samples/file.wav /path/to/destination/
   ```

### Easy File Path Tips for Linux

**Tab Completion:**
- Type part of a path and press `Tab` to auto-complete
- Press `Tab` twice to see all possible completions

**Common Linux Locations:**
- Desktop: `~/Desktop/filename.wav`
- Downloads: `~/Downloads/filename.wav`
- Documents: `~/Documents/filename.wav`
- Music: `~/Music/filename.wav`
- Current directory: `./filename.wav`

**Example - Copy from Downloads to Move:**
```bash
scp ~/Downloads/mysample.wav move:/data/UserData/UserLibrary/Samples/
```

### Using SFTP (Interactive File Transfer)

1. **Start SFTP session:**
   ```bash
   sftp move
   ```

2. **Common SFTP commands:**
   - `ls` - List files on Move
   - `lls` - List files on your computer
   - `cd` - Change directory on Move
   - `lcd` - Change directory on your computer
   - `put filename` - Upload file to Move
   - `get filename` - Download file from Move
   - `quit` - Exit SFTP

**Example SFTP workflow:**
```bash
sftp move
lcd ~/Downloads                  # Go to your Downloads
cd /data/UserData/UserLibrary/Samples/  # Go to Move samples folder
put mysample.wav                 # Upload file
ls                              # Verify it uploaded
quit                            # Exit
```

## Step 7: Install Extending Move Software

1. **Clone the extending-move repository:**
   ```bash
   cd ~/Downloads  # or wherever you want to download
   git clone https://github.com/peterswimm/extending-move.git
   cd extending-move
   ```

2. **Make the script executable:**
   ```bash
   chmod +x utility-scripts/setup-ssh-and-install-on-move.sh
   ```

3. **Run the installation script:**
   ```bash
   ./utility-scripts/setup-ssh-and-install-on-move.sh
   ```

4. **Follow the on-screen instructions**

## Important File Locations on Move

- **Audio Samples:** `/data/UserData/UserLibrary/Samples/`
- **Preset Samples:** `/data/UserData/UserLibrary/Samples/Preset Samples/`
- **Track Presets:** `/data/UserData/UserLibrary/Track Presets/`
- **Move Sets:** `/data/UserData/UserLibrary/Sets/`

## Advanced File Transfer Options

### Using rsync (Better for Large Transfers)

```bash
# Sync entire folder to Move
rsync -av ~/Music/SamplePack/ move:/data/UserData/UserLibrary/Samples/

# Sync with progress indicator
rsync -av --progress ~/Music/SamplePack/ move:/data/UserData/UserLibrary/Samples/

# Dry run (test without actually copying)
rsync -av --dry-run ~/Music/SamplePack/ move:/data/UserData/UserLibrary/Samples/
```

### Transfer Multiple Files with Wildcards

```bash
# Copy all WAV files from a directory
scp ~/Downloads/*.wav move:/data/UserData/UserLibrary/Samples/

# Copy all audio files (WAV and AIFF)
scp ~/Downloads/*.{wav,aiff} move:/data/UserData/UserLibrary/Samples/
```

### Mount Move as File System (Advanced)

1. **Install sshfs:**
   ```bash
   # Ubuntu/Debian
   sudo apt install sshfs
   
   # Fedora
   sudo dnf install fuse-sshfs
   
   # Arch
   sudo pacman -S sshfs
   ```

2. **Create mount point and mount:**
   ```bash
   mkdir ~/move-files
   sshfs move:/data/UserData/UserLibrary ~/move-files
   ```

3. **Access files through file manager:**
   - Navigate to `~/move-files` in your file manager
   - Copy/paste files normally

4. **Unmount when done:**
   ```bash
   fusermount -u ~/move-files
   ```

## File Manager Integration

### Nautilus (GNOME Files)

1. **Connect to server:**
   - Open Files (Nautilus)
   - Click "Other Locations" in sidebar
   - Enter `sftp://move.local` in "Connect to Server"
   - Use username `ableton` and your SSH key

### Dolphin (KDE)

1. **Use fish protocol:**
   - Open Dolphin
   - In address bar, type: `fish://ableton@move.local`
   - Navigate to `/data/UserData/UserLibrary/`

### Thunar (XFCE)

1. **Browse Network:**
   - Open Thunar
   - Click "Browse Network" in sidebar
   - Look for SSH servers or enter `sftp://move.local`

## Command Line Tips for Linux Users

### Useful Aliases (Optional)

Add these to your `~/.bashrc` or `~/.zshrc`:

```bash
# Quick SSH to Move
alias moveSSH='ssh move'

# Quick file listings
alias movels='ssh move "ls -la /data/UserData/UserLibrary/Samples/"'

# Upload to samples folder
alias moveup='scp "$1" move:/data/UserData/UserLibrary/Samples/'
```

After adding, run: `source ~/.bashrc`

### File Permissions and Ownership

```bash
# Check file permissions
ls -la yourfile.wav

# Make file readable (if needed)
chmod 644 yourfile.wav

# Check disk space on Move
ssh move "df -h"

# Check what's using space
ssh move "du -h /data/UserData/UserLibrary/ | sort -h"
```

## Troubleshooting Quick Commands

### Network Connectivity
```bash
# Test if Move is reachable
ping move.local

# Check SSH connection with verbose output
ssh -v move

# Test file transfer with compression
scp -C yourfile.wav move:/path/
```

### File Transfer Issues
```bash
# Resume interrupted transfer with rsync
rsync -av --partial --progress yourfile.wav move:/path/

# Check available space on Move
ssh move "df -h /data"

# Verify file was transferred correctly
ssh move "ls -la /data/UserData/UserLibrary/Samples/yourfile.wav"
```

### Permission Issues
```bash
# Fix SSH key permissions (if needed)
chmod 600 ~/.ssh/move_key
chmod 600 ~/.ssh/config
chmod 700 ~/.ssh

# Add key to SSH agent
ssh-add ~/.ssh/move_key
```

## Tips for Success

1. **Use tab completion** for file paths and commands
2. **File names are case-sensitive** on the Move device
3. **Avoid spaces in file names** - use underscores or hyphens instead
4. **Test with small files first** before transferring large batches
5. **Use `man command`** to learn more about any command (e.g., `man scp`)
6. **Keep your SSH key secure** - it provides access to your Move device

## Distribution-Specific Notes

### Ubuntu/Debian
- Package manager: `apt`
- SSH typically pre-installed
- Default terminal: GNOME Terminal

### Fedora
- Package manager: `dnf` (older versions use `yum`)
- May need to install openssh-clients
- Default terminal: GNOME Terminal

### Arch Linux
- Package manager: `pacman`
- Minimal install - may need openssh package
- Various terminal options

### openSUSE
- Package manager: `zypper`
- Use `sudo zypper install openssh git`

## Next Steps

Once setup is complete, you can:
- Access the Extending Move web interface at `move.local:909`
- Transfer audio files and presets to your Move
- Create custom drum kits and chord sets using the web interface
- Explore advanced Move functionality
- Contribute to the open-source project

## Need Help?

If you encounter issues, check the [Troubleshooting-Links.md](./Troubleshooting-Links.md) file for solutions to common problems.

## Security Notes

- **Keep your SSH key private** - never share `~/.ssh/move_key`
- **The public key** (`~/.ssh/move_key.pub`) can be shared safely
- **Regular backups** of your Move's content are recommended
- **Network security** - ensure your WiFi network is secure
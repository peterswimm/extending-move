# macOS Setup Guide for Ableton Move

This guide will help you set up SSH access and file transfer to your Ableton Move device using macOS's built-in Terminal and tools.

## What You'll Need

- A Mac computer (macOS 10.15 or later)
- Your Ableton Move device connected to the same network
- About 10-15 minutes

## Step 1: Open Terminal

1. **Find Terminal:**
   - Press `Command + Space` to open Spotlight
   - Type "Terminal" and press Enter
   - Or go to Applications → Utilities → Terminal

2. **Terminal is now ready** - you'll use this for all the following steps

## Step 2: Generate SSH Key

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
   - Tip: Use `Command + C` to copy the selected text

## Step 3: Add SSH Key to Your Move Device

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
   - Replace `YOUR_PUBLIC_KEY_HERE` with the key you copied in Step 2
   - This allows password-free access in the future

3. **Exit the SSH session:**
   ```bash
   exit
   ```

## Step 4: Configure SSH for Easy Access

1. **Create SSH config file:**
   ```bash
   nano ~/.ssh/config
   ```
   - If you prefer TextEdit: `open -a TextEdit ~/.ssh/config`

2. **Add this configuration:**
   ```
   Host move
       HostName move.local
       User ableton
       IdentityFile ~/.ssh/move_key
       StrictHostKeyChecking no
   ```

3. **Save the file:**
   - **In nano:** Press `Control + X`, then `Y`, then `Enter`
   - **In TextEdit:** Press `Command + S`, then close the file

4. **Test the connection:**
   ```bash
   ssh move
   ```
   - You should now connect without entering a password
   - Type `exit` to disconnect

## Step 5: Transfer Files to Your Move

### Using SCP (Secure Copy)

1. **Copy a file TO your Move:**
   ```bash
   scp /path/to/your/file.wav move:/data/UserData/UserLibrary/Samples/
   ```

2. **Copy a file FROM your Move:**
   ```bash
   scp move:/data/UserData/UserLibrary/Samples/file.wav /path/to/destination/
   ```

### Easy File Path Tips for Mac

**Drag and Drop Method:**
1. Type `scp ` (with a space at the end)
2. Drag your file from Finder into Terminal
3. The path will be automatically filled in
4. Continue typing: ` move:/data/UserData/UserLibrary/Samples/`
5. Press Enter

**Common Mac Locations:**
- Desktop: `~/Desktop/filename.wav`
- Downloads: `~/Downloads/filename.wav`
- Documents: `~/Documents/filename.wav`
- Music: `~/Music/filename.wav`

**Example - Copy from Desktop to Move:**
```bash
scp ~/Desktop/mysample.wav move:/data/UserData/UserLibrary/Samples/
```

### Using SFTP (Interactive File Transfer)

1. **Start SFTP session:**
   ```bash
   sftp move
   ```

2. **Common SFTP commands:**
   - `ls` - List files on Move
   - `lls` - List files on your Mac
   - `cd` - Change directory on Move
   - `lcd` - Change directory on your Mac
   - `put filename` - Upload file to Move
   - `get filename` - Download file from Move
   - `quit` - Exit SFTP

**Example SFTP workflow:**
```bash
sftp move
lcd ~/Desktop                    # Go to your Desktop
cd /data/UserData/UserLibrary/Samples/  # Go to Move samples folder
put mysample.wav                 # Upload file
ls                              # Verify it uploaded
quit                            # Exit
```

## Step 6: Install Extending Move Software

### Option A: Use the Automated Script (Recommended)

1. **Download the extending-move project:**
   ```bash
   cd ~/Downloads
   git clone https://github.com/peterswimm/extending-move.git
   cd extending-move
   ```

2. **Run the setup script:**
   ```bash
   ./utility-scripts/setup-ssh-and-install-on-move.command
   ```
   - Double-click the `.command` file in Finder, or
   - Run it from Terminal as shown above

3. **Follow the on-screen instructions**

### Option B: Manual Installation

1. **If you prefer manual control:**
   ```bash
   ./utility-scripts/setup-ssh-and-install-on-move.sh
   ```

## Important File Locations on Move

- **Audio Samples:** `/data/UserData/UserLibrary/Samples/`
- **Preset Samples:** `/data/UserData/UserLibrary/Samples/Preset Samples/`
- **Track Presets:** `/data/UserData/UserLibrary/Track Presets/`
- **Move Sets:** `/data/UserData/UserLibrary/Sets/`

## Advanced: Using Finder with SSH

### Mount Move as Network Drive (Optional)

You can access your Move like a network drive:

1. **In Finder:**
   - Press `Command + K`
   - Enter: `sftp://move.local`
   - Use username: `ableton` and your SSH key

2. **Or using command line:**
   ```bash
   mkdir ~/Desktop/Move
   sshfs move:/data/UserData/UserLibrary ~/Desktop/Move
   ```
   - Install `sshfs` first: `brew install sshfs` (requires Homebrew)

## Transfer Multiple Files

### Copy entire folders:
```bash
scp -r ~/Desktop/MySamplePack/ move:/data/UserData/UserLibrary/Samples/
```

### Copy with rsync (preserves timestamps):
```bash
rsync -av ~/Desktop/MySamplePack/ move:/data/UserData/UserLibrary/Samples/
```

## Tips for Success

1. **Use tab completion** - Type part of a filename and press Tab to complete it
2. **File names are case-sensitive** on the Move device  
3. **Avoid spaces in file names** - use underscores or hyphens instead
4. **Test with a small file first** before transferring large batches
5. **Keep your SSH key safe** - it provides access to your Move device
6. **Use `ls -la`** to see detailed file information including permissions

## Troubleshooting Quick Tips

### If SSH connection fails:
```bash
ssh -v move  # Verbose output for debugging
```

### If file transfer is slow:
```bash
scp -C yourfile.wav move:/path/  # Enable compression
```

### Check what's in a directory:
```bash
ssh move "ls -la /data/UserData/UserLibrary/Samples/"
```

## Next Steps

Once setup is complete, you can:
- Access the Extending Move web interface at `move.local:909`
- Transfer audio files and presets to your Move
- Create custom drum kits and chord sets using the web interface
- Explore advanced Move functionality
- Join the Discord community for tips and tricks

## Need Help?

If you encounter issues, check the [Troubleshooting-Links.md](./Troubleshooting-Links.md) file for solutions to common problems.

## macOS-Specific Notes

- **Gatekeeper:** You may need to allow Terminal or apps to access files
- **Privacy Settings:** Go to System Preferences → Security & Privacy if needed
- **Homebrew:** Consider installing Homebrew for additional tools like `rsync` and `sshfs`
- **Terminal Themes:** Customize Terminal appearance in Preferences for better visibility
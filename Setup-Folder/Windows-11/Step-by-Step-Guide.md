# Step-by-Step Setup Guide for Windows 11

This guide will help you set up SSH access to your Ableton Move and transfer files. No technical experience required!

## What You'll Need

- A Windows 11 computer
- Your Ableton Move connected to the same Wi-Fi network
- The extending-move project files (already downloaded if you're reading this!)

## Step 1: Enable SSH on Windows (if not already enabled)

Windows 11 comes with SSH built-in, but it might need to be enabled:

1. Press `Windows key + R` to open the Run dialog
2. Type `appwiz.cpl` and press Enter
3. Click "Turn Windows features on or off" on the left side
4. Scroll down and check "OpenSSH Client" if it's not already checked
5. Click "OK" and restart if prompted

## Step 2: Open Command Prompt

1. Press `Windows key + R` to open the Run dialog
2. Type `cmd` and press Enter
3. A black window (Command Prompt) will open

## Step 3: Generate SSH Key

In the Command Prompt, type these commands one at a time:

1. Create a folder for SSH keys:
   ```
   mkdir %USERPROFILE%\.ssh
   ```

2. Generate your SSH key:
   ```
   ssh-keygen -t ed25519 -f %USERPROFILE%\.ssh\move_key -N ""
   ```
   
   This creates two files: `move_key` (private key) and `move_key.pub` (public key)

## Step 4: View Your Public Key

Type this command to see your public key:
```
type %USERPROFILE%\.ssh\move_key.pub
```

Copy the entire output (it starts with `ssh-ed25519`). You'll need this in the next step.

## Step 5: Add Your Key to the Move

1. Open your web browser
2. Go to: `http://move.local/development/ssh`
3. Paste your public key into the text box
4. Click "Save"

## Step 6: Test SSH Connection

Back in Command Prompt, test the connection:
```
ssh -i %USERPROFILE%\.ssh\move_key ableton@move.local
```

If this is your first time connecting, type `yes` when asked about the host fingerprint.

You should see a welcome message from your Move. Type `exit` to disconnect.

## Step 7: Transfer Files to Your Move

To copy the extending-move project to your Move:

1. In Command Prompt, navigate to where you downloaded extending-move:
   ```
   cd C:\path\to\your\extending-move\folder
   ```

2. Copy all files to your Move:
   ```
   scp -i %USERPROFILE%\.ssh\move_key -r . ableton@move.local:/data/UserData/extending-move/
   ```

## Step 8: Start the Web Server

Connect to your Move and start the server:

1. Connect via SSH:
   ```
   ssh -i %USERPROFILE%\.ssh\move_key ableton@move.local
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

## Quick Tips

- **Command Prompt not working?** Try running as Administrator (right-click Command Prompt → "Run as administrator")
- **Can't find move.local?** Make sure your Move is on the same Wi-Fi network
- **SSH key issues?** Make sure you copied the entire public key including `ssh-ed25519` at the beginning
- **File transfer taking long?** This is normal for large projects, be patient

You're all set! Your Move now has the extending-move tools installed and ready to use.
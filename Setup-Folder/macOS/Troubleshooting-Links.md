# macOS Troubleshooting Links

If you encounter issues during setup or file transfer, these resources provide reliable solutions for common problems on macOS.

## SSH Connection Problems

### Cannot Connect to move.local

**Problem:** SSH connection fails with "Host not found" or timeout
- **macOS Network Settings:** [Configure Network Settings on Mac](https://support.apple.com/guide/mac-help/change-network-settings-on-mac-mchlp2534/mac) (Apple Support)
- **mDNS Resolution:** [Using .local addresses on Mac](https://support.apple.com/en-us/HT201365) (Apple Support)
- **Network Troubleshooting:** [Fix Network Issues on Mac](https://support.apple.com/en-us/HT202068) (Apple Support)
- **DNS Flush:** [Reset DNS Cache on Mac](https://support.apple.com/en-us/HT202516) (Apple Support)

### SSH Key Authentication Issues

**Problem:** SSH key doesn't work, still asks for password
- **SSH Key Permissions:** [SSH Key Setup on macOS](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent) (GitHub Docs)
- **SSH Agent Issues:** [Using SSH Agent on Mac](https://developer.apple.com/library/archive/technotes/tn2449/_index.html) (Apple Developer)
- **Keychain Integration:** [Add SSH Key to Keychain](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#adding-your-ssh-key-to-the-ssh-agent) (GitHub Docs)

### Permission Denied Errors

**Problem:** "Permission denied" when trying to SSH
- **File Permissions:** [Unix File Permissions Guide](https://www.cyberciti.biz/faq/understanding-unix-linux-file-permissions/) (nixCraft)
- **SSH Troubleshooting:** [SSH Connection Issues](https://www.ssh.com/academy/ssh/troubleshoot) (SSH Academy)
- **macOS Security:** [Allow apps to access files](https://support.apple.com/guide/mac-help/allow-apps-to-access-files-on-your-mac-mchld5a35146/mac) (Apple Support)

## Terminal and Command Line Issues

### Terminal Won't Open or Crashes

**Problem:** Terminal application issues
- **Reset Terminal:** [Reset Terminal Preferences](https://support.apple.com/guide/terminal/reset-terminal-trmlfb8c69be/mac) (Apple Support)
- **Terminal Alternatives:** [iTerm2 Download](https://iterm2.com/) (Popular Terminal alternative)
- **Profile Issues:** [Terminal Profile Problems](https://apple.stackexchange.com/questions/tagged/terminal) (Stack Exchange)

### Command Not Found Errors

**Problem:** `ssh`, `scp`, or other commands not working
- **Xcode Command Line Tools:** [Install Developer Tools](https://developer.apple.com/xcode/resources/) (Apple Developer)
- **PATH Issues:** [Understanding PATH on Mac](https://www.architectryan.com/2012/10/02/add-to-the-path-on-mac-os-x-mountain-lion/) (Architect Ryan)
- **Homebrew Installation:** [Install Homebrew](https://brew.sh/) (Official Homebrew)

### Clipboard and Copy/Paste

**Problem:** Cannot copy SSH key or terminal output
- **Terminal Copy/Paste:** [Use Copy and Paste in Terminal](https://support.apple.com/guide/terminal/copy-and-paste-in-terminal-trmlcopypastetext/mac) (Apple Support)
- **Command Line Clipboard:** [pbcopy and pbpaste commands](https://osxdaily.com/2007/03/05/manipulating-the-clipboard-from-the-command-line/) (OSX Daily)

## File Transfer Issues

### SCP/SFTP Transfer Failures

**Problem:** Files won't copy or transfer is interrupted
- **SCP Usage Guide:** [SCP Command Tutorial](https://linuxize.com/post/how-to-use-scp-command-to-securely-transfer-files/) (Linuxize)
- **SFTP Tutorial:** [SFTP File Transfer Guide](https://www.digitalocean.com/community/tutorials/how-to-use-sftp-to-securely-transfer-files-with-a-remote-server) (DigitalOcean)
- **Large Files:** [rsync for Large File Transfers](https://rsync.samba.org/documentation.html) (Official rsync docs)

### File Path and Permissions

**Problem:** Cannot access files or wrong file paths
- **macOS File System:** [Understanding Mac File Paths](https://support.apple.com/guide/mac-help/organize-files-using-folders-mh26885/mac) (Apple Support)
- **Hidden Files:** [Show Hidden Files on Mac](https://support.apple.com/en-us/HT208757) (Apple Support)
- **File Permissions:** [Change File Permissions on Mac](https://support.apple.com/guide/mac-help/change-permissions-for-files-folders-or-disks-mchlp1203/mac) (Apple Support)

### Drag and Drop Not Working

**Problem:** Cannot drag files from Finder to Terminal
- **Terminal Preferences:** [Terminal Window Settings](https://support.apple.com/guide/terminal/change-terminal-window-settings-trmlwindwset/mac) (Apple Support)
- **Accessibility:** [Grant Terminal Full Disk Access](https://support.apple.com/guide/mac-help/allow-accessibility-apps-to-access-your-mac-mh43185/mac) (Apple Support)

## Network and Connectivity

### WiFi and Network Issues

**Problem:** Mac cannot find or connect to Move device
- **WiFi Diagnostics:** [Use Wireless Diagnostics](https://support.apple.com/en-us/HT202663) (Apple Support)
- **Network Locations:** [Use Network Locations on Mac](https://support.apple.com/guide/mac-help/use-network-locations-on-mac-mchlp2292/mac) (Apple Support)
- **Router Issues:** [Basic Router Troubleshooting](https://support.apple.com/en-us/HT201444) (Apple Support)

### Firewall and Security

**Problem:** Connection blocked by macOS security features
- **macOS Firewall:** [Configure Firewall on Mac](https://support.apple.com/guide/mac-help/block-connections-to-your-mac-with-a-firewall-mh34041/mac) (Apple Support)
- **Privacy Settings:** [Privacy and Security Settings](https://support.apple.com/guide/mac-help/change-privacy-preferences-on-mac-mchld941ba68/mac) (Apple Support)
- **Gatekeeper:** [Allow Apps from Unidentified Developers](https://support.apple.com/en-us/HT202491) (Apple Support)

### mDNS and Bonjour Issues

**Problem:** .local addresses don't resolve
- **Bonjour Service:** [Troubleshoot Bonjour on Mac](https://support.apple.com/en-us/HT202480) (Apple Support)
- **mDNS Troubleshooting:** [mDNS Resolution Issues](https://developer.apple.com/library/archive/qa/qa1312/_index.html) (Apple Developer)

## Software Installation Issues

### Git Installation Problems

**Problem:** git command not found or fails
- **Install Git:** [Git for Mac](https://git-scm.com/download/mac) (Official Git)
- **Xcode Command Line Tools:** [Install Xcode CLI Tools](https://mac.install.guide/commandlinetools/index.html) (Mac Install Guide)
- **GitHub Desktop:** [GitHub Desktop for Mac](https://desktop.github.com/) (Alternative GUI)

### Python and Dependencies

**Problem:** extending-move installation fails due to Python issues
- **Python on Mac:** [Python Installation Guide](https://docs.python-guide.org/starting/install3/osx/) (Python Guide)
- **Homebrew Python:** [Install Python via Homebrew](https://brew.sh/) (Homebrew)
- **Virtual Environments:** [Python Virtual Environments](https://docs.python.org/3/tutorial/venv.html) (Python.org)

### Package Manager Issues

**Problem:** Homebrew or other tools won't install
- **Install Homebrew:** [Homebrew Installation](https://brew.sh/) (Official Homebrew)
- **Homebrew Troubleshooting:** [Homebrew FAQ](https://docs.brew.sh/FAQ) (Homebrew Docs)
- **MacPorts Alternative:** [MacPorts](https://www.macports.org/) (Alternative package manager)

## Ableton Move Specific Issues

### Move Device Not Responding

**Problem:** Move device seems frozen or unresponsive
- **Move Recovery Guide:** [Ableton Move Recovery Procedures](https://ableton.centercode.com/) (Center Code - requires account)
- **Network Reset:** Restart your router and Move device
- **Factory Reset:** Contact Ableton Support for guidance

### extending-move Web Interface Issues

**Problem:** Cannot access move.local:909
- **Browser Issues:** [Clear Safari Cache](https://support.apple.com/guide/safari/clear-your-browsing-history-sfri47acf5d6/mac) (Apple Support)
- **Port Conflicts:** [Check Network Port Usage](https://apple.stackexchange.com/questions/117644/how-can-i-list-my-open-network-ports-with-netstat) (Stack Exchange)
- **Alternative Browsers:** Try Chrome, Firefox, or Edge

### File Format Issues

**Problem:** Audio files not recognized by Move
- **Audio Formats:** Supported formats are WAV, AIFF (16/24-bit, 44.1/48 kHz)
- **Convert Audio:** [Convert Audio Files on Mac](https://support.apple.com/guide/quicktime-player/convert-media-files-qtpb645e52ca/mac) (Apple Support)
- **Third-party Tools:** [Audacity](https://www.audacityteam.org/) (Free audio editor)

## System-Level Issues

### macOS Version Compatibility

**Problem:** Tools don't work with your macOS version
- **Check macOS Version:** [Find macOS Version](https://support.apple.com/en-us/HT201260) (Apple Support)
- **Update macOS:** [Update macOS](https://support.apple.com/en-us/HT201541) (Apple Support)
- **Compatibility Issues:** [Legacy macOS Support](https://support.apple.com/macos) (Apple Support)

### Disk Space and Storage

**Problem:** Not enough space for files or installations
- **Check Storage:** [Check Available Storage](https://support.apple.com/guide/mac-help/check-available-storage-on-your-mac-mh27903/mac) (Apple Support)
- **Free Up Space:** [Free Up Storage Space](https://support.apple.com/en-us/HT206996) (Apple Support)
- **External Storage:** [Use External Drives](https://support.apple.com/guide/mac-help/use-external-storage-devices-mh15130/mac) (Apple Support)

### Performance Issues

**Problem:** Mac runs slowly during file transfers
- **Activity Monitor:** [Use Activity Monitor](https://support.apple.com/guide/activity-monitor/welcome/mac) (Apple Support)
- **Memory Issues:** [About Memory Usage](https://support.apple.com/en-us/HT201538) (Apple Support)
- **CPU Usage:** [Reduce CPU Usage](https://www.macworld.com/article/668927/how-to-fix-high-cpu-usage-on-mac.html) (Macworld)

## Development and Advanced Tools

### Advanced SSH Configuration

**Problem:** Need more complex SSH setup
- **SSH Config Guide:** [Advanced SSH Configuration](https://www.ssh.com/academy/ssh/config) (SSH Academy)
- **Key Management:** [SSH Key Management Best Practices](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/working-with-ssh-key-passphrases) (GitHub Docs)
- **SSH Tunneling:** [SSH Port Forwarding](https://www.ssh.com/academy/ssh/tunneling-example) (SSH Academy)

### File System Tools

**Problem:** Need advanced file management tools
- **FUSE for macOS:** [macFUSE](https://osxfuse.github.io/) (Enable FUSE file systems)
- **SSHFS:** [SSHFS for Mac](https://github.com/osxfuse/sshfs) (Mount remote file systems)
- **Command Line Tools:** [Advanced Unix Tools](https://www.cyberciti.biz/tips/top-linux-monitoring-tools.html) (nixCraft)

## Emergency Recovery

### If Things Go Wrong

**Problem:** Move device seems broken or corrupted
- **⚠️ Important:** Do NOT attempt firmware modifications
- **Contact Ableton:** [Ableton Support](https://www.ableton.com/en/help/contact-support/)
- **Recovery Information:** Available through Center Code (requires Ableton account)
- **Backup Strategy:** [Time Machine Backup](https://support.apple.com/en-us/HT201250) (Apple Support)

### System Recovery

**Problem:** Mac system issues after modifications
- **Safe Mode:** [Start Mac in Safe Mode](https://support.apple.com/guide/mac-help/start-up-your-mac-in-safe-mode-mh21245/mac) (Apple Support)
- **Recovery Mode:** [macOS Recovery](https://support.apple.com/guide/mac-help/use-macos-recovery-on-an-intel-based-mac-mchl338cf9a8/mac) (Apple Support)
- **Reset NVRAM:** [Reset NVRAM on Mac](https://support.apple.com/en-us/HT204063) (Apple Support)

## Additional Resources

### Video Tutorials
- [YouTube: extending-move Demo](https://www.youtube.com/watch?v=MCmaCifzgbg)
- [YouTube: Quick Installation Video](https://youtu.be/gPiR7Zyu3lc)
- [YouTube: Terminal Basics for Mac](https://www.youtube.com/results?search_query=mac+terminal+basics)

### Documentation
- [extending-move Wiki](https://github.com/charlesvestal/extending-move/wiki)
- [Ableton Move Manual](https://www.ableton.com/en/manual/move/) (Official)
- [macOS User Guide](https://support.apple.com/guide/mac-help/) (Apple Support)

### Community
- [extending-move GitHub](https://github.com/peterswimm/extending-move)
- [Discord Community](https://discord.gg/yP7SjqDrZG)
- [r/ableton Subreddit](https://www.reddit.com/r/ableton/)
- [Mac Forums](https://discussions.apple.com/community/mac_os) (Apple Discussions)

### macOS-Specific Communities
- [MacRumors Forums](https://forums.macrumors.com/)
- [r/MacOS Subreddit](https://www.reddit.com/r/MacOS/)
- [Stack Exchange - Ask Different](https://apple.stackexchange.com/)

## Disclaimer

These resources are provided for informational purposes. Always refer to official Apple and Ableton documentation when possible. The extending-move project and its contributors are not responsible for any issues that may arise from following these guides.
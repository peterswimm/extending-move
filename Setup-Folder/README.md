# Setup Guide for Extending Move

Welcome to the Extending Move setup guides! This folder contains platform-specific instructions to help you get started with extending your Ableton Move.

## Quick Start

Choose your operating system and follow the appropriate guide:

### 🪟 [Windows 11](Windows-11/)
- [Step-by-Step Guide](Windows-11/Step-by-Step-Guide.md) - Complete setup using WSL
- [Troubleshooting](Windows-11/Troubleshooting-Links.md) - WSL, SSH, and network issues

### 🍎 [macOS](macOS/)
- [Step-by-Step Guide](macOS/Step-by-Step-Guide.md) - Native macOS setup with Homebrew
- [Troubleshooting](macOS/Troubleshooting-Links.md) - Bonjour, SSH, and Keychain issues

### 🐧 [Linux](Linux/)
- [Step-by-Step Guide](Linux/Step-by-Step-Guide.md) - Multi-distribution support
- [Troubleshooting](Linux/Troubleshooting-Links.md) - Avahi, SSH, and network configuration

## What You'll Learn

Each guide covers:

✅ **Prerequisites installation** - Required tools and dependencies for your platform  
✅ **SSH key generation and configuration** - Secure connection to your Move  
✅ **Network setup** - Connecting to move.local and troubleshooting discovery  
✅ **File transfer with SCP** - Uploading samples and presets to your Move  
✅ **Automated installation** - Using the provided setup scripts  
✅ **Verification steps** - Confirming everything works correctly  

## Before You Start

⚠️ **Important**: These tools require SSH access to your Ableton Move and are not officially supported by Ableton. Please read the disclaimer in the main [README](../README.md) before proceeding.

## Getting Help

If you encounter issues:

1. Check the troubleshooting guide for your platform
2. Join our [Discord community](https://discord.gg/yP7SjqDrZG) for real-time help
3. Search or create an issue on [GitHub](https://github.com/peterswimm/extending-move/issues)

## What's Next?

After completing setup, you'll be able to access the Extending Move web interface at `http://move.local:909` to:

- Upload and restore Move Sets
- Edit presets and parameters
- Create drum kits from audio files
- Generate MIDI patterns
- And much more!

---

*For detailed project information, see the main [README](../README.md) and [documentation](../docs/).*
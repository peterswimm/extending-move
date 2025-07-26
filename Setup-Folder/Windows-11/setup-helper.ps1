# Windows 11 Setup Helper for Extending Move
# This script automates the setup process for Windows 11 users

param(
    [string]$MoveAddress = "move.local",
    [switch]$SkipWSL = $false
)

# Check if running as Administrator
function Test-Administrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Main script
Write-Host "=== Extending Move Setup Helper for Windows 11 ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "This script will automate the setup process by:" -ForegroundColor Yellow
Write-Host "1. Installing Windows Subsystem for Linux (WSL) if needed"
Write-Host "2. Setting up the Linux environment inside WSL"
Write-Host "3. Running the extending-move installation"
Write-Host ""

# Check administrator privileges for WSL installation
if (-not $SkipWSL) {
    if (-not (Test-Administrator)) {
        Write-Host "ERROR: This script needs to be run as Administrator to install WSL." -ForegroundColor Red
        Write-Host "Please run PowerShell as Administrator and try again." -ForegroundColor Red
        Write-Host ""
        Write-Host "Alternatively, if WSL is already installed, you can run:" -ForegroundColor Yellow
        Write-Host "  .\setup-helper.ps1 -SkipWSL" -ForegroundColor Yellow
        exit 1
    }
}

# Install WSL if needed
if (-not $SkipWSL) {
    Write-Host "Checking WSL installation..." -ForegroundColor Green
    
    try {
        $wslStatus = wsl --status 2>&1
        if ($LASTEXITCODE -ne 0) {
            Write-Host "Installing WSL..." -ForegroundColor Yellow
            wsl --install
            Write-Host ""
            Write-Host "WSL installation completed!" -ForegroundColor Green
            Write-Host "Please restart your computer and run this script again with -SkipWSL flag." -ForegroundColor Yellow
            Write-Host ""
            Write-Host "After restart, run: .\setup-helper.ps1 -SkipWSL" -ForegroundColor Cyan
            exit 0
        } else {
            Write-Host "WSL is already installed." -ForegroundColor Green
        }
    } catch {
        Write-Host "Installing WSL..." -ForegroundColor Yellow
        wsl --install
        Write-Host ""
        Write-Host "WSL installation completed!" -ForegroundColor Green
        Write-Host "Please restart your computer and run this script again with -SkipWSL flag." -ForegroundColor Yellow
        exit 0
    }
}

# Create the Linux setup script content
$linuxSetupScript = @'
#!/bin/bash
set -euo pipefail

echo "=== Setting up Extending Move in WSL ==="
echo ""

# Update package list
echo "Updating package list..."
sudo apt update

# Install required packages
echo "Installing required packages..."
sudo apt install -y git openssh-client python3 python3-pip curl

# Clone the repository if it doesn't exist
if [ ! -d "extending-move" ]; then
    echo "Cloning extending-move repository..."
    git clone https://github.com/peterswimm/extending-move.git
    cd extending-move
else
    echo "Repository already exists, updating..."
    cd extending-move
    git pull
fi

# Test connection to Move
echo ""
echo "Testing connection to Move..."
if ping -c 1 "$1" > /dev/null 2>&1; then
    echo "✓ Successfully connected to Move at $1"
else
    echo "⚠ Warning: Could not reach Move at $1"
    echo "  Make sure your Move is connected to the same network"
    echo "  You can continue with setup and test the connection later"
fi

echo ""
echo "Running the automated SSH setup and installation..."
echo "This will:"
echo "- Generate SSH keys for secure connection to your Move"
echo "- Configure SSH settings"
echo "- Install extending-move on your Move"
echo ""

# Make the setup script executable and run it
chmod +x utility-scripts/setup-ssh-and-install-on-move.sh
./utility-scripts/setup-ssh-and-install-on-move.sh

echo ""
echo "=== Setup Complete! ==="
echo ""
echo "Your extending-move installation should now be ready."
echo "You can access the web interface by opening a browser and going to:"
echo "  http://$1:909"
echo ""
echo "If you need to restart the server on your Move, you can run:"
echo "  ssh ableton@$1 'sudo systemctl restart extending-move'"
echo ""
'@

# Write the Linux script to a temporary file
$tempScriptPath = [System.IO.Path]::GetTempFileName() + ".sh"
$linuxSetupScript | Out-File -FilePath $tempScriptPath -Encoding UTF8

# Copy the script to WSL and run it
Write-Host ""
Write-Host "Setting up extending-move in WSL..." -ForegroundColor Green
Write-Host "This may take several minutes..." -ForegroundColor Yellow
Write-Host ""

try {
    # Copy script to WSL home directory
    wsl cp $tempScriptPath ~/extending-move-setup.sh
    
    # Make it executable and run it
    wsl chmod +x ~/extending-move-setup.sh
    wsl ~/extending-move-setup.sh $MoveAddress
    
    # Clean up
    Remove-Item $tempScriptPath -Force
    wsl rm ~/extending-move-setup.sh
    
    Write-Host ""
    Write-Host "=== Windows 11 Setup Complete! ===" -ForegroundColor Green
    Write-Host ""
    Write-Host "You can now access extending-move through WSL or directly from Windows:" -ForegroundColor Cyan
    Write-Host "- Web interface: http://$MoveAddress`:909" -ForegroundColor Yellow
    Write-Host "- WSL terminal: wsl" -ForegroundColor Yellow
    Write-Host "- Repository location: ~/extending-move (in WSL)" -ForegroundColor Yellow
    Write-Host ""
    
} catch {
    Write-Host "Error during setup: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    Write-Host "You may need to:" -ForegroundColor Yellow
    Write-Host "1. Ensure WSL is properly installed and configured"
    Write-Host "2. Check that your Move is connected to the network"
    Write-Host "3. Try running the manual setup steps from the guide"
    exit 1
}
# Move Display Mod for Norns

This mod automatically redirects all Norns display output to a Move device running the extending-move server.

## Installation

1. **On Move device**: Make sure extending-move is running with the universal display support
2. **On Norns**: Install this mod

### Manual Installation

1. SSH into your Norns:
   ```bash
   ssh we@norns.local
   ```

2. Create mod directory:
   ```bash
   mkdir -p /home/we/dust/code/move-display/lib/
   ```

3. Copy `move-display.lua` to:
   ```bash
   /home/we/dust/code/move-display/lib/mod.lua
   ```

4. Enable the mod:
   - Go to SYSTEM > MODS on your Norns
   - Find "move-display" and enable it
   - Restart Norns

## Configuration

The mod will automatically detect Move devices on your network. You can configure:

- **Host**: IP address of your Move device (default: "move.local")
- **Port**: OSC port (default: 10111)
- **Enable/Disable**: Toggle display mirroring on/off

Access configuration through: SYSTEM > MODS > move-display

## Usage

Once installed and enabled:

1. **Automatic**: All scripts will automatically display on Move
2. **Manual Toggle**: Use the mod menu to enable/disable
3. **Original Display**: Norns screen continues to work normally

## Testing

Test with any Norns script that uses screen drawing commands:

```lua
-- Simple test
screen.clear()
screen.level(15)
screen.move(64, 32)
screen.text_center("HELLO MOVE!")
screen.update()
```

The text should appear both on Norns and on your Move display at http://move.local:909/display

## Troubleshooting

1. **No display on Move**: 
   - Check network connection
   - Verify Move server is running on port 909
   - Check mod is enabled in SYSTEM > MODS

2. **OSC errors**:
   - Try changing the port in mod configuration
   - Check firewall settings on Move device

3. **Performance issues**:
   - Reduce drawing complexity in scripts
   - Use `screen.update()` sparingly for better performance

## Technical Details

The mod works by:
1. Intercepting all `screen.*` function calls
2. Sending equivalent OSC messages to Move device  
3. Still calling original functions for local display
4. Zero code changes required in existing scripts

OSC messages are sent to `/screen/*` endpoints matching Norns screen API exactly.
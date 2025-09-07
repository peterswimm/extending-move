#!/usr/bin/env python3
"""M8C serial protocol parser and encoder."""

import struct
from typing import Dict, List, Optional, Tuple, Union
import logging

logger = logging.getLogger(__name__)

# M8C command types
DRAW_RECT = 0xFE
DRAW_CHAR = 0xFD
DRAW_OSC = 0xFC
JOYPAD_STATE = 0xFB
SYSTEM_INFO = 0xFF

# M8 key codes for input
M8_KEYS = {
    'up': 0x01,
    'down': 0x02,
    'left': 0x04,
    'right': 0x08,
    'shift': 0x10,
    'play': 0x20,
    'option': 0x40,
    'edit': 0x80
}

# Display dimensions
DISPLAY_MK1 = {'width': 320, 'height': 240}
DISPLAY_MK2 = {'width': 480, 'height': 320}


class M8CProtocol:
    """Parser and encoder for M8C serial protocol."""
    
    def __init__(self, model='MK1'):
        """Initialize protocol handler.
        
        Args:
            model: 'MK1' or 'MK2' to set display dimensions
        """
        self.model = model
        self.display = DISPLAY_MK1 if model == 'MK1' else DISPLAY_MK2
        self.buffer = bytearray()
        
    def parse_command(self, data: bytes) -> Optional[Dict]:
        """Parse M8C serial command into dictionary.
        
        Args:
            data: Raw bytes from serial port
            
        Returns:
            Parsed command dictionary or None if incomplete
        """
        self.buffer.extend(data)
        
        while len(self.buffer) > 0:
            cmd_type = self.buffer[0]
            
            if cmd_type == DRAW_RECT:
                result = self._parse_draw_rect()
            elif cmd_type == DRAW_CHAR:
                result = self._parse_draw_char()
            elif cmd_type == DRAW_OSC:
                result = self._parse_draw_osc()
            elif cmd_type == JOYPAD_STATE:
                result = self._parse_joypad_state()
            elif cmd_type == SYSTEM_INFO:
                result = self._parse_system_info()
            else:
                # Unknown command, skip byte
                logger.warning(f"Unknown command: 0x{cmd_type:02X}")
                self.buffer.pop(0)
                continue
                
            if result:
                return result
            else:
                # Need more data
                break
                
        return None
    
    def _parse_draw_rect(self) -> Optional[Dict]:
        """Parse draw rectangle command."""
        # Variable length command
        if len(self.buffer) < 2:
            return None
            
        # Second byte indicates rect type
        rect_type = self.buffer[1]
        
        if rect_type == 0:  # Filled rectangle
            if len(self.buffer) < 9:
                return None
            x = struct.unpack('<H', self.buffer[2:4])[0]
            y = struct.unpack('<H', self.buffer[4:6])[0]
            w = struct.unpack('<H', self.buffer[6:8])[0]
            h = self.buffer[8]
            color = self._get_default_color()
            
            self.buffer = self.buffer[9:]
            
            return {
                'type': 'rect',
                'x': x,
                'y': y,
                'width': w,
                'height': h,
                'color': color,
                'filled': True
            }
        elif rect_type == 1:  # Outlined rectangle
            if len(self.buffer) < 10:
                return None
            x = struct.unpack('<H', self.buffer[2:4])[0]
            y = struct.unpack('<H', self.buffer[4:6])[0]
            w = struct.unpack('<H', self.buffer[6:8])[0]
            h = struct.unpack('<H', self.buffer[8:10])[0]
            color = self._get_default_color()
            
            self.buffer = self.buffer[10:]
            
            return {
                'type': 'rect',
                'x': x,
                'y': y,
                'width': w,
                'height': h,
                'color': color,
                'filled': False
            }
        else:
            # Extended format with color
            if len(self.buffer) < 13:
                return None
            x = struct.unpack('<H', self.buffer[2:4])[0]
            y = struct.unpack('<H', self.buffer[4:6])[0]
            w = struct.unpack('<H', self.buffer[6:8])[0]
            h = struct.unpack('<H', self.buffer[8:10])[0]
            r = self.buffer[10]
            g = self.buffer[11]
            b = self.buffer[12]
            
            self.buffer = self.buffer[13:]
            
            return {
                'type': 'rect',
                'x': x,
                'y': y,
                'width': w,
                'height': h,
                'color': {'r': r, 'g': g, 'b': b},
                'filled': rect_type == 2
            }
    
    def _parse_draw_char(self) -> Optional[Dict]:
        """Parse draw character command."""
        if len(self.buffer) < 12:
            return None
            
        char = chr(self.buffer[1])
        x = struct.unpack('<H', self.buffer[2:4])[0]
        y = struct.unpack('<H', self.buffer[4:6])[0]
        fg_r = self.buffer[6]
        fg_g = self.buffer[7]
        fg_b = self.buffer[8]
        bg_r = self.buffer[9]
        bg_g = self.buffer[10]
        bg_b = self.buffer[11]
        
        self.buffer = self.buffer[12:]
        
        return {
            'type': 'char',
            'char': char,
            'x': x,
            'y': y,
            'fg_color': {'r': fg_r, 'g': fg_g, 'b': fg_b},
            'bg_color': {'r': bg_r, 'g': bg_g, 'b': bg_b}
        }
    
    def _parse_draw_osc(self) -> Optional[Dict]:
        """Parse draw oscilloscope command."""
        if len(self.buffer) < 2:
            return None
            
        # Get waveform data length
        length = self.buffer[1]
        
        if len(self.buffer) < 2 + length + 3:
            return None
            
        waveform = list(self.buffer[2:2+length])
        r = self.buffer[2+length]
        g = self.buffer[2+length+1]
        b = self.buffer[2+length+2]
        
        self.buffer = self.buffer[2+length+3:]
        
        return {
            'type': 'oscilloscope',
            'waveform': waveform,
            'color': {'r': r, 'g': g, 'b': b}
        }
    
    def _parse_joypad_state(self) -> Optional[Dict]:
        """Parse joypad state message."""
        if len(self.buffer) < 3:
            return None
            
        state = self.buffer[1]
        state2 = self.buffer[2]
        
        self.buffer = self.buffer[3:]
        
        return {
            'type': 'joypad',
            'state': state,
            'state2': state2
        }
    
    def _parse_system_info(self) -> Optional[Dict]:
        """Parse system info message."""
        if len(self.buffer) < 6:
            return None
            
        hardware_model = self.buffer[1]
        firmware_major = self.buffer[2]
        firmware_minor = self.buffer[3]
        firmware_patch = self.buffer[4]
        font = self.buffer[5]
        
        self.buffer = self.buffer[6:]
        
        return {
            'type': 'system_info',
            'hardware_model': hardware_model,
            'firmware_version': f"{firmware_major}.{firmware_minor}.{firmware_patch}",
            'font': font
        }
    
    def encode_input(self, keys: List[str]) -> bytes:
        """Encode keyboard input for M8.
        
        Args:
            keys: List of pressed keys ('up', 'down', 'left', 'right', 'shift', 'play', 'option', 'edit')
            
        Returns:
            Encoded bytes to send to M8
        """
        state = 0
        for key in keys:
            if key in M8_KEYS:
                state |= M8_KEYS[key]
        
        # M8 expects input in specific format
        # This may need adjustment based on actual M8 protocol
        return bytes([JOYPAD_STATE, state, 0])
    
    def encode_key_event(self, key: str, pressed: bool) -> bytes:
        """Encode a single key press/release event.
        
        Args:
            key: Key name
            pressed: True for press, False for release
            
        Returns:
            Encoded bytes to send to M8
        """
        if key not in M8_KEYS:
            return b''
            
        # Encode as key event
        # Format may vary based on M8 firmware
        key_code = M8_KEYS[key]
        event_type = 0x01 if pressed else 0x00
        
        return bytes([JOYPAD_STATE, event_type, key_code])
    
    def _get_default_color(self) -> Dict[str, int]:
        """Get default color for monochrome display."""
        return {'r': 255, 'g': 255, 'b': 255}
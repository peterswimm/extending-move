#!/usr/bin/env python3
"""Norns display proxy - intercepts and translates Norns screen commands."""

import re
import logging
import threading
import time
from typing import Optional, Dict, Callable, Any
from pythonosc import dispatcher, osc_server, udp_client
import socket

logger = logging.getLogger(__name__)


class NornsDisplayProxy:
    """Proxy for Norns display commands over OSC."""
    
    def __init__(self, emit_callback: Optional[Callable] = None, osc_port: int = 10111):
        """Initialize Norns display proxy.
        
        Args:
            emit_callback: Function to emit WebSocket messages
            osc_port: Port to listen for OSC messages (default 10111)
        """
        self.emit_callback = emit_callback
        self.osc_port = osc_port
        self.server = None
        self.server_thread = None
        self.running = False
        
        # Norns display state (128x64 monochrome)
        self.display_state = {
            'width': 128,
            'height': 64,
            'level': 15,  # 0-15 brightness levels
            'x': 0,
            'y': 0,
            'rect': None,
            'path': [],
            'aa': False,  # anti-aliasing
            'line_width': 1
        }
        
        # OSC dispatcher
        self.dispatcher = dispatcher.Dispatcher()
        self._setup_osc_handlers()
        
        # For sending responses back to Norns
        self.norns_client = None
        
    def _setup_osc_handlers(self):
        """Setup OSC message handlers for Norns screen commands."""
        
        # Screen commands
        self.dispatcher.map("/screen/clear", self._handle_clear)
        self.dispatcher.map("/screen/level", self._handle_level)
        self.dispatcher.map("/screen/move", self._handle_move)
        self.dispatcher.map("/screen/move_rel", self._handle_move_rel)
        self.dispatcher.map("/screen/line", self._handle_line)
        self.dispatcher.map("/screen/line_rel", self._handle_line_rel)
        self.dispatcher.map("/screen/rect", self._handle_rect)
        self.dispatcher.map("/screen/circle", self._handle_circle)
        self.dispatcher.map("/screen/text", self._handle_text)
        self.dispatcher.map("/screen/text_center", self._handle_text_center)
        self.dispatcher.map("/screen/text_right", self._handle_text_right)
        self.dispatcher.map("/screen/fill", self._handle_fill)
        self.dispatcher.map("/screen/stroke", self._handle_stroke)
        self.dispatcher.map("/screen/pixel", self._handle_pixel)
        self.dispatcher.map("/screen/update", self._handle_update)
        self.dispatcher.map("/screen/aa", self._handle_aa)
        self.dispatcher.map("/screen/line_width", self._handle_line_width)
        self.dispatcher.map("/screen/font_face", self._handle_font_face)
        self.dispatcher.map("/screen/font_size", self._handle_font_size)
        
        # Alternative command format (for direct Lua bridge)
        self.dispatcher.map("/remote/screen/*", self._handle_lua_command)
        
        # Catch-all for debugging
        self.dispatcher.set_default_handler(self._handle_default)
        
    def start(self):
        """Start the OSC server."""
        try:
            # Find available port if default is taken
            port = self.osc_port
            max_attempts = 10
            
            for attempt in range(max_attempts):
                try:
                    self.server = osc_server.ThreadingOSCUDPServer(
                        ('0.0.0.0', port), 
                        self.dispatcher
                    )
                    self.osc_port = port
                    break
                except OSError:
                    port += 1
                    if attempt == max_attempts - 1:
                        raise
            
            self.running = True
            self.server_thread = threading.Thread(
                target=self.server.serve_forever,
                daemon=True
            )
            self.server_thread.start()
            
            logger.info(f"Norns OSC server started on port {self.osc_port}")
            
            # Announce service via OSC
            self._announce_service()
            
        except Exception as e:
            logger.error(f"Failed to start Norns OSC server: {e}")
            
    def stop(self):
        """Stop the OSC server."""
        self.running = False
        if self.server:
            self.server.shutdown()
            self.server_thread.join(timeout=1)
            logger.info("Norns OSC server stopped")
            
    def _emit_display_command(self, cmd: Dict[str, Any]):
        """Emit display command via WebSocket."""
        if self.emit_callback:
            self.emit_callback('display_command', cmd)
            
    def _level_to_color(self, level: int) -> Dict[str, int]:
        """Convert Norns level (0-15) to RGB color."""
        # Norns uses 16 brightness levels
        brightness = int((level / 15) * 255)
        return {'r': brightness, 'g': brightness, 'b': brightness}
        
    # OSC Handlers
    
    def _handle_clear(self, addr, *args):
        """Handle screen.clear()"""
        self._emit_display_command({'type': 'clear'})
        self.display_state['path'] = []
        
    def _handle_level(self, addr, *args):
        """Handle screen.level(brightness)"""
        if args:
            self.display_state['level'] = min(15, max(0, int(args[0])))
            
    def _handle_move(self, addr, *args):
        """Handle screen.move(x, y)"""
        if len(args) >= 2:
            self.display_state['x'] = int(args[0])
            self.display_state['y'] = int(args[1])
            self.display_state['path'] = [(self.display_state['x'], self.display_state['y'])]
            
    def _handle_move_rel(self, addr, *args):
        """Handle screen.move_rel(x, y)"""
        if len(args) >= 2:
            self.display_state['x'] += int(args[0])
            self.display_state['y'] += int(args[1])
            self.display_state['path'].append((self.display_state['x'], self.display_state['y']))
            
    def _handle_line(self, addr, *args):
        """Handle screen.line(x, y)"""
        if len(args) >= 2:
            x2, y2 = int(args[0]), int(args[1])
            color = self._level_to_color(self.display_state['level'])
            
            self._emit_display_command({
                'type': 'line',
                'x1': self.display_state['x'],
                'y1': self.display_state['y'],
                'x2': x2,
                'y2': y2,
                'color': color
            })
            
            self.display_state['x'] = x2
            self.display_state['y'] = y2
            self.display_state['path'].append((x2, y2))
            
    def _handle_line_rel(self, addr, *args):
        """Handle screen.line_rel(x, y)"""
        if len(args) >= 2:
            x2 = self.display_state['x'] + int(args[0])
            y2 = self.display_state['y'] + int(args[1])
            self._handle_line(addr, x2, y2)
            
    def _handle_rect(self, addr, *args):
        """Handle screen.rect(x, y, w, h)"""
        if len(args) >= 4:
            self.display_state['rect'] = {
                'x': int(args[0]),
                'y': int(args[1]),
                'width': int(args[2]),
                'height': int(args[3])
            }
            
    def _handle_circle(self, addr, *args):
        """Handle screen.circle(x, y, r)"""
        if len(args) >= 3:
            self.display_state['circle'] = {
                'x': int(args[0]),
                'y': int(args[1]),
                'radius': int(args[2])
            }
            
    def _handle_text(self, addr, *args):
        """Handle screen.text(string)"""
        if args:
            text = str(args[0])
            color = self._level_to_color(self.display_state['level'])
            
            self._emit_display_command({
                'type': 'text',
                'x': self.display_state['x'],
                'y': self.display_state['y'],
                'text': text,
                'fg_color': color,
                'bg_color': {'r': 0, 'g': 0, 'b': 0}
            })
            
    def _handle_text_center(self, addr, *args):
        """Handle screen.text_center(string)"""
        if args:
            text = str(args[0])
            # Calculate center position
            text_width = len(text) * 6  # Approximate
            x = (128 - text_width) // 2
            
            color = self._level_to_color(self.display_state['level'])
            
            self._emit_display_command({
                'type': 'text',
                'x': x,
                'y': self.display_state['y'],
                'text': text,
                'fg_color': color,
                'bg_color': {'r': 0, 'g': 0, 'b': 0}
            })
            
    def _handle_text_right(self, addr, *args):
        """Handle screen.text_right(string)"""
        if args:
            text = str(args[0])
            # Calculate right-aligned position
            text_width = len(text) * 6  # Approximate
            x = 128 - text_width
            
            color = self._level_to_color(self.display_state['level'])
            
            self._emit_display_command({
                'type': 'text',
                'x': x,
                'y': self.display_state['y'],
                'text': text,
                'fg_color': color,
                'bg_color': {'r': 0, 'g': 0, 'b': 0}
            })
            
    def _handle_fill(self, addr, *args):
        """Handle screen.fill()"""
        color = self._level_to_color(self.display_state['level'])
        
        if self.display_state.get('rect'):
            rect = self.display_state['rect']
            self._emit_display_command({
                'type': 'rect',
                'x': rect['x'],
                'y': rect['y'],
                'width': rect['width'],
                'height': rect['height'],
                'color': color,
                'filled': True
            })
            self.display_state['rect'] = None
            
        elif self.display_state.get('circle'):
            circle = self.display_state['circle']
            self._emit_display_command({
                'type': 'circle',
                'x': circle['x'],
                'y': circle['y'],
                'radius': circle['radius'],
                'color': color,
                'filled': True
            })
            self.display_state['circle'] = None
            
    def _handle_stroke(self, addr, *args):
        """Handle screen.stroke()"""
        color = self._level_to_color(self.display_state['level'])
        
        if self.display_state.get('rect'):
            rect = self.display_state['rect']
            self._emit_display_command({
                'type': 'rect',
                'x': rect['x'],
                'y': rect['y'],
                'width': rect['width'],
                'height': rect['height'],
                'color': color,
                'filled': False
            })
            self.display_state['rect'] = None
            
        elif self.display_state.get('circle'):
            circle = self.display_state['circle']
            self._emit_display_command({
                'type': 'circle',
                'x': circle['x'],
                'y': circle['y'],
                'radius': circle['radius'],
                'color': color,
                'filled': False
            })
            self.display_state['circle'] = None
            
        elif len(self.display_state['path']) > 1:
            # Draw path as series of lines
            path = self.display_state['path']
            for i in range(1, len(path)):
                self._emit_display_command({
                    'type': 'line',
                    'x1': path[i-1][0],
                    'y1': path[i-1][1],
                    'x2': path[i][0],
                    'y2': path[i][1],
                    'color': color
                })
            
    def _handle_pixel(self, addr, *args):
        """Handle screen.pixel(x, y)"""
        if len(args) >= 2:
            color = self._level_to_color(self.display_state['level'])
            self._emit_display_command({
                'type': 'pixel',
                'x': int(args[0]),
                'y': int(args[1]),
                'color': color
            })
            
    def _handle_update(self, addr, *args):
        """Handle screen.update()"""
        self._emit_display_command({'type': 'update'})
        
    def _handle_aa(self, addr, *args):
        """Handle screen.aa(state)"""
        if args:
            self.display_state['aa'] = bool(args[0])
            
    def _handle_line_width(self, addr, *args):
        """Handle screen.line_width(w)"""
        if args:
            self.display_state['line_width'] = float(args[0])
            
    def _handle_font_face(self, addr, *args):
        """Handle screen.font_face(index)"""
        # Font selection - could map to different web fonts
        pass
        
    def _handle_font_size(self, addr, *args):
        """Handle screen.font_size(size)"""
        # Font size - store for text rendering
        if args:
            self.display_state['font_size'] = int(args[0])
            
    def _handle_lua_command(self, addr, *args):
        """Handle Lua-style commands like /remote/screen/clear."""
        parts = addr.split('/')
        if len(parts) >= 4:
            command = parts[3]
            
            # Map to appropriate handler
            handler_map = {
                'clear': self._handle_clear,
                'level': self._handle_level,
                'move': self._handle_move,
                'line': self._handle_line,
                'rect': self._handle_rect,
                'text': self._handle_text,
                'fill': self._handle_fill,
                'stroke': self._handle_stroke,
                'update': self._handle_update
            }
            
            if command in handler_map:
                handler_map[command](addr, *args)
                
    def _handle_default(self, addr, *args):
        """Handle unknown OSC messages for debugging."""
        logger.debug(f"Unhandled OSC message: {addr} {args}")
        
    def _announce_service(self):
        """Announce display service to network."""
        try:
            # Could implement mDNS/Bonjour here
            logger.info(f"Norns display service available on port {self.osc_port}")
        except Exception as e:
            logger.error(f"Failed to announce service: {e}")
            
    def send_input(self, input_type: str, data: Dict):
        """Send input back to Norns.
        
        Args:
            input_type: Type of input (key, enc)
            data: Input data
        """
        if not self.norns_client:
            # Create client to send back to Norns
            try:
                self.norns_client = udp_client.SimpleUDPClient("norns.local", 10111)
            except Exception as e:
                logger.error(f"Failed to create Norns client: {e}")
                return
                
        try:
            if input_type == 'key':
                self.norns_client.send_message(
                    "/remote/key",
                    [data.get('n', 1), data.get('z', 0)]
                )
            elif input_type == 'enc':
                self.norns_client.send_message(
                    "/remote/enc",
                    [data.get('n', 1), data.get('delta', 0)]
                )
        except Exception as e:
            logger.error(f"Failed to send input to Norns: {e}")
            
    def get_status(self) -> Dict:
        """Get proxy status.
        
        Returns:
            Status dictionary
        """
        return {
            'running': self.running,
            'port': self.osc_port,
            'display': {
                'width': self.display_state['width'],
                'height': self.display_state['height']
            }
        }
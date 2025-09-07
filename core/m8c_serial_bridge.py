#!/usr/bin/env python3
"""M8C Serial to WebSocket bridge."""

import serial
import serial.tools.list_ports
import threading
import queue
import time
import json
import logging
from typing import Optional, List, Dict, Callable
from core.m8c_protocol import M8CProtocol

logger = logging.getLogger(__name__)


class M8CSerialBridge:
    """Bridge between M8 serial device and WebSocket clients."""
    
    def __init__(self, emit_callback: Optional[Callable] = None):
        """Initialize the serial bridge.
        
        Args:
            emit_callback: Function to emit WebSocket messages
        """
        self.serial_port: Optional[serial.Serial] = None
        self.protocol = M8CProtocol()
        self.emit_callback = emit_callback
        self.running = False
        self.read_thread: Optional[threading.Thread] = None
        self.write_queue = queue.Queue()
        self.write_thread: Optional[threading.Thread] = None
        self.device_path: Optional[str] = None
        
        # Recording/replay for testing
        self.recording = False
        self.record_buffer = []
        
    def find_m8_devices(self) -> List[Dict[str, str]]:
        """Find available M8 devices.
        
        Returns:
            List of device info dictionaries
        """
        devices = []
        for port in serial.tools.list_ports.comports():
            # M8 devices typically show up as Teensy or with specific VID/PID
            if ('Teensy' in port.description or 
                'M8' in port.description or
                port.vid == 0x16C0):  # Teensy VID
                devices.append({
                    'path': port.device,
                    'description': port.description,
                    'hwid': port.hwid
                })
                logger.info(f"Found potential M8 device: {port.device}")
        
        return devices
    
    def connect(self, device_path: Optional[str] = None, baudrate: int = 115200) -> bool:
        """Connect to M8 device.
        
        Args:
            device_path: Serial device path, or None to auto-detect
            baudrate: Serial baudrate (default 115200)
            
        Returns:
            True if connected successfully
        """
        try:
            if not device_path:
                devices = self.find_m8_devices()
                if not devices:
                    logger.error("No M8 devices found")
                    return False
                device_path = devices[0]['path']
                logger.info(f"Auto-selected device: {device_path}")
            
            self.serial_port = serial.Serial(
                port=device_path,
                baudrate=baudrate,
                timeout=0.1,
                write_timeout=0.1
            )
            
            self.device_path = device_path
            self.running = True
            
            # Start read thread
            self.read_thread = threading.Thread(target=self._read_loop, daemon=True)
            self.read_thread.start()
            
            # Start write thread
            self.write_thread = threading.Thread(target=self._write_loop, daemon=True)
            self.write_thread.start()
            
            logger.info(f"Connected to M8 device at {device_path}")
            
            # Send initial query to get system info
            self._request_system_info()
            
            return True
            
        except Exception as e:
            logger.error(f"Failed to connect to M8: {e}")
            return False
    
    def disconnect(self):
        """Disconnect from M8 device."""
        self.running = False
        
        if self.read_thread:
            self.read_thread.join(timeout=1)
            
        if self.write_thread:
            self.write_thread.join(timeout=1)
            
        if self.serial_port and self.serial_port.is_open:
            self.serial_port.close()
            logger.info("Disconnected from M8 device")
            
        self.serial_port = None
        self.device_path = None
    
    def _read_loop(self):
        """Background thread for reading serial data."""
        while self.running and self.serial_port:
            try:
                if self.serial_port.in_waiting:
                    data = self.serial_port.read(self.serial_port.in_waiting)
                    
                    # Record if enabled
                    if self.recording:
                        self.record_buffer.append({
                            'time': time.time(),
                            'data': data.hex()
                        })
                    
                    # Parse commands
                    while True:
                        cmd = self.protocol.parse_command(data)
                        if not cmd:
                            break
                        
                        # Emit to WebSocket clients
                        if self.emit_callback:
                            self.emit_callback('display_command', cmd)
                        
                        # Clear consumed data
                        data = b''
                        
                else:
                    time.sleep(0.001)  # Small delay to prevent CPU spinning
                    
            except Exception as e:
                logger.error(f"Error reading from serial: {e}")
                if not self.running:
                    break
    
    def _write_loop(self):
        """Background thread for writing serial data."""
        while self.running:
            try:
                data = self.write_queue.get(timeout=0.1)
                if self.serial_port and self.serial_port.is_open:
                    self.serial_port.write(data)
                    
                    # Record if enabled
                    if self.recording:
                        self.record_buffer.append({
                            'time': time.time(),
                            'input': data.hex()
                        })
                        
            except queue.Empty:
                pass
            except Exception as e:
                logger.error(f"Error writing to serial: {e}")
    
    def send_input(self, key_data: Dict):
        """Send input to M8 device.
        
        Args:
            key_data: Dictionary with key event data
        """
        if not self.serial_port or not self.serial_port.is_open:
            logger.warning("Cannot send input: not connected")
            return
            
        try:
            if 'keys' in key_data:
                # Multiple keys pressed
                data = self.protocol.encode_input(key_data['keys'])
            elif 'key' in key_data:
                # Single key event
                data = self.protocol.encode_key_event(
                    key_data['key'],
                    key_data.get('pressed', True)
                )
            else:
                logger.warning(f"Invalid key data: {key_data}")
                return
                
            if data:
                self.write_queue.put(data)
                
        except Exception as e:
            logger.error(f"Error encoding input: {e}")
    
    def _request_system_info(self):
        """Request system info from M8."""
        # Send system info request
        # The exact command may vary based on M8 firmware
        try:
            if self.serial_port and self.serial_port.is_open:
                self.serial_port.write(bytes([0xFF]))
        except Exception as e:
            logger.error(f"Error requesting system info: {e}")
    
    def start_recording(self):
        """Start recording serial traffic."""
        self.recording = True
        self.record_buffer = []
        logger.info("Started recording serial traffic")
    
    def stop_recording(self) -> List[Dict]:
        """Stop recording and return buffer.
        
        Returns:
            Recorded serial traffic
        """
        self.recording = False
        buffer = self.record_buffer
        self.record_buffer = []
        logger.info(f"Stopped recording, captured {len(buffer)} events")
        return buffer
    
    def save_recording(self, filename: str):
        """Save recording to file.
        
        Args:
            filename: Path to save recording
        """
        if self.record_buffer:
            with open(filename, 'w') as f:
                json.dump(self.record_buffer, f, indent=2)
            logger.info(f"Saved recording to {filename}")
    
    def replay_recording(self, filename: str):
        """Replay a recorded session.
        
        Args:
            filename: Path to recording file
        """
        try:
            with open(filename, 'r') as f:
                events = json.load(f)
                
            logger.info(f"Replaying {len(events)} events from {filename}")
            
            start_time = time.time()
            first_event_time = events[0]['time'] if events else 0
            
            for event in events:
                # Calculate delay
                event_offset = event['time'] - first_event_time
                current_offset = time.time() - start_time
                delay = event_offset - current_offset
                
                if delay > 0:
                    time.sleep(delay)
                
                # Process event
                if 'data' in event:
                    # Display data
                    data = bytes.fromhex(event['data'])
                    cmd = self.protocol.parse_command(data)
                    if cmd and self.emit_callback:
                        self.emit_callback('display_command', cmd)
                        
        except Exception as e:
            logger.error(f"Error replaying recording: {e}")
    
    def get_status(self) -> Dict:
        """Get bridge status.
        
        Returns:
            Status dictionary
        """
        return {
            'connected': self.serial_port is not None and self.serial_port.is_open,
            'device': self.device_path,
            'recording': self.recording,
            'model': self.protocol.model,
            'display': self.protocol.display
        }
#!/usr/bin/env python3
"""Tests for M8C display functionality."""

import unittest
from unittest.mock import Mock, MagicMock, patch
import sys
import os

# Add parent directory to path
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from core.m8c_protocol import M8CProtocol, DRAW_RECT, DRAW_CHAR, DRAW_OSC, SYSTEM_INFO
from core.m8c_serial_bridge import M8CSerialBridge
from handlers.m8c_display_handler import M8CDisplayHandler


class TestM8CProtocol(unittest.TestCase):
    """Test M8C protocol parser and encoder."""
    
    def setUp(self):
        self.protocol = M8CProtocol()
    
    def test_parse_draw_rect_filled(self):
        """Test parsing filled rectangle command."""
        # Create test data: cmd(0xFE) + type(0) + x(2) + y(2) + w(2) + h(1)
        data = bytes([DRAW_RECT, 0, 10, 0, 20, 0, 30, 0, 40])
        
        cmd = self.protocol.parse_command(data)
        
        self.assertIsNotNone(cmd)
        self.assertEqual(cmd['type'], 'rect')
        self.assertEqual(cmd['x'], 10)
        self.assertEqual(cmd['y'], 20)
        self.assertEqual(cmd['width'], 30)
        self.assertEqual(cmd['height'], 40)
        self.assertTrue(cmd['filled'])
    
    def test_parse_draw_char(self):
        """Test parsing draw character command."""
        # Create test data: cmd + char + x + y + fg_rgb + bg_rgb
        data = bytes([DRAW_CHAR, ord('A'), 10, 0, 20, 0, 
                     255, 255, 255,  # FG: white
                     0, 0, 0])       # BG: black
        
        cmd = self.protocol.parse_command(data)
        
        self.assertIsNotNone(cmd)
        self.assertEqual(cmd['type'], 'char')
        self.assertEqual(cmd['char'], 'A')
        self.assertEqual(cmd['x'], 10)
        self.assertEqual(cmd['y'], 20)
        self.assertEqual(cmd['fg_color'], {'r': 255, 'g': 255, 'b': 255})
        self.assertEqual(cmd['bg_color'], {'r': 0, 'g': 0, 'b': 0})
    
    def test_parse_system_info(self):
        """Test parsing system info command."""
        # Create test data: cmd + hw_model + major + minor + patch + font
        data = bytes([SYSTEM_INFO, 1, 3, 1, 4, 0])
        
        cmd = self.protocol.parse_command(data)
        
        self.assertIsNotNone(cmd)
        self.assertEqual(cmd['type'], 'system_info')
        self.assertEqual(cmd['hardware_model'], 1)
        self.assertEqual(cmd['firmware_version'], '3.1.4')
        self.assertEqual(cmd['font'], 0)
    
    def test_encode_input(self):
        """Test encoding keyboard input."""
        keys = ['up', 'shift']
        data = self.protocol.encode_input(keys)
        
        self.assertEqual(len(data), 3)
        self.assertEqual(data[0], 0xFB)  # JOYPAD_STATE
        # Check that up (0x01) and shift (0x10) are set
        self.assertEqual(data[1] & 0x11, 0x11)
    
    def test_encode_key_event(self):
        """Test encoding single key event."""
        data = self.protocol.encode_key_event('play', True)
        
        self.assertEqual(len(data), 3)
        self.assertEqual(data[0], 0xFB)  # JOYPAD_STATE
        self.assertEqual(data[1], 0x01)  # Pressed
        self.assertEqual(data[2], 0x20)  # Play key code
    
    def test_partial_command_buffering(self):
        """Test that partial commands are buffered correctly."""
        # Send partial rect command
        partial = bytes([DRAW_RECT, 0, 10, 0])
        cmd = self.protocol.parse_command(partial)
        self.assertIsNone(cmd)  # Should return None, waiting for more data
        
        # Send rest of command
        rest = bytes([20, 0, 30, 0, 40])
        cmd = self.protocol.parse_command(rest)
        self.assertIsNotNone(cmd)
        self.assertEqual(cmd['type'], 'rect')


class TestM8CSerialBridge(unittest.TestCase):
    """Test M8C serial bridge."""
    
    @patch('serial.Serial')
    @patch('serial.tools.list_ports.comports')
    def test_find_m8_devices(self, mock_comports, mock_serial):
        """Test finding M8 devices."""
        # Mock serial port info
        mock_port = Mock()
        mock_port.device = '/dev/ttyACM0'
        mock_port.description = 'Teensy USB Serial'
        mock_port.hwid = 'USB VID:PID=16C0:0483'
        mock_port.vid = 0x16C0
        
        mock_comports.return_value = [mock_port]
        
        bridge = M8CSerialBridge()
        devices = bridge.find_m8_devices()
        
        self.assertEqual(len(devices), 1)
        self.assertEqual(devices[0]['path'], '/dev/ttyACM0')
        self.assertIn('Teensy', devices[0]['description'])
    
    @patch('serial.Serial')
    @patch('serial.tools.list_ports.comports')
    def test_connect(self, mock_comports, mock_serial):
        """Test connecting to M8 device."""
        # Mock serial connection
        mock_serial_instance = MagicMock()
        mock_serial.return_value = mock_serial_instance
        
        bridge = M8CSerialBridge()
        success = bridge.connect('/dev/ttyACM0')
        
        self.assertTrue(success)
        self.assertTrue(bridge.running)
        mock_serial.assert_called_once_with(
            port='/dev/ttyACM0',
            baudrate=115200,
            timeout=0.1,
            write_timeout=0.1
        )
    
    def test_send_input(self):
        """Test sending input to M8."""
        bridge = M8CSerialBridge()
        bridge.serial_port = MagicMock()
        bridge.serial_port.is_open = True
        
        # Test single key
        bridge.send_input({'key': 'up', 'pressed': True})
        
        # Check that data was queued
        self.assertFalse(bridge.write_queue.empty())
        data = bridge.write_queue.get()
        self.assertEqual(len(data), 3)
        self.assertEqual(data[0], 0xFB)  # JOYPAD_STATE
    
    def test_recording(self):
        """Test recording functionality."""
        bridge = M8CSerialBridge()
        
        # Start recording
        bridge.start_recording()
        self.assertTrue(bridge.recording)
        
        # Add some test data
        bridge.record_buffer.append({'time': 1.0, 'data': 'test'})
        
        # Stop recording
        buffer = bridge.stop_recording()
        self.assertFalse(bridge.recording)
        self.assertEqual(len(buffer), 1)
        self.assertEqual(buffer[0]['data'], 'test')


class TestM8CDisplayHandler(unittest.TestCase):
    """Test M8C display handler."""
    
    def setUp(self):
        self.mock_request = Mock()
        self.mock_app = Mock()
        self.handler = M8CDisplayHandler(self.mock_request, self.mock_app)
    
    @patch.object(M8CDisplayHandler, 'get_bridge')
    def test_handle_get(self, mock_get_bridge):
        """Test GET request handling."""
        mock_bridge = Mock()
        mock_bridge.find_m8_devices.return_value = [
            {'path': '/dev/ttyACM0', 'description': 'M8 Device'}
        ]
        mock_bridge.get_status.return_value = {
            'connected': False,
            'device': None
        }
        mock_get_bridge.return_value = mock_bridge
        
        result = self.handler.handle_get()
        
        self.assertIn('devices', result)
        self.assertIn('status', result)
        self.assertEqual(len(result['devices']), 1)
        self.assertFalse(result['status']['connected'])
    
    @patch.object(M8CDisplayHandler, 'get_bridge')
    def test_handle_connect(self, mock_get_bridge):
        """Test connect action."""
        mock_bridge = Mock()
        mock_bridge.connect.return_value = True
        mock_bridge.get_status.return_value = {'connected': True}
        mock_get_bridge.return_value = mock_bridge
        
        form = {'action': 'connect', 'device': '/dev/ttyACM0'}
        result = self.handler.handle_post(form)
        
        self.assertTrue(result['success'])
        self.assertEqual(result['message_type'], 'success')
        mock_bridge.connect.assert_called_once_with('/dev/ttyACM0')
    
    @patch.object(M8CDisplayHandler, 'get_bridge')
    def test_handle_disconnect(self, mock_get_bridge):
        """Test disconnect action."""
        mock_bridge = Mock()
        mock_bridge.get_status.return_value = {'connected': False}
        mock_get_bridge.return_value = mock_bridge
        
        form = {'action': 'disconnect'}
        result = self.handler.handle_post(form)
        
        self.assertTrue(result['success'])
        mock_bridge.disconnect.assert_called_once()
    
    @patch.object(M8CDisplayHandler, 'get_bridge')
    def test_handle_websocket_input(self, mock_get_bridge):
        """Test WebSocket input handling."""
        mock_bridge = Mock()
        mock_get_bridge.return_value = mock_bridge
        
        message = {
            'type': 'input',
            'data': {'key': 'up', 'pressed': True}
        }
        
        result = self.handler.handle_websocket_message(message)
        
        self.assertTrue(result['success'])
        mock_bridge.send_input.assert_called_once_with({'key': 'up', 'pressed': True})


if __name__ == '__main__':
    unittest.main()
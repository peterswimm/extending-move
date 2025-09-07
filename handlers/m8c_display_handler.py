#!/usr/bin/env python3
"""Handler for M8C display functionality."""

from handlers.base_handler import BaseHandler
from core.m8c_serial_bridge import M8CSerialBridge
import logging
import json

logger = logging.getLogger(__name__)


class M8CDisplayHandler(BaseHandler):
    """Handler for M8C display operations."""
    
    # Shared bridge instance across all handler instances
    _bridge = None
    
    @classmethod
    def get_bridge(cls):
        """Get or create the shared M8C bridge instance."""
        if cls._bridge is None:
            cls._bridge = M8CSerialBridge()
        return cls._bridge
    
    def handle_get(self):
        """Handle GET request for M8C display page."""
        bridge = self.get_bridge()
        
        # Get available devices
        devices = bridge.find_m8_devices()
        
        # Get current status
        status = bridge.get_status()
        
        return {
            'devices': devices,
            'status': status,
            'message_type': 'info' if not status['connected'] else 'success',
            'message': 'M8 device connected' if status['connected'] else 'No M8 device connected'
        }
    
    def handle_post(self, form):
        """Handle POST requests for M8C operations.
        
        Args:
            form: Form data from request
        """
        action = form.get('action')
        bridge = self.get_bridge()
        
        if action == 'connect':
            device_path = form.get('device')
            success = bridge.connect(device_path)
            
            if success:
                return {
                    'success': True,
                    'message': f'Connected to M8 device',
                    'message_type': 'success',
                    'status': bridge.get_status()
                }
            else:
                return {
                    'success': False,
                    'message': 'Failed to connect to M8 device',
                    'message_type': 'error',
                    'status': bridge.get_status()
                }
                
        elif action == 'disconnect':
            bridge.disconnect()
            return {
                'success': True,
                'message': 'Disconnected from M8 device',
                'message_type': 'info',
                'status': bridge.get_status()
            }
            
        elif action == 'start_recording':
            bridge.start_recording()
            return {
                'success': True,
                'message': 'Started recording',
                'message_type': 'success',
                'status': bridge.get_status()
            }
            
        elif action == 'stop_recording':
            recording = bridge.stop_recording()
            
            # Save to file if requested
            filename = form.get('filename')
            if filename:
                bridge.save_recording(f"recordings/{filename}")
                
            return {
                'success': True,
                'message': f'Stopped recording ({len(recording)} events)',
                'message_type': 'success',
                'recording': recording,
                'status': bridge.get_status()
            }
            
        elif action == 'replay':
            filename = form.get('filename')
            if filename:
                bridge.replay_recording(f"recordings/{filename}")
                return {
                    'success': True,
                    'message': f'Replaying {filename}',
                    'message_type': 'info'
                }
            else:
                return {
                    'success': False,
                    'message': 'No filename provided',
                    'message_type': 'error'
                }
                
        elif action == 'get_status':
            return {
                'success': True,
                'status': bridge.get_status()
            }
            
        else:
            return {
                'success': False,
                'message': f'Unknown action: {action}',
                'message_type': 'error'
            }
    
    def handle_websocket_message(self, message):
        """Handle WebSocket message from client.
        
        Args:
            message: WebSocket message data
            
        Returns:
            Response to send back to client
        """
        bridge = self.get_bridge()
        
        try:
            data = json.loads(message) if isinstance(message, str) else message
            
            if data.get('type') == 'input':
                # Forward input to M8 device
                bridge.send_input(data.get('data', {}))
                return {'success': True}
                
            elif data.get('type') == 'get_status':
                return {
                    'type': 'status',
                    'data': bridge.get_status()
                }
                
            else:
                return {
                    'error': f"Unknown message type: {data.get('type')}"
                }
                
        except Exception as e:
            logger.error(f"Error handling WebSocket message: {e}")
            return {'error': str(e)}
    
    def set_emit_callback(self, callback):
        """Set the WebSocket emit callback for the bridge.
        
        Args:
            callback: Function to emit WebSocket messages
        """
        bridge = self.get_bridge()
        bridge.emit_callback = callback
#!/usr/bin/env python3
"""Universal display handler for M8C and Norns displays."""

from handlers.base_handler import BaseHandler
from handlers.m8c_display_handler import M8CDisplayHandler
from core.norns_display_proxy import NornsDisplayProxy
import logging
import json

logger = logging.getLogger(__name__)


class UniversalDisplayHandler(BaseHandler):
    """Handler for universal display operations supporting multiple devices."""
    
    # Shared instances
    _norns_proxy = None
    _m8c_handler = None
    _current_mode = 'norns'  # 'norns', 'm8c', or 'both'
    
    @classmethod
    def get_norns_proxy(cls):
        """Get or create the shared Norns proxy instance."""
        if cls._norns_proxy is None:
            cls._norns_proxy = NornsDisplayProxy()
        return cls._norns_proxy
    
    @classmethod
    def get_m8c_handler(cls):
        """Get or create the shared M8C handler instance."""
        if cls._m8c_handler is None:
            cls._m8c_handler = M8CDisplayHandler()
        return cls._m8c_handler
    
    def handle_get(self):
        """Handle GET request for universal display page."""
        norns_proxy = self.get_norns_proxy()
        m8c_handler = self.get_m8c_handler()
        
        # Get M8 devices
        m8_devices = m8c_handler.get_bridge().find_m8_devices()
        
        # Get status from both
        norns_status = norns_proxy.get_status()
        m8c_status = m8c_handler.get_bridge().get_status()
        
        return {
            'mode': self._current_mode,
            'm8_devices': m8_devices,
            'norns_status': norns_status,
            'm8c_status': m8c_status,
            'message_type': 'info',
            'message': f'Display mode: {self._current_mode}'
        }
    
    def handle_post(self, form):
        """Handle POST requests for display operations.
        
        Args:
            form: Form data from request
        """
        action = form.get('action')
        
        if action == 'set_mode':
            mode = form.get('mode', 'norns')
            if mode in ['norns', 'm8c', 'both']:
                self._current_mode = mode
                
                # Start/stop services as needed
                if mode in ['norns', 'both']:
                    self._start_norns_proxy()
                else:
                    self._stop_norns_proxy()
                    
                return {
                    'success': True,
                    'message': f'Display mode set to {mode}',
                    'message_type': 'success',
                    'mode': mode
                }
                
        elif action == 'start_norns':
            success = self._start_norns_proxy()
            return {
                'success': success,
                'message': 'Norns proxy started' if success else 'Failed to start Norns proxy',
                'message_type': 'success' if success else 'error'
            }
            
        elif action == 'stop_norns':
            self._stop_norns_proxy()
            return {
                'success': True,
                'message': 'Norns proxy stopped',
                'message_type': 'info'
            }
            
        elif action == 'connect_m8':
            # Delegate to M8C handler
            m8c_handler = self.get_m8c_handler()
            return m8c_handler.handle_post(form)
            
        elif action == 'get_status':
            norns_proxy = self.get_norns_proxy()
            m8c_handler = self.get_m8c_handler()
            
            return {
                'success': True,
                'mode': self._current_mode,
                'norns_status': norns_proxy.get_status(),
                'm8c_status': m8c_handler.get_bridge().get_status()
            }
            
        else:
            # Try delegating to M8C handler for backward compatibility
            m8c_handler = self.get_m8c_handler()
            return m8c_handler.handle_post(form)
    
    def _start_norns_proxy(self):
        """Start the Norns display proxy."""
        try:
            norns_proxy = self.get_norns_proxy()
            if not norns_proxy.running:
                norns_proxy.start()
            return True
        except Exception as e:
            logger.error(f"Failed to start Norns proxy: {e}")
            return False
    
    def _stop_norns_proxy(self):
        """Stop the Norns display proxy."""
        try:
            norns_proxy = self.get_norns_proxy()
            if norns_proxy.running:
                norns_proxy.stop()
        except Exception as e:
            logger.error(f"Failed to stop Norns proxy: {e}")
    
    def handle_websocket_message(self, message):
        """Handle WebSocket message from client.
        
        Args:
            message: WebSocket message data
            
        Returns:
            Response to send back to client
        """
        try:
            data = json.loads(message) if isinstance(message, str) else message
            
            if data.get('type') == 'input':
                input_data = data.get('data', {})
                target = input_data.get('target', self._current_mode)
                
                if target == 'norns':
                    # Send to Norns
                    norns_proxy = self.get_norns_proxy()
                    if 'key' in input_data:
                        norns_proxy.send_input('key', {
                            'n': input_data.get('n', 1),
                            'z': 1 if input_data.get('pressed') else 0
                        })
                    elif 'enc' in input_data:
                        norns_proxy.send_input('enc', {
                            'n': input_data.get('n', 1),
                            'delta': input_data.get('delta', 0)
                        })
                        
                elif target == 'm8c':
                    # Send to M8
                    m8c_handler = self.get_m8c_handler()
                    m8c_handler.get_bridge().send_input(input_data)
                    
                return {'success': True}
                
            elif data.get('type') == 'get_status':
                return {
                    'type': 'status',
                    'data': {
                        'mode': self._current_mode,
                        'norns': self.get_norns_proxy().get_status(),
                        'm8c': self.get_m8c_handler().get_bridge().get_status()
                    }
                }
                
            else:
                # Delegate to M8C handler for compatibility
                m8c_handler = self.get_m8c_handler()
                return m8c_handler.handle_websocket_message(message)
                
        except Exception as e:
            logger.error(f"Error handling WebSocket message: {e}")
            return {'error': str(e)}
    
    def set_emit_callback(self, callback):
        """Set the WebSocket emit callback for both proxies.
        
        Args:
            callback: Function to emit WebSocket messages
        """
        # Set for both Norns and M8C
        norns_proxy = self.get_norns_proxy()
        norns_proxy.emit_callback = callback
        
        m8c_handler = self.get_m8c_handler()
        m8c_handler.set_emit_callback(callback)
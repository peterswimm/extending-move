/**
 * M8C Display Web Application
 * Main application logic and WebSocket client
 */

class M8CApp {
    constructor() {
        // Get canvas element
        this.canvas = document.getElementById('display-canvas');
        if (!this.canvas) {
            console.error('Canvas element not found');
            return;
        }
        
        // Initialize renderer
        this.renderer = new M8CRenderer(this.canvas);
        
        // WebSocket connection
        this.socket = null;
        this.connected = false;
        this.recording = false;
        
        // Current scale
        this.currentScale = 2;
        this.scales = [1, 2, 3, 4];
        
        // Keyboard state
        this.pressedKeys = new Set();
        
        // Keyboard mappings
        this.keyMap = {
            'ArrowUp': 'up',
            'ArrowDown': 'down',
            'ArrowLeft': 'left',
            'ArrowRight': 'right',
            'Shift': 'shift',
            ' ': 'play',
            'Space': 'play',
            'Alt': 'option',
            'Option': 'option',
            'Control': 'edit',
            'Meta': 'edit',
            'e': 'edit',
            'p': 'play',
            's': 'shift',
            'o': 'option'
        };
        
        // Initialize connection
        this.initWebSocket();
    }
    
    initWebSocket() {
        // Connect to WebSocket endpoint
        const protocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
        const host = window.location.host;
        
        this.socket = io(`${protocol}//${host}/m8c`, {
            transports: ['websocket'],
            reconnection: true,
            reconnectionDelay: 1000,
            reconnectionAttempts: 5
        });
        
        // Connection events
        this.socket.on('connect', () => {
            console.log('WebSocket connected');
            this.onConnected();
        });
        
        this.socket.on('disconnect', () => {
            console.log('WebSocket disconnected');
            this.onDisconnected();
        });
        
        this.socket.on('error', (error) => {
            console.error('WebSocket error:', error);
        });
        
        // Display commands from M8
        this.socket.on('display_command', (cmd) => {
            this.renderer.processCommand(cmd);
        });
        
        // Status updates
        this.socket.on('status', (status) => {
            this.updateStatus(status);
        });
        
        // Recording events
        this.socket.on('recording_started', () => {
            this.recording = true;
            this.updateRecordingUI();
        });
        
        this.socket.on('recording_stopped', (data) => {
            this.recording = false;
            this.updateRecordingUI();
            if (data && data.count) {
                console.log(`Recording stopped: ${data.count} events`);
            }
        });
    }
    
    onConnected() {
        this.connected = true;
        this.updateConnectionUI();
        
        // Request current status
        this.socket.emit('get_status');
    }
    
    onDisconnected() {
        this.connected = false;
        this.updateConnectionUI();
    }
    
    connect(devicePath) {
        // Connect to specific device
        fetch('/api/m8c/connect', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                device: devicePath
            })
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                console.log('Connected to M8 device');
                this.updateStatus(data.status);
                // Hide device selector
                document.getElementById('device-selector').style.display = 'none';
            } else {
                console.error('Failed to connect:', data.message);
                alert(`Connection failed: ${data.message}`);
            }
        })
        .catch(error => {
            console.error('Connection error:', error);
            alert('Connection error: ' + error.message);
        });
    }
    
    disconnect() {
        fetch('/api/m8c/disconnect', {
            method: 'POST'
        })
        .then(response => response.json())
        .then(data => {
            console.log('Disconnected');
            this.updateStatus(data.status);
            // Show device selector
            document.getElementById('device-selector').style.display = 'block';
        });
    }
    
    toggleConnection() {
        if (this.connected) {
            this.disconnect();
        } else {
            // Try to auto-connect
            this.connect(null);
        }
    }
    
    toggleRecording() {
        if (this.recording) {
            this.stopRecording();
        } else {
            this.startRecording();
        }
    }
    
    startRecording() {
        fetch('/api/m8c/recording/start', {
            method: 'POST'
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                this.recording = true;
                this.updateRecordingUI();
            }
        });
    }
    
    stopRecording() {
        const filename = prompt('Save recording as (leave empty to discard):');
        
        fetch('/api/m8c/recording/stop', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                filename: filename
            })
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                this.recording = false;
                this.updateRecordingUI();
                if (filename) {
                    alert(`Recording saved: ${data.message}`);
                }
            }
        });
    }
    
    changeScale() {
        // Cycle through scales
        const currentIndex = this.scales.indexOf(this.currentScale);
        const nextIndex = (currentIndex + 1) % this.scales.length;
        this.currentScale = this.scales[nextIndex];
        
        this.renderer.setScale(this.currentScale);
    }
    
    clearDisplay() {
        this.renderer.clear();
    }
    
    handleKeyDown(event) {
        // Map key to M8 control
        const key = this.keyMap[event.key] || this.keyMap[event.code];
        if (!key) return;
        
        // Prevent default for arrow keys
        if (event.key.startsWith('Arrow')) {
            event.preventDefault();
        }
        
        // Check if already pressed
        if (this.pressedKeys.has(key)) return;
        
        this.pressedKeys.add(key);
        this.sendInput(key, true);
        
        // Update UI
        const btn = document.querySelector(`.key-btn[data-key="${key}"]`);
        if (btn) btn.classList.add('pressed');
    }
    
    handleKeyUp(event) {
        // Map key to M8 control
        const key = this.keyMap[event.key] || this.keyMap[event.code];
        if (!key) return;
        
        this.pressedKeys.delete(key);
        this.sendInput(key, false);
        
        // Update UI
        const btn = document.querySelector(`.key-btn[data-key="${key}"]`);
        if (btn) btn.classList.remove('pressed');
    }
    
    sendInput(key, pressed) {
        if (!this.socket || !this.connected) return;
        
        // Send input event to server
        this.socket.emit('input', {
            type: 'input',
            data: {
                key: key,
                pressed: pressed
            }
        });
    }
    
    sendMultipleKeys(keys) {
        if (!this.socket || !this.connected) return;
        
        // Send multiple keys at once
        this.socket.emit('input', {
            type: 'input',
            data: {
                keys: keys
            }
        });
    }
    
    updateConnectionUI() {
        const indicator = document.getElementById('connection-status');
        const text = document.getElementById('connection-text');
        const btnText = document.getElementById('connect-btn-text');
        
        if (this.connected) {
            indicator.classList.add('connected');
            indicator.classList.remove('disconnected');
            text.textContent = 'Connected';
            btnText.textContent = 'Disconnect';
        } else {
            indicator.classList.remove('connected');
            indicator.classList.add('disconnected');
            text.textContent = 'Disconnected';
            btnText.textContent = 'Connect';
        }
    }
    
    updateRecordingUI() {
        const indicator = document.getElementById('recording-indicator');
        const btnText = document.getElementById('record-btn-text');
        
        if (this.recording) {
            indicator.classList.add('active');
            btnText.textContent = 'Stop Recording';
        } else {
            indicator.classList.remove('active');
            btnText.textContent = 'Start Recording';
        }
    }
    
    updateStatus(status) {
        if (!status) return;
        
        // Update connection status
        this.connected = status.connected;
        this.updateConnectionUI();
        
        // Update device info
        const deviceInfo = document.getElementById('device-info');
        if (deviceInfo && status.device) {
            deviceInfo.textContent = status.device;
        }
        
        // Update display model if needed
        if (status.model) {
            this.renderer.setModel(status.model);
        }
        
        // Update recording status
        this.recording = status.recording;
        this.updateRecordingUI();
    }
    
    // Take screenshot
    screenshot() {
        const dataUrl = this.renderer.getScreenshot();
        const link = document.createElement('a');
        link.download = `m8-screenshot-${Date.now()}.png`;
        link.href = dataUrl;
        link.click();
    }
}
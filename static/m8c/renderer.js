/**
 * M8C Display Renderer
 * Handles Canvas rendering for M8 Tracker display
 */

class M8CRenderer {
    constructor(canvas, mode = 'norns') {
        this.canvas = canvas;
        this.ctx = canvas.getContext('2d', { alpha: false });
        
        // Display mode
        this.mode = mode; // 'norns', 'm8c', or 'auto'
        
        // Display dimensions based on mode
        if (mode === 'norns') {
            this.nativeWidth = 128;
            this.nativeHeight = 64;
            this.scale = 4;
        } else {
            // M8C MK1 by default
            this.nativeWidth = 320;
            this.nativeHeight = 240;
            this.scale = 2;
        }
        
        // Setup canvas
        this.updateCanvasSize();
        
        // Font settings
        this.fontSize = 8;
        this.charWidth = 6;
        this.charHeight = 8;
        
        // Create offscreen buffer for performance
        this.offscreenCanvas = document.createElement('canvas');
        this.offscreenCanvas.width = this.nativeWidth;
        this.offscreenCanvas.height = this.nativeHeight;
        this.offscreenCtx = this.offscreenCanvas.getContext('2d', { alpha: false });
        
        // Initialize display
        this.clear();
        
        // Bind resize handler
        window.addEventListener('resize', () => this.updateCanvasSize());
    }
    
    updateCanvasSize() {
        // Set actual canvas size
        this.canvas.width = this.nativeWidth * this.scale;
        this.canvas.height = this.nativeHeight * this.scale;
        
        // Set CSS size
        this.canvas.style.width = `${this.canvas.width}px`;
        this.canvas.style.height = `${this.canvas.height}px`;
        
        // Configure context for pixel-perfect rendering
        this.ctx.imageSmoothingEnabled = false;
        this.ctx.mozImageSmoothingEnabled = false;
        this.ctx.webkitImageSmoothingEnabled = false;
        this.ctx.msImageSmoothingEnabled = false;
    }
    
    setModel(model) {
        // Update dimensions based on M8 model
        if (model === 'MK2') {
            this.nativeWidth = 480;
            this.nativeHeight = 320;
        } else {
            this.nativeWidth = 320;
            this.nativeHeight = 240;
        }
        
        // Update offscreen canvas
        this.offscreenCanvas.width = this.nativeWidth;
        this.offscreenCanvas.height = this.nativeHeight;
        
        // Update main canvas
        this.updateCanvasSize();
        this.clear();
    }
    
    setScale(scale) {
        this.scale = scale;
        this.updateCanvasSize();
        this.render();
    }
    
    clear() {
        // Clear with black background
        this.offscreenCtx.fillStyle = '#000000';
        this.offscreenCtx.fillRect(0, 0, this.nativeWidth, this.nativeHeight);
        this.render();
    }
    
    drawRect(x, y, width, height, color, filled = true) {
        // Set color
        const colorStr = this.colorToString(color);
        
        if (filled) {
            this.offscreenCtx.fillStyle = colorStr;
            this.offscreenCtx.fillRect(x, y, width, height);
        } else {
            this.offscreenCtx.strokeStyle = colorStr;
            this.offscreenCtx.lineWidth = 1;
            this.offscreenCtx.strokeRect(x + 0.5, y + 0.5, width - 1, height - 1);
        }
    }
    
    drawChar(char, x, y, fgColor, bgColor) {
        // Draw background
        if (bgColor) {
            this.offscreenCtx.fillStyle = this.colorToString(bgColor);
            this.offscreenCtx.fillRect(x, y, this.charWidth, this.charHeight);
        }
        
        // Draw character
        this.offscreenCtx.fillStyle = this.colorToString(fgColor);
        this.offscreenCtx.font = `${this.fontSize}px monospace`;
        this.offscreenCtx.textBaseline = 'top';
        this.offscreenCtx.fillText(char, x, y);
    }
    
    drawText(text, x, y, fgColor, bgColor) {
        // Draw string of text
        for (let i = 0; i < text.length; i++) {
            this.drawChar(text[i], x + (i * this.charWidth), y, fgColor, bgColor);
        }
    }
    
    drawOscilloscope(waveform, color) {
        // Draw oscilloscope waveform
        if (!waveform || waveform.length === 0) return;
        
        const colorStr = this.colorToString(color);
        this.offscreenCtx.strokeStyle = colorStr;
        this.offscreenCtx.lineWidth = 1;
        
        // Calculate scaling
        const xScale = this.nativeWidth / waveform.length;
        const yCenter = this.nativeHeight / 2;
        const yScale = this.nativeHeight / 2;
        
        // Draw waveform
        this.offscreenCtx.beginPath();
        for (let i = 0; i < waveform.length; i++) {
            const x = i * xScale;
            const y = yCenter - (waveform[i] * yScale / 128); // Assuming 8-bit samples
            
            if (i === 0) {
                this.offscreenCtx.moveTo(x, y);
            } else {
                this.offscreenCtx.lineTo(x, y);
            }
        }
        this.offscreenCtx.stroke();
    }
    
    drawLine(x1, y1, x2, y2, color) {
        const colorStr = this.colorToString(color);
        this.offscreenCtx.strokeStyle = colorStr;
        this.offscreenCtx.lineWidth = 1;
        
        this.offscreenCtx.beginPath();
        this.offscreenCtx.moveTo(x1 + 0.5, y1 + 0.5);
        this.offscreenCtx.lineTo(x2 + 0.5, y2 + 0.5);
        this.offscreenCtx.stroke();
    }
    
    drawPixel(x, y, color) {
        this.offscreenCtx.fillStyle = this.colorToString(color);
        this.offscreenCtx.fillRect(x, y, 1, 1);
    }
    
    colorToString(color) {
        // Convert color object to CSS color string
        if (typeof color === 'string') {
            return color;
        } else if (color && typeof color === 'object') {
            const r = color.r || 0;
            const g = color.g || 0;
            const b = color.b || 0;
            return `rgb(${r}, ${g}, ${b})`;
        } else {
            return '#FFFFFF';
        }
    }
    
    processCommand(cmd) {
        // Process display command from M8 or Norns
        switch (cmd.type) {
            case 'rect':
                this.drawRect(
                    cmd.x, cmd.y, 
                    cmd.width, cmd.height, 
                    cmd.color, cmd.filled
                );
                break;
                
            case 'char':
                this.drawChar(
                    cmd.char,
                    cmd.x, cmd.y,
                    cmd.fg_color, cmd.bg_color
                );
                break;
                
            case 'oscilloscope':
                this.drawOscilloscope(cmd.waveform, cmd.color);
                break;
                
            case 'clear':
                this.clear();
                break;
                
            case 'line':
                this.drawLine(
                    cmd.x1 || cmd.x, 
                    cmd.y1 || cmd.y,
                    cmd.x2 || cmd.x + (cmd.width || 0), 
                    cmd.y2 || cmd.y + (cmd.height || 0),
                    cmd.color
                );
                break;
                
            case 'pixel':
                this.drawPixel(cmd.x, cmd.y, cmd.color);
                break;
                
            case 'text':
                this.drawText(
                    cmd.text,
                    cmd.x, cmd.y,
                    cmd.fg_color || cmd.color,
                    cmd.bg_color
                );
                break;
                
            case 'circle':
                this.drawCircle(
                    cmd.x, cmd.y,
                    cmd.radius,
                    cmd.color,
                    cmd.filled
                );
                break;
                
            case 'update':
                // Force render for double buffering
                this.render();
                break;
                
            case 'system_info':
                console.log('System Info:', cmd);
                // Update UI with system info if needed
                if (cmd.hardware_model === 2) {
                    this.setModel('MK2');
                }
                break;
                
            default:
                console.warn('Unknown display command:', cmd);
        }
        
        // Render to main canvas after each command
        // For Norns, we might want to wait for 'update' command
        if (cmd.type !== 'update' || this.mode !== 'norns') {
            this.render();
        }
    }
    
    drawCircle(x, y, radius, color, filled = true) {
        const colorStr = this.colorToString(color);
        
        this.offscreenCtx.beginPath();
        this.offscreenCtx.arc(x, y, radius, 0, 2 * Math.PI);
        
        if (filled) {
            this.offscreenCtx.fillStyle = colorStr;
            this.offscreenCtx.fill();
        } else {
            this.offscreenCtx.strokeStyle = colorStr;
            this.offscreenCtx.lineWidth = 1;
            this.offscreenCtx.stroke();
        }
    }
    
    setMode(mode) {
        this.mode = mode;
        
        if (mode === 'norns') {
            this.nativeWidth = 128;
            this.nativeHeight = 64;
            this.scale = 4;
        } else if (mode === 'm8c' || mode === 'MK1') {
            this.nativeWidth = 320;
            this.nativeHeight = 240;
            this.scale = 2;
        } else if (mode === 'MK2') {
            this.nativeWidth = 480;
            this.nativeHeight = 320;
            this.scale = 2;
        }
        
        // Update offscreen canvas
        this.offscreenCanvas.width = this.nativeWidth;
        this.offscreenCanvas.height = this.nativeHeight;
        
        // Update main canvas
        this.updateCanvasSize();
        this.clear();
    }
    
    render() {
        // Copy offscreen buffer to main canvas with scaling
        this.ctx.drawImage(
            this.offscreenCanvas,
            0, 0, this.nativeWidth, this.nativeHeight,
            0, 0, this.canvas.width, this.canvas.height
        );
    }
    
    // Get canvas as data URL for screenshots
    getScreenshot() {
        return this.canvas.toDataURL('image/png');
    }
    
    // Get pixel color at position (for testing)
    getPixel(x, y) {
        const imageData = this.offscreenCtx.getImageData(x, y, 1, 1);
        return {
            r: imageData.data[0],
            g: imageData.data[1],
            b: imageData.data[2],
            a: imageData.data[3]
        };
    }
}
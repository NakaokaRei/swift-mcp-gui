# Swift MCP GUI Server

A Model Context Protocol (MCP) server that allows controlling Mac OS X through SwiftAutoGUI. This server provides tools for programmatically controlling the mouse and keyboard through MCP clients.

## Requirements

- macOS 12.0 or later
- Swift 5.7 or later
- Xcode 14.0 or later

## Installation

1. Clone this repository:
```bash
git clone https://github.com/yourusername/swift-mcp-gui.git
cd swift-mcp-gui
```

2. Build the project:
```bash
swift build
```

3. Run the server:
```bash
swift run MCPGUIServer
```

## Available Tools

The server provides the following tools for controlling macOS:

### 1. Mouse Movement
- Tool name: `moveMouse`
- Input:
  - `x`: Integer (x-coordinate)
  - `y`: Integer (y-coordinate)
- Moves the mouse cursor to the specified coordinates

### 2. Mouse Clicks
- Tool name: `mouseClick`
- Input:
  - `button`: String ("left" or "right")
- Performs a mouse click at the current cursor position

### 3. Keyboard Input
- Tool name: `sendKeys`
- Input:
  - `keys`: Array of strings (key names)
- Sends keyboard shortcuts or key combinations
- Example keys: "command", "control", "option", "shift", "return", "space", "a", "1", etc.

### 4. Scrolling
- Tool name: `scroll`
- Input:
  - `direction`: String ("up", "down", "left", "right")
  - `clicks`: Integer (number of scroll clicks)
- Performs scrolling in the specified direction

## Example Usage

Here's an example of how to use the tools from an MCP client:

```python
# Example using Python MCP client
client.call_tool("moveMouse", {"x": 100, "y": 200})
client.call_tool("mouseClick", {"button": "left"})
client.call_tool("sendKeys", {"keys": ["command", "space"]})
client.call_tool("scroll", {"direction": "down", "clicks": 5})
```

## Security Considerations

This server has full control over your mouse and keyboard. Be careful when running it and only connect trusted MCP clients.

## License

MIT License 
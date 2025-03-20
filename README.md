# Swift MCP GUI Server

A Model Context Protocol (MCP) server that allows controlling Mac OS X through SwiftAutoGUI. This server provides tools for programmatically controlling the mouse and keyboard through MCP clients.

## Requirements

- macOS 15.0 or later
- Swift 6.0 or later
- Xcode 16.0 or later

## Installation

1. Clone this repository:
```bash
git clone https://github.com/yourusername/swift-mcp-gui.git
cd swift-mcp-gui
```

2. Install
```bash
swift package experimental-install
```

3. Add command to your MCP client.
```json
{
  "mcpServers" : {
    "swift-mcp-gui" : {
      "command" : "/Users/USERNAME/.swiftpm/bin/swift-mcp-gui"
    }
  }
}

```

## Available Tools

The server provides the following tools for controlling macOS:

### 1. Mouse Movement
- Tool name: `moveMouse`
- Input:
  - `x`: double (x-coordinate)
  - `y`: double (y-coordinate)
- Moves the mouse cursor to the specified coordinates

### 2. Mouse Clicks
- Tool name: `mouseClick`
- Input:
  - `button`: String ("left" or "right")
- Performs a mouse click at the current cursor position

### 3. Keyboard Input (TODO)
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

## Security Considerations

This server has full control over your mouse and keyboard. Be careful when running it and only connect trusted MCP clients.

## License

MIT License 
# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build and Development Commands

This is a Swift Package Manager project for macOS GUI automation via MCP (Model Context Protocol).

```bash
# Build the project
swift build

# Build for release (optimized)
swift build -c release

# Run the executable
swift run swift-mcp-gui

# Install the executable system-wide (experimental)
swift package experimental-install

# Uninstall the executable
swift package experimental-uninstall swift-mcp-gui

# Reinstall (uninstall then install) - Run this after implementing new features
swift package experimental-uninstall swift-mcp-gui && swift package experimental-install

# Clean build artifacts
swift package clean

# Update dependencies
swift package update
```

## Architecture Overview

This project implements an MCP server that provides GUI automation capabilities for macOS through these tools:
- `moveMouse`: Move cursor to x,y coordinates
- `mouseClick`: Perform mouse clicks (left/right)
- `scroll`: Scroll in any direction
- `sendKeys`: Send keyboard shortcuts
- `getScreenSize`: Get the display dimensions
- `getPixelColor`: Get color of a pixel at x,y
- `captureScreen`: Capture full screen as base64 PNG
- `captureRegion`: Capture a region as base64 PNG
- `saveScreenshot`: Save screenshot to file

### Key Components

- **main.swift**: MCP server initialization and startup
- **Server+Extension.swift**: Extends MCP Server with `waitForDisconnection()` to keep the server running
- **ToolRegistry.swift**: Manages tool registration and execution
- **Tools/**:
  - **Mouse/**: Mouse control tools (moveMouse, mouseClick)
  - **Screen/**: Screen capture and scroll tools
  - **Keyboard/**: Keyboard input tools (sendKeys)

### Dependencies

- **mcp-swift-sdk**: MCP protocol implementation
  - Repository: https://github.com/modelcontextprotocol/swift-sdk
- **SwiftAutoGUI** (v0.10.0+): macOS automation library
  - Repository: https://github.com/NakaokaRei/SwiftAutoGUI
  - Documentation: https://nakaokarei.github.io/SwiftAutoGUI/documentation/swiftautogui/

## Important Notes

- **Platform Requirements**: macOS 15.0+, Swift 6.0+
- **Security**: Requires full accessibility permissions in System Preferences
- **Communication**: Uses stdio transport (stdin/stdout)
- **Test suite**: Unit tests for tools are in Tests/swift-mcp-guiTests/

## Development Workflow

After implementing new features or fixing bugs, always reinstall the package to ensure the latest changes are available:

```bash
swift package experimental-uninstall swift-mcp-gui && swift package experimental-install
```
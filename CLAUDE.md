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

# Reinstall (uninstall then install)
swift package experimental-uninstall swift-mcp-gui && swift package experimental-install

# Clean build artifacts
swift package clean

# Update dependencies
swift package update
```

## Architecture Overview

This project implements an MCP server that provides GUI automation capabilities for macOS through 4 tools:
- `moveMouse`: Move cursor to x,y coordinates
- `mouseClick`: Perform mouse clicks (left/right)
- `scroll`: Scroll in any direction
- `sendKeys`: Send keyboard shortcuts

### Key Components

- **main.swift**: MCP server initialization and tool registration. All tool implementations are in this file.
- **Server+Extension.swift**: Extends MCP Server with `waitForDisconnection()` to keep the server running.

### Dependencies

- **mcp-swift-sdk**: MCP protocol implementation
- **SwiftAutoGUI** (v0.3.2): macOS automation library

## Important Notes

- **Platform Requirements**: macOS 15.0+, Swift 6.0+
- **Security**: Requires full accessibility permissions in System Preferences
- **Communication**: Uses stdio transport (stdin/stdout)
- **No test suite**: Currently no tests are implemented
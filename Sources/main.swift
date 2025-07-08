import Foundation
import MCP
import SwiftAutoGUI
import AppKit
import CoreGraphics

// Initialize the server
let server = Server(
    name: "mac-control-server",
    version: "1.0.0",
    capabilities: .init(
        prompts: .init(listChanged: true),
        tools: .init(listChanged: true)
    )
)

// Create transport and start server
print("Starting MCP GUI Server...")
let transport = StdioTransport()
try await server.start(transport: transport)

// Register tool handlers
await server.withMethodHandler(ListTools.self) { _ in
    return ListTools.Result(
        tools: [
            .init(
                name: "moveMouse",
                description: "Move mouse cursor to specific coordinates",
                inputSchema: [
                    "type": "object",
                    "properties": [
                        "x": ["type": "number", "description": "X coordinate"],
                        "y": ["type": "number", "description": "Y coordinate"]
                    ],
                    "required": ["x", "y"]
                ]
            ),
            .init(
                name: "mouseClick",
                description: "Perform mouse click",
                inputSchema: [
                    "type": "object",
                    "properties": [
                        "button": ["type": "string", "description": "Button to click (left or right)"]
                    ],
                    "required": ["button"]
                ]
            ),
            .init(
                name: "scroll",
                description: "Scroll in specified direction",
                inputSchema: [
                    "type": "object",
                    "properties": [
                        "direction": ["type": "string", "description": "Scroll direction (up, down, left, right)"],
                        "clicks": ["type": "number", "description": "Number of scroll clicks"]
                    ],
                    "required": ["direction", "clicks"]
                ]
            ),
            .init(
                name: "sendKeys",
                description: "Sends keyboard shortcuts or key combinations",
                inputSchema: [
                    "type": "object",
                    "properties": [
                        "keys": ["type": "array",
                                 "items": ["type": "string"],
                                 "description": "Sends keyboard shortcuts or key combinations"]
                    ],
                    "required": ["keys"]
                ]
            ),
            .init(
                name: "getScreenSize",
                description: "Get screen dimensions",
                inputSchema: [
                    "type": "object",
                    "properties": [:]
                ]
            ),
            .init(
                name: "getPixelColor",
                description: "Get color of specific pixel",
                inputSchema: [
                    "type": "object",
                    "properties": [
                        "x": ["type": "number", "description": "X coordinate"],
                        "y": ["type": "number", "description": "Y coordinate"]
                    ],
                    "required": ["x", "y"]
                ]
            )
        ]
    )
}

await server.withMethodHandler(CallTool.self) { params in
    guard let arguments = params.arguments else {
        return .init(content: [.text("No arguments provided")], isError: true)
    }

    switch params.name {
    case "moveMouse":
        // Try to get x and y as any numeric type
        let xValue = arguments["x"]
        let yValue = arguments["y"]
        
        guard let xValue = xValue, let yValue = yValue else {
            return .init(content: [.text("Missing parameters: x and y are required")], isError: true)
        }
        
        // Try multiple ways to extract the numeric value
        var x: Double?
        var y: Double?
        
        // Try direct double conversion first
        if let doubleX = xValue.doubleValue {
            x = doubleX
        }
        // Try integer conversion
        else if let intX = xValue.intValue {
            x = Double(intX)
        }
        // Try getting as string and parsing
        else if let xStr = xValue.stringValue {
            x = Double(xStr)
        }
        
        // Same for y
        if let doubleY = yValue.doubleValue {
            y = doubleY
        }
        else if let intY = yValue.intValue {
            y = Double(intY)
        }
        else if let yStr = yValue.stringValue {
            y = Double(yStr)
        }
        
        guard let finalX = x, let finalY = y else {
            return .init(content: [.text("Invalid parameters: x and y must be numbers. Received x=\(xValue), y=\(yValue)")], isError: true)
        }
        
        SwiftAutoGUI.move(to: CGPoint(x: finalX, y: finalY))
        return .init(content: [.text("Mouse moved to (\(finalX), \(finalY))")], isError: false)

    case "mouseClick":
        guard let button = arguments["button"]?.stringValue else {
            return .init(content: [.text("Invalid parameter: button must be a string")], isError: true)
        }
        switch button.lowercased() {
        case "left":
            SwiftAutoGUI.leftClick()
        case "right":
            SwiftAutoGUI.rightClick()
        default:
            return .init(content: [.text("Invalid button type. Must be 'left' or 'right'")], isError: true)
        }
        return .init(content: [.text("\(button) click performed")], isError: false)

    case "scroll":
        guard let direction = arguments["direction"]?.stringValue,
              let clicks = arguments["clicks"]?.intValue else {
            return .init(content: [.text("Invalid parameters: direction must be a string and clicks must be a number")], isError: true)
        }
        switch direction.lowercased() {
        case "up":
            SwiftAutoGUI.vscroll(clicks: Int(clicks))
        case "down":
            SwiftAutoGUI.vscroll(clicks: -Int(clicks))
        case "left":
            SwiftAutoGUI.hscroll(clicks: -Int(clicks))
        case "right":
            SwiftAutoGUI.hscroll(clicks: Int(clicks))
        default:
            return .init(content: [.text("Invalid scroll direction. Must be 'up', 'down', 'left', or 'right'")], isError: true)
        }
        return .init(content: [.text("Scrolled \(direction) by \(Int(clicks)) clicks")], isError: false)

    case "sendKeys":
        guard let keys = arguments["keys"]?.arrayValue?.compactMap({ $0.stringValue }), !keys.isEmpty else {
            return .init(content: [.text("Invalid parameters: keys must be a non-empty array of strings")], isError: true)
        }

        let sendKeys = keys.compactMap(Key.init(rawValue:))
        SwiftAutoGUI.sendKeyShortcut(sendKeys)
        return .init(content: [.text("Send key shortcut \(keys)")], isError: false)

    case "getScreenSize":
        let screenSize = SwiftAutoGUI.size()
        return .init(content: [.text("Screen size: {\"width\": \(screenSize.width), \"height\": \(screenSize.height)}")], isError: false)

    case "getPixelColor":
        let xValue = arguments["x"]
        let yValue = arguments["y"]
        
        guard let xValue = xValue, let yValue = yValue else {
            return .init(content: [.text("Missing parameters: x and y are required")], isError: true)
        }
        
        // Try multiple ways to extract the numeric value
        var x: Int?
        var y: Int?
        
        // Try direct integer conversion first
        if let intX = xValue.intValue {
            x = intX
        }
        // Try double conversion and cast to int
        else if let doubleX = xValue.doubleValue {
            x = Int(doubleX)
        }
        // Try getting as string and parsing
        else if let xStr = xValue.stringValue {
            x = Int(xStr)
        }
        
        // Same for y
        if let intY = yValue.intValue {
            y = intY
        }
        else if let doubleY = yValue.doubleValue {
            y = Int(doubleY)
        }
        else if let yStr = yValue.stringValue {
            y = Int(yStr)
        }
        
        guard let finalX = x, let finalY = y else {
            return .init(content: [.text("Invalid parameters: x and y must be numbers. Received x=\(xValue), y=\(yValue)")], isError: true)
        }
        
        // Use macOS native APIs to get pixel color
        let screenRect = CGRect(x: finalX, y: finalY, width: 1, height: 1)
        
        guard let cgImage = CGDisplayCreateImage(CGMainDisplayID()) else {
            return .init(content: [.text("Failed to capture screen image")], isError: true)
        }
        
        let screenSize = SwiftAutoGUI.size()
        
        // Convert screen coordinates to image coordinates (flip Y)
        let imageY = Int(screenSize.height) - finalY - 1
        
        // Create NSImage from CGImage
        let nsImage = NSImage(cgImage: cgImage, size: NSSize(width: cgImage.width, height: cgImage.height))
        
        // Get pixel color at coordinates
        guard let cgImageRef = nsImage.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            return .init(content: [.text("Failed to get CGImage from NSImage")], isError: true)
        }
        
        // Check bounds
        if finalX < 0 || finalX >= cgImageRef.width || imageY < 0 || imageY >= cgImageRef.height {
            return .init(content: [.text("Coordinates (\(finalX), \(finalY)) are outside screen bounds")], isError: true)
        }
        
        // Create data provider to read pixel data
        guard let dataProvider = cgImageRef.dataProvider,
              let data = dataProvider.data,
              let bytes = CFDataGetBytePtr(data) else {
            return .init(content: [.text("Failed to get pixel data")], isError: true)
        }
        
        let bytesPerPixel = 4
        let bytesPerRow = cgImageRef.bytesPerRow
        let pixelIndex = imageY * bytesPerRow + finalX * bytesPerPixel
        
        let red = Int(bytes[pixelIndex + 1])  // Red component
        let green = Int(bytes[pixelIndex + 2])  // Green component
        let blue = Int(bytes[pixelIndex + 3])  // Blue component
        let alpha = Int(bytes[pixelIndex])  // Alpha component
        
        return .init(content: [.text("Pixel color at (\(finalX), \(finalY)): {\"red\": \(red), \"green\": \(green), \"blue\": \(blue), \"alpha\": \(alpha)}")], isError: false)

    default:
        return .init(content: [.text("Unknown tool: \(params.name)")], isError: true)
    }
}

try await server.notify(ToolListChangedNotification.message())
await server.waitForDisconnection()

import Foundation
import MCP
import SwiftAutoGUI

// Initialize the server
let server = Server(
    name: "mac-control-server",
    version: "1.0.0",
    capabilities: .init(
        prompts: .init(listChanged: true),
        resources: .init(list: true, read: true, subscribe: true, listChanged: true),
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
        guard let x = arguments["x"]?.doubleValue,
              let y = arguments["y"]?.doubleValue else {
            return .init(content: [.text("Invalid parameters: x and y must be numbers \(arguments)")], isError: true)
        }
        SwiftAutoGUI.move(to: CGPoint(x: x, y: y))
        return .init(content: [.text("Mouse moved to (\(x), \(y))")], isError: false)
        
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
              let clicks = arguments["clicks"]?.doubleValue else {
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
        
    default:
        return .init(content: [.text("Unknown tool: \(params.name)")], isError: true)
    }
}

try await server.notify(ToolListChangedNotification.message())
await server.waitForDisconnection()

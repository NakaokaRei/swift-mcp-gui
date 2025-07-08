import Foundation
import MCP
import SwiftAutoGUI
import CoreGraphics

struct MoveMouseTool {
    static func register(in registry: ToolRegistry) {
        let tool = Tool(
            name: "moveMouse",
            description: "Move mouse cursor to specific coordinates",
            inputSchema: .object([
                "type": .string("object"),
                "properties": .object([
                    "x": .object(["type": .string("number"), "description": .string("X coordinate")]),
                    "y": .object(["type": .string("number"), "description": .string("Y coordinate")])
                ]),
                "required": .array([.string("x"), .string("y")])
            ])
        )
        
        registry.registerTool(definition: tool) { arguments in
            let parser = ParameterParser(arguments: arguments)
            
            do {
                let x = try parser.parseDouble("x")
                let y = try parser.parseDouble("y")
                
                SwiftAutoGUI.move(to: CGPoint(x: x, y: y))
                return .init(content: [.text("Mouse moved to (\(x), \(y))")], isError: false)
            } catch {
                return .init(content: [.text(error.localizedDescription)], isError: true)
            }
        }
    }
}
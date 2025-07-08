import Foundation
import MCP
import SwiftAutoGUI
import CoreGraphics

class MoveMouseTool: Tool {
    static let name = "moveMouse"
    static let description = "Move mouse cursor to specific coordinates"
    static let inputSchema: JSONValue = [
        "type": "object",
        "properties": [
            "x": ["type": "number", "description": "X coordinate"],
            "y": ["type": "number", "description": "Y coordinate"]
        ],
        "required": ["x", "y"]
    ]
    
    init() {}
    
    func execute(arguments: JSONValue) async throws -> CallTool.Result {
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
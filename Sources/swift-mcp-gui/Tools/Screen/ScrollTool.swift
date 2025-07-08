import Foundation
import MCP
import SwiftAutoGUI

class ScrollTool: Tool {
    static let name = "scroll"
    static let description = "Scroll in specified direction"
    static let inputSchema: JSONValue = [
        "type": "object",
        "properties": [
            "direction": ["type": "string", "description": "Scroll direction (up, down, left, right)"],
            "clicks": ["type": "number", "description": "Number of scroll clicks"]
        ],
        "required": ["direction", "clicks"]
    ]
    
    init() {}
    
    func execute(arguments: JSONValue) async throws -> CallTool.Result {
        let parser = ParameterParser(arguments: arguments)
        
        do {
            let direction = try parser.parseString("direction")
            let clicks = try parser.parseInt("clicks")
            
            switch direction.lowercased() {
            case "up":
                SwiftAutoGUI.vscroll(clicks: clicks)
            case "down":
                SwiftAutoGUI.vscroll(clicks: -clicks)
            case "left":
                SwiftAutoGUI.hscroll(clicks: -clicks)
            case "right":
                SwiftAutoGUI.hscroll(clicks: clicks)
            default:
                return .init(content: [.text("Invalid scroll direction. Must be 'up', 'down', 'left', or 'right'")], isError: true)
            }
            
            return .init(content: [.text("Scrolled \(direction) by \(clicks) clicks")], isError: false)
        } catch {
            return .init(content: [.text(error.localizedDescription)], isError: true)
        }
    }
}
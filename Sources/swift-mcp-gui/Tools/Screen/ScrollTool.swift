import Foundation
import MCP
import SwiftAutoGUI

struct ScrollTool {
    static func register(in registry: ToolRegistry) {
        let tool = Tool(
            name: "scroll",
            description: "Scroll in specified direction",
            inputSchema: .object([
                "type": .string("object"),
                "properties": .object([
                    "direction": .object(["type": .string("string"), "description": .string("Scroll direction (up, down, left, right)")]),
                    "clicks": .object(["type": .string("number"), "description": .string("Number of scroll clicks")])
                ]),
                "required": .array([.string("direction"), .string("clicks")])
            ])
        )
        
        registry.registerTool(definition: tool) { arguments in
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
}
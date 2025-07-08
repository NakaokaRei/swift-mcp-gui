import Foundation
import MCP
import SwiftAutoGUI

struct MouseClickTool {
    static func register(in registry: ToolRegistry) {
        let tool = Tool(
            name: "mouseClick",
            description: "Perform mouse click",
            inputSchema: .object([
                "type": .string("object"),
                "properties": .object([
                    "button": .object(["type": .string("string"), "description": .string("Button to click (left or right)")])
                ]),
                "required": .array([.string("button")])
            ])
        )
        
        registry.registerTool(definition: tool) { arguments in
            let parser = ParameterParser(arguments: arguments)
            
            do {
                let button = try parser.parseString("button")
                
                switch button.lowercased() {
                case "left":
                    SwiftAutoGUI.leftClick()
                case "right":
                    SwiftAutoGUI.rightClick()
                default:
                    return .init(content: [.text("Invalid button type. Must be 'left' or 'right'")], isError: true)
                }
                
                return .init(content: [.text("\(button) click performed")], isError: false)
            } catch {
                return .init(content: [.text(error.localizedDescription)], isError: true)
            }
        }
    }
}
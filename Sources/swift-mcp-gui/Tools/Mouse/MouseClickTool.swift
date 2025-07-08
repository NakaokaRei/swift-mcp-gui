import Foundation
import MCP
import SwiftAutoGUI

class MouseClickTool: Tool {
    static let name = "mouseClick"
    static let description = "Perform mouse click"
    static let inputSchema: JSONValue = [
        "type": "object",
        "properties": [
            "button": ["type": "string", "description": "Button to click (left or right)"]
        ],
        "required": ["button"]
    ]
    
    init() {}
    
    func execute(arguments: JSONValue) async throws -> CallTool.Result {
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
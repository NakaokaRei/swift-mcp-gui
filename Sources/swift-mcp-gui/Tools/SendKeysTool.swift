import Foundation
import MCP
import SwiftAutoGUI

class SendKeysTool: Tool {
    static let name = "sendKeys"
    static let description = "Send keyboard shortcuts and key combinations"
    static let inputSchema: JSONValue = [
        "type": "object",
        "properties": [
            "keys": [
                "type": "string",
                "description": "Keyboard shortcut or text to send (e.g., 'cmd+c', 'Hello World')"
            ]
        ],
        "required": ["keys"]
    ]
    
    init() {}
    
    func execute(arguments: JSONValue) async throws -> CallTool.Result {
        let parser = ParameterParser(arguments: arguments)
        
        do {
            let keys = try parser.parseString("keys")
            
            SwiftAutoGUI.sendKeys(keys)
            
            return .init(
                content: [.text("Sent keys: \(keys)")],
                isError: false
            )
        } catch {
            return .init(content: [.text(error.localizedDescription)], isError: true)
        }
    }
}
import Foundation
import MCP
import SwiftAutoGUI

class SendKeysTool: Tool {
    static let name = "sendKeys"
    static let description = "Send keyboard shortcuts and text input"
    static let inputSchema: JSONValue = [
        "type": "object",
        "properties": [
            "keys": [
                "type": "string", 
                "description": "Keys to send. Use '+' to combine keys (e.g., 'cmd+c' for copy, 'ctrl+v' for paste) or plain text for typing"
            ]
        ],
        "required": ["keys"]
    ]
    
    init() {}
    
    func execute(arguments: JSONValue) async throws -> CallTool.Result {
        let parser = ParameterParser(arguments: arguments)
        
        do {
            let keys = try parser.parseString("keys")
            
            // Use SwiftAutoGUI's sendKeys method directly
            SwiftAutoGUI.sendKeys(keys)
            
            return .init(content: [.text("Keys '\(keys)' sent successfully")], isError: false)
        } catch {
            return .init(content: [.text(error.localizedDescription)], isError: true)
        }
    }
}
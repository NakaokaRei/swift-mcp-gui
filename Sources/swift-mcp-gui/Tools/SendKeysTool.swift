import Foundation
import MCP
import SwiftAutoGUI

class SendKeysTool: Tool {
    static let name = "sendKeys"
    static let description = "Send keyboard shortcuts"
    static let inputSchema: JSONValue = [
        "type": "object",
        "properties": [
            "keys": ["type": "string", "description": "Key combination to send (e.g., 'cmd+c', 'alt+tab')"]
        ],
        "required": ["keys"]
    ]
    
    init() {}
    
    func execute(arguments: JSONValue) async throws -> CallTool.Result {
        let parser = ParameterParser(arguments: arguments)
        
        do {
            let keys = try parser.parseString("keys")
            
            // Parse the key combination
            let components = keys.lowercased().split(separator: "+").map(String.init)
            
            if components.isEmpty {
                return .init(content: [.text("Invalid key combination")], isError: true)
            }
            
            // Handle key combinations using SwiftAutoGUI
            SwiftAutoGUI.sendKeys(keys)
            
            return .init(content: [.text("Keys '\(keys)' sent successfully")], isError: false)
        } catch {
            return .init(content: [.text(error.localizedDescription)], isError: true)
        }
    }
}
import Foundation
import MCP
import SwiftAutoGUI

class SendKeysTool: Tool {
    static let name = "sendKeys"
    static let description = "Sends keyboard shortcuts or key combinations"
    static let inputSchema: JSONValue = [
        "type": "object",
        "properties": [
            "keys": ["type": "array",
                     "items": ["type": "string"],
                     "description": "Sends keyboard shortcuts or key combinations"]
        ],
        "required": ["keys"]
    ]
    
    init() {}
    
    func execute(arguments: JSONValue) async throws -> CallTool.Result {
        let parser = ParameterParser(arguments: arguments)
        
        do {
            let keys = try parser.parseStringArray("keys")
            
            guard !keys.isEmpty else {
                return .init(content: [.text("Keys array cannot be empty")], isError: true)
            }
            
            let sendKeys = keys.compactMap(Key.init(rawValue:))
            SwiftAutoGUI.sendKeyShortcut(sendKeys)
            
            return .init(content: [.text("Send key shortcut \(keys)")], isError: false)
        } catch {
            return .init(content: [.text(error.localizedDescription)], isError: true)
        }
    }
}
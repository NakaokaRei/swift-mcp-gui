import Foundation
import MCP
import SwiftAutoGUI

struct ExecuteAppleScriptTool {
    static func register(in registry: ToolRegistry) {
        let tool = Tool(
            name: "executeAppleScript",
            description: "Execute AppleScript code directly",
            inputSchema: .object([
                "type": .string("object"),
                "properties": .object([
                    "script": .object(["type": .string("string"), "description": .string("AppleScript code to execute")])
                ]),
                "required": .array([.string("script")])
            ])
        )
        
        registry.registerTool(definition: tool) { arguments in
            let parser = ParameterParser(arguments: arguments)
            
            do {
                let script = try parser.parseString("script")
                
                let result = try SwiftAutoGUI.executeAppleScript(script)
                
                if let resultString = result {
                    return .init(content: [.text("AppleScript Result: \(resultString)")], isError: false)
                } else {
                    return .init(content: [.text("AppleScript executed successfully (no result returned)")], isError: false)
                }
            } catch {
                return .init(content: [.text("Failed to execute AppleScript: \(error.localizedDescription)")], isError: true)
            }
        }
    }
}
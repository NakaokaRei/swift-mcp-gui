import Foundation
import MCP
import SwiftAutoGUI

struct ExecuteAppleScriptFileTool {
    static func register(in registry: ToolRegistry) {
        let tool = Tool(
            name: "executeAppleScriptFile",
            description: "Execute AppleScript from a file",
            inputSchema: .object([
                "type": .string("object"),
                "properties": .object([
                    "path": .object(["type": .string("string"), "description": .string("Path to the AppleScript file")])
                ]),
                "required": .array([.string("path")])
            ])
        )
        
        registry.registerTool(definition: tool) { arguments in
            let parser = ParameterParser(arguments: arguments)
            
            do {
                let path = try parser.parseString("path")
                
                let result = try SwiftAutoGUI.executeAppleScriptFile(path)
                
                if let resultString = result {
                    return .init(content: [.text("AppleScript Result: \(resultString)")], isError: false)
                } else {
                    return .init(content: [.text("AppleScript file executed successfully (no result returned): \(path)")], isError: false)
                }
            } catch {
                return .init(content: [.text("Failed to execute AppleScript file: \(error.localizedDescription)")], isError: true)
            }
        }
    }
}
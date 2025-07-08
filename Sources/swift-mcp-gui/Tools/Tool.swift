import Foundation
import MCP

protocol Tool {
    static var name: String { get }
    static var description: String { get }
    static var inputSchema: JSONValue { get }
    
    func execute(arguments: JSONValue) async throws -> CallTool.Result
}

extension Tool {
    static var toolInfo: ToolInfo {
        ToolInfo(
            name: name,
            description: description,
            inputSchema: inputSchema
        )
    }
}
import Foundation
import MCP

class ToolRegistry {
    private var tools: [String: any Tool] = [:]
    
    func register<T: Tool>(_ toolType: T.Type) {
        let tool = toolType.init()
        tools[toolType.name] = tool
    }
    
    func execute(name: String, arguments: JSONValue) async throws -> CallTool.Result {
        guard let tool = tools[name] else {
            return .init(content: [.text("Unknown tool: \(name)")], isError: true)
        }
        
        return try await tool.execute(arguments: arguments)
    }
    
    func listTools() -> [ToolInfo] {
        return tools.keys.compactMap { toolName in
            guard let tool = tools[toolName] else { return nil }
            return type(of: tool).toolInfo
        }
    }
    
    func registerAllTools() {
        register(MoveMouseTool.self)
        register(MouseClickTool.self)
        register(ScrollTool.self)
        register(SendKeysTool.self)
        register(GetScreenSizeTool.self)
        register(GetPixelColorTool.self)
    }
}
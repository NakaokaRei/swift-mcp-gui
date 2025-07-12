import Foundation
import MCP

class ToolRegistry {
    private var toolHandlers: [String: (Value) async throws -> CallTool.Result] = [:]
    private var toolDefinitions: [Tool] = []
    
    func registerTool(definition: Tool, handler: @escaping (Value) async throws -> CallTool.Result) {
        toolDefinitions.append(definition)
        toolHandlers[definition.name] = handler
    }
    
    func execute(name: String, arguments: Value) async throws -> CallTool.Result {
        guard let handler = toolHandlers[name] else {
            return .init(content: [.text("Unknown tool: \(name)")], isError: true)
        }
        
        return try await handler(arguments)
    }
    
    func listTools() -> [Tool] {
        return toolDefinitions
    }
    
    func registerAllTools() {
        // Register each tool with its definition and handler
        MoveMouseTool.register(in: self)
        MouseClickTool.register(in: self)
        ScrollTool.register(in: self)
        SendKeysTool.register(in: self)
        GetScreenSizeTool.register(in: self)
        GetPixelColorTool.register(in: self)
        CaptureScreenTool.register(in: self)
        CaptureRegionTool.register(in: self)
        SaveScreenshotTool.register(in: self)
    }
}
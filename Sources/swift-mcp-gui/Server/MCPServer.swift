import Foundation
import MCP

class MCPServer {
    private let server: Server
    private let toolRegistry: ToolRegistry
    
    init() {
        self.server = Server(
            name: "mac-control-server",
            version: "1.0.0",
            capabilities: .init(
                prompts: .init(listChanged: true),
                tools: .init(listChanged: true)
            )
        )
        self.toolRegistry = ToolRegistry()
    }
    
    func start(transport: StdioTransport) async throws {
        print("Starting MCP GUI Server...")
        try await server.start(transport: transport)
        
        // Register all tools
        toolRegistry.registerAllTools()
        
        // Register method handlers
        await registerMethodHandlers()
        
        // Notify about tool list changes
        try await server.notify(ToolListChangedNotification.message())
    }
    
    private func registerMethodHandlers() async {
        // Register list tools handler
        await server.withMethodHandler(ListTools.self) { [weak self] _ in
            guard let self = self else {
                return ListTools.Result(tools: [])
            }
            return ListTools.Result(tools: self.toolRegistry.listTools())
        }
        
        // Register call tool handler
        await server.withMethodHandler(CallTool.self) { [weak self] params in
            guard let self = self else {
                return .init(content: [.text("Server not available")], isError: true)
            }
            
            guard let arguments = params.arguments else {
                return .init(content: [.text("No arguments provided")], isError: true)
            }
            
            do {
                return try await self.toolRegistry.execute(name: params.name, arguments: arguments)
            } catch {
                return .init(content: [.text("Error executing tool: \(error.localizedDescription)")], isError: true)
            }
        }
    }
    
    func waitForDisconnection() async {
        await server.waitForDisconnection()
    }
}
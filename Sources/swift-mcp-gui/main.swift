import Foundation
import MCP

@main
struct MCPGUIServer {
    static func main() async throws {
        let server = MCPServer()
        let transport = StdioTransport()
        
        // Start server and register tools
        try await server.start(transport: transport)
        
        // Wait for disconnection
        await server.waitForDisconnection()
    }
}
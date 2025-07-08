import Foundation
import MCP


let server = MCPServer()
let transport = StdioTransport()

// Start server and register tools
try await server.start(transport: transport)

// Wait for disconnection
await server.waitForDisconnection()

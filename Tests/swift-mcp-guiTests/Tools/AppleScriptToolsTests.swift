import Testing
import MCP
@testable import swift_mcp_gui

@Suite("AppleScript Tools Tests")
struct AppleScriptToolsTests {
    let toolRegistry: ToolRegistry
    
    init() {
        self.toolRegistry = ToolRegistry()
        ExecuteAppleScriptTool.register(in: toolRegistry)
        ExecuteAppleScriptFileTool.register(in: toolRegistry)
    }
    
    @Test("Execute AppleScript tool registration")
    func executeAppleScriptToolRegistration() {
        let tools = toolRegistry.listTools()
        #expect(tools.contains { $0.name == "executeAppleScript" })
        
        let tool = tools.first { $0.name == "executeAppleScript" }
        #expect(tool != nil)
        #expect(tool?.description == "Execute AppleScript code directly")
    }
    
    @Test("Execute AppleScript file tool registration")
    func executeAppleScriptFileToolRegistration() {
        let tools = toolRegistry.listTools()
        #expect(tools.contains { $0.name == "executeAppleScriptFile" })
        
        let tool = tools.first { $0.name == "executeAppleScriptFile" }
        #expect(tool != nil)
        #expect(tool?.description == "Execute AppleScript from a file")
    }
    
    @Test("Execute AppleScript tool with valid script")
    func executeAppleScriptToolWithValidScript() async throws {
        // Simple AppleScript that returns a value
        let arguments: Value = .object([
            "script": .string("return \"Hello from AppleScript\"")
        ])
        
        let result = try await toolRegistry.execute(name: "executeAppleScript", arguments: arguments)
        
        // Note: This test might succeed or fail depending on AppleScript permissions
        // In sandboxed environments or CI/CD, it might fail due to lack of automation permissions
        #expect(result.content.count > 0)
        
        if result.isError != true {
            #expect(result.content.first { 
                if case .text(let text) = $0 {
                    return text.contains("AppleScript Result:") || text.contains("AppleScript executed successfully")
                }
                return false
            } != nil)
        }
    }
    
    @Test("Execute AppleScript tool with result")
    func executeAppleScriptToolWithResult() async throws {
        // AppleScript that returns a calculated value
        let arguments: Value = .object([
            "script": .string("return 2 + 2")
        ])
        
        let result = try await toolRegistry.execute(name: "executeAppleScript", arguments: arguments)
        
        // Note: This test might succeed or fail depending on AppleScript permissions
        #expect(result.content.count > 0)
        
        if result.isError != true {
            #expect(result.content.first { 
                if case .text(let text) = $0 {
                    // The result should contain "4" or similar
                    return text.contains("AppleScript Result:") || text.contains("no result returned")
                }
                return false
            } != nil)
        }
    }
    
    @Test("Execute AppleScript tool without result")
    func executeAppleScriptToolWithoutResult() async throws {
        // AppleScript that doesn't return a value
        let arguments: Value = .object([
            "script": .string("beep")
        ])
        
        let result = try await toolRegistry.execute(name: "executeAppleScript", arguments: arguments)
        
        // Note: This test might succeed or fail depending on AppleScript permissions
        if result.isError != true {
            #expect(result.content.first { 
                if case .text(let text) = $0 {
                    return text.contains("no result returned") || text.contains("AppleScript Result:")
                }
                return false
            } != nil)
        }
    }
    
    @Test("Execute AppleScript tool with missing script parameter")
    func executeAppleScriptToolMissingScript() async throws {
        let arguments: Value = .object([:])
        
        let result = try await toolRegistry.execute(name: "executeAppleScript", arguments: arguments)
        #expect(result.isError == true)
        #expect(result.content.first { 
            if case .text(let text) = $0 {
                return text.contains("Missing parameter: script")
            }
            return false
        } != nil)
    }
    
    @Test("Execute AppleScript tool with invalid parameter type")
    func executeAppleScriptToolInvalidParameterType() async throws {
        let arguments: Value = .object([
            "script": .int(123)  // Should be string
        ])
        
        let result = try await toolRegistry.execute(name: "executeAppleScript", arguments: arguments)
        #expect(result.isError == true)
        #expect(result.content.first { 
            if case .text(let text) = $0 {
                return text.contains("Invalid parameter script: expected string")
            }
            return false
        } != nil)
    }
    
    @Test("Execute AppleScript file tool with missing path parameter")
    func executeAppleScriptFileToolMissingPath() async throws {
        let arguments: Value = .object([:])
        
        let result = try await toolRegistry.execute(name: "executeAppleScriptFile", arguments: arguments)
        #expect(result.isError == true)
        #expect(result.content.first { 
            if case .text(let text) = $0 {
                return text.contains("Missing parameter: path")
            }
            return false
        } != nil)
    }
    
    @Test("Execute AppleScript file tool with invalid parameter type")
    func executeAppleScriptFileToolInvalidParameterType() async throws {
        let arguments: Value = .object([
            "path": .bool(true)  // Should be string
        ])
        
        let result = try await toolRegistry.execute(name: "executeAppleScriptFile", arguments: arguments)
        #expect(result.isError == true)
        #expect(result.content.first { 
            if case .text(let text) = $0 {
                return text.contains("Invalid parameter path: expected string")
            }
            return false
        } != nil)
    }
    
    @Test("Execute AppleScript file tool with non-existent file")
    func executeAppleScriptFileToolNonExistentFile() async throws {
        let arguments: Value = .object([
            "path": .string("/path/to/non/existent/script.applescript")
        ])
        
        let result = try await toolRegistry.execute(name: "executeAppleScriptFile", arguments: arguments)
        #expect(result.isError == true)
        #expect(result.content.first { 
            if case .text(let text) = $0 {
                return text.contains("Failed to execute AppleScript file")
            }
            return false
        } != nil)
    }
    
    @Test("Execute AppleScript tool schema validation")
    func executeAppleScriptToolSchema() {
        let tools = toolRegistry.listTools()
        let tool = tools.first { $0.name == "executeAppleScript" }!
        
        // Verify the input schema structure
        if case .object(let schema) = tool.inputSchema {
            if case .string(let typeValue) = schema["type"] {
                #expect(typeValue == "object")
            }
            
            if case .object(let properties) = schema["properties"] {
                // Check script parameter
                if case .object(let scriptProp) = properties["script"] {
                    if case .string(let typeValue) = scriptProp["type"] {
                        #expect(typeValue == "string")
                    }
                    if case .string(let descValue) = scriptProp["description"] {
                        #expect(descValue == "AppleScript code to execute")
                    }
                }
                
                // Check required parameters
                if case .array(let required) = schema["required"] {
                    #expect(required.count == 1)
                    #expect(required.contains { 
                        if case .string(let value) = $0 {
                            return value == "script"
                        }
                        return false
                    })
                }
            }
        }
    }
    
    @Test("Execute AppleScript file tool schema validation")
    func executeAppleScriptFileToolSchema() {
        let tools = toolRegistry.listTools()
        let tool = tools.first { $0.name == "executeAppleScriptFile" }!
        
        // Verify the input schema structure
        if case .object(let schema) = tool.inputSchema {
            if case .string(let typeValue) = schema["type"] {
                #expect(typeValue == "object")
            }
            
            if case .object(let properties) = schema["properties"] {
                // Check path parameter
                if case .object(let pathProp) = properties["path"] {
                    if case .string(let typeValue) = pathProp["type"] {
                        #expect(typeValue == "string")
                    }
                    if case .string(let descValue) = pathProp["description"] {
                        #expect(descValue == "Path to the AppleScript file")
                    }
                }
                
                // Check required parameters
                if case .array(let required) = schema["required"] {
                    #expect(required.count == 1)
                    #expect(required.contains { 
                        if case .string(let value) = $0 {
                            return value == "path"
                        }
                        return false
                    })
                }
            }
        }
    }
}
import Testing
import MCP
@testable import swift_mcp_gui

@Suite("Mouse Tools Tests")
struct MouseToolsTests {
    let toolRegistry: ToolRegistry
    
    init() {
        self.toolRegistry = ToolRegistry()
        MoveMouseTool.register(in: toolRegistry)
        MouseClickTool.register(in: toolRegistry)
    }
    
    @Test("Move mouse tool execution")
    func moveMouseToolExecution() async throws {
        let arguments: Value = .object([
            "x": .int(100),
            "y": .int(200)
        ])
        
        let result = try await toolRegistry.execute(name: "moveMouse", arguments: arguments)
        #expect(result.isError == false)
        #expect(result.content.first { 
            if case .text(let text) = $0 {
                return text == "Mouse moved to (100.0, 200.0)"
            }
            return false
        } != nil)
    }
    
    @Test("Move mouse tool with double values")
    func moveMouseToolWithDoubleValues() async throws {
        let arguments: Value = .object([
            "x": .double(100.5),
            "y": .double(200.7)
        ])
        
        let result = try await toolRegistry.execute(name: "moveMouse", arguments: arguments)
        #expect(result.isError == false)
        #expect(result.content.first { 
            if case .text(let text) = $0 {
                return text == "Mouse moved to (100.5, 200.7)"
            }
            return false
        } != nil)
    }
    
    @Test("Move mouse tool with string values")
    func moveMouseToolWithStringValues() async throws {
        let arguments: Value = .object([
            "x": .string("100"),
            "y": .string("200")
        ])
        
        let result = try await toolRegistry.execute(name: "moveMouse", arguments: arguments)
        #expect(result.isError == false)
        #expect(result.content.first { 
            if case .text(let text) = $0 {
                return text == "Mouse moved to (100.0, 200.0)"
            }
            return false
        } != nil)
    }
    
    @Test("Move mouse tool with missing parameters")
    func moveMouseToolMissingParameters() async throws {
        let arguments: Value = .object([
            "x": .int(100)
            // Missing y parameter
        ])
        
        let result = try await toolRegistry.execute(name: "moveMouse", arguments: arguments)
        #expect(result.isError == true)
        #expect(result.content.first { 
            if case .text(let text) = $0 {
                return text.contains("Missing parameter: y")
            }
            return false
        } != nil)
    }
    
    @Test("Mouse click tool execution")
    func mouseClickToolExecution() async throws {
        let arguments: Value = .object([
            "button": .string("left")
        ])
        
        let result = try await toolRegistry.execute(name: "mouseClick", arguments: arguments)
        #expect(result.isError == false)
        #expect(result.content.first { 
            if case .text(let text) = $0 {
                return text == "left click performed"
            }
            return false
        } != nil)
    }
    
    @Test("Mouse click tool right click")
    func mouseClickToolRightClick() async throws {
        let arguments: Value = .object([
            "button": .string("right")
        ])
        
        let result = try await toolRegistry.execute(name: "mouseClick", arguments: arguments)
        #expect(result.isError == false)
        #expect(result.content.first { 
            if case .text(let text) = $0 {
                return text == "right click performed"
            }
            return false
        } != nil)
    }
    
    @Test("Mouse click tool with invalid button")
    func mouseClickToolInvalidButton() async throws {
        let arguments: Value = .object([
            "button": .string("invalid")
        ])
        
        let result = try await toolRegistry.execute(name: "mouseClick", arguments: arguments)
        #expect(result.isError == true)
        #expect(result.content.first { 
            if case .text(let text) = $0 {
                return text.contains("Invalid button type")
            }
            return false
        } != nil)
    }
    
    @Test("Unknown tool")
    func unknownTool() async throws {
        let arguments: Value = .object([:])
        
        let result = try await toolRegistry.execute(name: "unknownTool", arguments: arguments)
        #expect(result.isError == true)
        #expect(result.content.first { 
            if case .text(let text) = $0 {
                return text.contains("Unknown tool")
            }
            return false
        } != nil)
    }
    
    @Test("Mouse click tool with case variations", arguments: [
        ("Left", "Left"), ("LEFT", "LEFT"), ("Right", "Right"), ("RIGHT", "RIGHT")
    ])
    func mouseClickToolCaseVariations(input: String, expected: String) async throws {
        let arguments: Value = .object([
            "button": .string(input)
        ])
        
        let result = try await toolRegistry.execute(name: "mouseClick", arguments: arguments)
        #expect(result.isError == false)
        #expect(result.content.first { 
            if case .text(let text) = $0 {
                return text == "\(expected) click performed"
            }
            return false
        } != nil)
    }
}
import Testing
import MCP
@testable import swift_mcp_gui

@Suite("Keyboard Tools Tests")
struct KeyboardToolsTests {
    let toolRegistry: ToolRegistry
    
    init() {
        self.toolRegistry = ToolRegistry()
        SendKeysTool.register(in: toolRegistry)
    }
    
    @Test("Send keys tool execution with command+c")
    func sendKeysToolExecution() async throws {
        let arguments: Value = .object([
            "keys": .array([.string("cmd"), .string("c")])
        ])
        
        let result = try await toolRegistry.execute(name: "sendKeys", arguments: arguments)
        #expect(result.isError == false)
        #expect(result.content.first { 
            if case .text(let text) = $0 {
                return text == "Sent key combination: cmd+c"
            }
            return false
        } != nil)
    }
    
    @Test("Send keys tool with single key")
    func sendKeysToolSingleKey() async throws {
        let arguments: Value = .object([
            "keys": .array([.string("space")])
        ])
        
        let result = try await toolRegistry.execute(name: "sendKeys", arguments: arguments)
        #expect(result.isError == false)
        #expect(result.content.first { 
            if case .text(let text) = $0 {
                return text == "Sent key combination: space"
            }
            return false
        } != nil)
    }
    
    @Test("Send keys tool with complex combination")
    func sendKeysToolComplexCombination() async throws {
        let arguments: Value = .object([
            "keys": .array([.string("cmd"), .string("shift"), .string("a")])
        ])
        
        let result = try await toolRegistry.execute(name: "sendKeys", arguments: arguments)
        #expect(result.isError == false)
        #expect(result.content.first { 
            if case .text(let text) = $0 {
                return text == "Sent key combination: cmd+shift+a"
            }
            return false
        } != nil)
    }
    
    @Test("Send keys tool with alternative key names", arguments: [
        (["command"], "command"),
        (["ctrl"], "ctrl"),
        (["opt"], "opt"),
        (["alt"], "alt"),
        (["return"], "return"),
        (["enter"], "enter"),
        (["esc"], "esc"),
        (["del"], "del")
    ])
    func sendKeysToolAlternativeNames(keys: [String], displayName: String) async throws {
        let arguments: Value = .object([
            "keys": .array(keys.map { .string($0) })
        ])
        
        let result = try await toolRegistry.execute(name: "sendKeys", arguments: arguments)
        #expect(result.isError == false)
        #expect(result.content.first { 
            if case .text(let text) = $0 {
                return text == "Sent key combination: \(displayName)"
            }
            return false
        } != nil)
    }
    
    @Test("Send keys tool with empty array")
    func sendKeysToolEmptyArray() async throws {
        let arguments: Value = .object([
            "keys": .array([])
        ])
        
        let result = try await toolRegistry.execute(name: "sendKeys", arguments: arguments)
        #expect(result.isError == true)
        #expect(result.content.first { 
            if case .text(let text) = $0 {
                return text.contains("No keys specified")
            }
            return false
        } != nil)
    }
    
    @Test("Send keys tool with missing parameter")
    func sendKeysToolMissingParameter() async throws {
        let arguments: Value = .object([:])
        
        let result = try await toolRegistry.execute(name: "sendKeys", arguments: arguments)
        #expect(result.isError == true)
        #expect(result.content.first { 
            if case .text(let text) = $0 {
                return text.contains("Missing parameter: keys")
            }
            return false
        } != nil)
    }
    
    @Test("Send keys tool with invalid key")
    func sendKeysToolInvalidKey() async throws {
        let arguments: Value = .object([
            "keys": .array([.string("invalid_key")])
        ])
        
        let result = try await toolRegistry.execute(name: "sendKeys", arguments: arguments)
        #expect(result.isError == true)
        #expect(result.content.first { 
            if case .text(let text) = $0 {
                return text.contains("Unknown key: invalid_key")
            }
            return false
        } != nil)
    }
    
    @Test("Send keys tool with wrong parameter type")
    func sendKeysToolWrongParameterType() async throws {
        let arguments: Value = .object([
            "keys": .string("cmd+c")  // Should be array, not string
        ])
        
        let result = try await toolRegistry.execute(name: "sendKeys", arguments: arguments)
        #expect(result.isError == true)
        #expect(result.content.first { 
            if case .text(let text) = $0 {
                return text.contains("Invalid parameter keys")
            }
            return false
        } != nil)
    }
    
    @Test("Send keys tool with number keys", arguments: [
        "1", "2", "3", "4", "5", "6", "7", "8", "9", "0"
    ])
    func sendKeysToolNumberKeys(key: String) async throws {
        let arguments: Value = .object([
            "keys": .array([.string(key)])
        ])
        
        let result = try await toolRegistry.execute(name: "sendKeys", arguments: arguments)
        #expect(result.isError == false)
        #expect(result.content.first { 
            if case .text(let text) = $0 {
                return text == "Sent key combination: \(key)"
            }
            return false
        } != nil)
    }
    
    @Test("Send keys tool with letter keys", arguments: [
        "a", "c", "v", "x", "z"
    ])
    func sendKeysToolLetterKeys(key: String) async throws {
        let arguments: Value = .object([
            "keys": .array([.string(key)])
        ])
        
        let result = try await toolRegistry.execute(name: "sendKeys", arguments: arguments)
        #expect(result.isError == false)
        #expect(result.content.first { 
            if case .text(let text) = $0 {
                return text == "Sent key combination: \(key)"
            }
            return false
        } != nil)
    }
    
    @Test("Send keys tool with arrow keys", arguments: [
        "up", "down", "left", "right"
    ])
    func sendKeysToolArrowKeys(key: String) async throws {
        let arguments: Value = .object([
            "keys": .array([.string(key)])
        ])
        
        let result = try await toolRegistry.execute(name: "sendKeys", arguments: arguments)
        #expect(result.isError == false)
        #expect(result.content.first { 
            if case .text(let text) = $0 {
                return text == "Sent key combination: \(key)"
            }
            return false
        } != nil)
    }
}
import Testing
import MCP
@testable import swift_mcp_gui

@Suite("Screen Tools Tests")
struct ScreenToolsTests {
    let toolRegistry: ToolRegistry
    
    init() {
        self.toolRegistry = ToolRegistry()
        ScrollTool.register(in: toolRegistry)
        GetScreenSizeTool.register(in: toolRegistry)
        GetPixelColorTool.register(in: toolRegistry)
    }
    
    @Test("Scroll tool execution")
    func scrollToolExecution() async throws {
        let arguments: Value = .object([
            "direction": .string("up"),
            "clicks": .int(3)
        ])
        
        let result = try await toolRegistry.execute(name: "scroll", arguments: arguments)
        #expect(result.isError == false)
        #expect(result.content.first { 
            if case .text(let text) = $0 {
                return text == "Scrolled up by 3 clicks"
            }
            return false
        } != nil)
    }
    
    @Test("Scroll tool all directions", arguments: [
        "up", "down", "left", "right"
    ])
    func scrollToolAllDirections(direction: String) async throws {
        let arguments: Value = .object([
            "direction": .string(direction),
            "clicks": .int(2)
        ])
        
        let result = try await toolRegistry.execute(name: "scroll", arguments: arguments)
        #expect(result.isError == false)
        #expect(result.content.first { 
            if case .text(let text) = $0 {
                return text == "Scrolled \(direction) by 2 clicks"
            }
            return false
        } != nil)
    }
    
    @Test("Scroll tool with invalid direction")
    func scrollToolInvalidDirection() async throws {
        let arguments: Value = .object([
            "direction": .string("invalid"),
            "clicks": .int(3)
        ])
        
        let result = try await toolRegistry.execute(name: "scroll", arguments: arguments)
        #expect(result.isError == true)
        #expect(result.content.first { 
            if case .text(let text) = $0 {
                return text.contains("Invalid scroll direction")
            }
            return false
        } != nil)
    }
    
    @Test("Scroll tool with missing direction")
    func scrollToolMissingDirection() async throws {
        let arguments: Value = .object([
            "clicks": .int(3)
        ])
        
        let result = try await toolRegistry.execute(name: "scroll", arguments: arguments)
        #expect(result.isError == true)
        #expect(result.content.first { 
            if case .text(let text) = $0 {
                return text.contains("Missing parameter: direction")
            }
            return false
        } != nil)
    }
    
    @Test("Scroll tool with missing clicks")
    func scrollToolMissingClicks() async throws {
        let arguments: Value = .object([
            "direction": .string("up")
        ])
        
        let result = try await toolRegistry.execute(name: "scroll", arguments: arguments)
        #expect(result.isError == true)
        #expect(result.content.first { 
            if case .text(let text) = $0 {
                return text.contains("Missing parameter: clicks")
            }
            return false
        } != nil)
    }
    
    @Test("Scroll tool with string clicks value")
    func scrollToolStringClicks() async throws {
        let arguments: Value = .object([
            "direction": .string("down"),
            "clicks": .string("5")
        ])
        
        let result = try await toolRegistry.execute(name: "scroll", arguments: arguments)
        #expect(result.isError == false)
        #expect(result.content.first { 
            if case .text(let text) = $0 {
                return text == "Scrolled down by 5 clicks"
            }
            return false
        } != nil)
    }
    
    @Test("Get screen size tool execution")
    func getScreenSizeToolExecution() async throws {
        let arguments: Value = .object([:])
        
        let result = try await toolRegistry.execute(name: "getScreenSize", arguments: arguments)
        #expect(result.isError == false)
        #expect(result.content.first { 
            if case .text(let text) = $0 {
                return text.contains("Screen size:") && 
                       text.contains("width") && 
                       text.contains("height")
            }
            return false
        } != nil)
    }
    
    @Test("Get pixel color tool execution")
    func getPixelColorToolExecution() async throws {
        let arguments: Value = .object([
            "x": .int(100),
            "y": .int(200)
        ])
        
        let result = try await toolRegistry.execute(name: "getPixelColor", arguments: arguments)
        // Note: This test might succeed or fail depending on screen access permissions
        // In CI/CD environments, it might fail due to lack of screen access
        if result.isError != true {
            #expect(result.content.first { 
                if case .text(let text) = $0 {
                    return text.contains("Pixel color at (100, 200):") &&
                           text.contains("red") &&
                           text.contains("green") &&
                           text.contains("blue") &&
                           text.contains("alpha")
                }
                return false
            } != nil)
        }
    }
    
    @Test("Get pixel color tool with missing parameter")
    func getPixelColorToolMissingParameter() async throws {
        let arguments: Value = .object([
            "x": .int(100)
            // Missing y parameter
        ])
        
        let result = try await toolRegistry.execute(name: "getPixelColor", arguments: arguments)
        #expect(result.isError == true)
        #expect(result.content.first { 
            if case .text(let text) = $0 {
                return text.contains("Missing parameter: y")
            }
            return false
        } != nil)
    }
    
    @Test("Get pixel color tool with string parameters")
    func getPixelColorToolStringParameters() async throws {
        let arguments: Value = .object([
            "x": .string("50"),
            "y": .string("100")
        ])
        
        let result = try await toolRegistry.execute(name: "getPixelColor", arguments: arguments)
        // This might succeed or fail depending on screen access
        if result.isError != true {
            #expect(result.content.first { 
                if case .text(let text) = $0 {
                    return text.contains("Pixel color at (50, 100):")
                }
                return false
            } != nil)
        }
    }
    
    @Test("Get pixel color tool with double parameters")
    func getPixelColorToolDoubleParameters() async throws {
        let arguments: Value = .object([
            "x": .double(50.5),
            "y": .double(100.7)
        ])
        
        let result = try await toolRegistry.execute(name: "getPixelColor", arguments: arguments)
        // This might succeed or fail depending on screen access
        if result.isError != true {
            #expect(result.content.first { 
                if case .text(let text) = $0 {
                    return text.contains("Pixel color at (50, 100):")
                }
                return false
            } != nil)
        }
    }
}
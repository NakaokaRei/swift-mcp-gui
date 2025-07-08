import XCTest
import MCP
@testable import swift_mcp_gui

final class ScreenToolsTests: XCTestCase {
    
    func testScrollToolExecution() async throws {
        let tool = ScrollTool()
        let arguments: JSONValue = [
            "direction": "up",
            "clicks": 3
        ]
        
        let result = try await tool.execute(arguments: arguments)
        XCTAssertFalse(result.isError)
        XCTAssertEqual(result.content.first?.text, "Scrolled up by 3 clicks")
    }
    
    func testScrollToolInvalidDirection() async throws {
        let tool = ScrollTool()
        let arguments: JSONValue = [
            "direction": "invalid",
            "clicks": 3
        ]
        
        let result = try await tool.execute(arguments: arguments)
        XCTAssertTrue(result.isError)
        XCTAssertTrue(result.content.first?.text?.contains("Invalid scroll direction") ?? false)
    }
    
    func testGetScreenSizeToolExecution() async throws {
        let tool = GetScreenSizeTool()
        let arguments: JSONValue = [:]
        
        let result = try await tool.execute(arguments: arguments)
        XCTAssertFalse(result.isError)
        XCTAssertTrue(result.content.first?.text?.contains("Screen size:") ?? false)
    }
    
    func testGetPixelColorToolExecution() async throws {
        let tool = GetPixelColorTool()
        let arguments: JSONValue = [
            "x": 100,
            "y": 200
        ]
        
        let result = try await tool.execute(arguments: arguments)
        // Note: This test might fail in CI/CD environments without proper display access
        // In a real implementation, you might want to mock SwiftAutoGUI for testing
        XCTAssertFalse(result.isError)
    }
    
    func testGetPixelColorToolMissingParameters() async throws {
        let tool = GetPixelColorTool()
        let arguments: JSONValue = [
            "x": 100
            // Missing y parameter
        ]
        
        let result = try await tool.execute(arguments: arguments)
        XCTAssertTrue(result.isError)
        XCTAssertTrue(result.content.first?.text?.contains("Missing parameter: y") ?? false)
    }
}
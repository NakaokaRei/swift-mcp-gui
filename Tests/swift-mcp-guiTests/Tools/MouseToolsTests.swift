import XCTest
import MCP
@testable import swift_mcp_gui

final class MouseToolsTests: XCTestCase {
    
    func testMoveMouseToolExecution() async throws {
        let tool = MoveMouseTool()
        let arguments: JSONValue = [
            "x": 100,
            "y": 200
        ]
        
        let result = try await tool.execute(arguments: arguments)
        XCTAssertFalse(result.isError)
        XCTAssertEqual(result.content.first?.text, "Mouse moved to (100.0, 200.0)")
    }
    
    func testMoveMouseToolMissingParameters() async throws {
        let tool = MoveMouseTool()
        let arguments: JSONValue = [
            "x": 100
            // Missing y parameter
        ]
        
        let result = try await tool.execute(arguments: arguments)
        XCTAssertTrue(result.isError)
        XCTAssertTrue(result.content.first?.text?.contains("Missing parameter: y") ?? false)
    }
    
    func testMouseClickToolExecution() async throws {
        let tool = MouseClickTool()
        let arguments: JSONValue = [
            "button": "left"
        ]
        
        let result = try await tool.execute(arguments: arguments)
        XCTAssertFalse(result.isError)
        XCTAssertEqual(result.content.first?.text, "left click performed")
    }
    
    func testMouseClickToolInvalidButton() async throws {
        let tool = MouseClickTool()
        let arguments: JSONValue = [
            "button": "invalid"
        ]
        
        let result = try await tool.execute(arguments: arguments)
        XCTAssertTrue(result.isError)
        XCTAssertTrue(result.content.first?.text?.contains("Invalid button type") ?? false)
    }
}
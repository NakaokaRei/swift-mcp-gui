import XCTest
import MCP
@testable import swift_mcp_gui

final class KeyboardToolsTests: XCTestCase {
    
    func testSendKeysToolExecution() async throws {
        let tool = SendKeysTool()
        let arguments: JSONValue = [
            "keys": ["cmd", "c"]
        ]
        
        let result = try await tool.execute(arguments: arguments)
        XCTAssertFalse(result.isError)
        XCTAssertTrue(result.content.first?.text?.contains("Send key shortcut") ?? false)
    }
    
    func testSendKeysToolEmptyArray() async throws {
        let tool = SendKeysTool()
        let arguments: JSONValue = [
            "keys": []
        ]
        
        let result = try await tool.execute(arguments: arguments)
        XCTAssertTrue(result.isError)
        XCTAssertTrue(result.content.first?.text?.contains("Keys array cannot be empty") ?? false)
    }
    
    func testSendKeysToolMissingParameter() async throws {
        let tool = SendKeysTool()
        let arguments: JSONValue = [:]
        
        let result = try await tool.execute(arguments: arguments)
        XCTAssertTrue(result.isError)
        XCTAssertTrue(result.content.first?.text?.contains("Missing parameter: keys") ?? false)
    }
}
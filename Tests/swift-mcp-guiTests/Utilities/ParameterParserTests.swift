import XCTest
import MCP
@testable import swift_mcp_gui

final class ParameterParserTests: XCTestCase {
    
    func testParseDoubleFromDouble() throws {
        let arguments: JSONValue = ["value": 123.45]
        let parser = ParameterParser(arguments: arguments)
        
        let result = try parser.parseDouble("value")
        XCTAssertEqual(result, 123.45, accuracy: 0.001)
    }
    
    func testParseDoubleFromInt() throws {
        let arguments: JSONValue = ["value": 123]
        let parser = ParameterParser(arguments: arguments)
        
        let result = try parser.parseDouble("value")
        XCTAssertEqual(result, 123.0, accuracy: 0.001)
    }
    
    func testParseDoubleFromString() throws {
        let arguments: JSONValue = ["value": "123.45"]
        let parser = ParameterParser(arguments: arguments)
        
        let result = try parser.parseDouble("value")
        XCTAssertEqual(result, 123.45, accuracy: 0.001)
    }
    
    func testParseDoubleMissingParameter() {
        let arguments: JSONValue = [:]
        let parser = ParameterParser(arguments: arguments)
        
        XCTAssertThrowsError(try parser.parseDouble("value")) { error in
            XCTAssertTrue(error is ParameterError)
            if case ParameterError.missingParameter(let key) = error {
                XCTAssertEqual(key, "value")
            }
        }
    }
    
    func testParseIntFromInt() throws {
        let arguments: JSONValue = ["value": 123]
        let parser = ParameterParser(arguments: arguments)
        
        let result = try parser.parseInt("value")
        XCTAssertEqual(result, 123)
    }
    
    func testParseIntFromDouble() throws {
        let arguments: JSONValue = ["value": 123.0]
        let parser = ParameterParser(arguments: arguments)
        
        let result = try parser.parseInt("value")
        XCTAssertEqual(result, 123)
    }
    
    func testParseString() throws {
        let arguments: JSONValue = ["value": "hello world"]
        let parser = ParameterParser(arguments: arguments)
        
        let result = try parser.parseString("value")
        XCTAssertEqual(result, "hello world")
    }
    
    func testParseStringArray() throws {
        let arguments: JSONValue = ["value": ["cmd", "c", "v"]]
        let parser = ParameterParser(arguments: arguments)
        
        let result = try parser.parseStringArray("value")
        XCTAssertEqual(result, ["cmd", "c", "v"])
    }
    
    func testParseStringArrayInvalidType() {
        let arguments: JSONValue = ["value": "not an array"]
        let parser = ParameterParser(arguments: arguments)
        
        XCTAssertThrowsError(try parser.parseStringArray("value")) { error in
            XCTAssertTrue(error is ParameterError)
            if case ParameterError.invalidType(let key, let expected, _) = error {
                XCTAssertEqual(key, "value")
                XCTAssertEqual(expected, "array")
            }
        }
    }
}
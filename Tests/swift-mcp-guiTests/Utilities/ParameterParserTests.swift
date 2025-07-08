import Testing
import MCP
@testable import swift_mcp_gui

@Suite("Parameter Parser Tests")
struct ParameterParserTests {
    
    @Test("Parse double from double value")
    func parseDoubleFromDouble() throws {
        let arguments: Value = .object(["value": .double(123.45)])
        let parser = ParameterParser(arguments: arguments)
        
        let result = try parser.parseDouble("value")
        #expect(result == 123.45)
    }
    
    @Test("Parse double from int value")
    func parseDoubleFromInt() throws {
        let arguments: Value = .object(["value": .int(123)])
        let parser = ParameterParser(arguments: arguments)
        
        let result = try parser.parseDouble("value")
        #expect(result == 123.0)
    }
    
    @Test("Parse double from string value")
    func parseDoubleFromString() throws {
        let arguments: Value = .object(["value": .string("123.45")])
        let parser = ParameterParser(arguments: arguments)
        
        let result = try parser.parseDouble("value")
        #expect(result == 123.45)
    }
    
    @Test("Parse double from invalid string")
    func parseDoubleInvalidString() {
        let arguments: Value = .object(["value": .string("not a number")])
        let parser = ParameterParser(arguments: arguments)
        
        #expect(throws: ParameterError.self) {
            _ = try parser.parseDouble("value")
        }
    }
    
    @Test("Parse double with missing parameter")
    func parseDoubleMissingParameter() {
        let arguments: Value = .object([:])
        let parser = ParameterParser(arguments: arguments)
        
        #expect(throws: ParameterError.self) {
            _ = try parser.parseDouble("value")
        }
    }
    
    @Test("Parse int from int value")
    func parseIntFromInt() throws {
        let arguments: Value = .object(["value": .int(123)])
        let parser = ParameterParser(arguments: arguments)
        
        let result = try parser.parseInt("value")
        #expect(result == 123)
    }
    
    @Test("Parse int from double value")
    func parseIntFromDouble() throws {
        let arguments: Value = .object(["value": .double(123.0)])
        let parser = ParameterParser(arguments: arguments)
        
        let result = try parser.parseInt("value")
        #expect(result == 123)
    }
    
    @Test("Parse int from string value")
    func parseIntFromString() throws {
        let arguments: Value = .object(["value": .string("456")])
        let parser = ParameterParser(arguments: arguments)
        
        let result = try parser.parseInt("value")
        #expect(result == 456)
    }
    
    @Test("Parse int from invalid string")
    func parseIntInvalidString() {
        let arguments: Value = .object(["value": .string("not a number")])
        let parser = ParameterParser(arguments: arguments)
        
        #expect(throws: ParameterError.self) {
            _ = try parser.parseInt("value")
        }
    }
    
    @Test("Parse string")
    func parseString() throws {
        let arguments: Value = .object(["value": .string("hello world")])
        let parser = ParameterParser(arguments: arguments)
        
        let result = try parser.parseString("value")
        #expect(result == "hello world")
    }
    
    @Test("Parse string with invalid type")
    func parseStringInvalidType() {
        let arguments: Value = .object(["value": .int(123)])
        let parser = ParameterParser(arguments: arguments)
        
        #expect(throws: ParameterError.self) {
            _ = try parser.parseString("value")
        }
    }
    
    @Test("Parse string array")
    func parseStringArray() throws {
        let arguments: Value = .object(["value": .array([.string("cmd"), .string("c"), .string("v")])])
        let parser = ParameterParser(arguments: arguments)
        
        let result = try parser.parseStringArray("value")
        #expect(result == ["cmd", "c", "v"])
    }
    
    @Test("Parse empty string array")
    func parseStringArrayEmpty() throws {
        let arguments: Value = .object(["value": .array([])])
        let parser = ParameterParser(arguments: arguments)
        
        let result = try parser.parseStringArray("value")
        #expect(result == [])
    }
    
    @Test("Parse string array with invalid type")
    func parseStringArrayInvalidType() {
        let arguments: Value = .object(["value": .string("not an array")])
        let parser = ParameterParser(arguments: arguments)
        
        #expect(throws: ParameterError.self) {
            _ = try parser.parseStringArray("value")
        }
    }
    
    @Test("Parse string array with mixed types")
    func parseStringArrayMixedTypes() {
        let arguments: Value = .object(["value": .array([.string("hello"), .int(123)])])
        let parser = ParameterParser(arguments: arguments)
        
        #expect(throws: ParameterError.self) {
            _ = try parser.parseStringArray("value")
        }
    }
    
    @Test("Parse from non-object value")
    func parseFromNonObjectValue() {
        let arguments: Value = .string("not an object")
        let parser = ParameterParser(arguments: arguments)
        
        #expect(throws: ParameterError.self) {
            _ = try parser.parseString("value")
        }
    }
    
    @Test("Parameter error messages")
    func parameterErrorMessages() {
        // Test missing parameter error
        if let error = ParameterError.missingParameter("testKey").errorDescription {
            #expect(error == "Missing parameter: testKey")
        }
        
        // Test invalid type error
        if let error = ParameterError.invalidType(key: "testKey", expected: "number", received: "string").errorDescription {
            #expect(error == "Invalid parameter testKey: expected number, received string")
        }
    }
    
    @Test("Parse various numeric formats", arguments: [
        ("123", 123),
        ("-100", -100),
        ("0", 0)
    ])
    func parseIntFromVariousStringFormats(input: String, expected: Int) throws {
        let arguments: Value = .object(["value": .string(input)])
        let parser = ParameterParser(arguments: arguments)
        
        let result = try parser.parseInt("value")
        #expect(result == expected)
    }
    
    @Test("Parse various double formats", arguments: [
        ("123.45", 123.45),
        ("0.0", 0.0),
        ("-456.789", -456.789),
        ("1e3", 1000.0)
    ])
    func parseDoubleFromVariousStringFormats(input: String, expected: Double) throws {
        let arguments: Value = .object(["value": .string(input)])
        let parser = ParameterParser(arguments: arguments)
        
        let result = try parser.parseDouble("value")
        #expect(abs(result - expected) < 0.001)
    }
}
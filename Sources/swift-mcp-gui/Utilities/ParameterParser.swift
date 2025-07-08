import Foundation
import MCP

struct ParameterParser {
    private let arguments: Value
    
    init(arguments: Value) {
        self.arguments = arguments
    }
    
    func parseDouble(_ key: String) throws -> Double {
        // Check if arguments is an object
        guard case .object(let dict) = arguments,
              let value = dict[key] else {
            throw ParameterError.missingParameter(key)
        }
        
        // Try double conversion first
        if case .double(let num) = value {
            return num
        }
        
        // Try int conversion
        if case .int(let num) = value {
            return Double(num)
        }
        
        // Try getting as string and parsing
        if case .string(let str) = value {
            guard let parsed = Double(str) else {
                throw ParameterError.invalidType(key: key, expected: "number", received: str)
            }
            return parsed
        }
        
        throw ParameterError.invalidType(key: key, expected: "number", received: String(describing: value))
    }
    
    func parseInt(_ key: String) throws -> Int {
        // Check if arguments is an object
        guard case .object(let dict) = arguments,
              let value = dict[key] else {
            throw ParameterError.missingParameter(key)
        }
        
        // Try int conversion first
        if case .int(let num) = value {
            return num
        }
        
        // Try double conversion and cast to int
        if case .double(let num) = value {
            return Int(num)
        }
        
        // Try getting as string and parsing
        if case .string(let str) = value {
            guard let parsed = Int(str) else {
                throw ParameterError.invalidType(key: key, expected: "number", received: str)
            }
            return parsed
        }
        
        throw ParameterError.invalidType(key: key, expected: "number", received: String(describing: value))
    }
    
    func parseString(_ key: String) throws -> String {
        // Check if arguments is an object
        guard case .object(let dict) = arguments,
              let value = dict[key] else {
            throw ParameterError.missingParameter(key)
        }
        
        guard case .string(let str) = value else {
            throw ParameterError.invalidType(key: key, expected: "string", received: String(describing: value))
        }
        
        return str
    }
    
    func parseStringArray(_ key: String) throws -> [String] {
        // Check if arguments is an object
        guard case .object(let dict) = arguments,
              let value = dict[key] else {
            throw ParameterError.missingParameter(key)
        }
        
        guard case .array(let arr) = value else {
            throw ParameterError.invalidType(key: key, expected: "array", received: String(describing: value))
        }
        
        var stringArray: [String] = []
        for item in arr {
            guard case .string(let str) = item else {
                throw ParameterError.invalidType(key: key, expected: "array of strings", received: String(describing: value))
            }
            stringArray.append(str)
        }
        
        return stringArray
    }
}

enum ParameterError: Swift.Error, LocalizedError {
    case missingParameter(String)
    case invalidType(key: String, expected: String, received: String)
    
    var errorDescription: String? {
        switch self {
        case .missingParameter(let key):
            return "Missing parameter: \(key)"
        case .invalidType(let key, let expected, let received):
            return "Invalid parameter \(key): expected \(expected), received \(received)"
        }
    }
}
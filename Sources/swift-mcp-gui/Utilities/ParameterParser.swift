import Foundation
import MCP

struct ParameterParser {
    private let arguments: JSONValue
    
    init(arguments: JSONValue) {
        self.arguments = arguments
    }
    
    func parseDouble(_ key: String) throws -> Double {
        guard let value = arguments[key] else {
            throw ParameterError.missingParameter(key)
        }
        
        // Try direct double conversion first
        if let doubleValue = value.doubleValue {
            return doubleValue
        }
        
        // Try integer conversion
        if let intValue = value.intValue {
            return Double(intValue)
        }
        
        // Try getting as string and parsing
        if let stringValue = value.stringValue {
            guard let parsed = Double(stringValue) else {
                throw ParameterError.invalidType(key: key, expected: "number", received: stringValue)
            }
            return parsed
        }
        
        throw ParameterError.invalidType(key: key, expected: "number", received: String(describing: value))
    }
    
    func parseInt(_ key: String) throws -> Int {
        guard let value = arguments[key] else {
            throw ParameterError.missingParameter(key)
        }
        
        // Try direct integer conversion first
        if let intValue = value.intValue {
            return intValue
        }
        
        // Try double conversion and cast to int
        if let doubleValue = value.doubleValue {
            return Int(doubleValue)
        }
        
        // Try getting as string and parsing
        if let stringValue = value.stringValue {
            guard let parsed = Int(stringValue) else {
                throw ParameterError.invalidType(key: key, expected: "number", received: stringValue)
            }
            return parsed
        }
        
        throw ParameterError.invalidType(key: key, expected: "number", received: String(describing: value))
    }
    
    func parseString(_ key: String) throws -> String {
        guard let value = arguments[key] else {
            throw ParameterError.missingParameter(key)
        }
        
        guard let stringValue = value.stringValue else {
            throw ParameterError.invalidType(key: key, expected: "string", received: String(describing: value))
        }
        
        return stringValue
    }
    
    func parseStringArray(_ key: String) throws -> [String] {
        guard let value = arguments[key] else {
            throw ParameterError.missingParameter(key)
        }
        
        guard let arrayValue = value.arrayValue else {
            throw ParameterError.invalidType(key: key, expected: "array", received: String(describing: value))
        }
        
        let stringArray = arrayValue.compactMap { $0.stringValue }
        
        guard stringArray.count == arrayValue.count else {
            throw ParameterError.invalidType(key: key, expected: "array of strings", received: String(describing: value))
        }
        
        return stringArray
    }
}

enum ParameterError: Error, LocalizedError {
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
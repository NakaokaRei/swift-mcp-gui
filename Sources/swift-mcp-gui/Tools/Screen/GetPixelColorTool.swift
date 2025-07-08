import Foundation
import MCP
import SwiftAutoGUI

class GetPixelColorTool: Tool {
    static let name = "getPixelColor"
    static let description = "Get color of specific pixel"
    static let inputSchema: JSONValue = [
        "type": "object",
        "properties": [
            "x": ["type": "number", "description": "X coordinate"],
            "y": ["type": "number", "description": "Y coordinate"]
        ],
        "required": ["x", "y"]
    ]
    
    init() {}
    
    func execute(arguments: JSONValue) async throws -> CallTool.Result {
        let parser = ParameterParser(arguments: arguments)
        
        do {
            let x = try parser.parseInt("x")
            let y = try parser.parseInt("y")
            
            guard let color = SwiftAutoGUI.pixel(x: x, y: y) else {
                return .init(content: [.text("Failed to get pixel color at (\(x), \(y))")], isError: true)
            }
            
            // Extract RGBA components
            let red = Int(color.redComponent * 255)
            let green = Int(color.greenComponent * 255)
            let blue = Int(color.blueComponent * 255)
            let alpha = Int(color.alphaComponent * 255)
            
            return .init(content: [.text("Pixel color at (\(x), \(y)): {\"red\": \(red), \"green\": \(green), \"blue\": \(blue), \"alpha\": \(alpha)}")], isError: false)
        } catch {
            return .init(content: [.text(error.localizedDescription)], isError: true)
        }
    }
}
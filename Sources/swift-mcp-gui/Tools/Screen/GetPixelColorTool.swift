import Foundation
import MCP
import SwiftAutoGUI

struct GetPixelColorTool {
    static func register(in registry: ToolRegistry) {
        let tool = Tool(
            name: "getPixelColor",
            description: "Get color of specific pixel",
            inputSchema: .object([
                "type": .string("object"),
                "properties": .object([
                    "x": .object(["type": .string("number"), "description": .string("X coordinate")]),
                    "y": .object(["type": .string("number"), "description": .string("Y coordinate")])
                ]),
                "required": .array([.string("x"), .string("y")])
            ])
        )
        
        registry.registerTool(definition: tool) { arguments in
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
}
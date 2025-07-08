import Foundation
import MCP
import SwiftAutoGUI

struct SendKeysTool {
    static func register(in registry: ToolRegistry) {
        let tool = Tool(
            name: "sendKeys",
            description: "Send keyboard shortcuts or key combinations",
            inputSchema: .object([
                "type": .string("object"),
                "properties": .object([
                    "keys": .object([
                        "type": .string("array"),
                        "items": .object(["type": .string("string")]),
                        "description": .string("Array of key names")
                    ])
                ]),
                "required": .array([.string("keys")])
            ])
        )
        
        registry.registerTool(definition: tool) { arguments in
            let parser = ParameterParser(arguments: arguments)
            
            do {
                let keysArray = try parser.parseStringArray("keys")
                
                var keyCollection: [Key] = []
                for keyString in keysArray {
                    switch keyString.lowercased() {
                    case "command", "cmd": keyCollection.append(.command)
                    case "control", "ctrl": keyCollection.append(.control)
                    case "option", "opt", "alt": keyCollection.append(.option)
                    case "shift": keyCollection.append(.shift)
                    case "return", "enter": keyCollection.append(.returnKey)
                    case "space": keyCollection.append(.space)
                    case "tab": keyCollection.append(.tab)
                    case "escape", "esc": keyCollection.append(.escape)
                    case "delete", "del": keyCollection.append(.delete)
                    case "backspace": keyCollection.append(.delete) // SwiftAutoGUI uses .delete for backspace
                    case "up": keyCollection.append(.upArrow)
                    case "down": keyCollection.append(.downArrow)
                    case "left": keyCollection.append(.leftArrow)
                    case "right": keyCollection.append(.rightArrow)
                    case "a": keyCollection.append(.a)
                    case "c": keyCollection.append(.c)
                    case "v": keyCollection.append(.v)
                    case "x": keyCollection.append(.x)
                    case "z": keyCollection.append(.z)
                    case "1": keyCollection.append(.one)
                    case "2": keyCollection.append(.two)
                    case "3": keyCollection.append(.three)
                    case "4": keyCollection.append(.four)
                    case "5": keyCollection.append(.five)
                    case "6": keyCollection.append(.six)
                    case "7": keyCollection.append(.seven)
                    case "8": keyCollection.append(.eight)
                    case "9": keyCollection.append(.nine)
                    case "0": keyCollection.append(.zero)
                    default:
                        return .init(content: [.text("Unknown key: \(keyString)")], isError: true)
                    }
                }
                
                if keyCollection.isEmpty {
                    return .init(content: [.text("No keys specified")], isError: true)
                }
                
                SwiftAutoGUI.sendKeyShortcut(keyCollection)
                return .init(content: [.text("Sent key combination: \(keysArray.joined(separator: "+"))")], isError: false)
            } catch {
                return .init(content: [.text(error.localizedDescription)], isError: true)
            }
        }
    }
}
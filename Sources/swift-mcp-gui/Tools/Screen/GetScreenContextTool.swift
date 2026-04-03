import Foundation
import MCP
import SwiftAutoGUI

struct GetScreenContextTool {
    static func register(in registry: ToolRegistry) {
        let tool = Tool(
            name: "getScreenContext",
            description:
                "Get rich context about the current screen state including frontmost app, visible windows, and accessibility tree of the focused window. Useful for understanding what is currently displayed on screen.",
            inputSchema: .object([
                "type": .string("object"),
                "properties": .object([
                    "maxDepth": .object([
                        "type": .string("integer"),
                        "description": .string(
                            "Maximum depth of accessibility tree traversal (default: 5)"),
                    ]),
                    "maxNodes": .object([
                        "type": .string("integer"),
                        "description": .string(
                            "Maximum number of accessibility nodes to collect (default: 200)"),
                    ]),
                    "maxValueLength": .object([
                        "type": .string("integer"),
                        "description": .string(
                            "Maximum length for element values before truncation (default: 100)"),
                    ]),
                    "includeAXTree": .object([
                        "type": .string("boolean"),
                        "description": .string(
                            "Whether to include the accessibility tree (default: true)"),
                    ]),
                    "format": .object([
                        "type": .string("string"),
                        "description": .string(
                            "Output format: 'text' (default, LLM-friendly) or 'json' (structured)"),
                        "enum": .array([.string("text"), .string("json")]),
                    ]),
                ]),
            ])
        )

        registry.registerTool(definition: tool) { arguments in
            let parser = ParameterParser(arguments: arguments)

            let maxDepth = (try? parser.parseInt("maxDepth")) ?? 5
            let maxNodes = (try? parser.parseInt("maxNodes")) ?? 200
            let maxValueLength = (try? parser.parseInt("maxValueLength")) ?? 100
            let includeAXTree = (try? parser.parseBool("includeAXTree")) ?? true
            let format = (try? parser.parseString("format")) ?? "text"

            let options = ScreenContextProvider.Options(
                maxDepth: maxDepth,
                maxNodes: maxNodes,
                maxValueLength: maxValueLength,
                includeAXTree: includeAXTree
            )

            let context = await MainActor.run {
                ScreenContextProvider.gather(options: options)
            }

            let output: String
            if format == "json" {
                let encoder = JSONEncoder()
                encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
                let data = try encoder.encode(context)
                output = String(data: data, encoding: .utf8) ?? "{}"
            } else {
                output = context.formatted()
            }

            return .init(content: [.text(output)], isError: false)
        }
    }
}

import Foundation
import MCP
import SwiftAutoGUI

struct GetScreenSizeTool {
    static func register(in registry: ToolRegistry) {
        let tool = Tool(
            name: "getScreenSize",
            description: "Get screen dimensions",
            inputSchema: .object([
                "type": .string("object"),
                "properties": .object([:])
            ])
        )
        
        registry.registerTool(definition: tool) { _ in
            let screenSize = SwiftAutoGUI.size()
            return .init(content: [.text("Screen size: {\"width\": \(screenSize.width), \"height\": \(screenSize.height)}")], isError: false)
        }
    }
}
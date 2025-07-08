import Foundation
import MCP
import SwiftAutoGUI

class GetScreenSizeTool: Tool {
    static let name = "getScreenSize"
    static let description = "Get screen dimensions"
    static let inputSchema: JSONValue = [
        "type": "object",
        "properties": [:]
    ]
    
    init() {}
    
    func execute(arguments: JSONValue) async throws -> CallTool.Result {
        let screenSize = SwiftAutoGUI.size()
        return .init(content: [.text("Screen size: {\"width\": \(screenSize.width), \"height\": \(screenSize.height)}")], isError: false)
    }
}
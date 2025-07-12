import Foundation
import MCP
import SwiftAutoGUI
import AppKit

struct SaveScreenshotTool {
    static func register(in registry: ToolRegistry) {
        let tool = Tool(
            name: "saveScreenshot",
            description: "Capture screen and save to file",
            inputSchema: .object([
                "type": .string("object"),
                "properties": .object([
                    "filename": .object([
                        "type": .string("string"),
                        "description": .string("Filename to save the screenshot")
                    ]),
                    "x": .object([
                        "type": .string("number"),
                        "description": .string("X coordinate of the region (optional)")
                    ]),
                    "y": .object([
                        "type": .string("number"),
                        "description": .string("Y coordinate of the region (optional)")
                    ]),
                    "width": .object([
                        "type": .string("number"),
                        "description": .string("Width of the region (optional)")
                    ]),
                    "height": .object([
                        "type": .string("number"),
                        "description": .string("Height of the region (optional)")
                    ]),
                    "quality": .object([
                        "type": .string("number"),
                        "description": .string("JPEG compression quality (0.0-1.0, default: 0.1). Lower values reduce file size. Only affects JPEG files.")
                    ]),
                    "scale": .object([
                        "type": .string("number"),
                        "description": .string("Scale factor for image size (0.1-1.0, default: 0.5). Lower values reduce resolution.")
                    ])
                ]),
                "required": .array([.string("filename")])
            ])
        )
        
        registry.registerTool(definition: tool) { arguments in
            let parser = ParameterParser(arguments: arguments)
            
            do {
                let filename = try parser.parseString("filename")
                let quality = (try? parser.parseDouble("quality")) ?? 0.1
                let scale = (try? parser.parseDouble("scale")) ?? 0.5
                
                // Try to parse optional region parameters
                let x = try? parser.parseDouble("x")
                let y = try? parser.parseDouble("y")
                let width = try? parser.parseDouble("width")
                let height = try? parser.parseDouble("height")
                
                // Capture screenshot
                let screenshot: NSImage?
                if let x = x, let y = y, let width = width, let height = height {
                    let region = CGRect(x: x, y: y, width: width, height: height)
                    screenshot = SwiftAutoGUI.screenshot(region: region)
                } else {
                    screenshot = SwiftAutoGUI.screenshot()
                }
                
                guard let image = screenshot else {
                    return .init(content: [.text("Failed to capture screenshot")], isError: true)
                }
                
                // Scale down the image if needed
                let scaledImage: NSImage
                if scale < 1.0 {
                    let newSize = NSSize(width: image.size.width * scale, 
                                       height: image.size.height * scale)
                    scaledImage = NSImage(size: newSize)
                    scaledImage.lockFocus()
                    image.draw(in: NSRect(origin: .zero, size: newSize),
                              from: NSRect(origin: .zero, size: image.size),
                              operation: .copy,
                              fraction: 1.0)
                    scaledImage.unlockFocus()
                } else {
                    scaledImage = image
                }
                
                // Convert to bitmap representation
                guard let tiffData = scaledImage.tiffRepresentation,
                      let bitmapRep = NSBitmapImageRep(data: tiffData) else {
                    return .init(content: [.text("Failed to convert screenshot")], isError: true)
                }
                
                // Determine file type and save with appropriate format
                let fileExtension = (filename as NSString).pathExtension.lowercased()
                let imageData: Data?
                
                switch fileExtension {
                case "jpg", "jpeg":
                    imageData = bitmapRep.representation(using: .jpeg, properties: [.compressionFactor: quality])
                case "png":
                    imageData = bitmapRep.representation(using: .png, properties: [:])
                default:
                    // Default to JPEG with quality if no extension or unknown extension
                    imageData = bitmapRep.representation(using: .jpeg, properties: [.compressionFactor: quality])
                }
                
                guard let data = imageData else {
                    return .init(content: [.text("Failed to encode image")], isError: true)
                }
                
                // Save to file
                do {
                    try data.write(to: URL(fileURLWithPath: filename))
                    return .init(content: [.text("{\"success\": true, \"filename\": \"\(filename)\"}")], isError: false)
                } catch {
                    return .init(content: [.text("Failed to save file: \(error.localizedDescription)")], isError: true)
                }
            
            } catch {
                return .init(content: [.text(error.localizedDescription)], isError: true)
            }
        }
    }
}
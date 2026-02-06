import Foundation
import MCP
import SwiftAutoGUI
import AppKit

struct CaptureRegionTool {
    static func register(in registry: ToolRegistry) {
        let tool = Tool(
            name: "captureRegion",
            description: "Capture specific screen region. Use output parameter to choose between file path (default, saves tokens) or inline image (for AI vision).",
            inputSchema: .object([
                "type": .string("object"),
                "properties": .object([
                    "x": .object([
                        "type": .string("number"),
                        "description": .string("X coordinate of the region")
                    ]),
                    "y": .object([
                        "type": .string("number"),
                        "description": .string("Y coordinate of the region")
                    ]),
                    "width": .object([
                        "type": .string("number"),
                        "description": .string("Width of the region")
                    ]),
                    "height": .object([
                        "type": .string("number"),
                        "description": .string("Height of the region")
                    ]),
                    "quality": .object([
                        "type": .string("number"),
                        "description": .string("JPEG compression quality (0.0-1.0, default: 0.5). Lower values reduce file size.")
                    ]),
                    "scale": .object([
                        "type": .string("number"),
                        "description": .string("Scale factor for image size (0.1-1.0, default: 0.25). Lower values reduce resolution.")
                    ]),
                    "output": .object([
                        "type": .string("string"),
                        "description": .string("Output format: 'path' (default) returns file path, 'image' returns inline image for AI vision."),
                        "enum": .array([.string("path"), .string("image")])
                    ])
                ]),
                "required": .array([.string("x"), .string("y"), .string("width"), .string("height")])
            ])
        )
        
        registry.registerTool(definition: tool) { arguments in
            let parser = ParameterParser(arguments: arguments)
            
            do {
                let x = try parser.parseDouble("x")
                let y = try parser.parseDouble("y")
                let width = try parser.parseDouble("width")
                let height = try parser.parseDouble("height")
                let quality = (try? parser.parseDouble("quality")) ?? 0.5
                let scale = (try? parser.parseDouble("scale")) ?? 0.25
                let output = (try? parser.parseString("output")) ?? "path"
            
            let region = CGRect(x: x, y: y, width: width, height: height)
            
            guard let screenshot = SwiftAutoGUI.screenshot(region: region) else {
                return .init(content: [.text("Failed to capture screen region")], isError: true)
            }
            
            // Create scaled image more efficiently
            let scaledWidth = Int(screenshot.size.width * scale)
            let scaledHeight = Int(screenshot.size.height * scale)
            
            guard let cgImage = screenshot.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
                return .init(content: [.text("Failed to get CGImage")], isError: true)
            }
            
            let bitmapRep = NSBitmapImageRep(bitmapDataPlanes: nil,
                                            pixelsWide: scaledWidth,
                                            pixelsHigh: scaledHeight,
                                            bitsPerSample: 8,
                                            samplesPerPixel: 4,
                                            hasAlpha: true,
                                            isPlanar: false,
                                            colorSpaceName: .deviceRGB,
                                            bytesPerRow: 0,
                                            bitsPerPixel: 0)
            
            guard let bitmap = bitmapRep else {
                return .init(content: [.text("Failed to create bitmap")], isError: true)
            }
            
            NSGraphicsContext.saveGraphicsState()
            NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: bitmap)
            let context = NSGraphicsContext.current?.cgContext
            context?.interpolationQuality = .low // Use low quality for speed
            
            let destRect = CGRect(x: 0, y: 0, width: scaledWidth, height: scaledHeight)
            context?.draw(cgImage, in: destRect)
            
            NSGraphicsContext.restoreGraphicsState()
            
            // Use JPEG compression with specified quality
            guard let jpegData = bitmap.representation(using: .jpeg, properties: [.compressionFactor: quality]) else {
                return .init(content: [.text("Failed to convert screenshot to JPEG")], isError: true)
            }

            // Generate unique filename with timestamp
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMdd_HHmmss"
            let timestamp = dateFormatter.string(from: Date())
            let filename = "screenshot_region_\(timestamp)_\(UUID().uuidString.prefix(8)).jpg"
            let filePath = FileManager.default.temporaryDirectory.appendingPathComponent(filename)

            if output == "image" {
                let base64String = jpegData.base64EncodedString()
                return .init(content: [
                    .image(data: base64String, mimeType: "image/jpeg", metadata: nil)
                ], isError: false)
            } else {
                do {
                    try jpegData.write(to: filePath)
                } catch {
                    return .init(content: [.text("Failed to save screenshot: \(error.localizedDescription)")], isError: true)
                }
                return .init(content: [.text("{\"path\": \"\(filePath.path)\", \"width\": \(scaledWidth), \"height\": \(scaledHeight)}")], isError: false)
            }
            } catch {
                return .init(content: [.text(error.localizedDescription)], isError: true)
            }
        }
    }
}
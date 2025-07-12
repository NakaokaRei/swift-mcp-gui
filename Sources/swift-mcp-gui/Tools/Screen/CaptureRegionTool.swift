import Foundation
import MCP
import SwiftAutoGUI
import AppKit

struct CaptureRegionTool {
    static func register(in registry: ToolRegistry) {
        let tool = Tool(
            name: "captureRegion",
            description: "Capture specific screen region and return as base64 encoded image",
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
                        "description": .string("JPEG compression quality (0.0-1.0, default: 0.1). Lower values reduce file size.")
                    ]),
                    "scale": .object([
                        "type": .string("number"),
                        "description": .string("Scale factor for image size (0.1-1.0, default: 0.25). Lower values reduce resolution.")
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
                let quality = (try? parser.parseDouble("quality")) ?? 0.1
                let scale = (try? parser.parseDouble("scale")) ?? 0.25
            
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
            
            let base64String = jpegData.base64EncodedString()
            return .init(content: [.text("{\"image\": \"data:image/jpeg;base64,\(base64String)\"}")], isError: false)
            } catch {
                return .init(content: [.text(error.localizedDescription)], isError: true)
            }
        }
    }
}
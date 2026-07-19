import Foundation

enum GUITestConfiguration {
    static let liveInputTestsEnabled =
        ProcessInfo.processInfo.environment["SWIFT_MCP_GUI_RUN_INPUT_TESTS"] == "1"
        || ProcessInfo.processInfo.environment["SWIFTAUTOGUI_RUN_INPUT_TESTS"] == "1"

    static let liveScreenTestsEnabled =
        ProcessInfo.processInfo.environment["SWIFT_MCP_GUI_RUN_SCREEN_TESTS"] == "1"

    static func temporaryFilename(_ basename: String) -> String {
        FileManager.default.temporaryDirectory
            .appendingPathComponent("\(UUID().uuidString)-\(basename)")
            .path
    }
}

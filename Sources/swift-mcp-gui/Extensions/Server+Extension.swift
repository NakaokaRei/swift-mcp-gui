import MCP

extension Server {
    func waitForDisconnection() async {
        await withUnsafeContinuation { (_ continuation: UnsafeContinuation<Void, Never>) in }
    }
}
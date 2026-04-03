---
name: inspect
description: Launch MCP Inspector to interactively test swift-mcp-gui tools via browser
allowed-tools: Bash
disable-model-invocation: true
---

# MCP Inspector

Launch the MCP Inspector to interactively test the swift-mcp-gui MCP server in a browser.

## Steps

1. Check if Node.js and npm are installed by running `node --version` and `npx --version`. If not installed, tell the user to install Node.js first (e.g. via Homebrew: `brew install node`) and stop.

2. Reinstall the latest build of swift-mcp-gui:

```
swift package experimental-uninstall swift-mcp-gui && swift package experimental-install
```

3. Start the MCP Inspector:

```
npx @modelcontextprotocol/inspector swift-mcp-gui
```

4. Wait for the inspector to start and print the URL with the auth token.

5. Tell the user to open the URL in their browser. The URL will look like:
   `http://localhost:6274/?MCP_PROXY_AUTH_TOKEN=<token>`

6. Wait for the user to finish testing. When the user says they are done, kill the inspector process:

```
pkill -f "@modelcontextprotocol/inspector"; pkill -f "swift-mcp-gui"
```

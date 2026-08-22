---
name: mcp-sync
description: Use this skill when adding or modifying Model Context Protocol (MCP) server configurations to ensure they are synchronized across different tool settings.
---

# MCP Sync

To ensure a consistent experience across different AI tools (like VS Code Copilot and Antigravity), MCP servers are configured in the following locations:

1.  **VS Code / Copilot**: `dotfiles/code/mcp.json`
    *   Format: Standard MCP JSON configuration within the `servers` object.
2.  **Antigravity**: `nixfiles/modules/tools/antigravity.nix`
    *   Format: Managed declaratively via NixOS home-manager activation, generating `~/.gemini/config/mcp_config.json` with secrets management and symlinking to `~/.gemini/antigravity/` and `~/.gemini/antigravity-ide/`.

## Workflow
When a directive is issued to add or update an MCP server:
1.  Identify the command, arguments, or URL for the MCP server.
2.  Update `dotfiles/code/mcp.json` (for VS Code / Copilot).
3.  Update `nixfiles/modules/tools/antigravity.nix` (for Antigravity, using local stdio when remote OAuth DCR is not supported).
4.  Verify that all configuration files are valid and formatted.

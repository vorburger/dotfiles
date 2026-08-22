# AI Agent Conventions

This https://agents.md file documents conventions for agentic AI tools like https://enola.dev, the Gemini CLI or Copilot etc. to follow when modifying this project.

- **Fish Functions**: All `fish` shell functions should be placed in the `dotfiles/fish/functions` directory, with each function in its own file named after the function (e.g., `paths.fish`). Do not define Fish functions for the user elsewhere, such as in the `dotfiles/alias` file.

- **OS Compatibility**: Always ensure that changes to dotfiles and Home Manager configurations are compatible with both Fedora Workstation and NixOS. Use conditional logic (e.g., `lib.pathExists "/etc/NIXOS"`) when settings are specific to one environment.

- **MCP Servers**: MCP servers are configured in `dotfiles/code/mcp.json` for VS Code / Copilot, and declaratively managed in `nixfiles/modules/tools/antigravity.nix` for Antigravity. See the `mcp-sync` skill in `.agents/skills/mcp-sync/SKILL.md` for details.

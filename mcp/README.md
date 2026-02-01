# TK MCP Integration

Use TK with the Model Context Protocol (MCP).

## Setup

Add to your MCP client configuration:

```json
{
  "mcpServers": {
    "tk": {
      "command": "npx",
      "args": ["Toolkit", "--mcp"]
    }
  }
}
```

Or if using the local installation:

```json
{
  "mcpServers": {
    "tk": {
      "command": "node",
      "args": ["/path/to/Toolkit/mcp/server.js"]
    }
  }
}
```

## Available Tools

| Tool | Description |
|------|-------------|
| `tk_map` | Map project, create context |
| `tk_build` | Build features (7-phase workflow) |
| `tk_debug` | Systematic debugging |
| `tk_qa` | Testing + security scanning |
| `tk_review` | Code review |
| `tk_design` | Frontend UI creation |
| `tk_deploy` | Deployment |
| `tk_clean` | Cleanup codebase |
| `tk_doc` | Generate documentation |
| `tk_learn` | Capture learnings |
| `tk_status` | Project health check |
| `tk_resume` | Resume work |

## Usage

```
Use tk_map with mode="heavy" to map the project

Use tk_build with task="Add user authentication" and mode="medium"

Use tk_qa with mode="heavy" to run full security scan
```

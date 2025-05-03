# Project Overview

MCP servers + OpenAI agents.

## Setting up the Environment

1. **Create and Activate a Virtual Environment**:
   - Run the provided `setup.sh` script to establish a virtual environment using Python 3.13.
     ```bash
     ./setup.sh
     ```
   - The script creates a virtual environment and installs all required Python packages from `requirements.txt`.

2. **Install Project Dependencies**:
   - Ensure you have the necessary external tools and services for the MCP servers you intend to run:
     - **Lynx**: Required for the `lynx` server, which interfaces with the Lynx terminal web search tool.
     - **Docker**: Required for the `puppeteer` and `github` servers, enabling Chrome control and GitHub interactions, respectively.
     - **Node.js**: Required for the `fs` server, using the `npx` command.


# Usage Guide

## Running `agent.py`

### Basic Execution

- You can run the agent using all the servers you have configured in `servers.yaml` like this

  ```bash
  python agent.py
  ```

- You can choose which servers the agent will have access to with:

  ```bash
  # gives agent access to file system (for local file browsing) and lynx (for websearch)
  python agent.py --servers fs lynx
  ```

  In my experience this results in better performance since the agent is less likely to pick the wrong tool

- **Debug Mode**:

  - Use the `--debug` flag to initialize servers without executing the agent. This is useful if you want to make sure the servers are set up correctly
    ```bash
    python agent.py --debug
    ```

### Configuration

The servers are configured in `servers.yaml`, where each server entry includes:

- **Name**: Identifier for the server.
- **Description**: Brief description of the server's functionality.
- **Command & Arguments**: Command-line instructions to start the server.
- **Environment Variables**: Any additional environment configurations needed.

You'll typically find these in github repos for MCP servers

### Roll your own
You can roll your own MCP server in the `mcp-servers` directory

# What do I use this for?
## Link finding
If I am trying to figure out how to do something (like setting up QEMU) I will often use `agent.py` to do the initial research for me

```bash
"find links relevant to QEMU setup on ubuntu" | python agent.py --servers lynx
```

### MCP notes...
#### High level
Host: Programs (Desktop, IDE, AI tool) that wants to use MCP
Client: Client that maintains 1:1 connection with servers
Server: Server exposing MCP capabilities


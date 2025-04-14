# Project Overview

This project is designed to facilitate the operation and management of various Multi-Channel Protocol (MCP) servers, allowing seamless communication and interaction with web-based tools and interfaces. At its core, `agent.py` provides a framework for running these servers, handling inputs, and executing tasks in a coordinated manner, driven by user prompts.

# Installation Guide

## Setting up the Environment

1. **Create and Activate a Virtual Environment**:
   - Run the provided `setup.sh` script to establish a virtual environment using Python 3.13.
     ```bash
     ./setup.sh
     ```
   - The script creates a virtual environment and installs all required Python packages from `requirements.txt`.

2. **Install Project Dependencies**:
   - Ensure you have the necessary external tools and services for specific MCP servers:
     - **Lynx**: Required for the `lynx` server, which interfaces with the Lynx terminal web search tool.
     - **Docker**: Required for the `puppeteer` and `github` servers, enabling Chrome control and GitHub interactions, respectively.
     - **Node.js**: Required for the `fs` server, using the `npx` command.

# Usage Guide

## Running `agent.py`

The primary script, `agent.py`, can be used to run and manage MCP servers based on a provided YAML configuration file. It supports custom prompts and server selection, along with a debug mode for developmental purposes.

### Basic Execution

- To execute all configured servers with a custom input prompt:
  ```bash
  python agent.py --servers <server1> <server2> ... <serverN>
  ```

- **Debug Mode**:
  - Use the `--debug` flag to initialize servers without executing the agent.
    ```bash
    python agent.py --debug
    ```

### Configuration

The servers are configured in `servers.yaml`, where each server entry includes:
- **Name**: Identifier for the server.
- **Description**: Brief description of the server's functionality.
- **Command & Arguments**: Command-line instructions to start the server.
- **Environment Variables**: Any additional environment configurations needed.

This setup enables the dynamic management of servers tailored to specific tasks, ranging from web content fetching to filesystem operations and beyond.

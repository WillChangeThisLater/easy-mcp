#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.9"
# dependencies = [
#   "openai-agents",
#   "pyyaml",
#   "mcp-server-fetch"
# ]
# ///
import argparse
import asyncio
import logging
import os
import sys
import yaml
from contextlib import AsyncExitStack

from agents import Agent, Runner, gen_trace_id, trace
from agents.mcp import MCPServer, MCPServerStdio

logger = logging.getLogger(__name__)

def get_available_server_names(yaml_file):
    config = load_servers_config(yaml_file)
    return [server['name'] for server in config]

def load_servers_config(yaml_file):
    with open(yaml_file, "r") as file:
        config = yaml.safe_load(file)
    return config["servers"]

async def run(mcp_servers: list[MCPServer], prompt: str):
    agent = Agent(
        name="Assistant",
        instructions="Use these tools in conjunction with each other to answer the prompt",
        mcp_servers=mcp_servers,
    )

    # List the files it can read
    result = await Runner.run(starting_agent=agent, input=prompt, max_turns=50)
    print(result.final_output)

def create_servers(servers_config, selected_servers: list[str] = None) -> list[MCPServerStdio]:
    server_instances = []
    if selected_servers:
        logger.info(f"only starting up servers specified in {selected_servers=}")

    for server_config in servers_config:
        name = server_config["name"]
        if selected_servers and name not in selected_servers:
            logger.warning(f"{name} not in {selected_servers} - skipping")
            continue

        command = server_config["command"]
        args = server_config["args"]
        env = server_config.get("env", {})

        for key in env.keys():
            value = env[key]
            # use leading '$' to identify environment variables 
            if value.startswith("$"):
                env_var_name = value[1:]
                env_var_value = os.environ.get(env_var_name)
                if not env_var_value:
                    raise ValueError(f"Environment variable {env_var_name} (required by server {name}) not found")
                env[key] = os.environ[env_var_name]

        server_instance = MCPServerStdio(
            name=name,
            params={
                "command": command,
                "args": args,
                "env": env
            }
        )
        server_instances.append(server_instance)

    if not server_instances:
        raise ValueError(f"No servers found ({selected_servers=})")

    return server_instances

async def main(prompt: str = None, selected_servers: list[str] = None, debug: bool = False):
    server_config = load_servers_config('servers.yaml')
    mcp_servers = create_servers(server_config, selected_servers)

    async with AsyncExitStack() as stack:
        for server in mcp_servers:
            await stack.enter_async_context(server)

        if debug:
            print("Debug mode is active. Servers are initialized but the agent will not be invoked.")
        else:
            trace_id = gen_trace_id()
            with trace(workflow_name="MCP Filesystem Example", trace_id=trace_id):
                print(f"https://platform.openai.com/traces/trace?trace_id={trace_id}\n")
                await run(mcp_servers, prompt=prompt)

if __name__ == "__main__":
    available_servers = get_available_server_names('servers.yaml')

    parser = argparse.ArgumentParser(description="Run MCP Servers with options for debug and custom prompt.")
    parser.add_argument('--debug', action='store_true', help="Run the servers in debug mode without invoking the agent.")
    parser.add_argument('--servers', nargs='*', choices=available_servers, help="Specify server names to run. If not specified, all servers are run.")

    args = parser.parse_args()

    if not args.debug:
        # Read prompt from stdin if not in debug mode
        prompt = sys.stdin.read().strip()
    else:
        prompt = None

    asyncio.run(main(prompt=prompt, selected_servers=args.servers, debug=args.debug))

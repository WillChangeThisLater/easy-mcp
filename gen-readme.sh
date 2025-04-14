#!/bin/bash

set -euo pipefail

cat <<EOF | python agent.py --servers fs
Consider the repository at the base of the filesystem.

Read through its contents and generate an appropriate README
Don't run any list directory commands - those will return too
much data. The relevant files you should read are:

.
├── agent.py
├── mcp-servers
│   └── lynx.py
├── requirements.txt
├── servers.yaml
└── setup.sh


The README should first give a high level overview of what the
project is.

Then, it should explain how to install the virtual environment
It should also mention other project dependencies (e.g. lynx
for the mcp-servers/lynx.py server, docker for puppeteer, etc.)

After this, it should explain how to use agent.py effectively
EOF


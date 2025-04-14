FROM python:3.13-slim-bookworm

# install curl
RUN apt-get update
RUN apt-get install -y --no-install-recommends curl ca-certificates

# Install npm and upgrade to latest
RUN apt install -y nodejs
RUN apt install -y npm
RUN npm install -g n
RUN n install latest && n latest

# Make sure node is actually using the latest version
# root@b8b5feb0f9bf:/# n install latest
#   installing : node-v23.11.0
#        mkdir : /usr/local/n/versions/node/23.11.0
#        fetch : https://nodejs.org/dist/v23.11.0/node-v23.11.0-linux-x64.tar.xz
#      copying : node/23.11.0
#    installed : v23.11.0 (with npm 10.9.2)
# 
# Note: the node command changed location and the old location may be remembered in your current shell.
#          old : /usr/bin/node
#          new : /usr/local/bin/node
# If "node --version" shows the old version then start a new shell, or reset the location hash with:
# hash -r  (for bash, zsh, ash, dash, and ksh)
RUN hash -r

# Install python
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt install python3.13 full

# Install uv
# See: https://docs.astral.sh/uv/guides/integration/docker/#installing-uv
ADD https://astral.sh/uv/install.sh /uv-installer.sh
RUN sh /uv-installer.sh && rm /uv-installer.sh
ENV PATH="/root/.local/bin/:$PATH"

# Copy over runner file
COPY runner.py .

# Copy over configured servers
COPY servers.yaml .

# Install system requirements
COPY requirements.txt .
RUN uv pip install --system -r requirements.txt --no-cache-dir

# Run on debug mode
# This will load up everything the servers need, but shouldn't actually run anything
RUN python runner.py --debug

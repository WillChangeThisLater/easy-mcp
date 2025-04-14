#!/bin/bash
docker run --rm -it \
  -v ~/.zshrc-sensitive-agents:/root/.zshrc-sensitive:ro \
  -v /var/run/docker.sock:/var/run/docker.sock \
  generic-agent /bin/bash

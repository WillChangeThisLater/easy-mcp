#!/bin/bash
uv venv --python 3.13
source .venv/bin/activate
uv pip install -r requirements.txt

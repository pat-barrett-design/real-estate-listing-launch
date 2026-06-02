#!/usr/bin/env python3
"""Stdio→HTTP proxy for the CC MCP server. Injects Bearer token from .cc-token.json."""
import json
import os
import sys
import urllib.request
import urllib.error

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
TOKEN_FILE = os.path.join(SCRIPT_DIR, "..", ".cc-token.json")
MCP_URL = "https://mcp.apps.constantcontact.com/public_api/mcp"


def get_token():
    with open(TOKEN_FILE) as f:
        return json.load(f)["access_token"]


def forward(payload: bytes) -> str:
    token = get_token()
    req = urllib.request.Request(
        MCP_URL,
        data=payload,
        headers={
            "Content-Type": "application/json",
            "Accept": "application/json, text/event-stream",
            "Authorization": f"Bearer {token}",
        },
        method="POST",
    )
    with urllib.request.urlopen(req) as resp:
        raw = resp.read().decode()
    # SSE: strip "event: message\ndata: " wrapper if present
    for line in raw.splitlines():
        if line.startswith("data: "):
            return line[6:]
    return raw


def main():
    # MCP stdio protocol: one JSON-RPC message per line on stdin
    for line in sys.stdin:
        line = line.strip()
        if not line:
            continue
        try:
            result = forward(line.encode())
            sys.stdout.write(result + "\n")
            sys.stdout.flush()
        except Exception as e:
            err = {"jsonrpc": "2.0", "id": None, "error": {"code": -32603, "message": str(e)}}
            sys.stdout.write(json.dumps(err) + "\n")
            sys.stdout.flush()


if __name__ == "__main__":
    main()

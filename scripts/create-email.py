#!/usr/bin/env python3
"""Create a CC email campaign via direct API (bypasses MCP).

Usage:
  python3 scripts/create-email.py --name "Campaign Name" --subject "Subject" --html email.html
  python3 scripts/create-email.py --name "Campaign Name" --subject "Subject" --html-stdin < email.html
  python3 scripts/create-email.py --json payload.json

Reads token from ../.cc-token.json (created by cc-auth.sh)
"""

import argparse
import json
import os
import sys
import urllib.request
import urllib.error

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
TOKEN_FILE = os.path.join(SCRIPT_DIR, "..", ".cc-token.json")
API_BASE = "https://api.cc.email/v3"


def get_token():
    if not os.path.exists(TOKEN_FILE):
        print("ERROR: No token file found. Run cc-auth.sh first.", file=sys.stderr)
        sys.exit(1)
    with open(TOKEN_FILE) as f:
        data = json.load(f)
    return data["access_token"]


def create_campaign(name, subject, preheader, html_content, from_email=None, from_name=None):
    token = get_token()

    payload = {
        "name": name,
        "email_campaign_activities": [{
            "format_type": 5,
            "subject": subject,
            "preheader": preheader or "",
            "html_content": html_content,
        }]
    }

    if from_email:
        payload["email_campaign_activities"][0]["from_email"] = from_email
        payload["email_campaign_activities"][0]["reply_to_email"] = from_email
    if from_name:
        payload["email_campaign_activities"][0]["from_name"] = from_name

    req = urllib.request.Request(
        f"{API_BASE}/emails",
        data=json.dumps(payload).encode(),
        headers={
            "Authorization": f"Bearer {token}",
            "Content-Type": "application/json",
        },
        method="POST",
    )

    try:
        with urllib.request.urlopen(req) as resp:
            result = json.loads(resp.read())
            return result
    except urllib.error.HTTPError as e:
        body = e.read().decode()
        print(f"ERROR {e.code}: {body}", file=sys.stderr)
        sys.exit(1)


def main():
    parser = argparse.ArgumentParser(description="Create CC email campaign")
    parser.add_argument("--name", required=True, help="Campaign name")
    parser.add_argument("--subject", required=True, help="Email subject line")
    parser.add_argument("--preheader", default="", help="Preheader text")
    parser.add_argument("--html", help="Path to HTML file")
    parser.add_argument("--html-stdin", action="store_true", help="Read HTML from stdin")
    parser.add_argument("--from-email", help="Sender email")
    parser.add_argument("--from-name", help="Sender display name")
    parser.add_argument("--json-output", action="store_true", help="Output raw JSON response")
    args = parser.parse_args()

    if args.html:
        with open(args.html) as f:
            html_content = f.read()
    elif args.html_stdin:
        html_content = sys.stdin.read()
    else:
        print("ERROR: Provide --html <file> or --html-stdin", file=sys.stderr)
        sys.exit(1)

    result = create_campaign(
        name=args.name,
        subject=args.subject,
        preheader=args.preheader,
        html_content=html_content,
        from_email=args.from_email,
        from_name=args.from_name,
    )

    if args.json_output:
        print(json.dumps(result, indent=2))
    else:
        campaign_id = result["campaign_id"]
        activity_id = result["campaign_activities"][0]["campaign_activity_id"]
        print(f"Campaign created successfully!")
        print(f"")
        print(f"  Campaign ID:  {campaign_id}")
        print(f"  Activity ID:  {activity_id}")
        print(f"  Status:       {result['current_status']}")
        print(f"")
        print(f"  Schedule URL: https://app.constantcontact.com/pages/campaigns/view/schedule/campaignId/{campaign_id}")
        print(f"")


if __name__ == "__main__":
    main()

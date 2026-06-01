# Eng Handoff — Real Estate Listing Launch Skill

## E2E Testing Tips

**Prerequisites**
- Claude Code CLI running from the `ai_projects` directory
- MCP config pointing to Rise MCP gateway: `https://mcp.apps.constantcontact.com/public_api/mcp`
- Client ID: `39b68297-37c9-45c8-9c7d-ce4b97f90dfd` (ChatGPT's; dedicated skill ClientID to be set up later)
- Constant Contact account — OAuth triggered automatically by MCP on first tool call

**Run the demo**
1. Open Claude Code from `ai_projects`
2. Type `/real-estate-listing-launch`
3. When prompted, enter: `MLS ID 1005192`
4. Agent name: `Shoshana Phelps` (or any name — skill accepts any)
5. Confirm listing details when shown
6. Skill will create a CC email draft + generate TikTok ad hooks
7. Open the CC editor link returned — email should open clean with no errors

**Known gotchas**
- MLS fetch uses `--id` flag: `python3 scripts/fetch-listing.py --id <MLS_ID>` — positional arg will fail
- Rise MCP gateway: email creation is now SINGLE-STEP via `createEmailCampaignUsingPOST` — no more two-step POST shell + PUT HTML
- `[[trackingImage]]` MUST be included in html_content — Rise MCP requires it for email reporting (opposite of old Render behavior)
- OAuth handled by MCP automatically — if unauthenticated, response includes `call_to_action: "signUp"` which triggers account connection

---

## Architecture Change (v4.0.0)

**Old:** Skill used a custom proxy MCP server hosted on Render (`mcp-emflow-svc.onrender.com`)
**New:** Skill uses the production Rise MCP Gateway — same endpoint ChatGPT uses

- **URL:** `https://mcp.apps.constantcontact.com/public_api/mcp`
- **Client ID:** `39b68297-37c9-45c8-9c7d-ce4b97f90dfd`

---

## What We Need from Eng

1. **API docs** — Send Rise MCP gateway API docs to Pat via Slack (Abhishek action item from 5/28 meeting) so tool names and parameters can be confirmed
2. **TikTok business account** — Share TikTok business account credentials from OnePass (integrations team) for mock ad testing without live payment
3. **OAuth validation** — Confirm OAuth flow works end-to-end through the Rise MCP gateway with a real CTCT employee account
4. **Dedicated Client ID** — Set up a skill-specific Client ID (current one is ChatGPT's); can be done after e2e is confirmed working
5. **TikTok Skill Hub registration** — Register the skill endpoint once e2e testing passes

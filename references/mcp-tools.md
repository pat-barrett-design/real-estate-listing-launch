# MCP Integration Reference

## TikTok Ads MCP — Upgraded Smart+

**Advertiser ID (testing):** `7643466141041917959`

All campaigns start DISABLED. The agent reviews and enables in Ads Manager.

### Create Campaign
```
Tool: Create_an_Upgraded_Smart_Campaign
Key args:
  advertiser_id: "7643466141041917959"
  request_id: <str(unix_timestamp)>   # unique per request
  objective_type: "LEAD_GENERATION"
  campaign_name: "[Address] — Listing Launch"
  budget_mode: "BUDGET_MODE_DYNAMIC_DAILY_BUDGET"
  budget: 25.00
  operation_status: "DISABLE"
```

### Create Ad Group
```
Tool: Create_an_Upgraded_Smart_Ad_Group
Key args:
  advertiser_id: "7643466141041917959"
  request_id: <str(unix_timestamp + 1)>
  campaign_id: <from campaign creation>
  adgroup_name: "[City] Buyers — [Price Range]"
  promotion_type: "LEAD_GENERATION"
  optimization_goal: "LEAD_GENERATION"
  bid_type: "BID_TYPE_NO_BID"
  billing_event: "OCPM"
  targeting_optimization_mode: "AUTOMATIC"
  schedule_type: "SCHEDULE_FROM_NOW"
  schedule_start_time: "<tomorrow 09:00:00 UTC>"
  targeting_spec:
    location_ids: ["2840"]     # US national — Fair Housing compliant
    spc_audience_age: "18+"    # Fair Housing — never restrict below 18
  operation_status: "DISABLE"
```

### Create Ad
```
Tool: Create_an_Upgraded_Smart_Ad
Key args:
  advertiser_id: "7643466141041917959"
  adgroup_id: <from ad group creation>
  ad_name: "[Address] — Listing Ad"
  ad_text_list:
    - {ad_text: "<hook_1>"}
    - {ad_text: "<hook_2>"}
    - {ad_text: "<hook_3>"}
  call_to_action_list:
    - {call_to_action: "LEARN_MORE"}
  landing_page_url_list:
    - {landing_page_url: "<listing URL or agent website>"}
  creative_list:
    - {creative_info: {ad_format: "SINGLE_VIDEO"}}
  operation_status: "DISABLE"
```

### Get Performance Report
```
Tool: Run_a_synchronous_report
Key args:
  advertiser_id: "7643466141041917959"
  report_type: "BASIC"
  data_level: "AUCTION_AD"
  dimensions: ["ad_id", "stat_time_day"]
  metrics: ["impressions", "clicks", "cost_per_result", "result"]
  start_date: "<campaign start date>"
  end_date: "<today>"
```

## Constant Contact MCP (Rise MCP Gateway)

**Server:** `https://mcp.apps.constantcontact.com/public_api/mcp`
**Client ID:** `39b68297-37c9-45c8-9c7d-ce4b97f90dfd`
**Auth:** OAuth — MCP supports both `oauth2` (scope: `campaign_data`) and `noauth`.
- If authenticated → `call_to_action: "schedule"` (user can schedule/send)
- If unauthenticated → `call_to_action: "signUp"` (triggers account connection flow)

### Create Email Campaign (single-step)
```
Tool: createEmailCampaignUsingPOST
Args:
  name: "[Address] — New Listing" (max 80 chars, must be unique)
  email_campaign_activities: [
    {
      subject: "Just Listed: [Address]",
      preheader: "[punchy preview text]",
      html_content: "<full HTML email — MUST include [[trackingImage]]>"
    }
  ]
Returns:
  campaign_activity_id: "<id>"
  call_to_action: "schedule" | "signUp"
  campaign_id: "<id>"
  from_email: "<account default>"
  subject: "<subject line>"
```
Notes:
- `from_name`, `from_email`, `reply_to_email` auto-populated from account defaults — do NOT pass these
- `[[trackingImage]]` is REQUIRED in html_content for CC reporting
- `format_type` defaults automatically — do not set
- This is a SINGLE call (no two-step POST shell + PUT HTML like the old Render server)

### Update Email Campaign Activity
```
Tool: updateEmailCampaignActivityUsingPUT
Args:
  campaign_activity_id: "<from create response>"
  update: {
    subject: "<new subject>",
    html_content: "<updated HTML>",
    preheader: "<updated preheader>"
  }
```

### Check Schedule Readiness
```
Tool: check_campaign_schedule_readiness
Args:
  campaign_activity_id: "<from create response>"
Returns: status + scheduling URL (only DRAFT campaigns can be scheduled)
```

### Get HTML Preview
```
Tool: get_campaign_html_preview
Args:
  campaign_activity_id: "<from create response>"
Returns: decoded HTML content + email metadata
```

### List Sender Emails
```
Tool: retrieveEmailAddresses
Args: {} (optional filters: confirm_status, role_code, email_address)
Returns: collection of verified sender email addresses
```

## Error handling

### TikTok billing error (code 40002)
> "Your TikTok Ads account needs a payment method before we can push campaigns live. [Link to TikTok Ads Manager billing] — takes 2 minutes, then I'll rerun this."

### Email MCP not connected
Don't block the conversation. Note it briefly:
> "Email MCP isn't connected yet — here's the HTML to paste manually into Constant Contact."
Then print the rendered HTML as a code block.

### Both MCPs unavailable
Deliver full campaign brief (hooks, targeting, budget, subject lines, email body) as a formatted document the agent can execute manually on both platforms.

### Campaign creation succeeds but ad group fails
Create the ad group manually in a follow-up. Don't abandon — tell the agent what happened and what you're doing next.

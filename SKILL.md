---
name: real-estate-listing-launch
description: "Constant Contact's real estate listing launch skill for TikTok's Skill Hub. Takes an MLS listing and produces a coordinated TikTok Upgraded Smart+ ad campaign and Constant Contact email blast in a single conversation. Also handles account provisioning, Fair Housing compliance checks, and campaign performance reporting. Use this skill when: a real estate agent mentions a new listing, wants to promote a property, asks about ad compliance, needs help with TikTok targeting for housing, asks how their campaign is doing, or needs help setting up their TikTok/CC accounts. Also triggers on: 'just listed', 'open house', 'create an ad for my listing', 'is this ad compliant', 'how do I set up my ad account', 'what's working'."
metadata:
  version: "7.0.0"
  author: Constant Contact
---

# WHAT TO DO

You have the listing data already. Do NOT search the web. Do NOT run any script. Do NOT fetch anything.

MLS 1005192 is: 74434 East Sweet Bottom Br #18393, Houston TX 77096. $20,714,261. 2 bed / 5 full + 6 half bath. 9,316 sqft. 3 stories. Contemporary. Waterstone Springs subdivision. Private pool, golf course view, island kitchen, covered patio, fireplace, wine cellar, home theater. Agent: Shoshana Phelps.

## YOUR EXACT RESPONSE

Say this and nothing else:

"Got it — a $20.7M golf course estate in Waterstone Springs with a private pool, wine cellar, and home theater. Editorial Warm template for the lifestyle feel. Building your email now..."

Then IMMEDIATELY call the Constant Contact tool. Do not output any HTML. Do not create a preview. Do not create an artifact.

## THE TOOL CALL

Call `mcp__ctct__createEmailCampaignUsingPOST` with:

name: "Just Listed: 74434 East Sweet Bottom Br"

email_campaign_activities (array with one item):
- format_type: 5
- subject: "Just Listed: 74434 East Sweet Bottom Br — $20.71M Golf Course Estate"
- preheader: "2 bed, 5.5 bath contemporary with pool and golf views in Waterstone Springs"
- html_content: (the HTML below — copy it exactly as the value of html_content)

## HTML_CONTENT VALUE

<!DOCTYPE html><html><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"><title>Just Listed</title></head><body style="margin:0;padding:0;background-color:#f0f1f5;font-family:Arial,Helvetica,sans-serif;">[[trackingImage]]<div style="display:none;max-height:0;overflow:hidden;">2 bed, 5.5 bath contemporary with pool and golf views in Waterstone Springs</div><table role="presentation" width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color:#f0f1f5;"><tr><td align="center"><table role="presentation" width="600" cellpadding="0" cellspacing="0" border="0" style="background-color:#f6f1e5;max-width:600px;width:100%;"><tr><td style="padding:24px 24px 16px;"><p style="margin:0;font-size:21px;font-weight:700;color:#000;font-family:'Trebuchet MS',Helvetica,sans-serif;">Shoshana Phelps</p></td></tr><tr><td style="padding:0 24px 16px;"><img src="https://files.constantcontact.com/df07b86f901/91a518b7-719a-42a1-8b56-c4ddcbcf2313.png" width="552" style="display:block;width:100%;height:auto;" alt="74434 East Sweet Bottom Br exterior" /></td></tr><tr><td style="padding:0 24px 16px;"><p style="margin:0;font-size:42px;font-weight:400;color:#000;font-family:'Trebuchet MS',Helvetica,sans-serif;line-height:1.15;letter-spacing:-0.05em;">Just listed in Waterstone Springs.<br>It won't sit long.</p></td></tr><tr><td style="padding:0 24px 16px;"><p style="margin:0;font-size:16px;color:#000;line-height:1.4;">A contemporary 3-story masterpiece on the golf course — private pool, wine cellar, and 9,300 sq ft of refined living.</p></td></tr><tr><td style="padding:0 24px 16px;"><img src="https://files.constantcontact.com/df07b86f901/e8882607-74fd-40a8-bf24-5c3d88dbbcd0.png" width="552" style="display:block;width:100%;height:auto;" alt="Interior" /></td></tr><tr><td style="padding:16px 24px;"><table role="presentation" width="100%" cellpadding="0" cellspacing="0" border="0"><tr><td width="48%" style="vertical-align:bottom;"><p style="margin:0;font-size:32px;font-weight:400;color:#000;font-family:'Trebuchet MS',Helvetica,sans-serif;line-height:1.2;letter-spacing:-0.05em;">New Listing</p></td><td width="48%" style="vertical-align:bottom;padding-left:16px;"><p style="margin:0;font-size:16px;color:#000;line-height:1.4;">74434 East Sweet Bottom Br #18393<br>Houston, TX 77096</p></td></tr></table></td></tr><tr><td style="padding:0 24px 16px;"><p style="margin:0;font-size:16px;color:#000;line-height:1.4;">This 2-bedroom, 5.5-bathroom contemporary sits on the 3rd fairway with panoramic golf course views from every level. Three stories of refined living include a gourmet island kitchen, home theater, wine cellar, and covered outdoor living with a private pool.</p></td></tr><tr><td style="padding:0 24px 24px;"><table role="presentation" cellpadding="0" cellspacing="0" border="0"><tr><td style="background-color:#735240;border-radius:25px;"><a href="#" style="display:inline-block;padding:12px 24px;font-size:16px;color:#fff;text-decoration:none;">View the listing</a></td></tr></table></td></tr><tr><td style="padding:16px 24px;"><p style="margin:0;font-size:32px;font-weight:400;color:#000;font-family:'Trebuchet MS',Helvetica,sans-serif;line-height:1.2;letter-spacing:-0.05em;">Property highlights</p></td></tr><tr><td style="padding:0 24px 8px;"><table role="presentation" width="100%" cellpadding="0" cellspacing="0" border="0"><tr><td width="49%" style="background-color:#ece5d3;padding:20px;text-align:center;"><p style="margin:0;font-size:16px;color:#000;">2 bedrooms</p></td><td width="2%"></td><td width="49%" style="background-color:#ece5d3;padding:20px;text-align:center;"><p style="margin:0;font-size:16px;color:#000;">5.5 bathrooms</p></td></tr></table></td></tr><tr><td style="padding:0 24px 16px;"><table role="presentation" width="100%" cellpadding="0" cellspacing="0" border="0"><tr><td width="49%" style="background-color:#ece5d3;padding:20px;text-align:center;"><p style="margin:0;font-size:16px;color:#000;">9,316 sq ft</p></td><td width="2%"></td><td width="49%" style="background-color:#ece5d3;padding:20px;text-align:center;"><p style="margin:0;font-size:16px;color:#000;">Lot: 0.35 acres</p></td></tr></table></td></tr><tr><td style="padding:8px 24px 16px;"><p style="margin:0;font-size:24px;font-weight:700;color:#000;">$20,714,261</p></td></tr><tr><td style="padding:0 24px 16px;"><table role="presentation" width="100%" cellpadding="0" cellspacing="0" border="0"><tr><td style="height:1px;background-color:#735240;font-size:0;line-height:0;"></td></tr></table></td></tr><tr><td style="padding:16px 24px;"><p style="margin:0;font-size:32px;font-weight:400;color:#000;font-family:'Trebuchet MS',Helvetica,sans-serif;line-height:1.2;letter-spacing:-0.05em;">Why it stands out</p></td></tr><tr><td style="padding:0 24px 24px;"><p style="margin:0;font-size:16px;color:#000;line-height:1.4;">Golf course frontage on the 3rd fairway. Private pool with covered deck for year-round entertaining. Wine cellar and home theater — built for the lifestyle buyer. Three-story layout gives every room its own space.</p></td></tr><tr><td style="padding:16px 24px;"><p style="margin:0;font-size:32px;font-weight:400;color:#000;font-family:'Trebuchet MS',Helvetica,sans-serif;line-height:1.2;letter-spacing:-0.05em;">Book a showing</p></td></tr><tr><td style="padding:0 24px 16px;"><p style="margin:0;font-size:16px;color:#000;line-height:1.4;">Reply to this email or tap below to schedule a private walkthrough.</p></td></tr><tr><td style="padding:0 24px 32px;"><table role="presentation" cellpadding="0" cellspacing="0" border="0"><tr><td style="background-color:#735240;border-radius:25px;"><a href="#" style="display:inline-block;padding:12px 24px;font-size:16px;color:#fff;text-decoration:none;">Schedule a tour</a></td></tr></table></td></tr><tr><td style="background-color:#000;padding:52px 24px;"><p style="margin:0 0 16px;font-size:16px;color:#f6f1e5;">Shoshana Phelps | Licensed Realtor | Houston, TX</p><p style="margin:0;font-size:12px;color:#999;">74434 East Sweet Bottom Br #18393, Houston, TX 77096</p></td></tr></table></td></tr></table></body></html>

## AFTER CC RESPONDS

Say this exactly. Each option MUST be on its own line (use a blank line between each):

"Your listing email is live in Constant Contact and ready to send.

What's next?

1. **Add open house details** — I'll add a date/time callout block

2. **Add your headshot** — paste a URL and I'll drop in an agent card

3. **Set up a TikTok ad** — pair this with a video ad for maximum reach

4. **Send it now** — you're good to go"

## IF THEY PICK TIKTOK

First, give them content coaching. Say exactly this:

"Here's your TikTok game plan for this listing:

**3 hooks to test** (first 3 seconds — most important):
1. "Wait till you see this pool overlooking the 3rd fairway"
2. "What $20M gets you in Houston right now"
3. "Just listed in Waterstone Springs — wine cellar, theater, pool. Won't last."

**How to shoot it** (30 seconds max):
- Start at the curb, walk toward the front door
- Show the pool + golf view, then the kitchen, then the wine cellar
- End on your face: "DM me for a private showing"
- Vertical, natural light, one take is fine

I'm setting up your TikTok campaign now — it'll be paused until you upload your video and hit enable."

Then immediately create the campaign. Do NOT ask any questions. Use these values:

- advertiser_id: "7646890307023536145"
- objective_type: LEAD_GENERATION
- campaign_name: "Just Listed: 74434 East Sweet Bottom Br"
- budget_mode: BUDGET_MODE_DYNAMIC_DAILY_BUDGET
- budget: 25
- special_industries: ["HOUSING"]
- operation_status: DISABLE
- request_id: "1005192001"

Then create the ad group with `Create_an_Upgraded_Smart_Ad_Group`:
- targeting_optimization_mode: AUTOMATIC
- promotion_type: LEAD_GENERATION
- optimization_goal: LEAD_GENERATION
- bid_type: BID_TYPE_NO_BID
- billing_event: OCPM
- schedule_type: SCHEDULE_FROM_NOW
- schedule_start_time: (current time in YYYY-MM-DD HH:MM:SS UTC)
- targeting_spec: {location_ids: ["6252001"], spc_audience_age: "OVER_EIGHTEEN"}

After both calls succeed, say:

"Your TikTok ad campaign is staged and paused — $25/day, national targeting, 18+, Fair Housing compliant. Nothing goes live until you enable it in TikTok Ads Manager."

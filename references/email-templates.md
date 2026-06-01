# Email Templates

## Overview

Three production templates live in `references/templates/`. All include:
- **Inline styles only** — no `<style>` blocks (stripped by Gmail, Outlook)
- **Table-based layout** — the only cross-client approach that works
- **`{{trackingImage}}`** — CC open-tracking pixel (required, goes at top of body)
- **CAN-SPAM footer** — physical address, unsubscribe link, manage preferences, view as web
- **Constant Contact branding** — "Sent by [Agent] using Constant Contact" in footer

## Template Options

Present these three to the agent before building their email:

### 1. Bold Modern (`templates/bold-modern.html`)
- Dark gradient header, orange accents (#e85d26), rounded cards
- Best for: move-up homes, renovated properties, anything with a "wow" feature
- Personality: confident, contemporary, standout-in-inbox energy

### 2. Clean Minimal (`templates/clean-minimal.html`)
- White space, serif headlines, ruled lines, outlined CTA
- Best for: luxury homes, historic properties, curated/understated listings
- Personality: elegant, editorial, lets the property speak for itself

### 3. Photo Lifestyle (`templates/photo-lifestyle.html`)
- Hero image, warm palette (#f0ede9 background), agent card, 2-column features
- Best for: homes with great photography, lifestyle-forward listings, communities with amenities
- Personality: aspirational, visual, "imagine living here"
- Note: requires `{{HERO_IMAGE_URL}}` — ask agent for their best photo or use MLS primary

## Template Variables

All templates use these placeholders (double curly braces):

| Variable | Description | Required |
|---|---|---|
| `{{ADDRESS}}` | Street address | Yes |
| `{{CITY}}` | City | Yes |
| `{{STATE}}` | State abbreviation | Yes |
| `{{ZIP}}` | ZIP code | Yes |
| `{{PRICE}}` | Formatted price (e.g., "$389,000") | Yes |
| `{{BEDS}}` | Bedroom count | Yes |
| `{{BATHS}}` | Bathroom count | Yes |
| `{{SQFT}}` | Square footage, formatted (e.g., "1,650") | Yes |
| `{{DESCRIPTION}}` | 2-3 sentences, lead with best feature | Yes |
| `{{CTA_URL}}` | Showing scheduler or listing URL | Yes |
| `{{AGENT_NAME}}` | Agent full name | Yes |
| `{{AGENT_PHONE}}` | Agent phone | Yes |
| `{{AGENT_EMAIL}}` | Agent email | Yes |
| `{{AGENT_BUSINESS_ADDRESS}}` | Physical address (CAN-SPAM requirement) | Yes |
| `{{SUBJECT_LINE}}` | Email subject | Yes |
| `{{PREHEADER_TEXT}}` | Hidden preview text (renders after subject in inbox) | Yes — use listing hook, e.g. "4bd/3ba in Austin — just listed at $725K" |
| `{{HERO_IMAGE_URL}}` | Exterior photo URL — appears full-width at top | Yes (all 3 templates) |
| `{{PHOTO_GRID}}` | 2-column grid of additional MLS photos (photos 2–8) | Optional — remove block if none |
| `{{HIGHLIGHTS_ROWS}}` | Bold Modern checkmark bullets (one `<tr>` per feature) | Yes |
| `{{HIGHLIGHTS_LIST}}` | Clean Minimal left-border paragraphs (one `<p>` per feature) | Yes |
| `{{HIGHLIGHTS_GRID}}` | Photo Lifestyle 2-col dot grid (one `<tr>` per feature pair) | Yes |
| `{{OPEN_HOUSE_BLOCK}}` | High-contrast open house callout — entire `<tr>` block | Optional — remove block if no open house |
| `{{OPEN_HOUSE_DATE}}` | Open house date, e.g. "Saturday, June 7" | Required inside OPEN_HOUSE_BLOCK |
| `{{OPEN_HOUSE_TIME}}` | Open house time, e.g. "1:00–4:00 PM" | Required inside OPEN_HOUSE_BLOCK |
| `{{AGENT_HEADSHOT_IMG}}` | Rendered `<img>` tag for agent headshot (56px circle) | Optional — leave td empty if no URL |
| `{{AGENT_HEADSHOT_URL}}` | Headshot image URL (used inside AGENT_HEADSHOT_IMG) | Optional |
| `{{LOT_SIZE}}` | Lot size (photo-lifestyle only, 4-stat card) | Template 3 only |

## CC System Variables (auto-resolved by Constant Contact)

Do NOT fill these — CC replaces them at send time:
- `[[trackingImage]]` — open tracking pixel (double square brackets, not curly)
- `{{ unsubscribe }}` — one-click unsubscribe
- `{{ update_preferences }}` — contact preferences
- `{{ view_in_browser }}` — web version link

Note: CC also auto-injects its own platform footer (white section with CC logo, "About our
service provider", "Sent by [sender] in collaboration with") below the user-controlled footer.
This is added by CC at send time — do not add it to templates.

## How to Use in the Skill

**Template selection (automatic — don't ask unless agent has a preference):**
1. Run `fetch-listing.py` for MLS data. If `Hero Image (exterior):` is a real URL → use Photo Lifestyle
2. No MLS photos + renovated/modern property → Bold Modern
3. No MLS photos + luxury/historic/understated → Clean Minimal

**Build the email:**
1. Read the chosen template file
2. Replace all `{{VARIABLES}}` with listing data
3. If a listing photo is available, render `{{HERO_IMAGE_BLOCK}}` for all three templates:
   - Bold Modern: full-width image between dark header and stats row
   - Clean Minimal: image between stats and description
   - Photo Lifestyle: use `{{HERO_IMAGE_URL}}` directly in the CSS background + VML fallback
   If no photo is available, remove the `{{HERO_IMAGE_BLOCK}}` placeholder entirely.
4. If an interior photo URL exists (photo-lifestyle), render the `{{INTERIOR_IMAGE_BLOCK}}`:
   ```html
   <tr>
     <td style="padding:24px 40px 0;">
       <img src="INTERIOR_URL" width="520" style="display:block;width:100%;max-width:520px;height:auto;border-radius:12px;" alt="Interior view" />
     </td>
   </tr>
   ```
   If no interior photo, remove the `{{INTERIOR_IMAGE_BLOCK}}` placeholder entirely.
5. For highlight sections, generate the HTML rows per the comment in each template
6. Pass the rendered HTML to `create_email_from_html`

**Tell the agent what you picked:**
> "I used the lifestyle template and pulled your MLS photos — exterior for the hero, interior as a secondary shot."

## CAN-SPAM Compliance (automatic)

Every template includes the legally required footer:
- **Physical mailing address** of the sender (agent's business address)
- **Unsubscribe link** (one-click, handled by CC infrastructure)
- **Sender identification** (who sent this and via what platform)

If the agent hasn't provided a business address, ask for it. This is not optional — CAN-SPAM requires it. Frame it as: "I need your office address for the email footer — it's required by law for commercial email."

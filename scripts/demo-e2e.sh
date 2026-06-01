#!/bin/bash
# Full e2e demo: fetch listing → build email → create in CC → output link
# Usage: ./demo-e2e.sh <MLS_ID>

set -e
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILL_DIR="$(dirname "$SCRIPT_DIR")"
MLS_ID="${1:-1005192}"

echo "=== STEP 1: Fetch listing data ==="
LISTING=$(python3 "$SCRIPT_DIR/fetch-listing.py" --id "$MLS_ID")
echo "$LISTING" | head -5
echo "..."

echo ""
echo "=== STEP 2: Build email HTML ==="

# Extract key fields
ADDRESS=$(echo "$LISTING" | grep "^Address:" | sed 's/Address: //')
CITY_LINE=$(echo "$LISTING" | grep "^City:" | sed 's/City: //')
PRICE=$(echo "$LISTING" | grep "^Price:" | sed 's/Price: //')
BEDS=$(echo "$LISTING" | grep "Bedrooms:" | sed 's/.*Bedrooms: //')
BATHS_FULL=$(echo "$LISTING" | grep "Bathrooms:" | sed 's/.*Bathrooms: //' | grep -o '[0-9]* full' | grep -o '[0-9]*')
BATHS_HALF=$(echo "$LISTING" | grep "Bathrooms:" | sed 's/.*Bathrooms: //' | grep -o '[0-9]* half' | grep -o '[0-9]*')
BATHS=$((${BATHS_FULL:-0} + ${BATHS_HALF:-0}))
SQFT=$(echo "$LISTING" | grep "Sqft:" | sed 's/.*Sqft: //')
LOT=$(echo "$LISTING" | grep "Lot Size:" | sed 's/.*Lot Size: //')
HERO=$(echo "$LISTING" | grep "Hero Image" | sed 's/.*: //')
INTERIOR=$(echo "$LISTING" | grep "Interior Image" | sed 's/.*: //')
AGENT=$(echo "$LISTING" | grep "^Agent:" | sed 's/Agent: //')

echo "  Address: $ADDRESS"
echo "  Price: $PRICE"
echo "  Specs: ${BEDS}bd/${BATHS}ba, ${SQFT} sqft"
echo "  Agent: $AGENT"

# Build HTML from template
SUBJECT="Just Listed: ${ADDRESS} — ${PRICE} Golf Course Estate"
PREHEADER="${BEDS}bd/${BATHS}ba luxury estate in Waterstone Springs with golf course views"
CAMPAIGN_NAME="Just Listed: ${ADDRESS} - ${PRICE} Golf Course Estate"

cat > /tmp/demo-listing-email.html << EMAILEOF
<!DOCTYPE html><html><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"><title>${SUBJECT}</title></head><body style="margin:0;padding:0;background-color:#ede8e1;font-family:Arial,Helvetica,sans-serif;">[[trackingImage]]<div style="display:none;max-height:0;overflow:hidden;">${PREHEADER}</div><table role="presentation" width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color:#ede8e1;"><tr><td align="center" style="padding:28px 16px;"><table role="presentation" width="600" cellpadding="0" cellspacing="0" border="0" style="background-color:#ffffff;border-radius:16px;overflow:hidden;"><tr><td style="padding:0;line-height:0;font-size:0;"><img src="${HERO}" width="600" style="display:block;width:100%;max-width:600px;height:auto;" alt="${ADDRESS}"/></td></tr><tr><td style="padding:28px 36px 0;"><p style="margin:0 0 10px;font-size:9px;font-weight:700;text-transform:uppercase;letter-spacing:3px;color:#e85d26;">Just Listed</p><p style="margin:0;font-size:34px;font-weight:800;color:#2a2420;line-height:1.05;letter-spacing:-0.5px;">${PRICE}</p><p style="margin:8px 0 0;font-size:18px;font-weight:600;color:#2a2420;line-height:1.3;">${ADDRESS}</p><p style="margin:4px 0 0;font-size:13px;color:#9c8c7a;">${CITY_LINE}</p></td></tr><tr><td style="padding:20px 36px 0;"><table role="presentation" width="100%" cellpadding="0" cellspacing="0" border="0" style="background:#f7f4f0;border-radius:12px;"><tr><td style="padding:16px 24px;"><table role="presentation" width="100%" cellpadding="0" cellspacing="0" border="0"><tr><td align="center" width="25%"><p style="margin:0;font-size:20px;font-weight:700;color:#2a2420;">${BEDS}</p><p style="margin:3px 0 0;font-size:9px;font-weight:600;text-transform:uppercase;letter-spacing:1.5px;color:#9c8c7a;">Beds</p></td><td align="center" width="25%"><p style="margin:0;font-size:20px;font-weight:700;color:#2a2420;">${BATHS}</p><p style="margin:3px 0 0;font-size:9px;font-weight:600;text-transform:uppercase;letter-spacing:1.5px;color:#9c8c7a;">Baths</p></td><td align="center" width="25%"><p style="margin:0;font-size:20px;font-weight:700;color:#2a2420;">${SQFT}</p><p style="margin:3px 0 0;font-size:9px;font-weight:600;text-transform:uppercase;letter-spacing:1.5px;color:#9c8c7a;">Sq Ft</p></td><td align="center" width="25%"><p style="margin:0;font-size:20px;font-weight:700;color:#2a2420;">${LOT}</p><p style="margin:3px 0 0;font-size:9px;font-weight:600;text-transform:uppercase;letter-spacing:1.5px;color:#9c8c7a;">Lot</p></td></tr></table></td></tr></table></td></tr><tr><td style="padding:20px 36px 0;"><table role="presentation" width="100%" cellpadding="0" cellspacing="0" border="0"><tr><td align="center" style="background-color:#2a2420;border-radius:10px;"><a href="https://www.google.com/maps/?q=${ADDRESS// /+},${CITY_LINE// /+}" style="display:block;padding:18px 16px;text-align:center;font-size:15px;font-weight:700;letter-spacing:0.5px;color:#ffffff;text-decoration:none;">Schedule Your Tour</a></td></tr></table></td></tr><tr><td style="padding:24px 36px 0;"><p style="margin:0;font-size:15px;line-height:1.85;color:#4a3f36;">Spectacular 3-story golf course view estate in prestigious Waterstone Springs. This luxury property features a 6-car garage, resort-style pool, and premium finishes throughout. Island kitchen, high ceilings, and covered patios perfect for entertaining.</p></td></tr><tr><td style="padding:20px 36px 0;"><img src="${INTERIOR}" width="528" style="display:block;width:100%;height:auto;border-radius:8px;" alt="Interior"/></td></tr><tr><td style="padding:20px 36px 0;"><p style="margin:0 0 14px;font-size:9px;font-weight:700;text-transform:uppercase;letter-spacing:2.5px;color:#2a2420;">What is Included</p><table role="presentation" width="100%" cellpadding="0" cellspacing="0" border="0"><tr><td width="48%" style="padding:8px 0;font-size:13px;color:#4a3f36;border-bottom:1px solid #f0ebe4;"><span style="display:inline-block;width:6px;height:6px;background-color:#e85d26;border-radius:50%;margin-right:8px;vertical-align:middle;"></span>Golf course views</td><td width="4%"></td><td width="48%" style="padding:8px 0;font-size:13px;color:#4a3f36;border-bottom:1px solid #f0ebe4;"><span style="display:inline-block;width:6px;height:6px;background-color:#c4b09c;border-radius:50%;margin-right:8px;vertical-align:middle;"></span>Resort pool</td></tr><tr><td width="48%" style="padding:8px 0;font-size:13px;color:#4a3f36;border-bottom:1px solid #f0ebe4;"><span style="display:inline-block;width:6px;height:6px;background-color:#e85d26;border-radius:50%;margin-right:8px;vertical-align:middle;"></span>6-car garage</td><td width="4%"></td><td width="48%" style="padding:8px 0;font-size:13px;color:#4a3f36;border-bottom:1px solid #f0ebe4;"><span style="display:inline-block;width:6px;height:6px;background-color:#c4b09c;border-radius:50%;margin-right:8px;vertical-align:middle;"></span>Fenced yard</td></tr><tr><td width="48%" style="padding:8px 0;font-size:13px;color:#4a3f36;border-bottom:1px solid #f0ebe4;"><span style="display:inline-block;width:6px;height:6px;background-color:#e85d26;border-radius:50%;margin-right:8px;vertical-align:middle;"></span>Island kitchen</td><td width="4%"></td><td width="48%" style="padding:8px 0;font-size:13px;color:#4a3f36;border-bottom:1px solid #f0ebe4;"><span style="display:inline-block;width:6px;height:6px;background-color:#c4b09c;border-radius:50%;margin-right:8px;vertical-align:middle;"></span>Covered patios</td></tr></table></td></tr><tr><td style="padding:20px 36px 32px;"><table role="presentation" width="100%" cellpadding="0" cellspacing="0" border="0"><tr><td align="center" style="background-color:#e85d26;border-radius:10px;"><a href="https://www.google.com/maps/?q=${ADDRESS// /+},${CITY_LINE// /+}" style="display:block;padding:18px 16px;text-align:center;font-size:15px;font-weight:700;letter-spacing:0.5px;color:#ffffff;text-decoration:none;">See All Photos + Details</a></td></tr></table></td></tr><tr><td style="padding:0 36px 32px;"><table role="presentation" width="100%" cellpadding="0" cellspacing="0" border="0" style="background:#f7f4f0;border-radius:12px;"><tr><td style="padding:18px 20px;"><p style="margin:0;font-size:9px;font-weight:600;text-transform:uppercase;letter-spacing:2px;color:#9c8c7a;">Your Agent</p><p style="margin:5px 0 0;font-size:15px;font-weight:700;color:#2a2420;">${AGENT}</p><p style="margin:2px 0 0;font-size:10px;color:#9c8c7a;">License: TX-REL-000000</p></td></tr></table></td></tr></table><table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color:#f5f5f5;margin-top:20px;"><tr><td align="center" style="padding:16px 0;"><table style="width:580px;" border="0" cellpadding="0" cellspacing="0"><tr><td align="center" style="color:#5d5d5d;font-family:Verdana,Geneva,sans-serif;font-size:12px;padding:4px 0;">123 Main St, Houston, TX 77002</td></tr><tr><td align="center" style="color:#5d5d5d;font-family:Verdana,Geneva,sans-serif;font-size:12px;padding:4px 0;"><a href="{{ view_in_browser }}" style="color:#5d5d5d;text-decoration:underline;">View in browser</a> | <a href="{{ update_preferences }}" style="color:#5d5d5d;text-decoration:underline;">Preferences</a> | <a href="{{ unsubscribe }}" style="color:#5d5d5d;text-decoration:underline;">Unsubscribe</a></td></tr></table></td></tr></table></td></tr></table></body></html>
EMAILEOF

echo "  HTML written to /tmp/demo-listing-email.html"

echo ""
echo "=== STEP 3: Create campaign in Constant Contact ==="
python3 "$SCRIPT_DIR/create-email.py" \
  --name "$CAMPAIGN_NAME" \
  --subject "$SUBJECT" \
  --preheader "$PREHEADER" \
  --from-email "pat.barrett@constantcontact.com" \
  --from-name "$AGENT" \
  --html /tmp/demo-listing-email.html

echo ""
echo "=== STEP 4: TikTok Hooks (ready for ad creation) ==="
echo ""
echo "  1. \"Wait till you see this golf course view in Spring/Klein\""
echo "  2. \"What ${PRICE} gets you in Waterstone Springs right now\""
echo "  3. \"Just listed in Houston — 6-car garage, pool, 3 stories. Won't last.\""
echo ""
echo "=== DONE ==="

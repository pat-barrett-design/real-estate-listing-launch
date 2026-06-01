#!/bin/bash
# Constant Contact OAuth token flow
# Usage: ./cc-auth.sh [refresh]
# - No args: full OAuth flow (opens browser, catches code, exchanges for token)
# - "refresh": uses saved refresh token to get a new access token

TOKEN_FILE="$(dirname "$0")/../.cc-token.json"
CLIENT_ID="db341bc5-1e4e-4252-8799-5449b56c2544"
CLIENT_SECRET="N8KhaUAFbvgeRAJ5mNLN9w"
REDIRECT_URI="http://localhost:3002/oauth/callback"
AUTH_URL="https://authz.constantcontact.com/oauth2/default/v1/authorize"
TOKEN_URL="https://authz.constantcontact.com/oauth2/default/v1/token"
STATE="ccauth$(date +%s)"

if [ "$1" = "refresh" ] && [ -f "$TOKEN_FILE" ]; then
  REFRESH_TOKEN=$(python3 -c "import json; print(json.load(open('$TOKEN_FILE'))['refresh_token'])" 2>/dev/null)
  if [ -n "$REFRESH_TOKEN" ]; then
    echo "Refreshing token..."
    RESPONSE=$(curl -s -X POST "$TOKEN_URL" \
      -H "Content-Type: application/x-www-form-urlencoded" \
      -u "$CLIENT_ID:$CLIENT_SECRET" \
      -d "refresh_token=$REFRESH_TOKEN&grant_type=refresh_token")

    if echo "$RESPONSE" | python3 -c "import sys,json; json.load(sys.stdin)['access_token']" 2>/dev/null; then
      echo "$RESPONSE" > "$TOKEN_FILE"
      echo "Token refreshed successfully."
      ACCESS_PREVIEW=$(python3 -c "import json; print(json.load(open('$TOKEN_FILE'))['access_token'][:50])")
      echo "Access token: ${ACCESS_PREVIEW}..."
      exit 0
    else
      echo "Refresh failed, running full flow..."
    fi
  fi
fi

# Full OAuth flow
FULL_URL="${AUTH_URL}?client_id=${CLIENT_ID}&redirect_uri=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$REDIRECT_URI'))")&response_type=code&scope=campaign_data+contact_data+account_read&state=${STATE}"

echo "Opening browser for CC login..."
open "$FULL_URL"

echo ""
echo "After logging in, you'll be redirected to localhost (it will show an error)."
echo "Copy the FULL URL from your browser bar and paste it here:"
echo ""
read -p "URL: " CALLBACK_URL

# Extract code
CODE=$(echo "$CALLBACK_URL" | python3 -c "
import sys, urllib.parse
url = sys.stdin.readline().strip()
params = urllib.parse.parse_qs(urllib.parse.urlparse(url).query)
print(params.get('code', [''])[0])
")

if [ -z "$CODE" ]; then
  echo "ERROR: Could not extract code from URL"
  exit 1
fi

echo "Exchanging code for token..."
RESPONSE=$(curl -s -X POST "$TOKEN_URL" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -u "$CLIENT_ID:$CLIENT_SECRET" \
  -d "code=$CODE&redirect_uri=$REDIRECT_URI&grant_type=authorization_code")

if echo "$RESPONSE" | python3 -c "import sys,json; json.load(sys.stdin)['access_token']" 2>/dev/null; then
  echo "$RESPONSE" > "$TOKEN_FILE"
  echo ""
  echo "Token saved to $TOKEN_FILE"
  EXPIRES=$(python3 -c "import json; print(json.load(open('$TOKEN_FILE')).get('expires_in', 'unknown'))")
  echo "Expires in: $EXPIRES seconds"
  echo "Done."
else
  echo "ERROR: Token exchange failed"
  echo "$RESPONSE"
  exit 1
fi

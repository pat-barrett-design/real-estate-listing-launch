#!/usr/bin/env python3
"""
Fetch listing data from SimplyRETS API (RESO Web API compatible).
Uses demo credentials for prototype/testing.

Usage:
  python3 fetch-listing.py "74434 Sweet Bottom"
  python3 fetch-listing.py --list          # show available listings
  python3 fetch-listing.py --id 1005192    # fetch by MLS ID
"""

import sys
import json
import urllib.request
import urllib.parse
import base64

# SimplyRETS demo credentials (free, no signup needed)
API_BASE = "https://api.simplyrets.com"
USERNAME = "simplyrets"
PASSWORD = "simplyrets"


def make_request(endpoint, params=None):
    """Make authenticated request to SimplyRETS API."""
    import urllib.error
    url = f"{API_BASE}{endpoint}"
    if params:
        url += "?" + urllib.parse.urlencode(params)

    credentials = base64.b64encode(f"{USERNAME}:{PASSWORD}".encode()).decode()
    req = urllib.request.Request(url)
    req.add_header("Authorization", f"Basic {credentials}")

    try:
        with urllib.request.urlopen(req) as response:
            return json.loads(response.read().decode())
    except urllib.error.HTTPError as e:
        print(f"LISTING NOT FOUND: HTTP {e.code} from SimplyRETS for {endpoint}")
        print("FALLBACK: Use web search to find this listing by MLS ID or address.")
        sys.exit(1)
    except urllib.error.URLError as e:
        print(f"NETWORK ERROR: {e.reason}")
        print("FALLBACK: Use web search to find this listing by MLS ID or address.")
        sys.exit(1)


def format_listing(listing):
    """Format a listing into a clean summary for the skill."""
    addr = listing.get("address", {})
    prop = listing.get("property", {})
    geo = listing.get("geo", {})
    school = listing.get("school", {})
    photos = listing.get("photos", [])

    # Build feature list
    features = []
    if prop.get("pool"):
        features.append(f"Pool ({prop['pool']})")
    if prop.get("fireplaces"):
        features.append(f"{prop['fireplaces']} fireplace(s)")
    if prop.get("view"):
        features.append(f"{prop['view']} view")
    if prop.get("interiorFeatures"):
        features.append(prop["interiorFeatures"])
    if prop.get("exteriorFeatures"):
        features.append(prop["exteriorFeatures"])

    # Format price
    price = listing.get("listPrice", 0)
    if price >= 1_000_000:
        price_str = f"${price / 1_000_000:.2f}M"
    else:
        price_str = f"${price:,.0f}"

    output = f"""
=== LISTING DATA (from MLS) ===

Address: {addr.get('full', 'Unknown')}
City: {addr.get('city', '')}, {addr.get('state', '')} {addr.get('postalCode', '')}
Price: {price_str}
Status: {listing.get('mls', {}).get('status', 'Unknown')}

Property Details:
  Bedrooms: {prop.get('bedrooms', 'N/A')}
  Bathrooms: {prop.get('bathsFull', 0)} full, {prop.get('bathsHalf', 0)} half
  Sqft: {prop.get('area', 'N/A')}
  Stories: {prop.get('stories', 'N/A')}
  Year Built: {prop.get('yearBuilt', 'N/A')}
  Style: {prop.get('style', 'N/A')}
  Lot Size: {prop.get('lotSize', 'N/A')}
  Garage: {prop.get('parking', {}).get('spaces', 'N/A')} spaces

Neighborhood:
  Subdivision: {prop.get('subdivision', 'N/A')}
  Market Area: {geo.get('marketArea', 'N/A')}
  County: {geo.get('county', 'N/A')}

Schools:
  Elementary: {school.get('elementarySchool', 'N/A')}
  Middle: {school.get('middleSchool', 'N/A')}
  High: {school.get('highSchool', 'N/A')}

Key Features:
{chr(10).join(f'  - {f}' for f in features) if features else '  - None listed'}

Photos: {len(photos)} available
Hero Image (exterior): {photos[0] if photos else 'None'}
Interior Image: {photos[1] if len(photos) > 1 else 'None'}
All Photos: {', '.join(photos[:8]) if photos else 'None'}

MLS ID: {listing.get('mlsId', 'N/A')}
Days on Market: {listing.get('mls', {}).get('daysOnMarket', 'N/A')}
List Date: {listing.get('listDate', 'N/A')[:10] if listing.get('listDate') else 'N/A'}

Agent: {listing.get('agent', {}).get('firstName', '')} {listing.get('agent', {}).get('lastName', '')}

================================
"""
    return output.strip()


def search_listings(query):
    """Search listings by address keyword."""
    params = {"q": query, "limit": 5}
    results = make_request("/properties", params)
    return results


def get_listing_by_id(mls_id):
    """Get a specific listing by MLS ID."""
    result = make_request(f"/properties/{mls_id}")
    return result


def list_available():
    """Show available demo listings."""
    results = make_request("/properties", {"limit": 10})
    print("\n=== AVAILABLE DEMO LISTINGS ===\n")
    for listing in results:
        addr = listing.get("address", {})
        prop = listing.get("property", {})
        price = listing.get("listPrice", 0)
        print(f"  MLS #{listing.get('mlsId')} | ${price:,.0f} | {prop.get('bedrooms', '?')}bd/{prop.get('bathsFull', '?')}ba | {addr.get('full', 'Unknown')}, {addr.get('city', '')}")
    print(f"\n  Total: {len(results)} listings shown")
    print("  Use: python3 fetch-listing.py --id <mlsId> for full details\n")


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage:")
        print("  python3 fetch-listing.py 'address search'")
        print("  python3 fetch-listing.py --list")
        print("  python3 fetch-listing.py --id <mlsId>")
        sys.exit(1)

    if sys.argv[1] == "--list":
        list_available()
    elif sys.argv[1] == "--id" and len(sys.argv) > 2:
        listing = get_listing_by_id(sys.argv[2])
        print(format_listing(listing))
    else:
        query = " ".join(sys.argv[1:])
        results = search_listings(query)
        if not results:
            print(f"No listings found for '{query}'")
            sys.exit(1)
        print(f"\nFound {len(results)} listing(s) for '{query}':\n")
        for listing in results:
            print(format_listing(listing))
            print()

# Fair Housing Compliance

## Why this matters

Fair Housing Act violations carry fines up to $100K+ and license revocation. Agents' #1 fear about running digital ads is accidentally violating FHA. Making compliance visible and automatic is a core differentiator — it removes the barrier to action.

## Hard rules (always enforced, no exceptions)

### Targeting
- **Age**: Always 18-65+. Never narrow age targeting for housing ads.
- **Radius**: Never less than 15 miles from the property.
- **No exclusions** by: race, color, religion, sex, disability, familial status, national origin.
- **No interest-based targeting** that proxies for protected classes (e.g., don't target "Christian families" or "Spanish speakers" for housing).

### Ad content language — never use:
- "Family-friendly" (familial status)
- "Safe neighborhood" / "low crime" (race proxy)
- "Up-and-coming" / "gentrifying" (race proxy)
- "Walking distance to [house of worship]" (religion)
- "Perfect for young professionals" (age + familial status)
- "No kids" / "adults only" (familial status)
- "English speakers" (national origin)
- "Quiet community" (can imply exclusion)

### What's OK:
- Describing the property itself: "3-car garage", "fenced yard", "open floor plan"
- Describing location factually: "2 blocks from [park name]", "downtown walkability score 92"
- Lifestyle-neutral features: "home office space", "chef's kitchen", "pool"
- School district info (factual, not "great schools" as code)

## How to position legally

We say "designed to follow Fair Housing best practices" — NOT "FHA compliant" or "guaranteed compliant." Legal has not cleared an absolute compliance claim.

If the agent asks "will this pass FHA?":
> "I've built this to follow Fair Housing best practices — open targeting, compliant language, no exclusions. For binding legal advice, check with your broker's compliance team."

## When something is ambiguous

Flag it visibly: "I want to double-check this for Fair Housing compliance before we run it." Then explain the concern and offer a compliant alternative.

## TikTok-specific FHA implementation

TikTok requires Special Ad Category for housing. When creating campaigns:
- `special_industries: ["HOUSING"]` — apply when available
- If not available via Smart+, ensure targeting stays FHA-compliant manually:
  - `spc_audience_age: "18+"` (never "25+")
  - `targeting_optimization_mode: "AUTOMATIC"` (lets platform optimize without exclusions)
  - `location_ids: ["2840"]` (US national) or metro-level (never neighborhood-level)

# Football Match Data Fields Documentation

This document describes all the data fields available in the football match API response, based on the sample data structure.

## Root Match Object

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | Integer | Yes | Unique identifier for the match |
| `kickoff` | Object | Yes | Match kickoff information |
| `competition` | Object | No | Competition/tournament information |
| `teams` | Array | Yes | Array of team objects (typically 2 teams) |
| `ground` | Object | Yes | Venue information where match is played |
| `status` | String | Yes | Match status indicator |
| `attendance` | Integer | No | Number of spectators (only for completed/live matches) |
| `clock` | Object | No | Current match time (only for live/completed matches) |
| `goals` | Array | No | Array of goal events (only when goals have been scored) |

## Kickoff Object

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `completeness` | Integer | Yes | Data completeness indicator (3 = complete) |
| `millis` | Long | Yes | Kickoff time as Unix timestamp in milliseconds |
| `label` | String | Yes | Human-readable kickoff time (e.g., "Mon 25 Nov 2024, 20:00 GMT") |

## Competition Object

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | Integer | Yes | Unique competition identifier |
| `title` | String | Yes | Competition name (e.g., "Premier League", "Champions League") |

## Teams Array

Each team object in the array contains:

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `team` | Object | Yes | Detailed team information |
| `score` | Integer | No | Current/final score (only present for live/completed matches) |

### Team Object (nested within teams)

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | Integer | Yes | Unique team identifier |
| `name` | String | Yes | Full team name (e.g., "Manchester United") |
| `shortName` | String | Yes | Shortened team name (e.g., "Man Utd") |
| `teamType` | String | Yes | Team type indicator (typically "FIRST" for first team) |
| `club` | Object | Yes | Club information |
| `altIds` | Object | No | Alternative identifiers for external systems |

### Club Object (nested within team)

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | Integer | Yes | Unique club identifier |
| `name` | String | Yes | Full club name |
| `shortName` | String | No | Short version of club name |
| `abbr` | String | Yes | Club abbreviation (3-letter code, e.g., "MUN", "ARS") |

### AltIds Object (nested within team)

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `opta` | String | No | Opta Sports data provider identifier (e.g., "t1", "t3") |

## Ground Object

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | Integer | Yes | Unique venue identifier |
| `name` | String | Yes | Stadium/ground name (e.g., "Emirates Stadium") |
| `city` | String | Yes | City where venue is located |
| `source` | String | Yes | Data source indicator (typically "OPTA") |

## Match Status Values

| Status | Meaning | Description |
|--------|---------|-------------|
| `"U"` | Upcoming | Match has not started yet |
| `"I"` | In Progress | Match is currently being played |
| `"C"` | Completed | Match has finished |

## Clock Object (Live/Completed matches only)

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `secs` | Integer | Yes | Match time in seconds from kickoff |
| `label` | String | Yes | Human-readable match time (e.g., "90 +5'00", "50'") |

### Clock Label Formats
- `"50'"` - Regular match time (50 minutes)
- `"90 +5'00"` - Stoppage time (90 minutes + 5 minutes added time)
- `"02'00"` - Early match time (2 minutes)

## Goals Array (When goals have been scored)

Each goal object contains:

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `personId` | Integer | Yes | Unique identifier for the goal scorer |
| `assistId` | Integer | No | Unique identifier for the player who assisted |
| `clock` | Object | Yes | Time when goal was scored |
| `phase` | String | Yes | Match phase when scored ("1" = first half, "2" = second half) |
| `type` | String | Yes | Type of goal scored |
| `description` | String | Yes | Goal description |

### Goal Types

| Type | Description |
|------|-------------|
| `"G"` | Regular goal |
| `"P"` | Penalty goal |

## Data Availability by Match Status

| Field | Upcoming | Live | Completed |
|-------|----------|------|-----------|
| Basic info (teams, kickoff, ground) | ✅ | ✅ | ✅ |
| Scores | ❌ | ✅ | ✅ |
| Clock | ❌ | ✅ | ✅ |
| Goals | ❌ | ✅ | ✅ |
| Attendance | ❌ | Sometimes | ✅ |

## Example Use Cases

### Displaying Team Names
- **Full UI**: Use `team.name` (e.g., "Manchester United")
- **Compact UI**: Use `team.shortName` (e.g., "Man Utd")  
- **Very compact**: Use `team.club.abbr` (e.g., "MUN")

### Match Time Display
- **Upcoming**: Show `kickoff.label`
- **Live**: Show `clock.label` 
- **Completed**: Show "FT" (Full Time)

### Score Display
- **Upcoming**: Hide scores or show "--"
- **Live/Completed**: Show `teams[0].score` vs `teams[1].score`

### Competition Context
Use `competition.title` to group matches or show tournament context.
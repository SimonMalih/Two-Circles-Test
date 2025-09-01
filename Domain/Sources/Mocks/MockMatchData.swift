import Foundation

/// Mock match data for testing purposes
public struct MockMatchData {
    public static let matches: [Match] = [
        // Premier League matches
        Match(
            id: 1,
            kickoff: Kickoff(
                completeness: 3,
                millis: Int64(Date().timeIntervalSince1970 * 1000) + 3600000,
                label: "Today 15:00 GMT"
            ),
            competition: Competition(
                id: 1,
                title: "Premier League"
            ),
            teams: [
                MatchTeam(
                    team: Team(
                        id: 1,
                        name: "Arsenal",
                        shortName: "Arsenal",
                        teamType: "FIRST",
                        club: Club(
                            id: 1,
                            name: "Arsenal",
                            abbr: "ARS",
                            shortName: "Arsenal"
                        ),
                        altIds: nil
                    ),
                    score: nil
                ),
                MatchTeam(
                    team: Team(
                        id: 10,
                        name: "Liverpool",
                        shortName: "Liverpool",
                        teamType: "FIRST",
                        club: Club(
                            id: 10,
                            name: "Liverpool",
                            abbr: "LIV",
                            shortName: "Liverpool"
                        ),
                        altIds: nil
                    ),
                    score: nil
                )
            ],
            ground: Ground(
                id: 1,
                name: "Emirates Stadium",
                city: "London",
                source: "OPTA"
            ),
            status: .upcoming,
            attendance: nil,
            clock: nil,
            goals: nil
        ),
        
        Match(
            id: 2,
            kickoff: Kickoff(
                completeness: 3,
                millis: Int64(Date().timeIntervalSince1970 * 1000) - 1800000,
                label: "Today 12:30 GMT"
            ),
            competition: Competition(
                id: 1,
                title: "Premier League"
            ),
            teams: [
                MatchTeam(
                    team: Team(
                        id: 12,
                        name: "Manchester United",
                        shortName: "Man Utd",
                        teamType: "FIRST",
                        club: Club(
                            id: 12,
                            name: "Manchester United",
                            abbr: "MUN",
                            shortName: "Man Utd"
                        ),
                        altIds: nil
                    ),
                    score: 2
                ),
                MatchTeam(
                    team: Team(
                        id: 131,
                        name: "Brighton and Hove Albion",
                        shortName: "Brighton",
                        teamType: "FIRST",
                        club: Club(
                            id: 131,
                            name: "Brighton and Hove Albion",
                            abbr: "BHA",
                            shortName: "Brighton"
                        ),
                        altIds: nil
                    ),
                    score: 1
                )
            ],
            ground: Ground(
                id: 2,
                name: "Old Trafford",
                city: "Manchester",
                source: "OPTA"
            ),
            status: .inProgress,
            attendance: 75000,
            clock: Clock(
                secs: 1800,
                label: "30'"
            ),
            goals: nil
        ),
        
        // Champions League match
        Match(
            id: 3,
            kickoff: Kickoff(
                completeness: 3,
                millis: Int64(Date().timeIntervalSince1970 * 1000) + 7200000,
                label: "Today 17:00 GMT"
            ),
            competition: Competition(
                id: 2,
                title: "UEFA Champions League"
            ),
            teams: [
                MatchTeam(
                    team: Team(
                        id: 23,
                        name: "Newcastle United",
                        shortName: "Newcastle",
                        teamType: "FIRST",
                        club: Club(
                            id: 23,
                            name: "Newcastle United",
                            abbr: "NEW",
                            shortName: "Newcastle"
                        ),
                        altIds: nil
                    ),
                    score: nil
                ),
                MatchTeam(
                    team: Team(
                        id: 127,
                        name: "Bournemouth",
                        shortName: "Bournemouth",
                        teamType: "FIRST",
                        club: Club(
                            id: 127,
                            name: "Bournemouth",
                            abbr: "BOU",
                            shortName: "Bournemouth"
                        ),
                        altIds: nil
                    ),
                    score: nil
                )
            ],
            ground: Ground(
                id: 3,
                name: "St. James' Park",
                city: "Newcastle",
                source: "OPTA"
            ),
            status: .upcoming,
            attendance: nil,
            clock: nil,
            goals: nil
        )
    ]
}
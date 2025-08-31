import Domain

extension MatchCardData {
    static let upcomingMatchCard = MatchCardData(
        homeTeam: .liverpool,
        awayTeam: .arsenal,
        homeScore: "1",
        awayScore: "2",
        homeTeamAbbr: Team.liverpool.shortName,
        awayTeamAbbr: Team.arsenal.shortName,
        shouldShowScores: false,
        match: .upcoming
    )
    
    static let liveMatchCard = MatchCardData(
        homeTeam: .psg,
        awayTeam: .manCity,
        homeScore: "3",
        awayScore: "4",
        homeTeamAbbr: Team.psg.shortName,
        awayTeamAbbr: Team.manCity.shortName,
        shouldShowScores: true,
        match: .live
    )
}
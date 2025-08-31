import Domain

extension Match {
    static let upcoming = Match(
        id: 1,
        kickoff: .upcoming,
        competition: .premierLeague,
        teams: [.liverpool, .arsenal],
        ground: .emirates,
        status: .upcoming,
        attendance: nil,
        clock: nil,
        goals: nil
    )
    
    static let live = Match(
        id: 2,
        kickoff: .live,
        competition: .championsLeague,
        teams: [.psg, .manCity],
        ground: .parcDesPrinces,
        status: .inProgress,
        attendance: nil,
        clock: .firstHalf,
        goals: nil
    )
    
    static let completed = Match(
        id: 3,
        kickoff: .completed,
        competition: .premierLeague,
        teams: [.chelsea, .tottenham],
        ground: .stamfordBridge,
        status: .completed,
        attendance: 40000,
        clock: .fullTime,
        goals: nil
    )
    
    static let premierLeagueMatches = [upcoming, completed]
    static let championsLeagueMatches = [live]
    static let allMatches = [upcoming, live, completed]
}
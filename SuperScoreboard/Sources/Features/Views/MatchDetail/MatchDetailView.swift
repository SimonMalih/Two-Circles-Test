//
//  MatchDetailView.swift
//  SuperScoreboard
//
//  Created by Simon Malih on 31/08/2025.
//

import SwiftUI
import Domain

struct MatchDetailView: View {
    
    let match: Match
    let favoritesRepository: FavouritesRepositoryProtocol?
    private let badgeWidth: CGFloat = 80
    private let teamViewPadding: CGFloat = 4
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                matchHeader
                venueSection
                if let goals = match.goals, !goals.isEmpty {
                    goalTimelineSection
                }
                matchMetadataSection
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
        }
        .addBackground()
        .navBarTitle("match_details_title")
    }
    
    private var matchHeader: some View {
        VStack(spacing: 16) {
            HStack(alignment: .center, spacing: 8) {
                teamView(for: homeTeam, isFavorite: isHomeTeamFavorite)
                    .padding(.leading, teamViewPadding)
                Spacer()
                scoreSection
                Spacer()
                teamView(for: awayTeam, isFavorite: isAwayTeamFavorite)
                    .padding(.trailing, teamViewPadding)
            }
        }
        .padding(.vertical)
        .background(.surfaceBase)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
        
    private var scoreSection: some View {
        VStack(spacing: 4) {
            HStack(spacing: 12) {
                Text(homeScore)
                Text("-")
                Text(awayScore)
            }
            .customFont(.headingsExtraLarge)
            
            Text(matchStatusText)
                .customFont(.bodySmall)
        }
    }
    
    private var venueSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            venueInfoRow
            
            if let attendance = match.attendance {
                attendanceRow(attendance)
            }
            
            if !match.kickoff.label.isEmpty {
                kickoffRow
            }
            
            if let competition = match.competition {
                competitionRow(competition)
            }
        }
        .padding(16)
        .background(.surfaceBase)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private var venueInfoRow: some View {
        HStack(spacing: 12) {
            Image(systemName: "location")
                .foregroundColor(.secondary)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(match.ground.name)
                    .customFont(.headingTitle3)                
                Text(match.ground.city)
                    .customFont(.bodyMedium, color: .gray)
            }
            
            Spacer()
        }
    }
    
    private var kickoffRow: some View {
        HStack(spacing: 12) {
            Image(systemName: "calendar")
                .foregroundColor(.secondary)
                .frame(width: 20)
            
            Text(match.kickoff.label)
                .customFont(.bodyMedium)
                .foregroundColor(.secondary)
            
            Spacer()
        }
    }
    
    private var goalTimelineSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            goalTimelineHeader
            GoalTimelineView(goals: match.goals ?? [])
        }
        .background(.surfaceBase)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private var goalTimelineHeader: some View {
        HStack(spacing: 8) {
            Image(systemName: "soccerball")
                .foregroundColor(.secondary)
            
            Text("goal_timeline_title")
                .customFont(.headingTitle3)
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
    }
    
    private var matchMetadataSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("match_information_title")
                .customFont(.headingTitle3)
                .foregroundColor(.primary)
            
            VStack(alignment: .leading, spacing: 8) {
                metadataRow(label: "match_id_label", value: "\(match.id)")
                metadataRow(label: "status_label", value: matchStatusDescription)
            }
        }
        .padding(16)
        .background(.surfaceBase)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - TeamView and Rows

private extension MatchDetailView {
    
    func teamView(for matchTeam: MatchTeam, isFavorite: Bool) -> some View {
        VStack(spacing: 8) {
            TeamBadgeView(
                teamId: matchTeam.team.id,
                abbreviation: matchTeam.team.club.abbr,
                isFavorite: isFavorite
            )
            Text(matchTeam.team.shortName)
                .customFont(.bodyMedium)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.8)
        }
        .frame(width: badgeWidth)
    }
    
    func metadataRow(label: LocalizedStringKey, value: LocalizedStringKey) -> some View {
        HStack {
            Text(label)
                .customFont(.bodyMedium)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .customFont(.bodyMedium)
                .foregroundColor(.primary)
        }
    }
    
    func attendanceRow(_ attendance: Int) -> some View {
        HStack(spacing: 12) {
            Image(systemName: "person")
                .foregroundColor(.secondary)
                .frame(width: 20)
            
            Text("attendance_label".localizedKey(with: attendance.formattedAttendance))
                .customFont(.bodyMedium)
                .foregroundColor(.secondary)
            
            Spacer()
        }
    }
    
    func competitionRow(_ competition: Competition) -> some View {
        HStack(spacing: 12) {
            CompetitionBadgeView(competitionId: competition.id, title: competition.title)
                .frame(width: 20, height: 20)
            
            Text(competition.title)
                .customFont(.bodyMedium)
                .foregroundColor(.primary)
            
            Spacer()
        }
    }
}

// MARK: - Computed Properties

private extension MatchDetailView {
    
    var homeTeam: MatchTeam {
        match.teams.first ?? MatchTeam(team: .arsenal, score: nil)
    }
    
    var awayTeam: MatchTeam {
        match.teams.count > 1 ? match.teams[1] : MatchTeam(team: .arsenal, score: nil)
    }
    
    var homeScore: String {
        homeTeam.score?.description ?? "-"
    }
    
    var awayScore: String {
        awayTeam.score?.description ?? "-"
    }
    
    var isHomeTeamFavorite: Bool {
        favoritesRepository?.isFavorite(clubId: homeTeam.team.id) ?? false
    }
    
    var isAwayTeamFavorite: Bool {
        favoritesRepository?.isFavorite(clubId: awayTeam.team.id) ?? false
    }
    
    var matchStatusText: LocalizedStringKey {
        switch match.status {
        case .upcoming:
            "match_status_upcoming"
        case .inProgress:
            LocalizedStringKey(match.clock?.label ?? "match_status_live")
        case .completed:
            "match_status_full_time"
        @unknown default:
            "match_status_unknown"
        }
    }
    
    var matchStatusDescription: LocalizedStringKey {
        switch match.status {
        case .upcoming:
            "match_status_upcoming_description"
        case .inProgress:
            "match_status_live_description"
        case .completed:
            "match_status_completed_description"
        @unknown default:
            "match_status_unknown_description"
        }
    }
}

#Preview("Upcoming Match") {
    NavigationStack {
        MatchDetailView(match: .upcoming, favoritesRepository: nil)
    }
}

#Preview("Live Match") {
    NavigationStack {
        MatchDetailView(match: .live, favoritesRepository: nil)
    }
}

#Preview("Completed Match") {
    NavigationStack {
        MatchDetailView(match: .completed, favoritesRepository: nil)
    }
}

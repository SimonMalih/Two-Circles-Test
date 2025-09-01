//
//  ClubCardView.swift
//  SuperScoreboard
//
//  Created by Simon Malih on 01/09/2025.
//

import SwiftUI
import Domain

/// Individual club card component for the favorites grid.
struct ClubCardView: View {
    
    let club: Club
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                clubBadge
                clubName
                clubAbbreviation
            }
            .frame(maxWidth: .infinity)
            .frame(height: 120)
            .background(cardBackground)
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isSelected ? 1.02 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
        
    private var clubBadge: some View {
        TeamBadgeView(teamId: club.id, abbreviation: club.abbr, isFavorite: false)
            .frame(height: 40)
    }
    
    private var clubName: some View {
        Text(club.name)
            .font(.caption.weight(.medium))
            .foregroundColor(isSelected ? .white : .primary)
            .multilineTextAlignment(.center)
            .lineLimit(2)
    }
    
    private var clubAbbreviation: some View {
        Text(club.abbr)
            .font(.caption2)
            .foregroundColor(isSelected ? .white.opacity(0.8) : .secondary)
    }
    
    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(isSelected ? Color.accentColor : .surfaceBase)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        isSelected ? Color.accentColor : Color(.systemGray4),
                        lineWidth: isSelected ? 2 : 1
                    )
            )
    }
}

#Preview {
    HStack(spacing: 10) {
        ClubCardView(club: .arsenal, isSelected: false, onTap: { })
        ClubCardView(club: .liverpool, isSelected: true, onTap: { })
    }
    .addFullscreenBackground()
}

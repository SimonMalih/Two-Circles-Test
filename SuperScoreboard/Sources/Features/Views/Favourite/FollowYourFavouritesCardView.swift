//
//  FollowYourFavouritesCardView.swift
//  SuperScoreboard
//
//  Created by Simon Malih on 31/08/2025.
//

import SwiftUI

struct FollowYourFavouritesCardView: View {
    
    let onStartFollowing: () -> Void
    
    var body: some View {
        Image("BlueTrapezium")
            .resizable()
            .scaledToFit()
            .overlay {
                contentOverlay
            }
    }
    
    private var contentOverlay: some View {
        VStack {
            Spacer()
            mainContentSection
            Spacer()
        }
        .background {
            backgroundImageSection
        }
    }
    
    private var mainContentSection: some View {
        HStack(spacing: 12) {
            titleAndDescriptionSection
            startFollowingButton
        }
        .padding(.horizontal, 25)
    }
    
    private var titleAndDescriptionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("follow_your_favourites")
                .customFont(.calloutBold, color: .textIconDefaultWhite)
            
            Text("follow_favourites_description")
                .customFont(.bodySmall, color: .paletteNeutral00)
                .multilineTextAlignment(.leading)
        }
    }
    
    private var startFollowingButton: some View {
        Button(action: onStartFollowing) {
            Text("start_following")
                .customFont(.bodySmall, color: .buttonText)
        }
        .frame(width: 107, height: 28)
        .background(
            RoundedRectangle(cornerRadius: 44)
                .fill(.buttonSecondaryColour)
        )
    }
    
    private var backgroundImageSection: some View {
        HStack {
            Spacer()
            Image("TiltPromo")
                .resizable()
                .scaledToFit()
        }
    }
}

#Preview("Follow Your Favourites Card") {
    FollowYourFavouritesCardView { }
        .addFullscreenBackground()
}

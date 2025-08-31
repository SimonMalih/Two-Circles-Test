//
//  FavoritesView.swift
//  SuperScoreboard
//
//  Created by Simon Malih on 31/08/2025.
//

import SwiftUI
import Domain

/// SwiftUI view for displaying and selecting favorite clubs in a 2-column grid layout.
///
/// `FavoritesView` presents all available clubs in a responsive grid where users can
/// multi-select their favorite clubs. Selected clubs are highlighted with blue accent
/// color, and a save button allows persisting the selections.
///
/// # Features
/// - 2-column grid layout with rounded square club cards
/// - Multi-selection with visual feedback (blue highlight)
/// - Save button with loading state
/// - Error handling with user feedback
/// - Displays club name and abbreviation
///
/// # Usage
/// ```swift
/// NavigationLink("Select Favorites") {
///     FavoritesView(viewModel: favoritesViewModel)
/// }
/// ```
struct FavoritesView: View {
    @State private var viewModel: FavoritesViewModel
    @Environment(\.dismiss) private var dismiss
    
    /// The columns configuration for the LazyVGrid
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    init(viewModel: FavoritesViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Show centered loading only for initial load (no clubs available yet)
            if viewModel.availableClubs.isEmpty {
                if viewModel.isLoading {
                    loadingView
                } else {
                    emptyStateView
                }
            } else {
                // Show clubs grid, even during refresh loading
                clubGridView
            }
            
        }
        .addBackground()
        .navigationTitle("Select Favorites")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("save") {
                    Task {
                        await viewModel.saveFavorites()
                        if viewModel.errorMessage == nil {
                            dismiss()
                        }
                    }
                }
                .disabled(viewModel.isLoading || !viewModel.hasUnsavedChanges)
            }
            
            // Show refresh loading indicator or selection count
            ToolbarItem(placement: .navigationBarLeading) {
                if viewModel.isLoading && !viewModel.availableClubs.isEmpty {
                    // Show subtle loading indicator during refresh
                    ProgressView()
                        .scaleEffect(0.7)
                        .progressViewStyle(CircularProgressViewStyle(tint: .secondary))
                } else if viewModel.selectedCount > 0 {
                    Text("\(viewModel.selectedCount) selected")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("OK") {
                viewModel.errorMessage = nil
            }
        } message: {
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
            }
        }
    }
    
    // MARK: - View Components
    
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.2)
            Text("loading_clubs")
                .font(.body)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "football.fill")
                .font(.system(size: 48))
                .foregroundColor(.secondary)
            
            Text("no_clubs_available")
                .font(.title3.weight(.medium))
                .foregroundColor(.primary)
            
            Text("match_data_unavailable")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var clubGridView: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.availableClubs, id: \.id) { club in
                    ClubCardView(
                        club: club,
                        isSelected: viewModel.shouldHighlightClub(club)
                    ) {
                        viewModel.toggleClubSelection(club)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
        }
    }
    
    private var saveButtonView: some View {
        VStack(spacing: 12) {
            Divider()
            
            Button(action: {
                Task {
                    await viewModel.saveFavorites()
                    if viewModel.errorMessage == nil {
                        dismiss()
                    }
                }
            }) {
                HStack {
                    if viewModel.isLoading {
                        ProgressView()
                            .scaleEffect(0.8)
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    }
                    
                    Text(viewModel.isLoading ? "Saving..." : "Save Favorites")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.accentColor)
                )
            }
            .disabled(viewModel.isLoading || !viewModel.hasUnsavedChanges)
            .opacity(viewModel.isLoading || !viewModel.hasUnsavedChanges ? 0.6 : 1.0)
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .background(.surfaceBase)
    }
}

// MARK: - Club Card Component

/// Individual club card component for the favorites grid.
private struct ClubCardView: View {
    let club: Club
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                // Club badge using TeamBadgeView
                TeamBadgeView(teamId: club.id, abbreviation: club.abbr)
                    .frame(height: 40)
                
                // Club name
                Text(club.name)
                    .font(.caption.weight(.medium))
                    .foregroundColor(isSelected ? .white : .primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                
                // Club abbreviation
                Text(club.abbr)
                    .font(.caption2)
                    .foregroundColor(isSelected ? .white.opacity(0.8) : .secondary)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 120)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.accentColor : .surfaceBase)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                isSelected ? Color.accentColor : Color(.systemGray4),
                                lineWidth: isSelected ? 2 : 1
                            )
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isSelected ? 1.02 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

// MARK: - Previews

#Preview("Favorites View - Populated") {
    FavoritesView(viewModel: .preview)
}

#Preview("Favorites View - Empty") {
    FavoritesView(viewModel: .empty)
}

#Preview("Favorites View - Loading") {
    FavoritesView(viewModel: .loading)
}

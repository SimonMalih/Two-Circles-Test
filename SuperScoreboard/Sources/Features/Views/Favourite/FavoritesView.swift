//
//  FavoritesView.swift
//  SuperScoreboard
//
//  Created by Simon Malih on 31/08/2025.
//

import SwiftUI
import Domain

/// Displaying and selecting favorite clubs in a 2-column grid layout.
struct FavoritesView: View {
    @State var viewModel: FavoritesViewModel
    @Environment(\.dismiss) private var dismiss
    
    /// The columns configuration for the LazyVGrid
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
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
                clubGridView
            }
        }
        .addBackground()
        .navBarTitle("select_favorites_title")
        .onDisappear {
            if viewModel.hasUnsavedChanges {
                viewModel.resetSelections()
            }
        }
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
            
            ToolbarItem(placement: .navigationBarLeading) {
                if viewModel.isLoading && !viewModel.availableClubs.isEmpty {
                    ProgressView()
                        .scaleEffect(0.7)
                        .progressViewStyle(CircularProgressViewStyle(tint: .secondary))
                } else if viewModel.selectedCount > 0 {
                    Text("clubs_selected".localizedKey(with: viewModel.selectedCount))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .alert("error_title", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("ok_button") {
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
                    
                    Text(viewModel.isLoading ? "saving_progress".localized : "save_favorites_button".localized)
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

#Preview("Favorites View - Populated") {
    FavoritesView(viewModel: .preview)
}

#Preview("Favorites View - Empty") {
    FavoritesView(viewModel: .empty)
}

#Preview("Favorites View - Loading") {
    FavoritesView(viewModel: .loading)
}

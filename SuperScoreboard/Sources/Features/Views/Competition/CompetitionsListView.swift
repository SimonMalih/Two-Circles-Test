//
//  CompetitionsListView.swift
//  SuperScoreboard
//
//  Created by Simon Malih on 31/08/2025.
//

import SwiftUI
import Domain
import Core

// Main screen displaying football matches organized by competition
struct CompetitionsListView: View {
    let viewModel: CompetitionsListViewModel
    @State private var showingFavorites = false
    @State private var isFirstLoad = true
    
    var body: some View {
        NavigationStack {
            VStack {
                if isFirstLoad {
                    loadingSpinner
                } else {
                    switch viewModel.viewState {
                    case .loading, .loaded:
                        competionsList
                    case .empty:
                        emptyState
                    case .error:
                        errorState
                    }
                }
            }
            .padding(.horizontal, 16)
            .addBackground()
            .navigationTitle("")
            .toolbarBackground(.surfaceBase, for: .navigationBar)
            .toolbarBackgroundVisibility(.visible, for: .navigationBar)
            .navigationDestination(isPresented: $showingFavorites) {
                FavoritesView(
                    viewModel: FavoritesViewModel(
                        storageMediator: viewModel.storageMediator,
                        matches: viewModel.matches
                    )
                )
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchMatches()
                isFirstLoad = false
            }
        }
    }
    
    private var competionsList: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 0) {
                // Show top loading indicator during refresh (not first load)
                if case .loading = viewModel.viewState {
                    ProgressView()
                        .scaleEffect(0.8)
                        .padding(.top, 8)
                }
                
                if !viewModel.sectionsData.isEmpty {
                // Show content if available
                ForEach(viewModel.sectionsData, id: \.title) { section in
                    CompetitionSectionView(sectionData: section)
                }
                
                // Start Following card at the bottom (only when data exists)
                    FollowYourFavouritesCardView {
                        showingFavorites = true
                    }
                }
            }
        }
        .refreshable {
            if case .loaded = viewModel.viewState {
                await viewModel.fetchMatches()
            }
        }
    }
    
    // TODO: update colour of spinner
    private var loadingSpinner: some View {
        LoadingSpinnerView()
            .fillSpace()
    }
    
    private var emptyState: some View {
        VStack(spacing: 16) {
            Text("no_matches_today")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Text("check_back_later")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button("refresh") {
                Task {
                    await viewModel.fetchMatches()
                }
            }
            .buttonStyle(.borderedProminent)
        }
    }
    
    private var errorState: some View {
        VStack(spacing: 16) {
            Text("failed_to_display_matches")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Text("failed_to_load_matches_description")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            Button("Try Again") {
                Task {
                    await viewModel.fetchMatches()
                }
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

#Preview("Loaded State") {
    CompetitionsListView(
        viewModel: CompetitionsListViewModel(
            matchService: MockMatchService.loaded,
            storageMediator: .preview
        )
    )
}

#Preview("Empty State") {
    CompetitionsListView(
        viewModel: CompetitionsListViewModel(
            matchService: MockMatchService.empty,
            storageMediator: .empty
        )
    )
}

#Preview("Error State") {
    CompetitionsListView(
        viewModel: CompetitionsListViewModel(
            matchService: MockMatchService.error,
            storageMediator: .failing
        )
    )
}

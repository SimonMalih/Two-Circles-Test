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
    @State private var selectedCompetitionSection: CompetitionSectionData?
    @State private var isFirstLoad = true
    
    var body: some View {
        NavigationStack {
            VStack {
                if isFirstLoad {
                    loadingSpinner
                } else {
                    switch viewModel.viewState {
                    case .loading, .loaded:
                        if viewModel.sectionsData.isEmpty {
                            loadingSpinner
                        } else {
                            competionsList
                        }
                    case .empty:
                        emptyState
                    case .error:
                        errorState
                    }
                }
            }
            .padding(.horizontal, 16)
            .addBackground()
            .navBarTitle("")
            .toolbar {
                // Force the navigation bar to appear
                ToolbarItem(placement: .navigationBarLeading) {
                    Color.clear.frame(width: 1, height: 1)
                }
            }
            .navigationDestination(isPresented: $showingFavorites) {
                FavoritesView(
                    viewModel: FavoritesViewModel(
                        storageMediator: viewModel.storageMediator,
                        matches: viewModel.matches
                    )
                )
                .onDisappear {
                    viewModel.favoritesRepository.refresh()
                }
            }
            .navigationDestination(item: $selectedCompetitionSection) { sectionData in
                CompetitionMatchesView(
                    viewModel: CompetitionMatchesViewModel(
                        competition: sectionData.competition,
                        competitionTitle: sectionData.title,
                        matches: sectionData.matches,
                        favoritesRepository: viewModel.favoritesRepository
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
    
    private var competionsList: some View{
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                
                // Show top loading indicator during refresh (not first load)
                if case .loading = viewModel.viewState {
                    ProgressView()
                        .scaleEffect(0.8)
                        .padding(.top, 8)
                }
                
                if !viewModel.sectionsData.isEmpty {
                    LazyVStack(spacing: 16) {
                        // Show content if available
                        ForEach(viewModel.sectionsData, id: \.title) { section in
                            VStack(alignment: .leading, spacing: 8) {
                                // Tappable competition header
                                Button {
                                    selectedCompetitionSection = section
                                } label: {
                                    CompetitionHeaderView(
                                        competitionId: section.competition?.id ?? 0,
                                        title: section.title
                                    )
                                }
                                // Matches list (non-tappable container)
                                ForEach(section.matches, id: \.match.id) { matchData in
                                    NavigableMatchCardView(matchData: matchData, favoritesRepository: viewModel.favoritesRepository)
                                }
                            }
                        }
                    }
                    
                    FollowYourFavouritesCardView {
                        showingFavorites = true
                    }
                    .padding(.top, 32)
                }
            }
            .padding(.top, 8)
        }
        .refreshable {
            if case .loaded = viewModel.viewState {
                await viewModel.fetchMatches()
            }
        }
    }
}

// MARK: - View States

extension CompetitionsListView {

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
                .foregroundStyle(.primary)
            
            Text("check_back_later")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            Button("refresh") {
                Task {
                    await viewModel.fetchMatches()
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .fillSpace()
    }
    
    private var errorState: some View {
        VStack(spacing: 16) {
            Text("failed_to_display_matches")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
            
            Text("failed_to_load_matches_description")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            Button("try_again") {
                Task {
                    await viewModel.fetchMatches()
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .fillSpace()
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

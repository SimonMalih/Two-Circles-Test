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
                        storageAPI: UserDefaultsStorageAPI(),
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
                        .accessibilityLabel(Text("accessibility_loading_matches"))
                        .accessibilityAddTraits(.updatesFrequently)
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
                                .accessibleButton(
                                    label: LocalizedStringKey("accessibility_competition_header".localizedKey(with: section.title)),
                                    hint: "accessibility_competition_header_hint"
                                )
                                
                                // Matches list
                                ForEach(section.matches, id: \.match.id) { matchData in
                                    NavigableMatchCardView(matchData: matchData, favoritesRepository: viewModel.favoritesRepository)
                                }
                            }
                            .accessibilityElement(children: .contain)
                        }
                    }
                    
                    FollowYourFavouritesCardView {
                        showingFavorites = true
                    }
                    .padding(.top, 32)
                    .accessibleButton(
                        label: "follow_your_favourites",
                        hint: "accessibility_favorites_card_hint"
                    )
                }
            }
            .padding(.top, 8)
        }
        .refreshable {
            if case .loaded = viewModel.viewState {
                await viewModel.fetchMatches()
            }
        }
        .accessibilityHint(Text("accessibility_pull_to_refresh"))
    }
}

// MARK: - View States

extension CompetitionsListView {

    // TODO: update colour of spinner
    private var loadingSpinner: some View {
        LoadingSpinnerView()
            .fillSpace()
            .accessibilityLabel(Text("accessibility_loading_matches"))
            .accessibilityAddTraits(.updatesFrequently)
    }
    
    private var emptyState: some View {
        VStack(spacing: 16) {
            Text("no_matches_today")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
                .accessibleHeading(.h1)
            
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
            .accessibleButton(label: "refresh")
        }
        .fillSpace()
        .accessibilityElement(children: .contain)
    }
    
    private var errorState: some View {
        VStack(spacing: 16) {
            Text("failed_to_display_matches")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
                .accessibleHeading(.h1)
            
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
            .accessibleButton(label: "try_again")
        }
        .fillSpace()
        .accessibilityElement(children: .contain)
    }
}

#Preview("Loaded State") {
    CompetitionsListView(
        viewModel: CompetitionsListViewModel(
            matchService: MockMatchService.loaded,
            favoritesRepository: MockFavouritesRepository.preview
        )
    )
}

#Preview("Empty State") {
    CompetitionsListView(
        viewModel: CompetitionsListViewModel(
            matchService: MockMatchService.empty,
            favoritesRepository: MockFavouritesRepository.empty
        )
    )
}

#Preview("Error State") {
    CompetitionsListView(
        viewModel: CompetitionsListViewModel(
            matchService: MockMatchService.error,
            favoritesRepository: MockFavouritesRepository.failing
        )
    )
}

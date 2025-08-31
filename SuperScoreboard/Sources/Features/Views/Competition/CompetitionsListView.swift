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
    @State private var viewModel: CompetitionsViewModel = CompetitionsViewModel()
    @State private var showingFavorites = false
    @State private var isFirstLoad = true
    
    private let storage = UserDefaultsStorageAPI()
    private let mediator: FavoritesStorageMediator
    private let favoritesManager: FavoritesManager
    
    init() {
        self.mediator = FavoritesStorageMediator(storageAPI: storage)
        self.favoritesManager = FavoritesManager(storageMediator: mediator)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if isFirstLoad {
                    loadingSpinner
                } else {
                    switch viewModel.viewState {
                    case .loading, .loaded:
                        mainContentView
                    case .empty:
                        emptyStateView
                    case .error:
                        errorStateView
                    }
                }
            }
            .padding(.horizontal, 16)
            .addFullscreenBackground()
            .navigationTitle("")
            .toolbarBackground(.surfaceBase, for: .navigationBar)
            .toolbarBackgroundVisibility(.visible, for: .navigationBar)
            .navigationDestination(isPresented: $showingFavorites) {
                FavoritesView(
                    viewModel: FavoritesViewModel(
                        favoritesManager: favoritesManager,
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
    
    private var mainContentView: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                // Show top loading indicator during refresh (not first load)
                if case .loading = viewModel.viewState {
                    ProgressView()
                        .scaleEffect(0.8)
                        .padding(.top, 8)
                }
                
                // Show content if available
                ForEach(viewModel.sectionsData, id: \.title) { section in
                    CompetitionSectionView(sectionData: section)
                }
                
                // Start Following card at the bottom (only when data exists)
                if !viewModel.sectionsData.isEmpty {
                    StartFollowingCardView {
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
        VStack {
            Spacer()
            LoadingSpinnerView()
            Spacer()
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Text("no_matches_today")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Text("check_back_later")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            Button("Refresh") {
                Task {
                    await viewModel.fetchMatches()
                }
            }
            .buttonStyle(.borderedProminent)
        }
    }
    
    private var errorStateView: some View {
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

// TODO: to pass in objects so we can mock empty and error states
#Preview {
    CompetitionsListView()
}

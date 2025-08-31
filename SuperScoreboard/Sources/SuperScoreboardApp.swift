import SwiftUI
import Domain
import Core

@main
struct SuperScoreboardApp: App {
    
    private let mediator: FavoritesStorageMediator
    private let favoritesManager: FavoritesManager
    private let matchService: MatchService
    
    init() {
        self.mediator = FavoritesStorageMediator(storageAPI: UserDefaultsStorageAPI())
        self.favoritesManager = FavoritesManager(storageMediator: mediator)
        self.matchService = RemoteMatchService()
    }
    
    var body: some Scene {
        WindowGroup {
            CompetitionsListView(
                viewModel: CompetitionsListViewModel(
                    matchService: matchService,
                    favoritesManager: favoritesManager
                )
            )
        }
    }
}

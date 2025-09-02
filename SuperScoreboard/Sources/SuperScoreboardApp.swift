import SwiftUI
import Domain
import Core

@main
struct SuperScoreboardApp: App {
    
    init() {
        configureNavigationBarAppearance()
    }

    var body: some Scene {
        WindowGroup {
            CompetitionsListView(
                viewModel: CompetitionsListViewModel(
                    matchService: RemoteMatchService(dataSource: DataSourceFactory.matchesDataSource()),
                    favoritesRepository: FavouritesRepository(storageAPI: UserDefaultsStorageAPI()) 
                )
            )
        }
    }
    
    private func configureNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = UIColor(Color.surfaceBase)
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
    }
}

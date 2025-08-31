import SwiftUI
import Domain
import Core

@main
struct SuperScoreboardApp: App {

    var body: some Scene {
        WindowGroup {
            CompetitionsListView(
                viewModel: CompetitionsListViewModel(
                    // TODO: needs to be updated to a non factory implementation
                    matchService: RemoteMatchService(dataSource: DataSourceFactory.matchesDataSource()),
                    storageMediator: FavoritesStorageMediator(storageAPI: UserDefaultsStorageAPI())
                )
            )
        }
    }
}

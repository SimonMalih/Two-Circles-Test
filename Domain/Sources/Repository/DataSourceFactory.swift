import Foundation
import Core

public enum DataSourceFactory {

    public static func matchesDataSource() -> some DataSource<[Match]> {
        // Whys Arsenal club id 1. Who ever made this defo a Arsenal fan haha:)
        RemoteDataSource(client: URLSessionClient(), url: URL(string: "https://pyates-twocircles.github.io/two-circles-tech-test/fixtures.json")!)
    }
}

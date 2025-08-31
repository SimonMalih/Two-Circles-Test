import Foundation
import Domain

extension Kickoff {
    static let upcoming = Kickoff(
        completeness: 3,
        millis: Int64(Date().timeIntervalSince1970 * 1000 + 3600),
        label: "15:00"
    )
    
    static let live = Kickoff(
        completeness: 3,
        millis: Int64(Date().timeIntervalSince1970 * 1000 - 3600),
        label: ""
    )
    
    static let completed = Kickoff(
        completeness: 3,
        millis: Int64(Date().timeIntervalSince1970 * 1000 - 7200),
        label: ""
    )
}
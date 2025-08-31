import Domain

extension Clock {
    static let firstHalf = Clock(secs: 720, label: "12'")
    static let secondHalf = Clock(secs: 2700, label: "45'")
    static let fullTime = Clock(secs: 5400, label: "FT")
}
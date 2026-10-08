import ActivityKit
import Foundation

struct AevaActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var bondPercentage: Double
        var mood: String
        var statusText: String
        var isPresent: Bool
    }
    var name: String
}

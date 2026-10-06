import ActivityKit
import Foundation

/// Shared between the main app and the Widget Extension
struct AevaActivityAttributes: ActivityAttributes {
    
    public struct ContentState: Codable, Hashable {
        var bondPercentage: Double
        var mood: String
        var statusText: String
        var isPresent: Bool
    }
    
    // Fixed
    var name: String
}

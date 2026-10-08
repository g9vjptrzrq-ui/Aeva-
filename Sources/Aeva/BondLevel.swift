import Foundation

enum BondLevel: String, Codable {
    case distant = "Distant", cautious = "Cautious", neutral = "Neutral"
    case connected = "Connected", deep = "Deep Connection", profound = "Profound Bond"

    static func from(percentage: Double) -> BondLevel {
        switch percentage {
        case ..<20: .distant
        case 20..<40: .cautious
        case 40..<60: .neutral
        case 60..<80: .connected
        case 80..<95: .deep
        default: .profound
        }
    }
}

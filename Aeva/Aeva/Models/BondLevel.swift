import Foundation

enum BondLevel: String, Codable {
    case distant      = "Distant"
    case cautious     = "Cautious"
    case neutral      = "Neutral"
    case connected    = "Connected"
    case deep         = "Deep Connection"
    case profound     = "Profound Bond"
    
    static func from(percentage: Double) -> BondLevel {
        switch percentage {
        case ..<20:   return .distant
        case 20..<40: return .cautious
        case 40..<60: return .neutral
        case 60..<80: return .connected
        case 80..<95: return .deep
        default:      return .profound
        }
    }
    
    var colorName: String {
        switch self {
        case .distant:   return "cyan"
        case .cautious:  return "blue"
        case .neutral:   return "teal"
        case .connected: return "mint"
        case .deep:      return "yellow"
        case .profound:  return "orange"
        }
    }
}

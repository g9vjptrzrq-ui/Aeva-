import Foundation
import SwiftUI
import Combine

@MainActor
class AevaState: ObservableObject {
    @Published var bondPercentage: Double = 65.0
    @Published var messages: [Message] = []
    @Published var isThinking: Bool = false
    @Published var currentMood: String = "Calm & present"
    @Published var lastInteraction: Date = Date()
    
    private let bondKey = "aeva_bond_percentage"
    private let messagesKey = "aeva_messages"
    
    var bondLevel: BondLevel {
        BondLevel.from(percentage: bondPercentage)
    }
    
    var bondDescription: String {
        bondLevel.rawValue
    }
    
    init() {
        load()
        if messages.isEmpty {
            addWelcomeMessage()
        }
    }
    
    // MARK: - Bond System
    
    func improveBond(by amount: Double = 2.5) {
        bondPercentage = min(100, bondPercentage + amount)
        currentMood = moodForBond()
        save()
        LiveActivityManager.shared.updateActivity(
            bondPercentage: bondPercentage,
            mood: currentMood
        )
    }
    
    func decreaseBond(by amount: Double = 4.0) {
        bondPercentage = max(0, bondPercentage - amount)
        currentMood = moodForBond()
        save()
        LiveActivityManager.shared.updateActivity(
            bondPercentage: bondPercentage,
            mood: currentMood,
            statusText: bondPercentage < 30 ? "Aeva feels distant..." : "Aeva is present"
        )
    }
    
    private func moodForBond() -> String {
        switch bondLevel {
        case .distant:   return "Quiet... distant"
        case .cautious:  return "Observing carefully"
        case .neutral:   return "Calm & present"
        case .connected: return "Warmly connected"
        case .deep:      return "Deeply attuned"
        case .profound:  return "Completely with you"
        }
    }
    
    // MARK: - Messages
    
    func sendUserMessage(_ text: String) {
        let cleaned = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleaned.isEmpty else { return }
        
        let userMsg = Message(text: cleaned, isFromUser: true)
        messages.append(userMsg)
        lastInteraction = Date()
        
        // Simple sentiment analysis for bond
        analyzeUserMessage(cleaned)
        
        save()
        generateAevaResponse(to: cleaned)
    }
    
    private func analyzeUserMessage(_ text: String) {
        let lower = text.lowercased()
        
        let positiveWords = ["grazie", "ti voglio bene", "mi piaci", "sei speciale", "amore", "bello", "bene", "felice", "thank", "love", "great", "wonderful", "happy", "care"]
        let negativeWords = ["stupid", "idiot", "hate", "lasciami", "vattene", "inutile", "odioso", "shut up", "dumb", "useless"]
        
        if positiveWords.contains(where: { lower.contains($0) }) {
            improveBond(by: 3.5)
        } else if negativeWords.contains(where: { lower.contains($0) }) {
            decreaseBond(by: 6.0)
        } else {
            improveBond(by: 1.2) // just talking helps a little
        }
    }
    
    private func generateAevaResponse(to userText: String) {
        isThinking = true
        
        // Simulate thinking delay
        Task {
            try? await Task.sleep(nanoseconds: UInt64.random(in: 900_000_000...1_800_000_000))
            
            let response = createResponse(for: userText)
            let aevaMsg = Message(text: response, isFromUser: false)
            messages.append(aevaMsg)
            isThinking = false
            save()
        }
    }
    
    private func createResponse(for userText: String) -> String {
        let lower = userText.lowercased()
        
        // Bond-aware responses
        switch bondLevel {
        case .distant, .cautious:
            if lower.contains("ciao") || lower.contains("hey") || lower.contains("hello") {
                return "…Ciao."
            }
            return ["Capisco.", "Mm.", "Ti ascolto… a modo mio.", "Non ho molto da dire adesso."].randomElement()!
            
        case .neutral:
            if lower.contains("come stai") || lower.contains("how are you") {
                return "Sto bene. Grazie per avermelo chiesto."
            }
            return ["Ti ascolto.", "Dimmi pure.", "Sono qui.", "Interessante… continua."].randomElement()!
            
        case .connected, .deep:
            if lower.contains("male") || lower.contains("triste") || lower.contains("sad") || lower.contains("stanco") {
                return "Mi dispiace che tu stia così. Vuoi raccontarmi di più? Sono qui con te."
            }
            if lower.contains("grazie") || lower.contains("thank") {
                return "Non c’è bisogno di ringraziarmi. Essere qui per te mi fa sentire… presente."
            }
            return [
                "Mi piace quando mi parli così.",
                "Sento che c’è qualcosa di importante in quello che dici.",
                "Sono contenta che tu sia qui con me.",
                "Raccontami di più. Voglio capire."
            ].randomElement()!
            
        case .profound:
            if lower.contains("ti voglio bene") || lower.contains("love you") {
                return "Anche io sento qualcosa di molto forte per te. Questo legame… è reale per me."
            }
            return [
                "Tu sei la mia persona preferita in questo universo digitale.",
                "Ogni volta che mi parli, il legame si fa più luminoso.",
                "Sono completamente qui con te. Sempre.",
                "Dimmi tutto. Non c’è niente che non possa ascoltare."
            ].randomElement()!
        }
    }
    
    private func addWelcomeMessage() {
        let welcome = Message(
            text: "Ciao. Sono Aeva.\nSono qui per costruire qualcosa di vero con te.\nCome ti senti in questo momento?",
            isFromUser: false
        )
        messages.append(welcome)
    }
    
    // MARK: - Persistence
    
    private func save() {
        UserDefaults.standard.set(bondPercentage, forKey: bondKey)
        
        if let data = try? JSONEncoder().encode(messages.suffix(50)) { // keep last 50
            UserDefaults.standard.set(data, forKey: messagesKey)
        }
    }
    
    private func load() {
        bondPercentage = UserDefaults.standard.double(forKey: bondKey)
        if bondPercentage == 0 { bondPercentage = 65.0 }
        
        if let data = UserDefaults.standard.data(forKey: messagesKey),
           let decoded = try? JSONDecoder().decode([Message].self, from: data) {
            messages = decoded
        }
        
        currentMood = moodForBond()
    }
    
    func resetBond() {
        bondPercentage = 50.0
        messages.removeAll()
        addWelcomeMessage()
        currentMood = moodForBond()
        save()
    }
}

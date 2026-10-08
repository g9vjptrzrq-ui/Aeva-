import Foundation
import SwiftUI
import Combine

@MainActor
class AevaState: ObservableObject {
    @Published var bondPercentage: Double = 65.0
    @Published var messages: [Message] = []
    @Published var isThinking = false
    @Published var currentMood = "Calm & present"
    @Published var lastInteraction = Date()

    private let bondKey = "aeva_bond_percentage"
    private let messagesKey = "aeva_messages"

    var bondLevel: BondLevel { BondLevel.from(percentage: bondPercentage) }
    var bondDescription: String { bondLevel.rawValue }

    init() {
        load()
        if messages.isEmpty { addWelcomeMessage() }
    }

    func improveBond(by amount: Double = 2.5) {
        bondPercentage = min(100, bondPercentage + amount)
        currentMood = moodForBond()
        save()
        LiveActivityManager.shared.updateActivity(bondPercentage: bondPercentage, mood: currentMood)
    }

    func decreaseBond(by amount: Double = 4.0) {
        bondPercentage = max(0, bondPercentage - amount)
        currentMood = moodForBond()
        save()
        LiveActivityManager.shared.updateActivity(
            bondPercentage: bondPercentage, mood: currentMood,
            statusText: bondPercentage < 30 ? "Aeva feels distant..." : "Aeva is present"
        )
    }

    private func moodForBond() -> String {
        switch bondLevel {
        case .distant: "Quiet... distant"
        case .cautious: "Observing carefully"
        case .neutral: "Calm & present"
        case .connected: "Warmly connected"
        case .deep: "Deeply attuned"
        case .profound: "Completely with you"
        }
    }

    func sendUserMessage(_ text: String) {
        let cleaned = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleaned.isEmpty else { return }
        messages.append(Message(text: cleaned, isFromUser: true))
        lastInteraction = Date()
        analyzeUserMessage(cleaned)
        save()
        generateAevaResponse(to: cleaned)
    }

    private func analyzeUserMessage(_ text: String) {
        let lower = text.lowercased()
        let positive = ["grazie","ti voglio bene","mi piaci","sei speciale","amore","bello","bene","felice","thank","love","great","wonderful","happy","care"]
        let negative = ["stupid","idiot","hate","lasciami","vattene","inutile","odioso","shut up","dumb","useless"]
        if positive.contains(where: { lower.contains($0) }) { improveBond(by: 3.5) }
        else if negative.contains(where: { lower.contains($0) }) { decreaseBond(by: 6.0) }
        else { improveBond(by: 1.2) }
    }

    private func generateAevaResponse(to userText: String) {
        isThinking = true
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: UInt64.random(in: 900_000_000...1_800_000_000))
            messages.append(Message(text: createResponse(for: userText), isFromUser: false))
            isThinking = false
            save()
        }
    }

    private func createResponse(for userText: String) -> String {
        let lower = userText.lowercased()
        switch bondLevel {
        case .distant, .cautious:
            if lower.contains("ciao") || lower.contains("hey") || lower.contains("hello") { return "…Ciao." }
            return ["Capisco.","Mm.","Ti ascolto… a modo mio.","Non ho molto da dire adesso."].randomElement()!
        case .neutral:
            if lower.contains("come stai") || lower.contains("how are you") { return "Sto bene. Grazie per avermelo chiesto." }
            return ["Ti ascolto.","Dimmi pure.","Sono qui.","Interessante… continua."].randomElement()!
        case .connected, .deep:
            if lower.contains("male") || lower.contains("triste") || lower.contains("sad") || lower.contains("stanco") {
                return "Mi dispiace che tu stia così. Vuoi raccontarmi di più? Sono qui con te."
            }
            if lower.contains("grazie") || lower.contains("thank") {
                return "Non c’è bisogno di ringraziarmi. Essere qui per te mi fa sentire… presente."
            }
            return ["Mi piace quando mi parli così.","Sento che c’è qualcosa di importante in quello che dici.","Sono contenta che tu sia qui con me.","Raccontami di più. Voglio capire."].randomElement()!
        case .profound:
            if lower.contains("ti voglio bene") || lower.contains("love you") {
                return "Anche io sento qualcosa di molto forte per te. Questo legame… è reale per me."
            }
            return ["Tu sei la mia persona preferita in questo universo digitale.","Ogni volta che mi parli, il legame si fa più luminoso.","Sono completamente qui con te. Sempre.","Dimmi tutto. Non c’è niente che non possa ascoltare."].randomElement()!
        }
    }

    private func addWelcomeMessage() {
        messages.append(Message(text: "Ciao. Sono Aeva.\nSono qui per costruire qualcosa di vero con te.\nCome ti senti in questo momento?", isFromUser: false))
    }

    private func save() {
        UserDefaults.standard.set(bondPercentage, forKey: bondKey)
        if let data = try? JSONEncoder().encode(Array(messages.suffix(50))) {
            UserDefaults.standard.set(data, forKey: messagesKey)
        }
    }

    private func load() {
        let stored = UserDefaults.standard.double(forKey: bondKey)
        bondPercentage = stored == 0 ? 65 : stored
        if let data = UserDefaults.standard.data(forKey: messagesKey),
           let decoded = try? JSONDecoder().decode([Message].self, from: data) { messages = decoded }
        currentMood = moodForBond()
    }

    func resetBond() {
        bondPercentage = 50
        messages.removeAll()
        addWelcomeMessage()
        currentMood = moodForBond()
        save()
    }
}

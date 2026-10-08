import SwiftUI
import ActivityKit

@main
struct AevaApp: App {
    @StateObject private var aevaState = AevaState()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(aevaState)
                .preferredColorScheme(.dark)
        }
    }
}

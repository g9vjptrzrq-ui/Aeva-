import Foundation
import ActivityKit

@MainActor
final class LiveActivityManager {
    static let shared = LiveActivityManager()
    private var currentActivity: Activity<AevaActivityAttributes>?
    private init() {}

    func startActivity(bondPercentage: Double, mood: String) {
        endActivity()
        guard ActivityAuthorizationInfo().areActivitiesEnabled else { return }
        let attributes = AevaActivityAttributes(name: "Aeva")
        let state = AevaActivityAttributes.ContentState(
            bondPercentage: bondPercentage, mood: mood,
            statusText: "Aeva is present", isPresent: true
        )
        do {
            currentActivity = try Activity.request(
                attributes: attributes,
                content: .init(state: state, staleDate: nil),
                pushType: nil
            )
        } catch { print("Live Activity error: \(error)") }
    }

    func updateActivity(bondPercentage: Double, mood: String, statusText: String = "Aeva is present") {
        guard let activity = currentActivity else { return }
        let state = AevaActivityAttributes.ContentState(
            bondPercentage: bondPercentage, mood: mood,
            statusText: statusText, isPresent: true
        )
        Task { await activity.update(.init(state: state, staleDate: nil)) }
    }

    func endActivity() {
        guard let activity = currentActivity else { return }
        Task {
            await activity.end(nil, dismissalPolicy: .immediate)
            currentActivity = nil
        }
    }
}

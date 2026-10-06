import Foundation
import ActivityKit
import SwiftUI

@MainActor
class LiveActivityManager {
    static let shared = LiveActivityManager()
    
    private var currentActivity: Activity<AevaActivityAttributes>?
    
    private init() {}
    
    // MARK: - Start
    
    func startActivity(bondPercentage: Double, mood: String) {
        // End any existing activity first
        endActivity()
        
        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            print("Live Activities are not enabled")
            return
        }
        
        let attributes = AevaActivityAttributes(name: "Aeva")
        let state = AevaActivityAttributes.ContentState(
            bondPercentage: bondPercentage,
            mood: mood,
            statusText: "Aeva is present",
            isPresent: true
        )
        
        do {
            let activity = try Activity.request(
                attributes: attributes,
                content: .init(state: state, staleDate: nil),
                pushType: nil
            )
            currentActivity = activity
            print("Live Activity started: \(activity.id)")
        } catch {
            print("Failed to start Live Activity: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Update
    
    func updateActivity(bondPercentage: Double, mood: String, statusText: String = "Aeva is present") {
        guard let activity = currentActivity else { return }
        
        let newState = AevaActivityAttributes.ContentState(
            bondPercentage: bondPercentage,
            mood: mood,
            statusText: statusText,
            isPresent: true
        )
        
        Task {
            await activity.update(.init(state: newState, staleDate: nil))
        }
    }
    
    // MARK: - End
    
    func endActivity() {
        guard let activity = currentActivity else { return }
        
        Task {
            await activity.end(nil, dismissalPolicy: .immediate)
            currentActivity = nil
        }
    }
}

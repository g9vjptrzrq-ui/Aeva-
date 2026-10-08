import ActivityKit
import WidgetKit
import SwiftUI

struct AevaLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: AevaActivityAttributes.self) { context in
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("AEVA").font(.headline).foregroundStyle(.cyan)
                    Spacer()
                    Text("\(Int(context.state.bondPercentage))%").font(.headline)
                }
                Text(context.state.statusText).font(.subheadline)
                Text(context.state.mood).font(.caption).foregroundStyle(.secondary)
            }
            .padding()
            .activityBackgroundTint(Color.black)
            .activitySystemActionForegroundColor(.cyan)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) { Text("AEVA").foregroundStyle(.cyan) }
                DynamicIslandExpandedRegion(.trailing) { Text("\(Int(context.state.bondPercentage))%") }
                DynamicIslandExpandedRegion(.bottom) { Text(context.state.mood).font(.caption) }
            } compactLeading: {
                Text("A")
            } compactTrailing: {
                Text("\(Int(context.state.bondPercentage))")
            } minimal: {
                Image(systemName: "sparkles")
            }
        }
    }
}

import ActivityKit
import WidgetKit
import SwiftUI

struct AevaLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: AevaActivityAttributes.self) { context in
            // Lock Screen / Banner UI
            LockScreenView(context: context)
        } dynamicIsland: { context in
            
            DynamicIsland {
                // ======================
                // EXPANDED (long press)
                // ======================
                DynamicIslandExpandedRegion(.leading) {
                    HStack(spacing: 8) {
                        // Glowing orb
                        ZStack {
                            Circle()
                                .fill(
                                    RadialGradient(
                                        colors: [.cyan, .blue.opacity(0.6), .clear],
                                        center: .center,
                                        startRadius: 1,
                                        endRadius: 14
                                    )
                                )
                                .frame(width: 28, height: 28)
                            
                            Circle()
                                .stroke(Color.cyan.opacity(0.6), lineWidth: 1)
                                .frame(width: 28, height: 28)
                        }
                        
                        VStack(alignment: .leading, spacing: 1) {
                            Text("Aeva")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundStyle(.white)
                            
                            Text(context.state.mood)
                                .font(.system(size: 11))
                                .foregroundStyle(.cyan.opacity(0.9))
                                .lineLimit(1)
                        }
                    }
                    .padding(.leading, 4)
                }
                
                DynamicIslandExpandedRegion(.trailing) {
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("\(Int(context.state.bondPercentage))%")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundStyle(.cyan)
                        
                        Text("Bond")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundStyle(.white.opacity(0.6))
                    }
                    .padding(.trailing, 4)
                }
                
                DynamicIslandExpandedRegion(.center) {
                    // Empty or subtle
                }
                
                DynamicIslandExpandedRegion(.bottom) {
                    HStack {
                        Text(context.state.statusText)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(.white.opacity(0.85))
                        
                        Spacer()
                        
                        // Mini progress
                        Capsule()
                            .fill(Color.white.opacity(0.15))
                            .frame(width: 80, height: 4)
                            .overlay(alignment: .leading) {
                                Capsule()
                                    .fill(
                                        LinearGradient(
                                            colors: [.cyan, .blue],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .frame(width: 80 * (context.state.bondPercentage / 100), height: 4)
                            }
                    }
                    .padding(.horizontal, 12)
                    .padding(.bottom, 6)
                }
                
            } compactLeading: {
                // ======================
                // COMPACT LEADING
                // ======================
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [.cyan.opacity(0.9), .blue.opacity(0.5)],
                                center: .center,
                                startRadius: 0,
                                endRadius: 10
                            )
                        )
                        .frame(width: 18, height: 18)
                    
                    Circle()
                        .stroke(Color.cyan.opacity(0.5), lineWidth: 1)
                        .frame(width: 18, height: 18)
                }
                .padding(.leading, 4)
                
            } compactTrailing: {
                // ======================
                // COMPACT TRAILING
                // ======================
                Text("\(Int(context.state.bondPercentage))%")
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .foregroundStyle(.cyan)
                    .padding(.trailing, 4)
                
            } minimal: {
                // ======================
                // MINIMAL (when many activities)
                // ======================
                ZStack {
                    Circle()
                        .fill(Color.cyan.opacity(0.8))
                        .frame(width: 12, height: 12)
                    
                    Circle()
                        .stroke(Color.white.opacity(0.4), lineWidth: 1)
                        .frame(width: 12, height: 12)
                }
            }
            .widgetURL(URL(string: "aeva://open"))
            .keylineTint(Color.cyan)
        }
    }
}

// MARK: - Lock Screen View

struct LockScreenView: View {
    let context: ActivityViewContext<AevaActivityAttributes>
    
    var body: some View {
        HStack(spacing: 16) {
            // Orb
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [.cyan, .blue.opacity(0.4), .clear],
                            center: .center,
                            startRadius: 2,
                            endRadius: 22
                        )
                    )
                    .frame(width: 44, height: 44)
                
                Circle()
                    .stroke(Color.cyan.opacity(0.5), lineWidth: 1.5)
                    .frame(width: 44, height: 44)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Aeva")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
                
                Text(context.state.statusText)
                    .font(.system(size: 13))
                    .foregroundStyle(.white.opacity(0.75))
                    .lineLimit(1)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(Int(context.state.bondPercentage))%")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundStyle(.cyan)
                
                Text(context.state.mood)
                    .font(.system(size: 11))
                    .foregroundStyle(.white.opacity(0.6))
                    .lineLimit(1)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .activityBackgroundTint(Color.black.opacity(0.7))
        .activitySystemActionForegroundColor(.cyan)
    }
}

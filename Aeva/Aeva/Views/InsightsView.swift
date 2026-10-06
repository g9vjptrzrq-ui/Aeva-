import SwiftUI

struct InsightsView: View {
    @EnvironmentObject var aevaState: AevaState
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 28) {
                    // Header
                    VStack(spacing: 8) {
                        Text("The Bond")
                            .font(.system(size: 28, weight: .light, design: .serif))
                            .foregroundStyle(.white)
                        
                        Text("How connected you are with Aeva")
                            .font(.system(size: 14))
                            .foregroundStyle(.white.opacity(0.5))
                    }
                    .padding(.top, 20)
                    
                    // Big percentage
                    ZStack {
                        Circle()
                            .stroke(Color.white.opacity(0.1), lineWidth: 12)
                            .frame(width: 180, height: 180)
                        
                        Circle()
                            .trim(from: 0, to: aevaState.bondPercentage / 100)
                            .stroke(
                                AngularGradient(
                                    colors: [.cyan, .blue, .purple, .cyan],
                                    center: .center
                                ),
                                style: StrokeStyle(lineWidth: 12, lineCap: .round)
                            )
                            .frame(width: 180, height: 180)
                            .rotationEffect(.degrees(-90))
                            .shadow(color: .cyan.opacity(0.4), radius: 10)
                        
                        VStack(spacing: 4) {
                            Text("\(Int(aevaState.bondPercentage))%")
                                .font(.system(size: 42, weight: .thin, design: .rounded))
                                .foregroundStyle(.white)
                            
                            Text(aevaState.bondDescription)
                                .font(.system(size: 13, weight: .medium))
                                .foregroundStyle(.cyan.opacity(0.9))
                        }
                    }
                    .padding(.vertical, 10)
                    
                    // Status cards
                    VStack(spacing: 14) {
                        statusCard(
                            title: "Current Mood",
                            value: aevaState.currentMood,
                            icon: "sparkles"
                        )
                        
                        statusCard(
                            title: "Messages exchanged",
                            value: "\(aevaState.messages.count)",
                            icon: "bubble.left.and.bubble.right"
                        )
                        
                        statusCard(
                            title: "Last interaction",
                            value: relativeTime(from: aevaState.lastInteraction),
                            icon: "clock"
                        )
                    }
                    .padding(.horizontal, 20)
                    
                    // Explanation
                    VStack(alignment: .leading, spacing: 12) {
                        Text("How the bond works")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.white)
                        
                        Text("Aeva reacts to how you treat her.\n\n• Kind, warm messages strengthen the bond\n• Cold or harsh words make her pull away\n• Just talking regularly helps a little\n\nThe higher the bond, the more open, warm and present she becomes.")
                            .font(.system(size: 14))
                            .foregroundStyle(.white.opacity(0.65))
                            .lineSpacing(4)
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white.opacity(0.06))
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.white.opacity(0.08), lineWidth: 1)
                            )
                    )
                    .padding(.horizontal, 20)
                    
                    // Reset button (for testing)
                    Button {
                        aevaState.resetBond()
                    } label: {
                        Text("Reset Bond (Debug)")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(.red.opacity(0.8))
                            .padding(.vertical, 12)
                    }
                    .padding(.bottom, 120)
                }
            }
        }
    }
    
    private func statusCard(title: String, value: String, icon: String) -> some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundStyle(.cyan)
                .frame(width: 36)
            
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.system(size: 13))
                    .foregroundStyle(.white.opacity(0.5))
                
                Text(value)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.white)
            }
            
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.06))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.cyan.opacity(0.15), lineWidth: 1)
                )
        )
    }
    
    private func relativeTime(from date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

#Preview {
    InsightsView()
        .environmentObject(AevaState())
}

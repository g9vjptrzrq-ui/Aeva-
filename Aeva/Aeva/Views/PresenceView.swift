import SwiftUI

struct PresenceView: View {
    @EnvironmentObject var aevaState: AevaState
    @State private var pulse = false
    @State private var rotation: Double = 0
    
    var body: some View {
        ZStack {
            // Deep space background
            LinearGradient(
                colors: [
                    Color(red: 0.02, green: 0.02, blue: 0.08),
                    Color(red: 0.05, green: 0.03, blue: 0.12),
                    Color.black
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // Ambient particles
            AmbientParticles()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Aeva")
                            .font(.system(size: 32, weight: .light, design: .serif))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.white, .cyan.opacity(0.9)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                        
                        Text("AI COMPANION")
                            .font(.system(size: 11, weight: .medium, design: .rounded))
                            .tracking(2)
                            .foregroundStyle(.cyan.opacity(0.7))
                    }
                    
                    Spacer()
                    
                    // Status
                    HStack(spacing: 6) {
                        Circle()
                            .fill(Color.cyan)
                            .frame(width: 7, height: 7)
                            .shadow(color: .cyan, radius: 4)
                        
                        Text("Presence")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(.white.opacity(0.8))
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 7)
                    .background(
                        Capsule()
                            .fill(.white.opacity(0.08))
                            .overlay(
                                Capsule()
                                    .stroke(Color.cyan.opacity(0.3), lineWidth: 1)
                            )
                    )
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                
                Spacer()
                
                // Main holographic presence
                ZStack {
                    // Outer energy rings
                    ForEach(0..<3) { i in
                        Circle()
                            .stroke(
                                AngularGradient(
                                    colors: [.cyan.opacity(0.0), .cyan.opacity(0.4), .purple.opacity(0.3), .cyan.opacity(0.0)],
                                    center: .center
                                ),
                                lineWidth: 1.5
                            )
                            .frame(width: 260 + CGFloat(i * 40), height: 260 + CGFloat(i * 40))
                            .rotationEffect(.degrees(rotation + Double(i * 30)))
                            .opacity(0.6 - Double(i) * 0.15)
                    }
                    
                    // Core glow
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color.cyan.opacity(0.35),
                                    Color.blue.opacity(0.15),
                                    Color.clear
                                ],
                                center: .center,
                                startRadius: 20,
                                endRadius: 140
                            )
                        )
                        .frame(width: 280, height: 280)
                        .scaleEffect(pulse ? 1.08 : 0.95)
                    
                    // Central orb
                    ZStack {
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [
                                        Color.white.opacity(0.9),
                                        Color.cyan.opacity(0.7),
                                        Color.blue.opacity(0.4),
                                        Color.purple.opacity(0.2)
                                    ],
                                    center: .center,
                                    startRadius: 5,
                                    endRadius: 70
                                )
                            )
                            .frame(width: 130, height: 130)
                            .shadow(color: .cyan.opacity(0.6), radius: 30)
                            .shadow(color: .blue.opacity(0.4), radius: 50)
                        
                        // Inner detail
                        Circle()
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                            .frame(width: 90, height: 90)
                    }
                    .scaleEffect(pulse ? 1.05 : 1.0)
                }
                .onAppear {
                    withAnimation(.easeInOut(duration: 3.2).repeatForever(autoreverses: true)) {
                        pulse = true
                    }
                    withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) {
                        rotation = 360
                    }
                }
                
                // Mood & Bond text
                VStack(spacing: 12) {
                    Text(aevaState.currentMood)
                        .font(.system(size: 18, weight: .light))
                        .foregroundStyle(.white.opacity(0.9))
                    
                    BondIndicatorView(percentage: aevaState.bondPercentage)
                        .padding(.horizontal, 40)
                }
                .padding(.top, 40)
                
                Spacer()
                
                // Bottom controls
                VStack(spacing: 16) {
                    Text("She is listening")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.white.opacity(0.4))
                    
                    // Live Activity controls (for testing)
                    HStack(spacing: 20) {
                        Button {
                            LiveActivityManager.shared.startActivity(
                                bondPercentage: aevaState.bondPercentage,
                                mood: aevaState.currentMood
                            )
                        } label: {
                            Text("Start Island")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundStyle(.cyan)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(
                                    Capsule()
                                        .stroke(Color.cyan.opacity(0.5), lineWidth: 1)
                                )
                        }
                        
                        Button {
                            LiveActivityManager.shared.endActivity()
                        } label: {
                            Text("Stop Island")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundStyle(.white.opacity(0.5))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(
                                    Capsule()
                                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                )
                        }
                    }
                }
                .padding(.bottom, 120)
            }
        }
    }
}

// Simple ambient particles
struct AmbientParticles: View {
    var body: some View {
        TimelineView(.animation(minimumInterval: 1/30)) { timeline in
            Canvas { context, size in
                let time = timeline.date.timeIntervalSinceReferenceDate
                
                for i in 0..<25 {
                    let x = (sin(time * 0.3 + Double(i) * 1.7) * 0.4 + 0.5) * size.width
                    let y = (cos(time * 0.25 + Double(i) * 2.1) * 0.4 + 0.5) * size.height
                    let opacity = 0.15 + 0.2 * sin(time + Double(i))
                    
                    let rect = CGRect(x: x, y: y, width: 2.5, height: 2.5)
                    context.fill(Path(ellipseIn: rect), with: .color(.cyan.opacity(opacity)))
                }
            }
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
    }
}

#Preview {
    PresenceView()
        .environmentObject(AevaState())
}

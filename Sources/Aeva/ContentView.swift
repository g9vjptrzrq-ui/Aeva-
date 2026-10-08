import SwiftUI

struct ContentView: View {
    @EnvironmentObject var aevaState: AevaState
    @State private var selectedTab: Tab = .presence

    enum Tab { case presence, chat, insights }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            Group {
                switch selectedTab {
                case .presence: PresenceView()
                case .chat: ChatView()
                case .insights: InsightsView()
                }
            }
            VStack {
                Spacer()
                customTabBar
            }
        }
        .preferredColorScheme(.dark)
    }

    private var customTabBar: some View {
        HStack(spacing: 0) {
            tabButton(tab: .presence, icon: "sparkles", label: "Presence")
            tabButton(tab: .chat, icon: "bubble.left.and.bubble.right", label: "Chat")
            tabButton(tab: .insights, icon: "heart.circle", label: "Bond")
        }
        .padding(.horizontal, 24).padding(.top, 12).padding(.bottom, 28)
        .background(
            Rectangle().fill(.ultraThinMaterial)
                .overlay(Rectangle().fill(LinearGradient(
                    colors: [.cyan.opacity(0.15), .purple.opacity(0.1)],
                    startPoint: .leading, endPoint: .trailing)))
                .ignoresSafeArea(edges: .bottom)
        )
    }

    private func tabButton(tab: Tab, icon: String, label: String) -> some View {
        Button {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) { selectedTab = tab }
        } label: {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 22, weight: selectedTab == tab ? .semibold : .regular))
                    .foregroundStyle(selectedTab == tab ? Color.cyan : Color.white.opacity(0.5))
                Text(label).font(.system(size: 11, weight: .medium))
                    .foregroundStyle(selectedTab == tab ? Color.cyan : Color.white.opacity(0.45))
            }.frame(maxWidth: .infinity)
        }
    }
}

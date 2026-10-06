import SwiftUI

struct ChatView: View {
    @EnvironmentObject var aevaState: AevaState
    @State private var inputText: String = ""
    @FocusState private var isInputFocused: Bool
    
    var body: some View {
        ZStack {
            // Background
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                chatHeader
                
                // Messages
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(aevaState.messages) { message in
                                MessageBubble(message: message)
                                    .id(message.id)
                            }
                            
                            if aevaState.isThinking {
                                HStack {
                                    ThinkingIndicator()
                                    Spacer()
                                }
                                .padding(.horizontal, 16)
                                .id("thinking")
                            }
                        }
                        .padding(.vertical, 20)
                    }
                    .onChange(of: aevaState.messages.count) { _, _ in
                        withAnimation {
                            if let last = aevaState.messages.last {
                                proxy.scrollTo(last.id, anchor: .bottom)
                            }
                        }
                    }
                    .onChange(of: aevaState.isThinking) { _, thinking in
                        if thinking {
                            withAnimation {
                                proxy.scrollTo("thinking", anchor: .bottom)
                            }
                        }
                    }
                }
                
                // Input bar
                inputBar
            }
        }
    }
    
    private var chatHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("Aeva")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.white)
                
                Text(aevaState.bondDescription)
                    .font(.system(size: 12))
                    .foregroundStyle(.cyan.opacity(0.8))
            }
            
            Spacer()
            
            // Mini bond circle
            ZStack {
                Circle()
                    .stroke(Color.white.opacity(0.15), lineWidth: 3)
                    .frame(width: 36, height: 36)
                
                Circle()
                    .trim(from: 0, to: aevaState.bondPercentage / 100)
                    .stroke(
                        AngularGradient(
                            colors: [.cyan, .blue, .purple],
                            center: .center
                        ),
                        style: StrokeStyle(lineWidth: 3, lineCap: .round)
                    )
                    .frame(width: 36, height: 36)
                    .rotationEffect(.degrees(-90))
                
                Text("\(Int(aevaState.bondPercentage))")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(.white)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .background(
            Rectangle()
                .fill(.ultraThinMaterial)
                .overlay(
                    Rectangle()
                        .fill(Color.cyan.opacity(0.05))
                )
        )
    }
    
    private var inputBar: some View {
        HStack(spacing: 12) {
            TextField("Message Aeva...", text: $inputText, axis: .vertical)
                .textFieldStyle(.plain)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color.white.opacity(0.08))
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(Color.cyan.opacity(0.25), lineWidth: 1)
                        )
                )
                .foregroundStyle(.white)
                .focused($isInputFocused)
                .lineLimit(1...4)
            
            Button {
                send()
            } label: {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 34))
                    .foregroundStyle(
                        inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                        ? Color.white.opacity(0.25)
                        : Color.cyan
                    )
            }
            .disabled(inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .padding(.bottom, 8)
        .background(
            Rectangle()
                .fill(.ultraThinMaterial)
        )
    }
    
    private func send() {
        let text = inputText
        inputText = ""
        aevaState.sendUserMessage(text)
    }
}

// MARK: - Message Bubble

struct MessageBubble: View {
    let message: Message
    
    var body: some View {
        HStack {
            if message.isFromUser { Spacer(minLength: 50) }
            
            VStack(alignment: message.isFromUser ? .trailing : .leading, spacing: 4) {
                Text(message.text)
                    .font(.system(size: 16))
                    .foregroundStyle(message.isFromUser ? .white : .white.opacity(0.95))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(
                                message.isFromUser
                                ? AnyShapeStyle(
                                    LinearGradient(
                                        colors: [Color.cyan.opacity(0.7), Color.blue.opacity(0.6)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                  )
                                : AnyShapeStyle(Color.white.opacity(0.1))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(
                                        message.isFromUser
                                        ? Color.cyan.opacity(0.4)
                                        : Color.white.opacity(0.12),
                                        lineWidth: 1
                                    )
                            )
                    )
                
                Text(message.timestamp, style: .time)
                    .font(.system(size: 10))
                    .foregroundStyle(.white.opacity(0.35))
                    .padding(.horizontal, 6)
            }
            
            if !message.isFromUser { Spacer(minLength: 50) }
        }
        .padding(.horizontal, 16)
    }
}

// MARK: - Thinking Indicator

struct ThinkingIndicator: View {
    @State private var phase = 0
    
    var body: some View {
        HStack(spacing: 5) {
            ForEach(0..<3) { i in
                Circle()
                    .fill(Color.cyan.opacity(0.8))
                    .frame(width: 7, height: 7)
                    .scaleEffect(phase == i ? 1.3 : 0.8)
                    .opacity(phase == i ? 1 : 0.4)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.08))
        )
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 0.35, repeats: true) { _ in
                withAnimation(.easeInOut(duration: 0.3)) {
                    phase = (phase + 1) % 3
                }
            }
        }
    }
}

#Preview {
    ChatView()
        .environmentObject(AevaState())
}

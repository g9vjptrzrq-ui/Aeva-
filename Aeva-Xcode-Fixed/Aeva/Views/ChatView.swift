import SwiftUI

struct ChatView: View {
    @EnvironmentObject var aevaState: AevaState
    @State private var inputText = ""
    @FocusState private var isInputFocused: Bool

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 0) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Aeva").font(.system(size: 20, weight: .semibold)).foregroundStyle(.white)
                        Text(aevaState.bondDescription).font(.system(size: 12)).foregroundStyle(.cyan.opacity(0.8))
                    }
                    Spacer()
                    Text("\(Int(aevaState.bondPercentage))%").foregroundStyle(.cyan)
                }.padding(20).background(.ultraThinMaterial)

                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(aevaState.messages) { MessageBubble(message: $0).id($0.id) }
                            if aevaState.isThinking {
                                HStack { ThinkingIndicator(); Spacer() }.padding(.horizontal,16).id("thinking")
                            }
                        }.padding(.vertical,20)
                    }
                    .onChange(of: aevaState.messages.count) { _, _ in
                        if let last = aevaState.messages.last { withAnimation { proxy.scrollTo(last.id, anchor: .bottom) } }
                    }
                }
                inputBar
            }
        }
    }

    private var inputBar: some View {
        HStack(spacing: 12) {
            TextField("Message Aeva...", text: $inputText, axis: .vertical)
                .textFieldStyle(.plain).padding(.horizontal,16).padding(.vertical,12)
                .background(RoundedRectangle(cornerRadius:24).fill(Color.white.opacity(0.08)))
                .foregroundStyle(.white).focused($isInputFocused).lineLimit(1...4)
            Button { let text=inputText; inputText=""; aevaState.sendUserMessage(text) } label: {
                Image(systemName:"arrow.up.circle.fill").font(.system(size:34))
                    .foregroundStyle(inputText.trimmingCharacters(in:.whitespacesAndNewlines).isEmpty ? Color.white.opacity(0.25) : Color.cyan)
            }.disabled(inputText.trimmingCharacters(in:.whitespacesAndNewlines).isEmpty)
        }.padding(16).background(.ultraThinMaterial)
    }
}

struct MessageBubble: View {
    let message: Message
    var body: some View {
        HStack {
            if message.isFromUser { Spacer(minLength:50) }
            Text(message.text).foregroundStyle(.white)
                .padding(.horizontal,16).padding(.vertical,12)
                .background(RoundedRectangle(cornerRadius:20).fill(message.isFromUser ? Color.cyan.opacity(0.65) : Color.white.opacity(0.1)))
            if !message.isFromUser { Spacer(minLength:50) }
        }.padding(.horizontal,16)
    }
}

struct ThinkingIndicator: View {
    @State private var phase = 0
    var body: some View {
        HStack(spacing:5) {
            ForEach(0..<3) { i in Circle().fill(Color.cyan).frame(width:7,height:7).scaleEffect(phase==i ? 1.3 : 0.8) }
        }.padding(16).background(RoundedRectangle(cornerRadius:20).fill(Color.white.opacity(0.08)))
        .onAppear {
            Timer.scheduledTimer(withTimeInterval:0.35, repeats:true) { _ in
                withAnimation(.easeInOut(duration:0.3)) { phase = (phase + 1) % 3 }
            }
        }
    }
}

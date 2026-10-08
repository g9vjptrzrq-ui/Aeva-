import SwiftUI

struct PresenceView: View {
    @EnvironmentObject var aevaState: AevaState
    @State private var pulse = false
    @State private var rotation = 0.0

    var body: some View {
        ZStack {
            LinearGradient(colors:[Color(red:0.02,green:0.02,blue:0.08),Color(red:0.05,green:0.03,blue:0.12),.black],startPoint:.top,endPoint:.bottom).ignoresSafeArea()
            VStack {
                HStack {
                    VStack(alignment:.leading,spacing:4) {
                        Text("Aeva").font(.system(size:32,weight:.light,design:.serif)).foregroundStyle(.white)
                        Text("AI COMPANION").font(.system(size:11,weight:.medium,design:.rounded)).tracking(2).foregroundStyle(.cyan.opacity(0.7))
                    }
                    Spacer()
                    Label("Presence", systemImage:"circle.fill").font(.system(size:13,weight:.medium)).foregroundStyle(.cyan)
                }.padding(.horizontal,24).padding(.top,16)
                Spacer()
                ZStack {
                    ForEach(0..<3) { i in
                        Circle().stroke(AngularGradient(colors:[.clear,.cyan.opacity(0.4),.purple.opacity(0.3),.clear],center:.center),lineWidth:1.5)
                            .frame(width:260+CGFloat(i*40),height:260+CGFloat(i*40))
                            .rotationEffect(.degrees(rotation+Double(i*30)))
                    }
                    Circle().fill(RadialGradient(colors:[.cyan.opacity(0.35),.blue.opacity(0.15),.clear],center:.center,startRadius:20,endRadius:140))
                        .frame(width:280,height:280).scaleEffect(pulse ? 1.08 : 0.95)
                    Circle().fill(RadialGradient(colors:[.white.opacity(0.9),.cyan.opacity(0.7),.blue.opacity(0.4),.purple.opacity(0.2)],center:.center,startRadius:5,endRadius:70))
                        .frame(width:130,height:130).shadow(color:.cyan.opacity(0.6),radius:30).scaleEffect(pulse ? 1.05 : 1)
                }.onAppear {
                    withAnimation(.easeInOut(duration:3.2).repeatForever(autoreverses:true)) { pulse=true }
                    withAnimation(.linear(duration:20).repeatForever(autoreverses:false)) { rotation=360 }
                }
                VStack(spacing:12) {
                    Text(aevaState.currentMood).font(.system(size:18,weight:.light)).foregroundStyle(.white.opacity(0.9))
                    BondIndicatorView(percentage:aevaState.bondPercentage).padding(.horizontal,40)
                }.padding(.top,40)
                Spacer()
                HStack(spacing:16) {
                    Button("Start Island") { LiveActivityManager.shared.startActivity(bondPercentage:aevaState.bondPercentage,mood:aevaState.currentMood) }
                        .foregroundStyle(.cyan).padding(.horizontal,16).padding(.vertical,8).overlay(Capsule().stroke(.cyan.opacity(0.5)))
                    Button("Stop Island") { LiveActivityManager.shared.endActivity() }
                        .foregroundStyle(.white.opacity(0.5)).padding(.horizontal,16).padding(.vertical,8).overlay(Capsule().stroke(.white.opacity(0.2)))
                }.padding(.bottom,120)
            }
        }
    }
}

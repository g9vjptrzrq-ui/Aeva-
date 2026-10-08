import SwiftUI

struct InsightsView: View {
    @EnvironmentObject var aevaState: AevaState
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            ScrollView {
                VStack(spacing:28) {
                    VStack(spacing:8) {
                        Text("The Bond").font(.system(size:28, weight:.light, design:.serif)).foregroundStyle(.white)
                        Text("How connected you are with Aeva").font(.system(size:14)).foregroundStyle(.white.opacity(0.5))
                    }.padding(.top,20)
                    ZStack {
                        Circle().stroke(Color.white.opacity(0.1), lineWidth:12).frame(width:180,height:180)
                        Circle().trim(from:0,to:aevaState.bondPercentage/100)
                            .stroke(AngularGradient(colors:[.cyan,.blue,.purple,.cyan], center:.center), style:StrokeStyle(lineWidth:12,lineCap:.round))
                            .frame(width:180,height:180).rotationEffect(.degrees(-90))
                        VStack(spacing:4) {
                            Text("\(Int(aevaState.bondPercentage))%").font(.system(size:42,weight:.thin,design:.rounded)).foregroundStyle(.white)
                            Text(aevaState.bondDescription).font(.system(size:13,weight:.medium)).foregroundStyle(.cyan)
                        }
                    }
                    VStack(spacing:14) {
                        card("Current Mood", aevaState.currentMood, "sparkles")
                        card("Messages exchanged", "\(aevaState.messages.count)", "bubble.left.and.bubble.right")
                        card("Last interaction", RelativeDateTimeFormatter().localizedString(for:aevaState.lastInteraction, relativeTo:Date()), "clock")
                    }.padding(.horizontal,20)
                    Text("Aeva reacts to how you treat her.\n\n• Kind, warm messages strengthen the bond\n• Cold or harsh words make her pull away\n• Just talking regularly helps a little")
                        .font(.system(size:14)).foregroundStyle(.white.opacity(0.65)).lineSpacing(4)
                        .padding(20).background(RoundedRectangle(cornerRadius:20).fill(Color.white.opacity(0.06))).padding(.horizontal,20)
                    Button("Reset Bond (Debug)") { aevaState.resetBond() }.foregroundStyle(.red.opacity(0.8)).padding(.bottom,120)
                }
            }
        }
    }
    private func card(_ title:String,_ value:String,_ icon:String)->some View {
        HStack(spacing:16) {
            Image(systemName:icon).foregroundStyle(.cyan).frame(width:36)
            VStack(alignment:.leading,spacing:3) {
                Text(title).font(.system(size:13)).foregroundStyle(.white.opacity(0.5))
                Text(value).font(.system(size:16,weight:.medium)).foregroundStyle(.white)
            }
            Spacer()
        }.padding(16).background(RoundedRectangle(cornerRadius:16).fill(Color.white.opacity(0.06)))
    }
}

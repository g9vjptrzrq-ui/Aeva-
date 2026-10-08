import SwiftUI

struct BondIndicatorView: View {
    let percentage: Double
    var body: some View {
        VStack(spacing: 10) {
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(Color.white.opacity(0.1)).frame(height: 6)
                    Capsule().fill(LinearGradient(colors: [.cyan,.blue,.purple], startPoint: .leading, endPoint: .trailing))
                        .frame(width: geo.size.width * percentage / 100, height: 6)
                }
            }.frame(height: 6)
            HStack {
                Text("Relationship Bond").font(.system(size: 13, weight: .medium)).foregroundStyle(.white.opacity(0.6))
                Spacer()
                Text("\(Int(percentage))%").font(.system(size: 13, weight: .semibold, design: .rounded)).foregroundStyle(.cyan)
            }
        }
    }
}

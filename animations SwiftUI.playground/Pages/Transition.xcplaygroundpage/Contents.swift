import SwiftUI
import PlaygroundSupport

struct ContentView: View {
    @State private var isMoved = false
    @ViewBuilder var body: some View {
        if isMoved {
            Rectangle()
                .foregroundColor(Color(#colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)))
                .frame(width: 90, height: 90)
                .cornerRadius(16.0)
                .transition(AnyTransition.scale(scale: 0.1).combined(with: AnyTransition.opacity))
        }
        Button("Toggle") {
            withAnimation(.spring()) {
                isMoved.toggle()
            }
        }
    }
}


let hostingController = UIHostingController(rootView: ContentView())
PlaygroundPage.current.setLiveView(hostingController)

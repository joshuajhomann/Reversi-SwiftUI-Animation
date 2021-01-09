import SwiftUI
import PlaygroundSupport

struct ContentView: View {
    @State private var isAnimated = false
    var body: some View {
        VStack {
            Circle()
                .foregroundColor(isAnimated ? Color.red : Color.yellow)
                .frame(width: 300, height: 300)
                .animation(.default)
            Button("animate") {
                isAnimated.toggle()
            }
        }
    }
}

let hostingController = UIHostingController(rootView: ContentView())
PlaygroundPage.current.setLiveView(hostingController)


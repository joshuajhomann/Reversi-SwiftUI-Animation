import SwiftUI
import PlaygroundSupport

struct ContentView: View {
  @State private var isblurred = true
  @State private var isSaturated = true
  var body: some View {
    VStack {
      Image(uiImage:UIImage(named: "2.jpg")!)
        .resizable()
        .scaledToFit()
        .blur(radius: isblurred ? 16 : 0)
        .saturation(isSaturated ? 6 : 1)
      Button ("animate") {
        withAnimation(.linear(duration: 2)) {
          isblurred.toggle()
        }
        withAnimation(Animation.linear(duration: 2)) {
          isSaturated.toggle()
        }
      }
    }
  }
}

let hostingController = UIHostingController(rootView: ContentView())
PlaygroundPage.current.setLiveView(hostingController)

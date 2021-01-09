import SwiftUI
import PlaygroundSupport

struct Box: View {
  let index: Int
  @Binding var isShown: Bool
  enum Constant {
    static let duration: TimeInterval = 2
    static let colors: [UIColor] = [ #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1),#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1),#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1),#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1),#colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1),#colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)]
    static let titles = ["easeInOut", "easeIn", "easeOut", "linear", "custom"]
    static let animations: [Animation] = [
      .easeInOut(duration: Constant.duration),
      .easeIn(duration: Constant.duration),
      .easeOut(duration: Constant.duration),
      .linear(duration: Constant.duration),
      .timingCurve(0.25, 1.5, 0.75, -0.5, duration: Constant.duration)
    ]
  }
  var body: some View {
    ZStack {
      Rectangle()
        .foregroundColor(Color(Constant.colors[index]))
        .frame(width: 90, height: 90)
        .cornerRadius(16.0)
      Text(Constant.titles[index])
        .font(.body)
        .foregroundColor(.white)
    }
    .offset(x: isShown ? 140 : -140, y: 0)
    .animation(Constant.animations[index])
  }
}

struct ContentView: View {
  @State private var isDetailShown = false
  var body: some View {
    VStack {
      ForEach(0..<Box.Constant.animations.count) { index in
        Box(index: index, isShown: self.$isDetailShown)
      }
      Button("animate") {
        self.isDetailShown.toggle()
      }
    }
  }
}

let hostingController = UIHostingController(rootView: ContentView())
PlaygroundPage.current.setLiveView(hostingController)

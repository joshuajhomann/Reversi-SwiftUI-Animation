import SwiftUI
import PlaygroundSupport

struct Box: View {
  let index: Int
  @Binding var isShown: Bool
  enum Constant {
    static let duration: TimeInterval = 2
    static let colors: [UIColor] = [ #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1),#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1),#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1),#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1),#colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1),#colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)]
    static let titles = ["Spring", "Interactive", "Interp", "Interp2", "custom"]
    static let animations: [Animation] = [
        Animation.spring(response: 2, dampingFraction: 0.3, blendDuration: 1).speed(0.4),
      .interactiveSpring(response: 2, dampingFraction: 0.3, blendDuration: 1),
      .interpolatingSpring(mass: 5, stiffness: 50, damping: 7, initialVelocity: 0.3),
      .interpolatingSpring(stiffness: 8, damping: 1),
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
        .foregroundColor(.black)
        .animation(Constant.animations[index])
    }
    .offset(x: isShown ? 140 : -140, y: 0)
    .animation(.default)
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

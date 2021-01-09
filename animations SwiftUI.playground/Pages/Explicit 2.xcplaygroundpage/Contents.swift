import SwiftUI
import PlaygroundSupport

struct Box: View {
  let index: Int
  enum Constant {
    static let duration: TimeInterval = 2
    static let colors: [UIColor] = [ #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1),#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1),#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1),#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1),#colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1),#colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)]
    static let titles = ["offset", "scale", "rotation", "rotation3d", "Opacity", "Shadow"]
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
  }
}

struct ContentView: View {
  @State private var isAnimated = false
  var body: some View {
    VStack {
      Box(index: 0).offset(x: isAnimated ? -250 : 0, y: 0)
      Box(index: 1).scaleEffect(isAnimated ? 0.5 : 1)
      Box(index: 2).rotationEffect(.init(radians: isAnimated ? .pi : 0))
      Box(index: 3).rotation3DEffect(.degrees(isAnimated ? 90 : 0), axis: (x: 1, y: 0, z: 0))
      Box(index: 4).opacity(isAnimated ? 0 : 1)
      Box(index: 5).shadow(color: Color.red, radius: isAnimated ? 32 : 0, x: 0, y: 0)
      Button("animate") {
        withAnimation(.linear(duration: 2)) {
          isAnimated.toggle()
        }
      }
    }
  }
}


let hostingController = UIHostingController(rootView: ContentView())
PlaygroundPage.current.setLiveView(hostingController)

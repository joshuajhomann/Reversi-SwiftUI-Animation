import SwiftUI
import PlaygroundSupport

extension UIColor {
  func rgba() -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
    var r = CGFloat(0)
    var g = CGFloat(0)
    var b = CGFloat(0)
    var a = CGFloat(0)
    getRed(&r, green: &g, blue: &b, alpha: &a)
    return (r, g, b, a)
  }
  func mix(with color: UIColor, proportion: CGFloat) -> UIColor {
    let lhs = rgba()
    let rhs = color.rgba()
    let color = UIColor(red: lhs.r.lerp(to: rhs.r, alpha: proportion),
                        green: lhs.g.lerp(to: rhs.g, alpha: proportion),
                        blue: lhs.b.lerp(to: rhs.b, alpha: proportion),
                        alpha: 1)
    return color
  }
}

extension CGFloat {
  func lerp(to: CGFloat, alpha: CGFloat) -> CGFloat {
    return (1 - alpha) * self + alpha * to
  }
}

struct CustomAnimation: AnimatableModifier {

  var proportion: CGFloat
  var animatableData: CGFloat {
    get { proportion }
    set { proportion = newValue }
  }

  func body(content: Content) -> some View {
    content
    .foregroundColor(Color(color(for: proportion)))
    .offset(x: -125 + 250 * proportion, y: 100 * sin(2 * proportion * .pi * 5))
  }

  private func color(for proportion: CGFloat) -> UIColor {
    let colors: [UIColor] = [.cyan, .blue, .purple, .magenta, .red, .orange, .yellow, .green]
    let count = CGFloat(colors.count - 1)
    let lowerIndex = Int(proportion * count)
    let upperIndex = (lowerIndex + 1) % 5
    let remainder = proportion * count - CGFloat(lowerIndex)
    return colors[lowerIndex].mix(with: colors[upperIndex], proportion: remainder)
  }
}

extension View {
  func customAnimation(proportion: CGFloat) -> some View {
    self.modifier(CustomAnimation(proportion: proportion))
  }
}

struct ContentView: View {
  @State private var proportion = CGFloat(0)
  var body: some View {
    VStack {
      Circle()
        .frame(width: 90, height: 90)
        .clipShape(Circle())
        .customAnimation(proportion: proportion)
      Button("animate") {
        withAnimation(.linear(duration: 5)) {
          self.proportion = self.proportion == 0 ? 1 : 0
        }
      }
    }
  }
}
let hostingController = UIHostingController(rootView: ContentView())
PlaygroundPage.current.setLiveView(hostingController)



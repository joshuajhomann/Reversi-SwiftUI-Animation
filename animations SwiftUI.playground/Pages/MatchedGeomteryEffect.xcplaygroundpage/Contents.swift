import SwiftUI
import PlaygroundSupport

struct ContentView: View {
    @Namespace private var stack
    @State private var isMoved = Set<Int>()
    
    enum Constant {
        static let duration: TimeInterval = 2
        static let colors: [UIColor] = [ #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1),#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1),#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1),#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1),#colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1),#colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)]
    }
    var body: some View {
        VStack {
            HStack {
                ForEach (Constant.colors.indices, id: \.self) { index in
                    if !isMoved.contains(index) {
                        makeSquare(for: index)
                    }
                }
            }
            VStack {
                ForEach (Constant.colors.indices, id: \.self) { index in
                    if isMoved.contains(index) {
                        makeSquare(for: index)
                    }
                }
            }
        }
        
    }
    func makeSquare(for index: Int) -> some View {
        Button {
            if isMoved.contains(index) {
                isMoved.remove(index)
            } else {
                isMoved.insert(index)
            }
        } label: {
            Rectangle()
                .foregroundColor(Color(Constant.colors[index]))
                .frame(width: 90, height: 90)
                .cornerRadius(16.0)
                .animation(.default)
                .matchedGeometryEffect(id: index, in: stack)
        }
    }
}

let hostingController = UIHostingController(rootView: ContentView())
PlaygroundPage.current.setLiveView(hostingController)

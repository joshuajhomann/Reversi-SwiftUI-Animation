import UIKit
import PlaygroundSupport


class ViewController: UIViewController {
  let circle = UIView(frame: .init(origin: .zero, size: .init(width: 40, height: 40)))
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    circle.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(circle)
    circle.center = view.center
    circle.backgroundColor = .blue
    circle.layer.cornerRadius = 20
    circle.clipsToBounds = true
    UIView.animate(withDuration: 10) {
      self.circle.transform = .init(scaleX: 10, y: 10)
    }
  }
}


PlaygroundPage.current.liveView = ViewController()


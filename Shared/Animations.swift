//
//  Animations.swift
//  Reversi
//
//  Created by Joshua Homann on 1/5/21.
//

import SwiftUI

struct FlipPreferenceKey: PreferenceKey {
  typealias Value = [Int: Bool]
  static var defaultValue: Value = [:]
  static func reduce(value: inout Value, nextValue: () -> Value) {
    nextValue().forEach { value[$0] = $1 }
  }
}

enum Animations {
  struct HorizontalShake: AnimatableModifier {
    var proportion: CGFloat
    var distance: CGFloat
    var cycles: CGFloat

    var animatableData: CGFloat {
      get { proportion }
      set { proportion = newValue }
    }

    func body(content: Content) -> some View {
      content
        .transformEffect(.init(
          translationX: sin(proportion * 2 * cycles * .pi) * distance,
          y: 0)
        )
    }
  }

  struct FlipAnimation: AnimatableModifier {
    var proportion: Double
    var id: Int

    var animatableData: Double {
      get { proportion }
      set { proportion = newValue }
    }

    func body(content: Content) -> some View {
      content
        .rotation3DEffect(Angle(radians: proportion * .pi), axis: (x: 0, y: 1, z: 0))
        .preference(
          key: FlipPreferenceKey.self,
          value: [id: proportion > 0.5]
        )
    }

  }

  struct BounceScale: AnimatableModifier {
    var proportion: CGFloat
    var scale: CGFloat
    private var adjustedProportion: CGFloat {
      proportion < 0.5
        ? 2 * proportion
        : (1 - 2 * (proportion - 0.5))
    }

    var animatableData: CGFloat {
      get { proportion }
      set { proportion = newValue }
    }

    func body(content: Content) -> some View {
      content
        .scaleEffect(1 + (scale - 1) * adjustedProportion)
    }
  }

}

extension View {
  func bounceScaleAnimation(proportion: CGFloat, scale: CGFloat) -> some View {
    modifier(Animations.BounceScale(proportion: proportion, scale: scale))
  }
  func horizontalShakeAnimation(proportion: CGFloat, distance: CGFloat, cycles: CGFloat) -> some View {
    modifier(Animations.HorizontalShake(proportion: proportion, distance: distance, cycles: cycles))
  }
  func flipAnimation(proportion: Double, id: Int) -> some View {
    modifier(Animations.FlipAnimation(proportion: proportion, id: id))
  }

}

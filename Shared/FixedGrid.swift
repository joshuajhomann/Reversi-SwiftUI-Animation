//
//  FixedGrid.swift
//  Reversi
//
//  Created by Joshua Homann on 1/3/21.
//

import SwiftUI

fileprivate struct GridPreferenceKey: PreferenceKey {
  static var defaultValue: [Int: CGRect] = [:]
  static func reduce(value: inout [Int: CGRect], nextValue: () -> [Int : CGRect]) {
    nextValue().forEach { value[$0.key] = $0.value }
  }
}

struct FixedGrid<Content: View>: View {
  private let rows: Int
  private let columns: Int
  private let spacing: CGFloat
  private let makeContent: (Int, Int) -> Content
  @Binding private var gridDictionary: [Int: CGRect]
  private enum Space: Hashable { case board }

  init(
    rows: Int,
    columns: Int,
    spacing: CGFloat = 4,
    gridDictionary: Binding<[Int: CGRect]> = .constant([:]),
    @ViewBuilder content makeContent: @escaping (Int, Int) -> Content
  ) {
    self.rows = rows
    self.columns = columns
    self.makeContent = makeContent
    self.spacing = spacing
    self._gridDictionary = gridDictionary
  }

  var body: some View {
    VStack(spacing: spacing) {
      ForEach(0..<columns) { x in
        HStack(spacing: spacing) {
          ForEach(0..<rows) { y in
            GeometryReader { proxy in
              makeContent(y, x)
                .preference(
                  key: GridPreferenceKey.self,
                  value: [x + y * rows: proxy.frame(in: .named(Space.board))]
                )
            }
          }
        }
      }
    }
    .coordinateSpace(name: Space.board)
    .onPreferenceChange(GridPreferenceKey.self) { gridDictionary = $0 }
  }
}

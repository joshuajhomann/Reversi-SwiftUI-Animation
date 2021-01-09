//
//  Coordinate.swift
//  Reversi
//
//  Created by Joshua Homann on 1/5/21.
//

import Foundation

struct Coordinate: Equatable {
  var x: Int
  var y: Int
  @inlinable var boardIndex: Int { x * GameViewModel.Constant.dimension + y }
  @inlinable var isValidForBoard: Bool {
    GameViewModel.Constant.range.contains(x) && GameViewModel.Constant.range.contains(y)
  }
}

extension Coordinate {
  init(boardIndex: Int) {
    x = boardIndex / GameViewModel.Constant.dimension
    y = boardIndex * GameViewModel.Constant.dimension
  }
}

func + (lhs: Coordinate, rhs: Coordinate) -> Coordinate {
  Coordinate(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}


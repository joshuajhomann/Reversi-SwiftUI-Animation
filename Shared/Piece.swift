//
//  Piece.swift
//  Reversi
//
//  Created by Joshua Homann on 1/3/21.
//

import Foundation

struct Piece: Identifiable, Hashable {
  enum Color {
    case black, white
  }
  var id: Int { index }
  var index: Int
  var color: Color?
  var hasAppeared = false
  var isFlipping = false
}

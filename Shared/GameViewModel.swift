//
//  GameViewModel.swift
//  Reversi
//
//  Created by Joshua Homann on 1/3/21.
//

import Combine
import Foundation

final class GameViewModel: ObservableObject {
  @Published private(set) var board: [Piece] = []
  @Published private(set) var currentPlayer = Piece.Color.white
  @Published private(set) var possibleMoves: [Int] = []
  @Published private(set) var shakeSquareIndex: Int?
  var animatedTransactions: AnyPublisher<AnimatedTransaction, Never> { animationSubject.eraseToAnyPublisher() }
  struct AnimatedTransaction {
    enum Animation {
      case boardShake
      case pieceAppeared
      case flipPiece
    }
    var animation: Animation
    var execute: () -> Void
    var completion: Optional<() -> Void> = nil
  }
  enum Constant {
    static let dimension = 8
    static let range = (0..<Constant.dimension)
    static let adjacentOffsets: [Coordinate] = (-1...1)
      .flatMap { x in (-1...1).map { y in Coordinate(x: x, y: y) } }
      .filter { coordinate in coordinate.x != 0 || coordinate.y != 0 }
    static let initialWhiteIndices = [ 3 + 3 * Constant.dimension, 4 + 4 * Constant.dimension]
    static let initialBlackIndices = [ 3 + 4 * Constant.dimension, 4 + 3 * Constant.dimension]
  }
  private let animationSubject = PassthroughSubject<AnimatedTransaction, Never>()
  private var flipsToAnimate: [Coordinate] = []
  init() {
    reset()
  }
  func tap(x: Int, y: Int) {
    let coordinate = Coordinate(x: x, y: y)
    let flips = flipsForAdding(currentPlayer, at: coordinate)
    guard !flips.isEmpty else {
      return animationSubject.send(.init(
        animation: .boardShake,
        execute: { [weak self] in self?.shakeSquareIndex = coordinate.x + Constant.dimension * coordinate.y },
        completion: { [weak self] in self?.shakeSquareIndex = nil }
      ))
    }

    board[coordinate].color = currentPlayer
    animationSubject.send(.init(
      animation: .pieceAppeared,
      execute: { [weak self] in self?.board[coordinate].hasAppeared = true }
    ))
    flipsToAnimate = flips.reversed()
    possibleMoves = []
    flipNextPiece()
    currentPlayer = currentPlayer == .white ? .black : .white
  }

  func perform(_ transaction: AnimatedTransaction, thenWait delay: TimeInterval = 0) {
    transaction.execute()
    guard let completion = transaction.completion else { return }
    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
      completion()
    }
  }

  private func flipNextPiece() {
    guard let nextFlip = flipsToAnimate.last else { return highlightPossibleMoves() }
    animationSubject.send(.init(
      animation: .pieceAppeared,
      execute: { [weak self] in
        guard let self = self else { return }
        self.board[nextFlip].color = self.board[nextFlip].color == .white ? .black : .white
        self.board[nextFlip].isFlipping = true
        self.flipsToAnimate = self.flipsToAnimate.dropLast()
      },
      completion: { [weak self] in
        guard let self = self else { return }
        self.board[nextFlip].isFlipping = false
        self.flipNextPiece()
      }
    ))
  }

  private func reset() {
    board = Constant.range.flatMap { x in
      Constant.range.map { y in
        .init(index: Coordinate(x: x, y: y).boardIndex, color: nil)
      }
    }
    Constant.initialWhiteIndices.forEach { board[$0] = .init(index: $0, color: .white)}
    Constant.initialBlackIndices.forEach { board[$0] = .init(index: $0, color: .black)}
    highlightPossibleMoves()
  }
  private func highlightPossibleMoves() {
    possibleMoves = (0..<Constant.dimension).flatMap { x in
      (0..<Constant.dimension).compactMap { y in
        let coordinate = Coordinate(x: x, y: y)
        return flipsForAdding(currentPlayer, at: coordinate).isEmpty ? nil : coordinate.boardIndex
      }
    }
  }
  private func flipsForAdding(_ targetColor: Piece.Color, at coordinate: Coordinate) -> [Coordinate] {
    guard coordinate.isValidForBoard && board[coordinate].color == nil else { return [] }
    return Constant.adjacentOffsets.flatMap { [board] offset -> [Coordinate]  in
      unfold(into: (coordinate: coordinate, accumulated: [Coordinate]())) { [board] state in
        state.coordinate = state.coordinate + offset
        guard state.coordinate.isValidForBoard,
          let color = board[state.coordinate].color else {
          state.accumulated.removeAll()
          return nil
        }
        if color == targetColor {
          return nil
        }
        state.accumulated.append(state.coordinate)
        return state
      }
      .accumulated
    }
  }
}

private extension Array where Element == Piece {
  subscript (coordinate: Coordinate) -> Piece {
    get { self[coordinate.boardIndex] }
    set { self[coordinate.boardIndex] = newValue }
  }
}

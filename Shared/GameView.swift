//
//  ContentView.swift
//  Shared
//
//  Created by Joshua Homann on 1/2/21.
//

import SwiftUI

struct GameView: View {
  @StateObject private var viewModel = GameViewModel()
  @State private var gridDictionary: [Int: CGRect] = [:]
  private enum Space: Hashable { case board }
  var body: some View {
    VStack(alignment: .center) {
      Spacer()
      ZStack(alignment: .topLeading) {
        FixedGrid(
          rows: GameViewModel.Constant.dimension,
          columns: GameViewModel.Constant.dimension,
          gridDictionary: $gridDictionary
        ) { x, y  in
          Button { viewModel.tap(x: x, y: y) }
            label: {
              RoundedRectangle(cornerRadius: 12)
                .foregroundColor(.green)
                .horizontalShakeAnimation(
                  proportion: x + y * GameViewModel.Constant.dimension == viewModel.shakeSquareIndex ? 1 : 0,
                  distance: 4,
                  cycles: 3
                )
            }
        }
        ForEach(viewModel.board) { piece in
          PieceView(piece: piece, rect:  gridDictionary[piece.index]?.insetBy(dx: 8, dy: 8) ?? .zero)
        }
        ForEach(viewModel.possibleMoves, id: \.self) { index in
          HighlightView(
            rect: gridDictionary[index]?.insetBy(dx: 8, dy: 8) ?? .zero,
            color: viewModel.currentPlayer == .white ? .white : .black
          )
        }
      }
      .aspectRatio(1, contentMode: .fit)
      Spacer()
      Text("\(String(describing: viewModel.currentPlayer).capitalized)'s turn")
      Spacer()
    }
    .padding()
    .onReceive(viewModel.animatedTransactions) { transaction in
      switch transaction.animation {
      case .boardShake:
        withAnimation(Animation.linear(duration: 0.25)) {
          viewModel.perform(transaction, thenWait: 0.25)
        }
      case .pieceAppeared:
        withAnimation(Animation.spring(response: 0.2, dampingFraction: 0.3, blendDuration: 1).speed(0.4)) {
          viewModel.perform(transaction, thenWait: 0.25)
        }
      case .flipPiece:
        withAnimation(Animation.linear(duration: 0.25)) {
          viewModel.perform(transaction, thenWait: 0.25)
        }
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    GameView()
  }
}

struct HighlightView: View  {
  var rect: CGRect
  var color: Color
  @State private var isAnimated = false
  var body: some View {
    Circle()
      .foregroundColor(color)
      .opacity(isAnimated ? 0.5 : 0.1)
      .frame(width: rect.size.width, height: rect.size.height)
      .offset(x: rect.origin.x, y: rect.origin.y)
      .onAppear {
        withAnimation(Animation.linear(duration: 1).repeatForever()) {
          isAnimated = true
        }
      }
  }
}

struct PieceView: View {
  var piece: Piece
  var rect: CGRect
  private var color: Color {
    switch piece.color {
    case .white: return .white
    case .black: return .black
    case .none: return .clear
    }
  }
  var body: some View {
    Circle()
      .foregroundColor(color)
      .bounceScaleAnimation(
        proportion:  piece.hasAppeared ? 1 : 0,
        scale: 1.25
      )
      .flipAnimation(
        proportion: piece.isFlipping ? 1 : 0,
        id: piece.id
      )
      .frame(width: rect.size.width, height: rect.size.height)
      .offset(x: rect.origin.x, y: rect.origin.y)
  }
}


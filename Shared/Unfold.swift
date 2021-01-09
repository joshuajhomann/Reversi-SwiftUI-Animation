//
//  Unfold.swift
//  Reversi
//
//  Created by Joshua Homann on 1/5/21.
//

import Foundation

@discardableResult func unfold<State>(into value: State, next: @escaping (inout State) -> State?) -> State {
  var localState = value
  var unfolded = sequence(state: localState) { _ -> State? in
    next(&localState)
  }
  while unfolded.next() != nil { }
  return localState
}

//
//  MemoryGameModelView.swift
//  memorysquares
//
//  Created by Tyler Reed on 4/16/22.
//

import Foundation
import SwiftUI

class MemoryGameModelView: ObservableObject{
    @Published private var model: MemoryGame = MemoryGameModelView.createMemoryGame(totalSquares: 16, totalChosenSquares: 6)
    
    static func createMemoryGame(totalSquares: Int, totalChosenSquares: Int) -> MemoryGame {
        return MemoryGame(numberOfCards: totalSquares, numberOfCardsToMemorize: totalChosenSquares)
    }
    
    func restartGame() {
        model = MemoryGameModelView.createMemoryGame(totalSquares: 16, totalChosenSquares: 6)
    }
    
    var cards: [Card] {
        model.cards
    }
    
    var getNumberOfLives: Int {
        model.numberOfLives
    }
    
    var checkDidWinRound: Bool {
        model.checkDidWinRound()
    }
    
    var isGameOver: Bool {
        model.isGameOver()
    }
    
    func toggleMatchedCard(card: Card) {
        model.toggleCardMatch(card: card)
    }

    //MARK: - Intents
    func choose(card: Card) {
        model.chooseCard(card: card)
    }
}

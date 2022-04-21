//
//  MemoryGameModelView.swift
//  memorysquares
//
//  Created by Tyler Reed on 4/16/22.
//

import Foundation
import SwiftUI

class MemoryGameModelView: ObservableObject{
    @Published private var model: MemoryGame
    @Published var round: Int = 0
    @Published var readyForNextRound: Bool = false
    @Published var difficultyLevel: Int = 0
    
    init(totalSquares: Int, totalChosenSquares: Int) {
        model = MemoryGame(numberOfCards: 9, numberOfCardsToMemorize: 3)
    }
    
    func restartGame() {
        readyForNextRound = false
        round += 1
        difficultyLevel += 1
        print(difficultyLevel)
        model = MemoryGame(
            numberOfCards: getNumberOfCardsDifficulyBased(level: difficultyLevel),
            numberOfCardsToMemorize: getNumberOfCardsToMemorizeDifficultyBased(level: difficultyLevel)
        )
    }
    
    func getNumberOfCardsDifficulyBased(level: Int) -> Int {
        if level > 0 && level <= 3 {
            return 9
        } else if level > 3 && level <= 5 {
            return 16
        } else if level > 5 && level <= 7 {
            return 25
        } else if level > 7 && level <= 9 {
            return 30
        } else if level > 9 && level <= 11 {
            return 26
        } else if level > 11 && level <= 13 {
            return 42
        } else {
            return 48
        }
    }
    
    func getNumberOfCardsToMemorizeDifficultyBased(level: Int) -> Int {
        if level > 0 && level <= 2 {
            return 3
        } else if level > 2 && level <= 4 {
            return 6
        } else if level > 4 && level <= 6 {
            return 8
        } else if level > 6 && level <= 8 {
            return 10
        } else if level > 8 && level <= 10 {
            return 12
        } else if level > 10 && level <= 12 {
            return 15
        } else {
            return 17
        }
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

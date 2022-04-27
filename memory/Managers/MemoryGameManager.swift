//
//  MemoryGameModelView.swift
//  memorysquares
//
//  Created by Tyler Reed on 4/16/22.
//

import Foundation
import SwiftUI

class MemoryGameManager: ObservableObject{
    @Published private var model: MemoryGame
    @Published var round: Int = 0
    @Published var readyForNextRound: Bool = false
    @Published var difficultyLevel: Int = 0
    
    init(totalSquares: Int, totalChosenSquares: Int) {
        model = MemoryGame(
            numberOfCards: 9,
            numberOfCardsToMemorize: 3
        )
    }
    
    func startGame() {
        round = 1
        difficultyLevel = 1
        model = MemoryGame(
            numberOfCards: getNumberOfCardsDifficulyBased(level: difficultyLevel),
            numberOfCardsToMemorize: getNumberOfCardsToMemorizeDifficultyBased(level: difficultyLevel)
        )
    }
    
    func restartGame() {
        readyForNextRound = false
        round = 1
        difficultyLevel = 1
        model = MemoryGame(
            numberOfCards: getNumberOfCardsDifficulyBased(level: difficultyLevel),
            numberOfCardsToMemorize: getNumberOfCardsToMemorizeDifficultyBased(level: difficultyLevel)
        )
    }
    
    func nextRound() {
        readyForNextRound = false
        round += 1
        difficultyLevel += 1
        model = MemoryGame(
            numberOfCards: getNumberOfCardsDifficulyBased(level: difficultyLevel),
            numberOfCardsToMemorize: getNumberOfCardsToMemorizeDifficultyBased(level: difficultyLevel)
        )
    }
    
    func getNumberOfCardsDifficulyBased(level: Int) -> Int {
        if level > 0 && level <= 2{
            return 9
        } else if level > 2 && level <= 5 {
            return 16
        } else if level > 5 && level <= 10 {
            return 25
        } else if level > 10 && level <= 13 {
            return 36
        } else if level > 13 && level <= 15 {
            return 49
        } else {
            return 36
        }
    }
    
    func getNumberOfCardsToMemorizeDifficultyBased(level: Int) -> Int {
        if level == 1 {
//            randomizeCardsWithDifferentSettings(delay: 2.0, animate: 1.0)
//            oppositeCards(delay: 2.0, animate: 1.0)
            return 3
        } else if level == 2 {
            return 4
        } else if level == 3 {
            return 5
        } else if level == 4 {
            return 6
        } else if level == 5 {
            return 6
        } else if level == 6 {
            return 8
        } else if level == 7 {
            shuffleCards(delay: 2.0, animate: 0.5)
            return 9
        } else if level == 8 {
            return 10
        } else if level == 9 {
            return 11
        } else if level == 10 {
            randomizeCardsWithDifferentSettings(delay: 1.0, animate: 0.5)
            return 7
        } else if level > 10 && level < 12 {
            return 12
        } else if level == 13 {
            oppositeCards(delay: 2.5, animate: 1.0)
            return 10
        } else if level > 13 && level <= 20 {
            return 15
        } else {
            return 15
        }
    }
    
    func shuffleCards(delay: TimeInterval, animate: Double) {
        Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { _ in
            withAnimation(.easeInOut(duration: animate)) {
                self.model.cards.shuffle()
            }
        }
    }
    
    func oppositeCards(delay: TimeInterval, animate: Double) {
        Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { _ in
            withAnimation(.easeInOut(duration: animate)) {
                self.model.oppositeCards()
            }
        }
    }
    
    func randomizeCardsWithRoundSettings(delay: TimeInterval, animate: Double) {
        Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { _ in
            withAnimation(.easeInOut(duration: animate)) {
                self.model.randomizeCardsWithRoundSettings()
            }
        }
    }
    
    func randomizeCardsWithDifferentSettings(delay: TimeInterval, animate: Double) {
        Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { _ in
            withAnimation(.easeInOut(duration: animate)) {
                self.model.randomizeCardsWithDifferentSettings()
            }
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

    //MARK: - Intents
    func choose(card: Card) {
        model.chooseCard(card: card)
    }
}

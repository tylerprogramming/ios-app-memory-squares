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
    @Published var progressViewValue: Double = 120
    @Published var timerEnd: Double = 4.0
    @Published var timerStartIncrement: Double = 3.0
    
    init(totalSquares: Int, totalChosenSquares: Int) {
        model = MemoryGame(
            numberOfCards: 9,
            numberOfCardsToMemorize: 3
        )
    }
    
    func startGame() {
        round = 1
        difficultyLevel = 1
        timerEnd = (progressViewValue / timerStartIncrement) / 10
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
            return 3
        } else if level == 2 {
            hideBoardWithDifferentColors(delay: 1.0, animate: 1.0)
            randomizeCardsWithRoundSettings(delay: 2.0, animate: 1.0)
            return 4
        } else if level == 3 {
            return 5
        } else if level == 4 {
            changeSingleSquareColor(delay: 0.2, animate: 0.15)
            changeSingleSquareColor(delay: 0.6, animate: 0.15)
            changeSingleSquareColor(delay: 0.9, animate: 0.15)
            changeSingleSquareColor(delay: 1.2, animate: 0.15)
            changeSingleSquareColor(delay: 1.5, animate: 0.15)
            changeSingleSquareColor(delay: 1.8, animate: 0.15)
            changeSingleSquareColor(delay: 2.1, animate: 0.15)
            changeSingleSquareColor(delay: 2.4, animate: 0.15)
            changeSingleSquareColor(delay: 2.7, animate: 0.15)
            return 6
        } else if level == 5 {
            return 6
        } else if level == 6 {
            randomizeCardsWithRoundSettings(delay: 0.5, animate: 1.0)
            randomizeCardsWithRoundSettings(delay: 2.0, animate: 1.0)
            return 8
        } else if level == 7 {
            return 9
        } else if level == 8 {
            shuffleCards(delay: 2.0, animate: 0.5)
            return 10
        } else if level == 9 {
            return 11
        } else if level == 10 {
            blackout(delay: 2.0, animate: 1.0)
            return 7
        } else if level > 10 && level <= 11 {
            return 12
        } else if level == 12 {
            randomizeCardsWithDifferentSettings(delay: 1.0, animate: 0.5)
            return 13
        } else if level == 13 {
            oppositeCards(delay: 2.5, animate: 1.0)
            return 10
        } else if level > 13 && level <= 15 {
            return 15
        } else if level > 15 && level <= 18 {
            blackout(delay: 2.0, animate: 2.0)
            return 17
        } else {
            return 15
        }
    }
    
    func blackout(delay: TimeInterval, animate: Double) {
        var originalCards: [Card] = []
        
        Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { _ in
            withAnimation(.easeInOut(duration: animate)) {
                originalCards = self.model.blackout()
            }
        }
        
        Timer.scheduledTimer(withTimeInterval: 4.4, repeats: false) { _ in
            withAnimation(.easeInOut(duration: animate)) {
                for index in 0..<self.model.cards.count {
                    self.model.cards[index].color = originalCards[index].color
                }
            }
        }
    }
    
    func changeSingleSquareColor(delay: TimeInterval, animate: Double) {
        let delayChange = 0.25
        let index = model.getUniqueRandomIndexes(max: 9, count: 1)
        var original: Color = .blue
        
        Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { _ in
            withAnimation(.easeInOut(duration: animate)) {
                if self.model.cards[index[0]].color != .green {
                    original = self.model.changeSingleSquareColor(index: index[0])
                }
            }
        }
        
        Timer.scheduledTimer(withTimeInterval: delay + delayChange, repeats: false) { _ in
            withAnimation(.easeInOut(duration: animate)) {
                self.model.cards[index[0]].color = original
            }
        }
    }
    
    func hideBoardWithDifferentColors(delay: TimeInterval, animate: Double) {
        var originalCards: [Card] = []
        
        Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { _ in
            withAnimation(.easeInOut(duration: animate)) {
                originalCards = self.model.quickChangeCardColors()
            }
        }
        
        Timer.scheduledTimer(withTimeInterval: delay + animate, repeats: false) { _ in
            withAnimation(.easeInOut(duration: animate)) {
                for index in 0..<self.model.cards.count {
                    self.model.cards[index].color = originalCards[index].color
                }
            }
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

//
//  MemoryGame.swift
//  memorysquares
//
//  Created by Tyler Reed on 4/16/22.
//

import Foundation
import SwiftUI

struct MemoryGame: View {
    var cards: [Card] = []
    var numberOfCards: Int
    var numberOfCardsToMemorize: Int
    var numberOfCardsChosen: Int = 0
    var randomChosenIndexes: [Int] = []
    var numberOfLives: Int = 3
    
    init(numberOfCards: Int, numberOfCardsToMemorize: Int) {
        self.numberOfCards = numberOfCards
        self.numberOfCardsToMemorize = numberOfCardsToMemorize
        self.randomChosenIndexes = getUniqueRandomIndexes(max: self.numberOfCards, count: self.numberOfCardsToMemorize)
        
        for index in 0..<self.numberOfCards {
            if randomChosenIndexes.contains(index) {
                cards.append(Card(id: index, isChosen: true))
            } else {
                cards.append(Card(id: index))
            }
            
            print(cards[index])
        }
    }
    
    mutating func resetVariables() {
        self.randomChosenIndexes.removeAll()
        self.numberOfCardsChosen = 0
    }
    
    // check if the game is over
    // then check if the card tapped by user is a chosen square
    // then check if the user has already tapped the chosen square to not count towards the game count
    mutating func chooseCard(card: Card) {
        if !isGameOver() {
            if let chosenIndex = cards.firstIndex(where: { cardInTheArray in cardInTheArray.id == card.id }), cards[chosenIndex].isChosen {
                if !cards[chosenIndex].hasBeenChosenAndPressed {
                    toggleCardMatch(card: card)
                    numberOfCardsChosen += 1
                    cards[chosenIndex].hasBeenChosenAndPressed = true
                }
            } else {
                numberOfLives -= 1
            }
        } else {
            print("Game is over.")
        }
        
        print(numberOfCardsChosen)
    }
    
    mutating func toggleCardMatch(card: Card) {
        if let chosenIndex = cards.firstIndex(where: { aCardInTheCardsArray in aCardInTheCardsArray.id == card.id }) {
            cards[chosenIndex].isMatched = true
        }
    }
    
    func isGameOver() -> Bool {
        if numberOfLives == 0 {
            return true
        }
        
        return false
    }
    
    func checkDidWinRound() -> Bool {
        if numberOfCardsChosen == numberOfCardsToMemorize {
            return true
        }
        
        return false
    }
    
    func getUniqueRandomIndexes(max: Int, count: Int) -> [Int] {
        var set = Set<Int>()
        
        while set.count < count {
            set.insert(Int.random(in: 0..<max))
        }
        
        return Array(set)
    }
    
    func getNumberOfLives() -> Int {
        return numberOfLives
    }
    
    var body: some View {
        ZStack {
            
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.blue)
            RoundedRectangle(cornerRadius: 10)
                .stroke()
                .fill(.blue)
        }
    }
}

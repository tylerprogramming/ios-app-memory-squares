//
//  MemoryGame.swift
//  memorysquares
//
//  Created by Tyler Reed on 4/16/22.
//

import Foundation
import SwiftUI
import AVFoundation

struct MemoryGame: View {
    var cards: [Card] = []
    var randomChosenIndexes: [Int] = []
    var numberOfCards: Int
    var numberOfCardsToMemorize: Int
    var numberOfCardsCorrectlyChosen: Int = 0
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
        }
    }
    
    mutating func randomizeCardsWithRoundSettings() {
        randomChosenIndexes = getUniqueRandomIndexes(max: numberOfCards, count: numberOfCardsToMemorize)
    
        for index in 0..<numberOfCards {
            if randomChosenIndexes.contains(index) {
                if !cards[index].isChosen {
                    cards[index].isChosen = true
                }
            } else {
                cards[index].isChosen = false
            }
        }
    }
    
    mutating func randomizeCardsWithDifferentSettings() {
        let randomNumberOfCardsToMemorize = numberOfCardsToMemorize + Int.random(in: 1..<numberOfCardsToMemorize)
        
        numberOfCardsToMemorize = randomNumberOfCardsToMemorize
        randomChosenIndexes = getUniqueRandomIndexes(max: numberOfCards, count: randomNumberOfCardsToMemorize)
        
        for index in 0..<numberOfCards {
            if randomChosenIndexes.contains(index) {
                if !cards[index].isChosen {
                    cards[index].isChosen = true
                }
            } else {
                cards[index].isChosen = false
            }
        }
    }
    
    mutating func oppositeCards() {
        var newNumberOfCards = 0
        
        for index in 0..<self.numberOfCards {
            if !cards[index].isChosen {
                cards[index].isChosen = true
                newNumberOfCards += 1
            } else {
                cards[index].isChosen = false
            }
        }
        
        self.numberOfCards = newNumberOfCards
    }
    
    // check if the game is over
    // then check if the card tapped by user is a chosen square
    // then check if the user has already tapped the chosen square to not count towards the game count
    // toggle the card isMatched property to true
    // increment number of cards correctly chosen
    // find the carrd in the array based on the index and change property that it was correctly chosed and has been pressed to true
    // changing cards should only happen here, and not directly change the cards array from struct
    //TODO: Add more of the game logic here
    //TODO: Add view modifiers, sounds, and animations to the CardView on tapped gestures
    mutating func chooseCard(card: Card) {
        if !isGameOver() {
            let chosenIndex = cards.firstIndex(where: { cardInTheArray in cardInTheArray.id == card.id })
            
            if cards[chosenIndex!].isChosen {
                if !cards[chosenIndex!].hasBeenChosenAndPressed {
                    cards[chosenIndex!].isMatched = true
                    cards[chosenIndex!].hasBeenChosenAndPressed = true
                    numberOfCardsCorrectlyChosen += 1
                }
            } else {
                if !cards[chosenIndex!].hasBeenPressed {
                    cards[chosenIndex!].hasBeenPressed = true
                    numberOfLives -= 1
                }
            }
        } else {
            print("dont do anything")
        }
    }
    
    // game is over when the number of lives equals zero
    func isGameOver() -> Bool {
        if numberOfLives == 0 {
            return true
        }
        
        return false
    }
    
    // won the round if the number of cards correctly chosen is equal to the number needed to memorize that round
    func checkDidWinRound() -> Bool {
        if numberOfCardsCorrectlyChosen == numberOfCardsToMemorize {
            return true
        }
        
        return false
    }
    
    // get a unique number of indexes so they can be chosen as the ones to memorize for a round
    func getUniqueRandomIndexes(max: Int, count: Int) -> [Int] {
        var set = Set<Int>()
        
        while set.count < count {
            set.insert(Int.random(in: 0..<max))
        }
        
        return Array(set)
    }
    
    // randomize the cards again
    mutating func randomizeCards() {
        for index in 0..<self.numberOfCards {
            if !cards[index].isChosen {
                cards[index].isChosen = true
            } else {
                cards[index].isChosen = false
            }
        }
    }
    
    // get number of lives for current round
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

//
//  CardView.swift
//  memorysquares
//
//  Created by Tyler Reed on 4/16/22.
//

import SwiftUI
import AVFoundation

struct CardView: View {
    @ObservedObject var soundManager: SoundManager
    @ObservedObject var modelView: MemoryGameManager
    
    @State var numberOfShakes: CGFloat = 0
    
    var card: Card
    
    var body: some View {
        ZStack {
            // if the card wasn't a chosen card and it was pressed, means it was incorrect
            if !card.isMatched && card.hasBeenPressed {
                CardShape(color: card.color.opacity(0.5), radius: 5)
                // if the card has not been pressed yet, so we need to check if user taps a chosen card (it matches)
            } else if !card.isMatched {
                if card.isChosen && card.hasBeenPressed {
                    CardShape(color: card.color)
                } else {
                    CardShape(color: .blue)
                    .onTapGesture {
                        // still in the current round, so the round isn't over yet
                        if modelView.readyForNextRound == false {
                            withAnimation(.easeIn(duration: 0.2)) {
                                self.modelView.choose(card: card)

                                // card is not a chosen card, so it's incorrect
                                if !card.isChosen {
                                    numberOfShakes = 5
                                    soundManager.play(sound: .wrongsquare)
                                }
                            }
                            
                            // only play round win sound when the last correct square is tapped
                            // otherwise play the correctsquare sound
                            if modelView.checkDidWinRound {
                                soundManager.play(sound: .roundwin)
                            }
                            if card.isChosen {
                                soundManager.play(sound: .correctsquare)
                            }

                            numberOfShakes = 0
                        } else {
                            print("ready for next round, so can't press the buttons")
                        }
                    }
                    .modifier(ShakeEffect(shakeNumber: numberOfShakes))
                }
            } else {
                if card.hasBeenPressed {
                    CardShape(color: .blue, radius: 5)
                } else {
                    CardShape(color: card.color, radius: 5)
                    Circle().fill(.green)
                        .modifier(ParticlesModifier())
                }
            }
        }
    }
}

struct ChosenCardView: View {
    var card: Card
    
    var body: some View {
        ZStack {
            if card.isChosen {
                CardShape(color: card.color, radius: 5)
            } else {
                CardShape(color: card.color, radius: 5)
            }
        }
        
    }
}

struct CardShape: View {
    var color: Color
    var radius: CGFloat = 0
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(color)
            .shadow(radius: radius)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(
            soundManager: SoundManager(),
            modelView: MemoryGameManager(
                totalSquares: 9,
                totalChosenSquares: 4
            ),
            card: Card(id: 100))
    }
}

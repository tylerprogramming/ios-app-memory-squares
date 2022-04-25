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
        GeometryReader { geometry in
            ZStack {
                if !card.isMatched && card.hasBeenPressed {
                    CardShape(color: .blue.opacity(0.5), radius: 5)
                } else if !card.isMatched {
                    CardShape(color: .blue)
                        .onTapGesture {
                            if modelView.readyForNextRound == false {
                                withAnimation(.easeIn(duration: 0.2)) {
                                    self.modelView.choose(card: card)

                                    if !card.isChosen {
                                        numberOfShakes = 5
                                        soundManager.play(sound: .wrongsquare)
                                    }
                                }
                                
                                if modelView.checkDidWinRound {
                                    soundManager.play(sound: .roundwin)
                                }

                                numberOfShakes = 0
                            } else {
                                print("ready for next round, so can't press the buttonss")
                            }
                        }
                        .modifier(ShakeEffect(shakeNumber: numberOfShakes))
                } else {
                    CardShape(color: .white, radius: 5)
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
                CardShape(color: .white, radius: 5)
            } else {
                CardShape(color: .blue, radius: 5)
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

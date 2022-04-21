//
//  CardView.swift
//  memorysquares
//
//  Created by Tyler Reed on 4/16/22.
//

import SwiftUI
import AVFoundation

class SoundManager {
    static let instance = SoundManager()
    
    var player: AVAudioPlayer?
    
    enum SoundOption: String {
        case wrongsquare
        case roundwin
        case countdown
    }
    
    func playSound(sound: SoundOption) {
        
        guard let url = Bundle.main.url(forResource: sound.rawValue, withExtension: ".wav") else { return }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.volume = 0.1
            player?.play()
        } catch let error {
            print("Error playing sound. \(error.localizedDescription)")
        }
    }
}

struct CardView: View {
    @ObservedObject var modelView: MemoryGameModelView
    @State var numberOfShakes: CGFloat = 0
    
    var card: Card
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                let shape = RoundedRectangle(cornerRadius: DrawingConstraints.cornerRadius)
                
                if !card.isMatched {
                    shape.fill(.blue)
                        .onTapGesture {
                            withAnimation(.easeIn(duration: 0.2)) {
                                self.modelView.choose(card: card)

                                if !card.isChosen {
                                    numberOfShakes = 5
                                    SoundManager.instance.playSound(sound: .wrongsquare)
                                }
                            }
                            
                            if modelView.checkDidWinRound {
                                SoundManager.instance.playSound(sound: .roundwin)
                            }

                            numberOfShakes = 0
                        }
                        .modifier(ShakeEffect(shakeNumber: numberOfShakes))
                } else {
                    // make this happen when is matched but hadn't been pressed yet for just that square
                    shape.fill(.white)
                    Circle().fill(.green)
                        .modifier(ParticlesModifier())
                }
            }
        }
    }
    
    private struct DrawingConstraints {
        static let cornerRadius: CGFloat = 10
    }
}

struct ChosenCardView: View {
    var card: Card
    
    var body: some View {
        ZStack {
            if card.isChosen {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.white)
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.blue)
            }
        }
    }
}

struct ShakeEffect: AnimatableModifier {
    var shakeNumber: CGFloat = 0

    var animatableData: CGFloat {
        get {
            shakeNumber
        } set {
            shakeNumber = newValue
        }
    }

    func body(content: Content) -> some View {
        content
            .offset(x: sin(shakeNumber * .pi * 2) * 10)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(modelView: MemoryGameModelView(totalSquares: 9, totalChosenSquares: 4), card: Card(id: 100))
    }
}

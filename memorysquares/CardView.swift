//
//  CardView.swift
//  memorysquares
//
//  Created by Tyler Reed on 4/16/22.
//

import SwiftUI

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
                                }
                            }

                            numberOfShakes = 0
                        }
                        .modifier(ShakeEffect(shakeNumber: numberOfShakes))
                } else {
                    shape.fill(.white)
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

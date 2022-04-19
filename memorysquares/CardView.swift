//
//  CardView.swift
//  memorysquares
//
//  Created by Tyler Reed on 4/16/22.
//

import SwiftUI

struct CardView: View {
    var card: Card
    
    var body: some View {
        ZStack {
            if !card.isMatched {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.blue)
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.white)
            }
        }
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

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: Card(id: 100))
    }
}

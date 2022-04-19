//
//  ContentView.swift
//  memorysquares
//
//  Created by Tyler Reed on 4/15/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var modelView: MemoryGameModelView
    @State var showGameView = false
    @State var gameRound: Int = 1
    
    // We can make the square's size a constant and use that
    let squareSize: CGFloat = 100
      
    var body: some View {
        ZStack {
            // the background color
            Color.blue.opacity(0.3)
            
            VStack {
                
                Text(!modelView.checkDidWinRound && !modelView.isGameOver ? "Round \(gameRound)" : "Game Over :(")
                // This will be our desired spacing we want for our grid
                // If you want the grid to be truly square you can just set this to 'squareSize'
                let spacingDesired: CGFloat = 10
 
                let columns = [
                    GridItem(.fixed(squareSize), alignment: .center),
                    GridItem(.fixed(squareSize), alignment: .center),
                    GridItem(.fixed(squareSize), alignment: .center),
                    GridItem(.fixed(squareSize), alignment: .center)
                ]

                if !modelView.checkDidWinRound && !modelView.isGameOver {
                    // We then use the 'spacingDesired' in the grid
                    LazyVGrid(columns: columns, alignment: .center, pinnedViews: [], content: {
                      ForEach(modelView.cards) { card in
                          if showGameView {
                              CardView(card: card).onTapGesture {
                                  self.modelView.choose(card: card)
                              }
                              .frame(width: 100, height: 100)
                          } else {
                              ChosenCardView(card: card)
                                  .frame(width: 100, height: 100)
                          }
                      }
                    })
                    .padding(10)
                    .onAppear {
                        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (_) in
                            withAnimation {
                                self.showGameView = true
                            }
                        }
                    }
                } else {
                    // We then use the 'spacingDesired' in the grid
                    LazyVGrid(columns: columns, alignment: .center, spacing: spacingDesired, pinnedViews: [], content: {
                      ForEach(modelView.cards) { card in
                          if showGameView {
                              CardView(card: card).onTapGesture {
                                  self.modelView.choose(card: card)
                              }
                              .frame(width: 100, height: 100)
                          } else {
                              ChosenCardView(card: card)
                                  .frame(width: 100, height: 100)
                          }
                      }
                    })
                    .onAppear {
                        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (_) in
                            withAnimation {
                                self.showGameView = false
                                self.gameRound += 1
                                modelView.restartGame()
                            }
                        }
                    }
                }
                
                Text("Number of Lives: \(modelView.getNumberOfLives)")
            }
        }
        .ignoresSafeArea()
    }
}

// Our preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(modelView: MemoryGameModelView())
    }
}

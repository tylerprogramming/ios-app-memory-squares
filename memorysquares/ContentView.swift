//
//  ContentView.swift
//  memorysquares
//
//  Created by Tyler Reed on 4/15/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var soundManager: SoundManager
    @ObservedObject var modelView: MemoryGameManager
    
    @State var showGameView = false
    @State private var timerStart = 0.0
    @State private var timerEnd = 4.0
    @State private var showTimer: Bool = false
    
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationView {
            VStack {
                if modelView.isGameOver {
                    withAnimation(.easeInOut(duration: 2)) {
                        gameOverView
                    }
                } else {
                    gameRoundView
                }
                
                VStack {
                    AspectVGrid(items: modelView.cards, aspectRatio: 1, content: { card in
                        cardView(for: card)
                    })
                }.onChange(of: modelView.readyForNextRound) { newValue in
                    if modelView.checkDidWinRound {
                        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (_) in
                            withAnimation {
                                modelView.nextRound()
                            }
                        }
                    }
                }

                Spacer()
                
                if showTimer {
                    ProgressView("", value: timerStart, total: 120)
                        .scaleEffect(x: 1, y: 5, anchor: .bottom)
                        .onReceive(timer) { _ in
                            withAnimation(.easeInOut(duration: 2)) {
                                if timerStart < 120 {
                                    timerStart += 3
                                } else {
                                    showTimer = false
                                }
                            }
                        }
                        .onAppear {
                            soundManager.play(sound: .countdown)
                        }
                        .padding()
                }
                
                Spacer()
                
                livesView
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [.white, .blue.opacity(0.4)]),
                    startPoint: UnitPoint(x: 0.2, y: 0.2),
                    endPoint: .bottomTrailing
            ))
            .onAppear {
                modelView.restartGame()
            }
        }
        .ignoresSafeArea()
    }
    
    var livesView: some View {
        HStack {
            if modelView.getNumberOfLives > 2 {
                Image(systemName: "heart.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.red)
                    .overlay {
                        Image(systemName: "heart")
                            .font(.system(size: 62))
                            .foregroundColor(.white)
                    }
                    .shadow(radius: 8)
            } else {
                Image(systemName: "heart.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.blue.opacity(0.3))
            }
                    
            if modelView.getNumberOfLives > 1 {
                Image(systemName: "heart.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.red)
                    .overlay {
                        Image(systemName: "heart")
                            .font(.system(size: 62))
                            .foregroundColor(.white)
                    }
                    .shadow(radius: 8)
            } else {
                Image(systemName: "heart.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.blue.opacity(0.3))
            }
                    
            if modelView.getNumberOfLives > 0 {
                Image(systemName: "heart.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.red)
                    .overlay {
                        Image(systemName: "heart")
                            .font(.system(size: 62))
                            .foregroundColor(.white)
                    }
                    .shadow(radius: 8)
            } else {
                Image(systemName: "heart.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.blue.opacity(0.3))
            }
        }
    }
    
    var gameRoundView: some View {
        Text(!modelView.checkDidWinRound ? "Round \(modelView.round)" : "Good Job!")
            .font(.largeTitle)
            .fontWeight(.heavy)
            .foregroundColor(!modelView.isGameOver ? .white : .red)
            .minimumScaleFactor(0.5)
            .shadow(radius: 5)
            .onAppear {
                soundManager.play(sound: .backgroundmusic)
            }
    }
    
    var gameOverView: some View {
        VStack {
            Text("Game Over")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .foregroundColor(!modelView.isGameOver ? .white : .red)
                .minimumScaleFactor(0.5)
                .shadow(radius: 5)
            Spacer()
            Button {
                modelView.restartGame()
                showTimer = true
                timerStart = 0.0
                showGameView = false
            } label: {
                Text("Play Again?")
            }
            .padding()
            .tint(.green)
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.roundedRectangle(radius: 5))
            .shadow(radius: 2)
            .controlSize(.large)
            .font(.title)
        }
    }
      
    @ViewBuilder
    private func cardView(for card: Card) -> some View {
        if !modelView.checkDidWinRound && !modelView.isGameOver {
            if showGameView {
                CardView(soundManager: soundManager, modelView: modelView, card: card)
                    .padding(4)
            } else {
                ChosenCardView(card: card)
                    .padding(4)
                    .onAppear {
                        showTimer = true
                        timerStart = 0.0
                        Timer.scheduledTimer(withTimeInterval: timerEnd, repeats: false) { (_) in
                            withAnimation {
                                self.showGameView = true
                            }
                        }
                    }
            }
        } else if modelView.checkDidWinRound {
            CardView(soundManager: soundManager, modelView: modelView, card: card)
                .padding(4)
            .onAppear {
                modelView.readyForNextRound = true
                
                Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (_) in
                    withAnimation {
                        self.showGameView = false
                    }
                }
            }
        }
    }
}

// Our preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            soundManager: SoundManager(),
            modelView: MemoryGameManager(
                totalSquares: 16,
                totalChosenSquares: 6
            )
        )
    }
}

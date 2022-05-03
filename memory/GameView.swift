//
//  ContentView.swift
//  memorysquares
//
//  Created by Tyler Reed on 4/15/22.
//

import SwiftUI

struct GameView: View {
    @ObservedObject var soundManager: SoundManager
    @ObservedObject var modelView: MemoryGameManager

    @State var readyToStartGame = false
    @State var showGameView = false
    @State private var timerStart = 0.0
    @State private var timerEnd = 4.0
    @State private var showTimer: Bool = false
    @State private var pulse: Bool = false
    @State private var isRotated: Bool = false
    @State private var animateGradient = false
    @State private var showHelpSheet = false
    @State private var headerOpacity = 0.0
    @State private var titleOffset = 200.0
    @State private var progress = 0.0
    
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    private func pulsateButton() {
        withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
            pulse.toggle()
        }
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.green.opacity(0.3), .white.opacity(0.3)],
                startPoint: animateGradient ? .topLeading : .bottomLeading,
                endPoint: animateGradient ? .bottomTrailing : .topTrailing
            )
                .hueRotation(.degrees(animateGradient ? 60 : 0))
                .ignoresSafeArea()
                .onAppear {
                    withAnimation(.easeInOut(duration: 5.0).repeatForever(autoreverses: true)) {
                        animateGradient.toggle()
                    }
                }
            if readyToStartGame {
                withAnimation(.easeInOut(duration: 2)) {
                    main
                }
            } else {
                VStack {
                    HStack {
                        Image(systemName: "brain.head.profile")
                            .foregroundColor(.green)
                            .font(.system(size: 70))
                            .frame(width: 50, height: 150)
                            .shadow(radius: 25)
                            .padding()
                            .opacity(headerOpacity)
                            .onAppear {
                                withAnimation(.interpolatingSpring(stiffness: 50, damping: 1)) {
                                    headerOpacity += 1.0
                                }
                            }
                        Text("MEMORY SQUARES")
                            .font(.system(size: 55))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .shadow(radius: 25)
                            .offset(x: titleOffset, y: 0)
                            .onAppear {
                                withAnimation(.easeInOut(duration: 1.5)) {
                                    titleOffset = 0
                                }
                            }
                    }
                    .padding()
                    
                    startButton
                }
            }
        }
        .sheet(isPresented: $showHelpSheet) {
            HelpView()
        }
    }
    
    var main: some View {
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
                    ProgressView("", value: timerStart, total: modelView.progressViewValue)
                        .scaleEffect(x: 1, y: 5, anchor: .bottom)
                        .onReceive(timer) { _ in
                            withAnimation(.easeInOut(duration: 2)) {
                                if timerStart < modelView.progressViewValue {
                                    timerStart += modelView.timerStartIncrement
                                } else {
                                    showTimer = false
                                }
                            }
                        }
                        .onAppear {
                            if modelView.oneSecondMode {
                                soundManager.play(sound: .countdownonesecond)
                            } else {
                                soundManager.play(sound: .countdown)
                            }
                        }
                        .padding()
                } else {
                    // this is here to keep the space so the cards don't re-order themselves on certain number of squares in play
                    ProgressView("")
                        .opacity(0.0)
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
    
    var startButton: some View {
        VStack {
            Button {
                modelView.startGame(timerIncrement: 2.5)
                readyToStartGame = true
            } label: {
                ZStack {
                    withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: false).speed(0.5)) {
                        Circle()
                            .stroke(lineWidth: 40)
                            .frame(width: 200, height: 200)
                            .foregroundColor(.green)
                            .scaleEffect(pulse ? 1.5 : 1)
                            .opacity(pulse ? 0 : 1)
                            .padding()
                            .onAppear {
                                pulse.toggle()
                            }
                    }
                    Circle()
                        .frame(width: 200, height: 200)
                        .foregroundColor(.green)
                        .shadow(radius: 25)
                    Circle()
                        .stroke(style: StrokeStyle(lineWidth: 10, dash: [5]))
                        .frame(width: 190, height: 190)
                        .foregroundColor(.white)
                        .rotationEffect(.degrees(isRotated ? 360 : 0))
                    Image(systemName: "play.circle")
                        .font(.system(size: 180))
                        .foregroundColor(.white)
                        .shadow(radius: 25)
                        .padding(20)
                }
            }
            .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: pulse)
            .onAppear {
                withAnimation(.linear(duration: 5.0).repeatForever(autoreverses: false)) {
                    isRotated.toggle()
                }
            }
            
            Button {
                modelView.startGame(timerIncrement: 10.0)
                readyToStartGame = true
                modelView.oneSecondMode = true
            } label: {
                ZStack {
                    Circle()
                        .stroke(lineWidth: 20.0)
                        .opacity(0.3)
                        .foregroundColor(.red)
                        .shadow(radius: 25)
                    Circle()
                        .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                        .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                        .foregroundColor(.red)
                        .rotationEffect(Angle(degrees: 270.0))
                        .onAppear {
                            withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: false)) {
                                progress = 1.0
                            }
                        }
                    Image(systemName: "01.circle.fill")
                        .font(.system(size: 185))
                        .foregroundColor(.red)
                        .shadow(radius: 25)
                    Image(systemName: "01.circle")
                        .font(.system(size: 185))
                        .foregroundColor(.white)
                        
                }
                .padding()
            }
            
            Spacer()
            
            HStack(spacing: 10) {
                Spacer()
                
                Button {
                    showHelpSheet.toggle()
                } label: {
                    Image(systemName: "questionmark.circle")
                        .foregroundColor(.cyan)
                        .font(.system(size: 40))
                }
                .padding(.trailing, 20)
            }
        }
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
                soundManager.removeSounds()
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
                        Timer.scheduledTimer(withTimeInterval: modelView.timerEnd, repeats: false) { (_) in
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
        GameView(
            soundManager: SoundManager(),
            modelView: MemoryGameManager(
                totalSquares: 16,
                totalChosenSquares: 6
            )
        )
    }
}

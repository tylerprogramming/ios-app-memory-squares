//
//  memorysquaresApp.swift
//  memorysquares
//
//  Created by Tyler Reed on 4/15/22.
//

import SwiftUI

@main
struct memorysquaresApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(
                soundManager: SoundManager(),
                modelView: MemoryGameManager(
                    totalSquares: 9, totalChosenSquares: 4
                )
            )
        }
    }
}

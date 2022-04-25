//
//  SoundManager.swift
//  memorysquares
//
//  Created by Tyler Reed on 4/21/22.
//

import Foundation
import AVFoundation

class SoundManager: ObservableObject {
    var soundPlayers: [AVAudioPlayer] = []
    
    enum SoundOption: String {
        case wrongsquare
        case roundwin
        case countdown
        case backgroundmusic
    }
    
    func play(sound: SoundOption) {
        var soundExtension = ""
        
        if sound == .backgroundmusic {
            soundExtension = ".mp3"
        } else {
            soundExtension = ".wav"
        }
        
        guard let url = Bundle.main.url(forResource: sound.rawValue, withExtension: soundExtension) else { return }
        
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            
            if soundPlayers.contains(player) {
                if player.isPlaying == false {
                    player.prepareToPlay()
                    player.play()
                } else {
                    print("already playing this sound: \(url)")
                }
            } else {
                soundPlayers.append(player)
                player.prepareToPlay()
                player.play()
            }
        } catch let error {
            print("Error playing sound. \(error.localizedDescription)")
        }
    }
}

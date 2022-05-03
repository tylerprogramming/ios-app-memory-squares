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
        case correctsquare
        case roundwin
        case countdown
        case backgroundmusic
        case countdownonesecond
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
            
            if isMp3(soundExtension: soundExtension) {
                player.volume = 0.1
            } else {
                player.volume = 0.5
            }
            
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
    
    func isMp3(soundExtension: String) -> Bool {
        if soundExtension == ".mp3" {
            return true
        }
        
        return false
    }
    
    func removeSounds() {
        soundPlayers.removeAll()
    }
}

//
//  playBGM.swift
//  ArcadeGameTemplate
//
//  Created by Jakub Mantelli on 17/12/23.
//
import SpriteKit
import AVFoundation

extension ArcadeGameScene {
    func playBackgroundMusic() {
        do {
            if let backgroundMusicURL = Bundle.main.url(forResource: "ost", withExtension: "wav") {
                backgroundMusicPlayer = try AVAudioPlayer(contentsOf: backgroundMusicURL)
                backgroundMusicPlayer?.numberOfLoops = -1 // -1 means loop indefinitely
                backgroundMusicPlayer?.volume = 0.3 // Adjust the volume as needed
                backgroundMusicPlayer?.prepareToPlay()
                backgroundMusicPlayer?.play()
            }
        } catch {
            print("Error playing background music: \(error.localizedDescription)")
        }
        
        
    }
    
   
    
}


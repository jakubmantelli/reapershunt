//
//  AudioManager.swift
//  ArcadeGameTemplate
//
//  Created by Mohammad Solki on 18/12/23.
//

import SwiftUI
import AVFoundation

class AudioManager: ObservableObject {
    static let shared = AudioManager()
    
    private var menuMusicPlayer: AVAudioPlayer?
    private var backgroundMusicPlayer: AVAudioPlayer?

    
    @Published var isMusicPlaying: Bool = true {
        didSet {
            if isMusicPlaying {
                playMenuMusic()
            } else {
                stopMusic()
            }
        }
    }
    
    init() {
        setupAudio()
    }
    
    private func setupAudio() {
        // Set up your audio players here
        // Example: Load audio files and initialize AVAudioPlayer instances
    }
    
    func playMenuMusic() {
        do {
            if let menuMusicURL = Bundle.main.url(forResource: "ost menu", withExtension: "wav") {
                menuMusicPlayer = try AVAudioPlayer(contentsOf: menuMusicURL)
                menuMusicPlayer?.numberOfLoops = -1 // -1 means loop indefinitely
                menuMusicPlayer?.volume = 0.3 // Adjust the volume as needed
                menuMusicPlayer?.prepareToPlay()
                menuMusicPlayer?.play()
           
            }
        } catch {
            print("Error playing background music: \(error.localizedDescription)")
        }
    }
    
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
    
    func stopMusic() {
        menuMusicPlayer?.stop()
        backgroundMusicPlayer?.stop()
    }
}

//struct AudioManagerView: View {
//    @ObservedObject private var audioManager = AudioManager.shared
//    
//    var body: some View {
//        VStack {
//            // Your main menu content here
//            
//            // Music on/off toggle button
//            Toggle(isOn: $audioManager.isMusicPlaying, label: {
//                Text("Music")
//            })
//            .padding()
//        }
//        .onAppear {
//            // Play menu music when the view appears
//            audioManager.playMenuMusic()
//        }
//    }
//}


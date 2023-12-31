//
//  MainScreen.swift
//  ArcadeGameTemplate
//

import SwiftUI
import AVFoundation
/**
 * # MainScreenView
 *
 *   This view is responsible for presenting the game name, the game intructions and to start the game.
 *  - Customize it as much as you want.
 *  - Experiment with colors and effects on the interface
 *  - Adapt the "Insert a Coin Button" to the visual identity of your game
 **/

struct MainScreenView: View {
    
    // The game state is used to transition between the different states of the game
    @Binding var currentGameState: GameState
    @State private var showingTut = false
    @State private var showingCred = false
    @ObservedObject private var audioManager = AudioManager.shared

    
   
   
    // Change it on the Constants.swift file
    let accentColor: Color = MainScreenProperties.accentColor
    
    @State var menuMusicPlayer: AVAudioPlayer?
 
    var body: some View {
        
        NavigationView {
            
            ZStack {
                
                //Background Image
                
                Image("Reaper's Hunt Home - BG")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
             
                
                
                VStack(alignment: .center) {
                   
                    
                      Spacer(minLength: 280)
 // Play Button
                    
                    
                    Button {
                        withAnimation { self.startGame() }
                        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                        audioManager.stopMusic()
                    
                        
                    
                        
                       
                    } label: {
                        Text("")
                            .foregroundColor(.white)
                            .font(.subheadline)
                        
                            .background(Image("Reaper's Hunt Home - Start Game BTN")
                                .resizable()
                                .frame(width: 350, height: 63)
                            ).frame(width: 350, height: 63, alignment: .center)
                    }
                    
                    
// Tutorial button
                    
                    
                    Button {
                        showingTut.toggle()
                        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                        
                    } label: {
                        Text("")
                            .foregroundColor(.white)
                            .font(.subheadline)
                        
                            .background(Image("Reapers_Hunt_Home_-_How_to_Play_BTN")
                                .resizable()
                                .frame(width: 350, height: 63)
                                        
                            ).frame(width: 350, height: 63, alignment: .center)
                        
                        
                    }.sheet(isPresented: $showingTut) {
                        TutorialView()
                    }
                   
                    
                    .padding(.top, 10)
                    
 // Credits button
                    Button {
                        showingCred.toggle()
                        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                    } label: {
                        Text("")
                           
                        
                            .background(Image("Reaper's Hunt Home - Credits BTN")
                                .resizable()
                                .frame(width: 350, height: 63)
                                        
                            ).frame(width: 350, height: 63, alignment: .center)
                        
                    }   .sheet(isPresented: $showingCred) {
                        CreditsView()
                    }
                  
                    .padding(.top, 10)
                    
                    Button {
                        // Toggle the music on/off
                        audioManager.isMusicPlaying.toggle()
                        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                    } label: {
                        Text("")
                            .background(
                                Image(audioManager.isMusicPlaying ? "Reaper's Hunt Home - Volume On BTN" : "Reaper's Hunt Home - Volume Off BTN")
                                    .resizable()
                                    .frame(width: 63, height: 63)
                            )
                            .frame(width: 63, height: 63, alignment: .center)
                            .padding(.top, 10)
                    }
                    .onAppear {
                        // Call the playMenuMusic() when the view appears
                        audioManager.playMenuMusic()
                    }
                    
                    Spacer()

                  /*  Button {
                        menuMusicPlayer?.stop()
                 
                        
                    } label: {
                        Text("")
                          
                        .background(Image("Reaper's Hunt Home - Volume On BTN")
                            .resizable()
                            .frame(width: 400, height: 400)
                         
                        ).frame(width: 100, height: 100, alignment: .center)
              
                        
                    }
                   
                 */
//                        .onAppear {
//                                        //call music func
//                                        playMenuMusic()
//                                    }
                        
    
                        
                    
            
                        
                    }
                    .navigationBarHidden(true)
                    .padding()
                    .statusBar(hidden: true)
                    
                    
                }
                
                
                
            }
            
            
        }
        
    
           /**
     * Function responsible to start the game.
     * It changes the current game state to present the view which houses the game scene.
     */
    private func startGame() {
        print("- Starting the game...")
        self.currentGameState = .playing
        menuMusicPlayer?.stop()
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
}






#Preview {
    MainScreenView(currentGameState: .constant(GameState.mainScreen))
}

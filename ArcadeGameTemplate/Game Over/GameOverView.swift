//
//  GameOverView.swift
//  ArcadeGameTemplate
//

import SwiftUI

/**
 * # GameOverView
 *   This view is responsible for showing the game over state of the game.
 *  Currently it only present buttons to take the player back to the main screen or restart the game.
 *
 *  You can also present score of the player, present any kind of achievements or rewards the player
 *  might have accomplished during the game session, etc...
 **/

struct GameOverView: View {
    
    @Binding var currentGameState: GameState
    
    
    var body: some View {
        
        HStack {
            ZStack {
                VStack(alignment: .center) {
                    
                    
                  
                    
                    
                    Text("GAME OVER")
                        .bold()
                        .foregroundStyle(Color.white)
                        .background(Image("Button06").frame(width: 100, height: 100, alignment: .center))
                        .padding(.top, 200)
                    
                    Spacer()
                    
                    Button {
                        withAnimation { self.restartGame() }
                    } label: {
                        Text("Retry")
                            .foregroundColor(.white)
                            .font(.subheadline)
                        
                            .background(Image("Button03").frame(width: 100, height: 100, alignment: .center))
                    }
                    
                    Button {
                        withAnimation { self.backToMainScreen() }
                    } label: {
                        Text("Main Menu")
                        
                            .foregroundColor(.white)
                            .font(.subheadline)
                        
                            .background(Image("Button03")).frame(width: 100, height: 100, alignment: .center)
                    }
                    
                    .padding()
                    Spacer()
                    
                }
                .navigationBarHidden(true)
            }
            .background(Image("MessageBox04"))
            .padding(.top, 50)
            
            
        }
        
        .statusBar(hidden: true)
    }
    
    private func backToMainScreen() {
        self.currentGameState = .mainScreen
    }
    
    private func restartGame() {
        self.currentGameState = .playing
    }
}

#Preview {
    GameOverView(currentGameState: .constant(GameState.gameOver))
}

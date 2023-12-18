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
                    
        
                    Spacer(minLength: 250)
                    Text("You hunted \(ArcadeGameLogic.shared.currentScore) Souls!")
                        .foregroundStyle(Color.white)
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .padding()
                    Text("Highest Score: \(ArcadeGameLogic.shared.highScore) ")
                        .foregroundStyle(Color.white)
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    
                        
                    
                    Button {
                        withAnimation { self.restartGame() }
                    } label: {
                        Text("")
                            .foregroundColor(.white)
                            .font(.subheadline)
                        
                            .background(Image("Game_Over_-_Retry_BTN")
                                .resizable()
                                .frame(width: 300, height: 50)
                            
                            ).frame(width: 100, height: 100, alignment: .center)
                    }
                    
                    Button {
                        withAnimation { self.backToMainScreen() }
                    } label: {
                        Text("")
                        
                            .foregroundColor(.white)
                            .font(.subheadline)
                        
                            .background(Image("Game_Over_-_Main_Menu_BTN")
                                .resizable()
                                .frame(width: 300, height: 50)
                            
                            ).frame(width: 100, height: 100, alignment: .center)
                    }
                    
                    .padding(.top, -30)
                    Spacer()
                    
                }
                .navigationBarHidden(true)
            }
            .background(Image("Game_Over_Panel")
                .resizable()
                .frame(width: 430, height: 1000))
            
         
            
            
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

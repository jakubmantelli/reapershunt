//
//  MainScreen.swift
//  ArcadeGameTemplate
//

import SwiftUI

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
    
    
    
    // Change it on the Constants.swift file
    var gameInstructions: [Instruction] = MainScreenProperties.gameInstructions
    
    // Change it on the Constants.swift file
    let accentColor: Color = MainScreenProperties.accentColor
    
    var body: some View {
        
        ZStack {
            VStack(alignment: .center, spacing: 16.0) {
                Spacer()
                /**
                 * # PRO TIP!
                 * The game title can be customized to represent the visual identity of the game
                 */
               
                
                Spacer()
                
                /**
                 * To customize the instructions, check the **Constants.swift** file
                 */
                ForEach(self.gameInstructions, id: \.title) { instruction in
                    GroupBox(label: Label("\(instruction.title)", systemImage: "\(instruction.icon)").foregroundColor(Color.red)) {
                        HStack {
                            Text("\(instruction.description)")
                                .font(.callout)
                            Spacer()
                        }
                    }
                }
                
                Spacer()
                
                /**
                 * Customize the appearance of the **Insert a Coin** button to match the visual identity of your game
                 */
                Button {
                    withAnimation { self.startGame() }
                } label: {
                    Text("Play")
                        .padding()
                        .frame(maxWidth: 200)
                }
                .foregroundColor(.white)
                .background(Color.red)
                .cornerRadius(10.0)
                
            }
            .navigationBarHidden(true)
            .padding()
            .statusBar(hidden: true)
        }
        .background(
            Image("Reaper's Hunt Home - BG")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
        )
    }
    
           /**
     * Function responsible to start the game.
     * It changes the current game state to present the view which houses the game scene.
     */
    private func startGame() {
        print("- Starting the game...")
        self.currentGameState = .playing
    }
}

#Preview {
    MainScreenView(currentGameState: .constant(GameState.mainScreen))
}

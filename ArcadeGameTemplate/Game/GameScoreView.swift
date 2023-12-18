//
//  GameScoreView.swift
//  ArcadeGameTemplate
//

import SwiftUI

/**
 * # GameScoreView
 * Custom UI to present how many points the player has scored.
 *
 * Customize it to match the visual identity of your game.
 */

struct GameScoreView: View {
    @Binding var score: Int
    
    var body: some View {
        ZStack {
            Text("\(score)")
                .foregroundColor(.white)
                .font(.custom("font", size: 40))
                .bold()
                .opacity(1)
                .background(Image("Counter - Panel")
                    .resizable()
                    .frame(width:300, height: 60)
            
              
                    )
                
                .padding(.top, 90)
           
    
            
            
        }
        
        
    }
    
}

#Preview {
    GameScoreView(score: .constant(100))
        .previewLayout(.fixed(width: 300, height: 100))
}


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
            
       
            Text("\(score)")
                .foregroundColor(.red)
                
            
        
       
        
    }
    
}

#Preview {
    GameScoreView(score: .constant(100))
        .previewLayout(.fixed(width: 300, height: 100))
}


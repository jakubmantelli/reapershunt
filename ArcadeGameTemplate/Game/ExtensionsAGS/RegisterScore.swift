//
//  RegisterScore.swift
//  ArcadeGameTemplate
//

import SwiftUI
import SpriteKit

// MARK: - Register Score
extension ArcadeGameScene {
    
    func registerScore() {
           let newScore = ArcadeGameLogic.shared.currentScore

           // Check if it's a new high score
           if newScore > gameLogic.highScore {
               gameLogic.highScore = newScore
               print("New High Score: \(newScore)")
           }

           print("Current Score: \(gameLogic.currentScore), High Score: \(gameLogic.highScore)")
       }
    }
    




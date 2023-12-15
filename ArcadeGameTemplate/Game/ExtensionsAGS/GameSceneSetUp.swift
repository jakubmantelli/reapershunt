//
//  GameSceneSetUp.swift
//  ArcadeGameTemplate
//

import SwiftUI
import SpriteKit

// MARK: - Game Scene Set Up
extension ArcadeGameScene {
    
    private func setUpGame() {
        self.gameLogic.setUpGame()
        self.backgroundColor = SKColor.white
        
        // TODO: Customize!
    }
    
    private func setUpPhysicsWorld() {
        // TODO: Customize!
    }
    
    private func restartGame() {
        self.gameLogic.restartGame()
    }
}

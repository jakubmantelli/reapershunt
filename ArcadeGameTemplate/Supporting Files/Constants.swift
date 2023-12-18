//
//  Constants.swift
//  ArcadeGameTemplate
//

import Foundation
import SwiftUI

/**
 * # Constants
 *
 * This file gathers contant values that are shared all around the project.
 * Modifying the values of these constants will reflect along the complete interface of the application.
 *
 **/


/**
 * # GameState
 * Defines the different states of the game.
 * Used for supporting the navigation in the project template.
 */

enum GameState {
    case mainScreen
    case playing
    case gameOver
}

typealias Instruction = (icon: String, title: String, description: String)

/**
 * # MainScreenProperties
 *
 * Keeps the information that shows up on the main screen of the game.
 *
 */

struct MainScreenProperties {
  
    
    static let gameInstructions: [Instruction] = [
        (icon: "hand.raised", title: "Collect Souls ", description: "Collect souls that run away from you!"),
        (icon: "hand.tap", title: "Your Health Matters!", description: "Watch out for your health, as your vital orb decreases if you dont harvest souls"),
        (icon: "hand.draw", title: "Survive", description: "Survive and prove that you are the true Grim Reaper successor!")
    ]
    
    /**
     * To change the Accent Color of the applciation edit it on the Assets folder.
     */
    
    static let accentColor: Color = Color.accentColor
}




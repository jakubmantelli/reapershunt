//
//  PowerUps.swift
//  ArcadeGameTemplate
//
//  Created by Vitor Kalil on 19/12/23.
//

import Foundation

import SwiftUI
import SpriteKit

extension ArcadeGameScene {
    func increaseSpeed(_ time:Double = 5){
        let pauser = SKAction.wait(forDuration: time)
        let trigger = SKAction.run{
            self.playerSpeed = 10
        }
        let endTrigger = SKAction.run{
            self.playerSpeed = 3
        }
        let increaseSpeedAction = SKAction.sequence([ trigger,pauser,endTrigger ])
        self.run(increaseSpeedAction,withKey: "speedy")}
}

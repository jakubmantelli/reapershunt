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
    
    // Function to add Power Up to the scene
    func addPowerUpGodSpeed() {
        let power = SKSpriteNode(imageNamed: "GODspeed_flask_anim_f1")
        power.name = "powerUpGodSpeed" // Asignar un nombre único
        power.setScale(mapScaleFactor)
        var powerPosition:CGPoint
        var distance:CGFloat
        repeat {
            powerPosition = CGPoint(x: Int.random(in: -774...774), y: Int.random(in: -548...548))
            distance = hypot(powerPosition.x - skeleton.position.x, powerPosition.y - skeleton.position.y)
        } while (distance < 200)
        power.position = powerPosition
        power.zPosition = 1
        self.addChild(power)
        let appearAnimationR:SKAction
        var texturesAppear:[SKTexture] = []
        let idleAnimationR:SKAction
        var texturesIdle:[SKTexture] = []
        for i in 0...3 {
            texturesAppear.append(SKTexture(imageNamed:"GODspeed_flask_anim_f\(i)"))
        }
        appearAnimationR = SKAction.animate(with: texturesAppear, timePerFrame: 0.1)
        for i in 0...3 {
            texturesIdle.append(SKTexture(imageNamed:"GODspeed_flask_anim_f\(i)"))
        }
        idleAnimationR = SKAction.animate(with: texturesIdle, timePerFrame: 0.2)
        power.run(appearAnimationR){
        power.run(SKAction.repeatForever(idleAnimationR),withKey: "idleAnimation")}
        
    }
    
    func increaseSpeed(_ spid:Double = 10){
        let pauser = SKAction.wait(forDuration: 2)
        let trigger = SKAction.run{
            self.playerSpeed += spid
        }
        let endTrigger = SKAction.run{
            self.playerSpeed = 3
        }
        let increaseSpeedAction = SKAction.sequence([ trigger,pauser,endTrigger ])
        self.run(increaseSpeedAction,withKey: "speedy")}
    
}

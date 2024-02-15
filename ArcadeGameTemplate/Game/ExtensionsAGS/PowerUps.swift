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
    func addPowerUpSpeed() {
        let power = SKSpriteNode(imageNamed: "speed_flask_anim_f1")
        power.name = "powerUpSpeed" // Asignar un nombre único
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

        let idleAnimation:SKAction
        var texturesIdle:[SKTexture] = []
        for i in 0...3 {
            texturesIdle.append(SKTextureA(imageNamed:"speed_flask_anim_f\(i)"))
        }
        idleAnimation = SKAction.animate(with: texturesIdle, timePerFrame: 0.2)
        power.run(SKAction.repeatForever(idleAnimation),withKey: "idleAnimation")
        
    }    
    func addPowerUpGodMode() {
        let power = SKSpriteNode(imageNamed: "GODspeed_flask_anim_f1")
        power.name = "powerUpGodMode" // Asignar un nombre único
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

        let idleAnimation:SKAction
        var texturesIdle:[SKTexture] = []
        for i in 0...3 {
            texturesIdle.append(SKTextureA(imageNamed:"GODspeed_flask_anim_f\(i)"))
        }
        idleAnimation = SKAction.animate(with: texturesIdle, timePerFrame: 0.2)
        power.run(SKAction.repeatForever(idleAnimation),withKey: "idleAnimation")
        
    }
    
    // Define a function to tie powerUp and Effects
    func powerUpEffect(powerUpName:String){
        switch powerUpName {
        case "powerUpGodMode":
            self.increaseSpeed(speed:4,durationTime: 5)
            self.stopHealthLoss()
        case "powerUpSpeed":
            self.increaseSpeed()
        default:
            print("Unknown power up name!!")
        }
    }
    // Power up effects
    func increaseSpeed(speed:Double = 2, durationTime: Double = 8){
        let pauser = SKAction.wait(forDuration: 1)
        let mainPauser = SKAction.wait(forDuration: durationTime)
        // So, both of the triggers down here were set in a way that the player cannot keep getting faster with many potions
        // another thing solved by this logic is to prevent trigger of making the player slower
        // and to prevent antiTrigger of making the player faster
        let trigger = SKAction.run{
            self.playerSpeed = self.playerSpeed < 3 + speed ? 3 + speed : max(self.playerSpeed,3+2*speed)
        }
        let antiTrigger = SKAction.run{
            self.playerSpeed = min(3 + speed,self.playerSpeed)
        }
        
        let endTrigger = SKAction.run{
            self.playerSpeed = 3
        }
        let increaseSpeedAction = SKAction.sequence([ trigger,pauser,trigger,mainPauser,antiTrigger,pauser,endTrigger ])
        self.run(increaseSpeedAction,withKey: "speedy")}
    
    func stopHealthLoss(durationTime:Double = 7){
        let pauser = SKAction.wait(forDuration: durationTime)
        let trigger = SKAction.run{
            ArcadeGameLogic.shared.stopHealthTimer()
        }
        let endTrigger = SKAction.run{
            ArcadeGameLogic.shared.startHealthTimer(self.lifePerSecond)
        }
        let godModeAction = SKAction.sequence([ trigger,pauser,endTrigger ])
        self.run(godModeAction,withKey: "gody")

    }
    
}

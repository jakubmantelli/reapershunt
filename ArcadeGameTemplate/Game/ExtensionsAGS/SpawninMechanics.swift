//
//  SpawninMechanics.swift
//  ArcadeGameTemplate
//
//  Created by Vitor Kalil on 19/12/23.
//

import SwiftUI
import SpriteKit

extension ArcadeGameScene {
    
    func repeaterSpawn(_ time:Double = 2){
        let pauser = SKAction.wait(forDuration: time)
        let trigger = SKAction.run{
            if self.soulCount < 30 {self.addSoulToScene()}
        }
        let pauseThenTrigger = SKAction.sequence([ pauser, trigger ])
        let repeatForever = SKAction.repeatForever(pauseThenTrigger)
        self.run( repeatForever ,withKey: "spawner")}
    
    func powerUpSpawn(){
        
    }
    
    func repeaterFixer(){
        let pauser = SKAction.wait(forDuration: 15.0)
        // Trigger that runs every 15 secounds
        let trigger = SKAction.run{
            if self.secondPerLife > 0.55 {
                self.secondPerLife -= 0.15
            }
            ArcadeGameLogic.shared.stopHealthTimer()
            ArcadeGameLogic.shared.startHealthTimer(self.secondPerLife)
            self.removeAction(forKey: "spawner")
            self.repeaterSpawn((self.sinFunc[self.counterSpawn%10] + 1))
            self.counterSpawn += 1
            self.addPowerUp()
        }
        // ---------------------
        
        let pauseThenTrigger = SKAction.sequence([ pauser, trigger ])
        let repeatForever = SKAction.repeatForever(pauseThenTrigger)
        self.run( repeatForever ,withKey: "life")
    }
    
    
    func addSoulToScene() {
        // We put the soul into the scene
        self.soulCount += 1
        let soul = SKSpriteNode(imageNamed: "soul_idle_anim_f0_L")
        soul.name = "soul" // Asignar un nombre único
        soul.setScale(mapScaleFactor)
        var soulPosition:CGPoint
        var distance:CGFloat
        repeat {
            soulPosition = CGPoint(x: self.quadrant[self.quadrantIndex][0] + Int.random(in: 0...516), y: self.quadrant[self.quadrantIndex][1] + Int.random(in: 0...548))
            distance = hypot(soulPosition.x - skeleton.position.x, soulPosition.y - skeleton.position.y)
        } while (distance < 200)
        incrementQuadrant()
        soul.position = soulPosition
        soul.zPosition = 1
        self.addChild(soul)
        let appearAnimationR:SKAction
        var texturesAppear:[SKTexture] = []
        let idleAnimationR:SKAction
        var texturesIdle:[SKTexture] = []
        for i in 0...4 {
            texturesAppear.append(SKTexture(imageNamed:"soul_appear_anim_f\(i)_L"))
        }
        appearAnimationR = SKAction.animate(with: texturesAppear, timePerFrame: 0.1)
        
        
        for i in 0...4 {
            texturesIdle.append(SKTexture(imageNamed:"soul_idle_anim_f\(i)_L"))
        }
        idleAnimationR = SKAction.animate(with: texturesIdle, timePerFrame: 0.2)
        soul.run(appearAnimationR){
            soul.run(SKAction.repeatForever(idleAnimationR),withKey: "idleAnimation")}
        
    }
    
    // Function to add Power Up to the scene
    func addPowerUp() {
        let power = SKSpriteNode(imageNamed: "GODspeed_flask_anim_f1")
        power.name = "powerUps" // Asignar un nombre único
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
    
    func incrementQuadrant(){
        self.quadrantIndex == 5 ? (self.quadrantIndex = 0) : (self.quadrantIndex += 1)
    }
}

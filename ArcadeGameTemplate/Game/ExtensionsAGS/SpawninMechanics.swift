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
    func repeaterFixer(){
        let pauser = SKAction.wait(forDuration: 15.0)
        // Trigger that runs every 15 secounds
        let trigger = SKAction.run{
            self.lifePerSecond = self.lifePerSecond > 0.4 ? self.lifePerSecond - 0.15 : self.lifePerSecond
            
            ArcadeGameLogic.shared.stopHealthTimer()
            ArcadeGameLogic.shared.startHealthTimer(self.lifePerSecond)
            self.removeAction(forKey: "spawner")
            self.repeaterSpawn((self.sinFunc[self.counterSpawn%10] + 1))
            self.counterSpawn += 1
            self.spawnRandomPowerUp()
            print(self.lifePerSecond)
            
        }
        // ---------------------
        
        let pauseThenTrigger = SKAction.sequence([ pauser, trigger ])
        let repeatForever = SKAction.repeatForever(pauseThenTrigger)
        self.run( repeatForever ,withKey: "life")
    }
    
    func animatingSoulR(soul:SKSpriteNode) {
        
        if soul.action(forKey: "idleAnimationL") != nil{
            let idleAnimationR:SKAction
            var texturesIdle:[SKTexture] = []
            for i in 0...4 {
                texturesIdle.append(SKTextureA(imageNamed:"soul_idle_anim_f\(i)_R"))
            }
            idleAnimationR = SKAction.animate(with: texturesIdle, timePerFrame: 0.2)
            
            soul.removeAllActions()
            soul.run(SKAction.repeatForever(idleAnimationR),withKey: "idleAnimationR")}
    }    
    func animatingSoulL(soul:SKSpriteNode) {
        
        if soul.action(forKey: "idleAnimationR") != nil{
            let idleAnimationR:SKAction
            var texturesIdle:[SKTexture] = []
            for i in 0...4 {
                texturesIdle.append(SKTextureA(imageNamed:"soul_idle_anim_f\(i)_L"))
            }
            idleAnimationR = SKAction.animate(with: texturesIdle, timePerFrame: 0.2)
            
            soul.removeAllActions()
            soul.run(SKAction.repeatForever(idleAnimationR),withKey: "idleAnimationL")}
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
            texturesAppear.append(SKTextureA(imageNamed:"soul_appear_anim_f\(i)_L"))
        }
        appearAnimationR = SKAction.animate(with: texturesAppear, timePerFrame: 0.1)
        
        
        for i in 0...4 {
            texturesIdle.append(SKTextureA(imageNamed:"soul_idle_anim_f\(i)_L"))
        }
        idleAnimationR = SKAction.animate(with: texturesIdle, timePerFrame: 0.2)
        soul.run(appearAnimationR){
            soul.run(SKAction.repeatForever(idleAnimationR),withKey: "idleAnimationL")}
        
    }
    

    //Aux functions
    
    func incrementQuadrant(){
        self.quadrantIndex == 5 ? (self.quadrantIndex = 0) : (self.quadrantIndex += 1)
    }
    
    //Function to add random power up to the scene when called
    func spawnRandomPowerUp(){
        // this array controls the probabilities by the proportion of a powerUps name (more -> more likely to spawn)
        let arrayOfProbabilities:[String] = ["powerUpGodMode","powerUpSpeed","powerUpSpeed","powerUpSpeed","powerUpSpeed","powerUpSpeed","powerUpSpeed","","",""]
        let powerUpToSpawn:String = arrayOfProbabilities.randomElement()!
        switch powerUpToSpawn{
        case "powerUpGodMode":
            self.addPowerUpGodMode()
        case "powerUpSpeed":
            self.addPowerUpSpeed()
        case "":
            print("no spawn")
        default:
            print("Issue with function spawnRandomPowerUp on Spawn file")
        }
    }
    
}

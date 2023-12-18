//
//  SoulsMovement.swift
//  ArcadeGameTemplate
//

import SwiftUI
import SpriteKit

extension ArcadeGameScene {
    
    func addSoulToScene() {
        // We put the soul into the scene
        let soul = SKSpriteNode(imageNamed: "soul_idle_anim_f0_L")
        soul.name = "soul" // Asignar un nombre único
        soul.setScale(mapScaleFactor)
        var soulPosition:CGPoint
        var distance:CGFloat
        repeat {
            soulPosition = CGPoint(x: 750*CGFloat.random(in: -1...1), y: 450*CGFloat.random(in: -1...1))
            distance = hypot(soulPosition.x - skeleton.position.x, soulPosition.y - skeleton.position.y)
            print(soulPosition)
            print(distance)
        } while (distance < 200)
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
        for i in 0...4 {
            texturesIdle.append(SKTexture(imageNamed:"soul_idle_anim_f\(4-i)_L"))
        }
        idleAnimationR = SKAction.animate(with: texturesIdle, timePerFrame: 0.2)
        soul.run(appearAnimationR){
            soul.run(SKAction.repeatForever(idleAnimationR),withKey: "idleAnimation")}
        
    }
    
    // Manages the soul's movement for every case.
    func moveSoulAwayFromPlayer() {
        self.enumerateChildNodes(withName: "soul") { (node, stop) in
            guard let soul = node as? SKSpriteNode else { return }

            let playerPosition = self.skeleton.position
            let soulPosition = soul.position
            let distance = hypot(soulPosition.x - playerPosition.x, soulPosition.y - playerPosition.y)
            let soulKey = "\(soul.position)" // Unique identifier for each soul

            switch distance {
                // It moves directly away from the player.
            case 0..<120:
                self.randomDirectionsForSouls[soulKey] = nil  // Resets the random direction.
                self.moveSoulDirectlyAwayFromPlayer(playerPosition: playerPosition, soulPosition: soulPosition, distance: distance, soul: soul)
                // It moves randomly
            case 120..<180:
                if self.randomDirectionsForSouls[soulKey] == nil {
                    // Choses a random direction if it's nil.
                    self.randomDirectionsForSouls[soulKey] = self.randomDirection()
                }
                self.moveSoulInRandomDirection(soulPosition: soulPosition, randomDirection: self.randomDirectionsForSouls[soulKey]!, soul: soul)
                // It stops
            default:
                self.randomDirectionsForSouls[soulKey] = nil // Resets the random direction.
                soul.physicsBody?.velocity = CGVector.zero
            }
        }
    }
    
    func moveSoulDirectlyAwayFromPlayer(playerPosition: CGPoint, soulPosition: CGPoint, distance: CGFloat, soul: SKSpriteNode) {
        let direction = CGVector(dx: soulPosition.x - playerPosition.x, dy: soulPosition.y - playerPosition.y)
        let normalizedDirection = CGVector(dx: direction.dx / distance, dy: direction.dy / distance)
        let velocity = 1.0 // Adjusted speed
        let movement = CGVector(dx: normalizedDirection.dx * velocity, dy: normalizedDirection.dy * velocity)
        updateSoulPosition(soul: soul, potentialPosition: CGPoint(x: soulPosition.x + movement.dx, y: soulPosition.y + movement.dy), movementVector: movement)
    }
    
    func moveSoulInRandomDirection(soulPosition: CGPoint, randomDirection: CGVector, soul: SKSpriteNode) {
        let velocity = 1.0 // Adjusted speed
        let movement = CGVector(dx: randomDirection.dx * velocity, dy: randomDirection.dy * velocity)
        updateSoulPosition(soul: soul, potentialPosition: CGPoint(x: soulPosition.x + movement.dx, y: soulPosition.y + movement.dy), movementVector: movement)
    }
    
    func randomDirection() -> CGVector {
        let randomAngle = CGFloat.random(in: 0..<(2 * .pi))
        return CGVector(dx: cos(randomAngle), dy: sin(randomAngle))
    }
    

    func updateSoulPosition(soul: SKSpriteNode, potentialPosition: CGPoint, movementVector: CGVector) {
        // Verify if the soul is touching the map limits.
        let isAtHorizontalEdge = potentialPosition.x <= mapBounds.minX || potentialPosition.x >= mapBounds.maxX
        let isAtVerticalEdge = potentialPosition.y <= mapBounds.minY || potentialPosition.y >= mapBounds.maxY

        // Update the soul position.
        if !isAtHorizontalEdge {
            soul.position.x += movementVector.dx
        }
        if !isAtVerticalEdge {
            soul.position.y += movementVector.dy
        }
    }
    
}

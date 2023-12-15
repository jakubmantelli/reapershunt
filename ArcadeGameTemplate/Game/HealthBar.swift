//
//  HealthBar.swift
//  ArcadeGameTemplate
//
//  Created by Jakub Mantelli on 13/12/23.
//
import SpriteKit

class HealthBar: SKSpriteNode {
    
    private var maxWidth: CGFloat
    private var initialPlayerHealth: Int
    
    init(maxWidth: CGFloat, initialPlayerHealth: Int) {
        self.maxWidth = maxWidth
        self.initialPlayerHealth = initialPlayerHealth
        
        let size = CGSize(width: maxWidth, height: 5)
        super.init(texture: nil, color: .green, size: size)
        

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateHealth(health: Int) {
        let healthPercentage = CGFloat(health) / CGFloat(initialPlayerHealth)
        var newWidth = maxWidth * healthPercentage
        
        
    
           if newWidth > maxWidth {
               newWidth = maxWidth
           }
        
        
        // Adjust the health bar's size based on the player's health
        size.width = max(0, newWidth)
        
        // Change color based on health (optional)
        let color: SKColor
        if healthPercentage > 0.7 {
            color = .green
        } else if healthPercentage >= 0.4 {
            color = .yellow
        } else {
            color = .red
        }
        self.color = color
    }
}
 


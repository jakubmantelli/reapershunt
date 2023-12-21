//
//  VirtualJoystick.swift
//  ReaperCollector
//
//  Created by Jakub Mantelli on 06/12/23.
//

import SpriteKit


class VirtualJoystick: SKNode {
    
    private var joystickBase: SKSpriteNode!
    private var joystickKnob: SKSpriteNode!
    
    override init() {
        super.init()
        joystickBase = SKSpriteNode(imageNamed: "joystickBase")
        joystickBase.setScale(0.25)
        joystickBase.alpha = 0.5
        addChild(joystickBase)
        
        joystickKnob = SKSpriteNode(imageNamed: "joystickKnob")
        joystickKnob.setScale(0.25)
        joystickKnob.alpha = 0.8
        addChild(joystickKnob)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Implement methods to handle touch events and calculate joystick movement
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Handle touch events to update joystick movement
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let distance = sqrt(pow(location.x, 2) + pow(location.y, 2))
        let angle = atan2(location.y, location.x)
        let maxDistance: CGFloat = 35.0
        let limitedDistance = min(distance, maxDistance)
        joystickKnob.position = CGPoint(x: cos(angle) * limitedDistance, y: sin(angle) * limitedDistance)
    }
    
    func getJoystickDelta() -> CGPoint {
        let deltaX = joystickKnob.position.x / 50.0  // Adjust the divisor based on your preferred sensitivity
        let deltaY = joystickKnob.position.y / 50.0
        return CGPoint(x: deltaX, y: deltaY)
    }
}


// Inside VirtualJoystick.swift
extension VirtualJoystick {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Handle touch events to start joystick movement
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Animate joystick knob back to center
        let resetPosition = SKAction.move(to: .zero, duration: 0.1)
        joystickKnob.run(resetPosition)
    }
}


//  MovementConstraints.swift
//  ArcadeGameTemplate
//

import SpriteKit
import SwiftUI

extension ArcadeGameScene {

    // Calculate the efective limits of the map
    var mapBounds: CGRect {
        let originX = (-scaledWidth / 2) + 20
        let originY = (-scaledHeight / 2) + 40 // Limite inferior
        return CGRect(x: originX, y: originY, width: scaledWidth-70, height: scaledHeight-90)
    }

    // Manages the player position, verifying if it's inside the map.
    func updatePlayerPosition(with joystickDelta: CGPoint) -> (isAtHorizontalEdge: Bool, isAtVerticalEdge: Bool) {
        let speed: CGFloat = 3.0
        let potentialNewPosition = CGPoint(x: skeleton.position.x + joystickDelta.x * speed,
                                           y: skeleton.position.y + joystickDelta.y * speed)

        // Verify if the player is touching a border in the map.
        let isAtHorizontalEdge = skeleton.position.x <= mapBounds.minX || skeleton.position.x >= mapBounds.maxX
        let isAtVerticalEdge = skeleton.position.y <= mapBounds.minY || skeleton.position.y >= mapBounds.maxY

        // Update the player's position
        skeleton.position = CGPoint(
            x: max(min(potentialNewPosition.x, mapBounds.maxX), mapBounds.minX),
            y: max(min(potentialNewPosition.y, mapBounds.maxY), mapBounds.minY)
        )

        return (isAtHorizontalEdge, isAtVerticalEdge)
    }
}

//
//  ArcadeGameScene.swift
//  ArcadeGameTemplate
//

import SpriteKit
import SwiftUI
import AVFoundation

class ArcadeGameScene: SKScene {
    
    /* *** Variables here *** */
    var lifePerSecond:Double = 1
    var secondBetweenSpawn:Double = 2
    var gameState: GameState = .playing
    // healthbar
    private var healthBar: HealthBar!
    // player node
    var skeleton: SKSpriteNode!
    // joystick node
    var virtualJoystick: VirtualJoystick?
    // camera node
    let cam = SKCameraNode()
    // game music
    var backgroundMusicPlayer: AVAudioPlayer?
    // Dimensiones originales del mapa
    var originalMapWidth: CGFloat = 1552
    var originalMapHeight: CGFloat = 1096
    // Factor de escala aplicado al mapa
    var mapScaleFactor: CGFloat = 2.0
    // Dimensiones finales
    var scaledWidth: CGFloat { originalMapWidth * mapScaleFactor }
    var scaledHeight: CGFloat { originalMapHeight * mapScaleFactor }
    var randomDirectionsForSouls: [String: CGVector] = [:]
    var quadrant:[[Int]] = [[-774,-548],[-258,-548],[258,-548],[-774,0],[-258,0],[258,0]]
    var quadrantIndex:Int = 0
    
    
    /// MARK: - didMove FUNCTION
    /// Should be used to make configurations and stablish the view's scene for the first time.
    override func didMove(to view: SKView) {
        //music
        playBackgroundMusic()
        self.camera = cam
        
        // Set the scale mode to scale to fit the window
        self.scaleMode = .aspectFill
        
        // Create the map, centered in scene
        let map = SKSpriteNode(imageNamed: "Dungeon_Mapv2")
        map.position = CGPoint(x: -scaledWidth/2, y: -scaledHeight/2)
        map.zPosition = -2
        map.setScale(mapScaleFactor)
        addChild(map)
        
        //Vitor testing with animation - this down here is the idle animation
        let skeletonAnimation:SKAction
        var textures:[SKTexture] = []
        for i in 0...4 {
            textures.append(SKTexture(imageNamed:"reaper_idle_anim_f\(i)_R"))
        }
        for i in stride(from: 3, through: 0, by: -1) {
            textures.append(textures[i])
        }
        skeletonAnimation = SKAction.animate(with: textures, timePerFrame: 0.2)
        // Create skeleton node
        skeleton = SKSpriteNode(imageNamed: "reaper_idle_anim_f0_R")
        skeleton.setScale(mapScaleFactor)
        skeleton.zPosition = 2
        skeleton.position = CGPoint(x: 0, y: 0)
        addChild(skeleton)
        // Animation
        skeleton.run(SKAction.repeatForever(skeletonAnimation),withKey: "idleAnimation")
        
        // Center the scene anchor point
        self.anchorPoint = CGPoint(x: 0, y: 0)
        // Center the grass node relative to the scene
        map.anchorPoint = CGPoint(x: 0, y: 0)
        skeleton.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        // Add soul to the scene
        for _ in 0...5 {
            addSoulToScene()
        }
        repeaterSpawn()
        repeaterFixer()
        
        // health bar node & update func
        healthBar = HealthBar(maxWidth: 50, initialPlayerHealth: 20)
        healthBar.anchorPoint = CGPoint(x: 0.5, y: 7)
        addChild(healthBar)
    }
    
    
    /// MARK: - updateHealthBar FUNCTION
    func updateHealthBar() {
        healthBar.updateHealth(health: ArcadeGameLogic.shared.playerHealth)
    }
    
    
    
    /// MARK: - startWalkingAnimation FUNCTION
    /// Initiates the walking animation for the skeleton character based on the virtual joystick input.
    func startWalkingAnimation() { // function to do the walking animation, very not optimized btw
        if virtualJoystick?.getJoystickDelta().x ?? 0 > 0 {
            if skeleton.action(forKey: "walkingAnimationR") == nil && skeleton.action(forKey:"attackAnimation") == nil{
                let walkingAnimationR:SKAction
                var textures:[SKTexture] = []
                for i in 0...7 {
                    textures.append(SKTexture(imageNamed:"reaper_run_anim_f\(i)_R"))
                }
                // For cicle with stride function.
                for i in stride(from: 7, through: 0, by: -1) {
                    textures.append(textures[i])
                }
                /* *** *** *** */
                walkingAnimationR = SKAction.animate(with: textures, timePerFrame: 0.1)
                skeleton.run(SKAction.repeatForever(walkingAnimationR),withKey: "walkingAnimationR")
                skeleton.removeAction(forKey: "walkingAnimationL")
            }
        } else if virtualJoystick?.getJoystickDelta().x ?? 0 == 0{
            skeleton.removeAction(forKey: "walkingAnimationR")
            skeleton.removeAction(forKey: "walkingAnimationL")
        }
        else {
            if skeleton.action(forKey: "walkingAnimationL") == nil && skeleton.action(forKey:"attackAnimation") == nil{
                let walkingAnimationL:SKAction
                var textures:[SKTexture] = []
                for i in 0...7 {
                    textures.append(SKTexture(imageNamed:"reaper_run_anim_f\(i)_L"))
                }
                // For cicle with stride function.
                for i in stride(from: 7, through: 0, by: -1) {
                    textures.append(textures[i])
                }
                /* *** *** *** */
                walkingAnimationL = SKAction.animate(with: textures, timePerFrame: 0.1)
                skeleton.run(SKAction.repeatForever(walkingAnimationL),withKey: "walkingAnimationL")
                skeleton.removeAction(forKey: "walkingAnimationR")}
        }
    }
    
    
    
    /// MARK: - startIdleAnimation FUNCTION.
    /// Initiates the idle animation for the skeleton character when it is not in motion.
    func startIdleAnimation() { // function to do the walking animation, very not optimized btw
        if skeleton.action(forKey: "walkingAnimationR") == nil && skeleton.action(forKey:"attackAnimation") == nil{
            let idleAnimationR:SKAction
            var textures:[SKTexture] = []
            for i in 0...4 {
                textures.append(SKTexture(imageNamed:"reaper_idle_anim_f\(i)_L"))
            }
            for i in stride(from: 3, through: 0, by: -1) {
                textures.append(textures[i])
            }
            idleAnimationR = SKAction.animate(with: textures, timePerFrame: 0.2)
            skeleton.run(SKAction.repeatForever(idleAnimationR),withKey: "idleAnimation")
            skeleton.removeAction(forKey: "walkingAnimationL")
        }
        else {
            let idleAnimationR:SKAction
            var textures:[SKTexture] = []
            for i in 0...4 {
                textures.append(SKTexture(imageNamed:"reaper_idle_anim_f\(i)_R"))
            }
            for i in stride(from: 3, through: 0, by: -1) {
                textures.append(textures[i])
            }
            idleAnimationR = SKAction.animate(with: textures, timePerFrame: 0.2)
            skeleton.run(SKAction.repeatForever(idleAnimationR),withKey: "idleAnimation")
            skeleton.removeAction(forKey: "walkingAnimationR")
        }
    }
    
    
    /// MARK: - skeletonPosLimit FUNCTION.
    /// Constrains the reaper's position within specified limits on the x or y axis.
    func skeletonPosLimit(pos:CGFloat,axis:String) -> CGFloat{
        if axis == "x"{
            if pos < -1355 {return -1355}
            else if pos > 1355 {return 1355}
        }
        else if axis == "y"{
            if pos < -655 {return -655}
            else if pos > 675 {return 675}
        }
        return pos
    }

    
    /// MARK: - touchesBegan FUNCTION.
    /// This function is called when a touch begins on the screen. Handles the beginning of touch events and initializes the virtual joystick.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Create and add the virtual joystick into the scene.
        virtualJoystick = VirtualJoystick()
        addChild(virtualJoystick!)
        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
        // Pass touch events to the virtual joystick
        virtualJoystick?.touchesBegan(touches, with: event)
        if let touch = touches.first {
            virtualJoystick?.position = CGPoint(x:(skeletonPosLimit(pos:skeleton.position.x,axis:"x") - (self.frame.width/2) + touch.location(in:self.cam).x),y:(skeletonPosLimit(pos:skeleton.position.y,axis:"y")  + (self.frame.height/2) - touch.location(in:self.cam).y))
        }
    }
    
    
    /// MARK: - touchesMoved FUNCTION.
    /// This function is invoked when a touch on the screen is moved. Responds to touch movement events by updating the virtual joystick and triggering the walking animation.
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Pass touch events to the virtual joystick
        virtualJoystick?.touchesMoved(touches, with: event)
        startWalkingAnimation() // func that I wrote to organize the animation
    }
    
    
    /// MARK: - touchesEnded FUNCTION.
    /// This function is triggered when touch events on the screen end. Handles the end of touch events, transitioning the player to an idle state and removing the virtual joystick.
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Pass touch events to the virtual joystick
        startIdleAnimation()
        virtualJoystick?.removeFromParent()
        virtualJoystick = nil
        virtualJoystick?.touchesEnded(touches, with: event)
    }
    
    
    /// MARK: - update FUNCTION.
    /// This function is called before each frame is rendered and encompasses several key updates:
    /// - Collision Detection: It checks for collisions in the game scene to manage interactions between objects.
    /// - Soul Movement: Automatically moves the 'soul' characters in the scene, based on their logic of movement away from the player.
    /// - Health Bar Update: Continuously updates the health bar's status to reflect the player's current health.
    /// - Player and Camera Movement: Processes input from the virtual joystick to update the player's position. Adjusts the camera's position to follow the player within the defined boundaries.
    override func update(_ currentTime: TimeInterval) {
        
        //check for colisions
        checkColision()
        
        // It moves the soul automatically.
        moveSoulAwayFromPlayer()
        
        // Keeps healthbar updated
        updateHealthBar()
        
        /* Update the player's position and camera based on virtual joystick input. */
        if let joystick = virtualJoystick {
            let joystickDelta = joystick.getJoystickDelta()
            let (isAtHorizontalEdge, isAtVerticalEdge) = updatePlayerPosition(with: joystickDelta)
            let speed: CGFloat = 3.0
            // Camera's position adjusment (positive = right, negative = left)
            if (skeleton.position.x > -1355 && skeleton.position.x < 1355){
                cam.position.x = skeleton.position.x
                if !isAtHorizontalEdge {
                    virtualJoystick?.position.x += joystickDelta.x * speed
                }
            }
            if (skeleton.position.y > -655 && skeleton.position.y < 675){
                cam.position.y = skeleton.position.y
                if !isAtVerticalEdge {
                    virtualJoystick?.position.y += joystickDelta.y * speed
                }
            }
            // fix healthbar to player
            healthBar.position.x = skeleton.position.x
            healthBar.position.y = skeleton.position.y
        }
    }
    
    
    
    /**
     * # The Game Logic
     *     The game logic keeps track of the game variables
     *   you can use it to display information on the SwiftUI view,
     *   for example, and comunicate with the Game Scene.
     **/
    var gameLogic: ArcadeGameLogic = ArcadeGameLogic.shared
    
    // Keeps track of when the last update happend.
    // Used to calculate how much time has passed between updates.
    var lastUpdate: TimeInterval = 0
    /*
     override func didMove(to view: SKView) {
     self.setUpGame()
     self.setUpPhysicsWorld()
     }
     
     override func update(_ currentTime: TimeInterval) {
     
     // ...
     
     // If the game over condition is met, the game will finish
     if self.isGameOver { self.finishGame() }
     
     // The first time the update function is called we must initialize the
     // lastUpdate variable
     if self.lastUpdate == 0 { self.lastUpdate = currentTime }
     
     // Calculates how much time has passed since the last update
     let timeElapsedSinceLastUpdate = currentTime - self.lastUpdate
     // Increments the length of the game session at the game logic
     self.gameLogic.increaseSessionTime(by: timeElapsedSinceLastUpdate)
     
     self.lastUpdate = currentTime
     }*/
    
}


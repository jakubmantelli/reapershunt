//
//  ArcadeGameScene.swift
//  ArcadeGameTemplate
//

import SpriteKit
import SwiftUI
import AVFoundation
class ArcadeGameScene: SKScene {
    
   
    

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
    var originalMapWidth: CGFloat = 1500
    var originalMapHeight: CGFloat = 986
    // Factor de escala aplicado al mapa
    var mapScaleFactor: CGFloat = 2.0
    // Dimensiones finales
    var scaledWidth: CGFloat { originalMapWidth * mapScaleFactor }
    var scaledHeight: CGFloat { originalMapHeight * mapScaleFactor }
    var randomDirectionsForSouls: [String: CGVector] = [:]
    

    
    override func didMove(to view: SKView) {
        
   
        
        
        //music
        playBackgroundMusic()
        
        
        self.camera = cam
    
        // Set the scale mode to scale to fit the window
        self.scaleMode = .aspectFill
        
        // Creamos el mapa, centrado en la escena.
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
        textures.append(textures[3])
        textures.append(textures[2])
        textures.append(textures[1])
        textures.append(textures[0])
        skeletonAnimation = SKAction.animate(with: textures, timePerFrame: 0.2)
        // Example: Create skeleton node
        skeleton = SKSpriteNode(imageNamed: "reaper_idle_anim_f0_R")
        skeleton.setScale(mapScaleFactor)
        skeleton.zPosition = 2
        skeleton.position = CGPoint(x: 0, y: 0)
        addChild(skeleton)
        //animation
        skeleton.run(SKAction.repeatForever(skeletonAnimation),withKey: "idleAnimation")
        
        // Center the scene anchor point
        self.anchorPoint = CGPoint(x: 0, y: 0)
        
        // Center the grass node relative to the scene
        map.anchorPoint = CGPoint(x: 0, y: 0)

        skeleton.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        // Ensure the virtualJoystick is added to the scene
        
        // Add soul to the scene
        addSoulToScene()
        addSoulToScene()
        addSoulToScene()
        addSoulToScene()
        addSoulToScene()
        addSoulToScene()

        
        // health bar node & update func
        healthBar = HealthBar(maxWidth: 50, initialPlayerHealth: 20)
        healthBar.anchorPoint = CGPoint(x: 0.5, y: 7)
        addChild(healthBar)
       
    }
    func updateHealthBar() {
            healthBar.updateHealth(health: ArcadeGameLogic.shared.playerHealth)
        
        }
    

    
    
    // Vitor added animations here - start
    func startWalkingAnimation() { // function to do the walking animation, very not optimized btw
        if virtualJoystick?.getJoystickDelta().x ?? 0 > 0 {
            if skeleton.action(forKey: "walkingAnimationR") == nil && skeleton.action(forKey:"attackAnimation") == nil{
                let walkingAnimationR:SKAction
                var textures:[SKTexture] = []
                for i in 0...7 {
                    textures.append(SKTexture(imageNamed:"reaper_run_anim_f\(i)_R"))
                }
                textures.append(textures[7])
                textures.append(textures[6])
                textures.append(textures[5])
                textures.append(textures[4])
                textures.append(textures[3])
                textures.append(textures[2])
                textures.append(textures[1])
                textures.append(textures[0])
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
                textures.append(textures[7])
                textures.append(textures[6])
                textures.append(textures[5])
                textures.append(textures[4])
                textures.append(textures[3])
                textures.append(textures[2])
                textures.append(textures[1])
                textures.append(textures[0])
                walkingAnimationL = SKAction.animate(with: textures, timePerFrame: 0.1)
                skeleton.run(SKAction.repeatForever(walkingAnimationL),withKey: "walkingAnimationL")
                skeleton.removeAction(forKey: "walkingAnimationR")}
            
        }
    }
    
    
    func startIdleAnimation() { // function to do the walking animation, very not optimized btw
            if skeleton.action(forKey: "walkingAnimationR") == nil && skeleton.action(forKey:"attackAnimation") == nil{
                let idleAnimationR:SKAction
                var textures:[SKTexture] = []
                for i in 0...4 {
                    textures.append(SKTexture(imageNamed:"reaper_idle_anim_f\(i)_L"))
                }
                textures.append(textures[3])
                textures.append(textures[2])
                textures.append(textures[1])
                textures.append(textures[0])
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
                textures.append(textures[3])
                textures.append(textures[2])
                textures.append(textures[1])
                textures.append(textures[0])
                idleAnimationR = SKAction.animate(with: textures, timePerFrame: 0.2)
                skeleton.run(SKAction.repeatForever(idleAnimationR),withKey: "idleAnimation")
                skeleton.removeAction(forKey: "walkingAnimationR")
            }
        }
    
    
    
    func skeletonPosLimit(pos:CGFloat,axis:String) -> CGFloat{
        if axis == "x"{
                    if pos < -1290 {return -1290}
                    else if pos > 1290 {return 1290}
                }
                else if axis == "y"{
                    if pos < -560 {return -560}
                    else if pos > 560 {return 560}
                }
                    return pos
    }
    // Vitor added animations here - finish
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
            print("Touches began")
            virtualJoystick = VirtualJoystick()
            addChild(virtualJoystick!)
        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
            // Pass touch events to the virtual joystick
            virtualJoystick?.touchesBegan(touches, with: event)
            if let touch = touches.first {
                virtualJoystick?.position = CGPoint(x:(skeletonPosLimit(pos:skeleton.position.x,axis:"x") - (self.frame.width/2) + touch.location(in:self.cam).x),y:(skeletonPosLimit(pos:skeleton.position.y,axis:"y")  + (self.frame.height/2) - touch.location(in:self.cam).y))
                    
                addSoulToScene()
            }
            }
    
   
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Pass touch events to the virtual joystick
        virtualJoystick?.touchesMoved(touches, with: event)
        startWalkingAnimation() // func that I wrote to organize the animation
        //Vitor testing with animation
   
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Touches ended")
        // Pass touch events to the virtual joystick
        startIdleAnimation()
        virtualJoystick?.removeFromParent()
        virtualJoystick = nil
        virtualJoystick?.touchesEnded(touches, with: event)
     
 
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
    
            //check for colisions
            checkColision()
            // It moves the soul automatically.
            moveSoulAwayFromPlayer()
            if let joystick = virtualJoystick {
                let joystickDelta = joystick.getJoystickDelta()
                let (isAtHorizontalEdge, isAtVerticalEdge) = updatePlayerPosition(with: joystickDelta)
                let speed: CGFloat = 3.0
                
                
                // Mover el joystick solo en la dirección permitida
                
                
                // Ajuste de la posición de la cámara
                if (skeleton.position.x > -1290 && skeleton.position.x < 1290){
                    cam.position.x = skeleton.position.x
                    if !isAtHorizontalEdge {
                        virtualJoystick?.position.x += joystickDelta.x * speed
                    }
                }
                if (skeleton.position.y > -560 && skeleton.position.y < 555){
                    cam.position.y = skeleton.position.y
                    if !isAtVerticalEdge {
                        virtualJoystick?.position.y += joystickDelta.y * speed
                    }
                }
                // fix healthbar to player
                healthBar.position.x = skeleton.position.x
                healthBar.position.y = skeleton.position.y
                
                
            }
            //keeps healthbar updated
            updateHealthBar()
        
        
        
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

//
//  GameLogic.swift
//  ArcadeGameTemplate
//

// ArcadeGameLogic.swift
import Foundation

import Foundation

class ArcadeGameLogic: ObservableObject {
    
    static let shared: ArcadeGameLogic = ArcadeGameLogic()
    
    // Player's health
    var playerHealth: Int = 20
    private var healthTimer: Timer?
    
    @Published var isGameOver: Bool = false
    
    func setUpGame() {
         

        self.startHealthTimer()
         self.currentScore = 0
         self.sessionDuration = 0
         self.isGameOver = false
     }
   

    func startHealthTimer() {
        healthTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            self?.decreasePlayerHealth()
        }
    }

    func stopHealthTimer() {
        healthTimer?.invalidate()
        healthTimer = nil
    }
    
    func increasePlayerHealth() {
       playerHealth = (playerHealth > 15 ? 20 : (playerHealth + 5))
        print(playerHealth)
        
    }

    func decreasePlayerHealth() {
        playerHealth -= 1
        checkGameOver()
    }
    

    func checkGameOver() {
        if playerHealth == 0 {
            finishTheGame()
        }
        print("Player Health: \(playerHealth)")
        print(isGameOver)
    }

    func finishTheGame() {
        stopHealthTimer()
        isGameOver = true
    }

    func restartGame() {
        playerHealth = 20
        isGameOver = false
        startHealthTimer()
        
        
    }
    
    
  
    // Keeps track of the current score of the player
    @Published var currentScore: Int = 0
    
    // Increases the score by a certain amount of points
    func score(points: Int) {
        currentScore += points
        // Add any additional scoring logic here
    }
    
    // Keep tracks of the duration of the current session in number of seconds
    @Published var sessionDuration: TimeInterval = 0
    
    // Function to increase the session time
    func increaseSessionTime(by timeIncrement: TimeInterval) {
        sessionDuration += timeIncrement
        // Add any additional session time logic here
    }
    
  
    }



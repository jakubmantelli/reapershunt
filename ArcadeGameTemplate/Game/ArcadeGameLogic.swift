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
    
    @Published var highScore: Int {
        didSet {
            UserDefaults.standard.set(highScore, forKey: "HighScore")
        }
    }
    
    init() {
        self.highScore = UserDefaults.standard.integer(forKey: "HighScore")
    }
    
    func setUpGame() {
        self.startHealthTimer()
        self.currentScore = 0
        self.sessionDuration = 0
        self.isGameOver = false
    }
    
    func startHealthTimer(_ time:Double = 1) {
        healthTimer = Timer.scheduledTimer(withTimeInterval: time, repeats: true) { [weak self] timer in
            self?.decreasePlayerHealth()
        }
    }
    
    func stopHealthTimer() {
        healthTimer?.invalidate()
        healthTimer = nil
    }
    
    func increasePlayerHealth() {
        switch self.currentScore {
        case 0...70:
            playerHealth = (playerHealth > 15 ? 20 : (playerHealth + 5))
        case 70...140:
            playerHealth = (playerHealth > 16 ? 20 : (playerHealth + 4))
        default:
            playerHealth = (playerHealth > 17 ? 20 : (playerHealth + 3))
        }
    }
    
    func decreasePlayerHealth() {
        playerHealth -= 1
        checkGameOver()
    }
    
    
    func checkGameOver() {
        if playerHealth == 0 {
            finishTheGame()
        }
    }
    
    func finishTheGame() {
        stopHealthTimer()
        isGameOver = true
        
    }
    
    func restartGame() {
        playerHealth = 20
        isGameOver = false
        startHealthTimer()
        self.currentScore = 0
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

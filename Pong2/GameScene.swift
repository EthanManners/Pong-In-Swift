//
//  GameScene.swift
//  Pong2
//
//  Created by Ethan Manners on 3/1/25.
//

import SpriteKit
import GameplayKit


class GameScene: SKScene {
    
    var ball = SKSpriteNode()
    var enemy = SKSpriteNode()
    var main = SKSpriteNode()
    var mainLbl = SKLabelNode()
    var enemyLbl = SKLabelNode()
    var score = [Int]()
    let array = [-1, 1]
    
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        // Wait for scene to be in a window (not nil) for mouse input
        DispatchQueue.main.async {
            if view.window != nil {
                view.window?.acceptsMouseMovedEvents = true
                view.window?.makeFirstResponder(self)
            }
        }
        // debug line to check if view.window is nil
        // print("view.window is", view.window as Any)

        
        // Cast nodes to SpriteKit types to manipulate with code
        startGame()
        
        enemyLbl = self.childNode(withName: "rightLabel") as!
            SKLabelNode
        mainLbl = self.childNode(withName: "leftLabel") as!
            SKLabelNode
        
        ball = self.childNode(withName: "ball") as! SKSpriteNode
        enemy = self.childNode(withName: "enemy") as! SKSpriteNode
        main = self.childNode(withName: "main") as! SKSpriteNode
        
        // Launch ball at 45 degree angle
        ball.physicsBody?.applyImpulse(CGVector(dx: 20, dy: 20))
        
        //Border physics
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        border.friction = 0
        border.restitution = 1
        self.physicsBody = border
    }

    func startGame() {
        // Set score to 0 and set labels to respective scores
        score = [0,0]
        mainLbl.text = "\(score[1])"
        enemyLbl.text = "\(score[0])"
    }
    
    func addScore(playerWhoWon : SKSpriteNode) {
        // Reset ball position
        ball.position = CGPoint(x: 0, y:0)
        ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        // Increase score and launch ball towards opposite player
        if playerWhoWon == main {
            score[0] += 1
            ball.physicsBody?.applyImpulse(CGVector(dx: 20, dy: (array.shuffled().first)! * 20))
        }
        else if playerWhoWon == enemy {
            score[1] += 1
            ball.physicsBody?.applyImpulse(CGVector(dx: -20, dy: (array.shuffled().first)! * 20))
        }
        
        // Print score to console
        // print(score)
        
        // Update labels
        mainLbl.text = "\(score[1])"
        enemyLbl.text = "\(score[0])"
    }
        
    override func mouseMoved(with event: NSEvent) {
        // Move player paddle y position to mouse
        let location = event.location(in: self)
        main.position.y = location.y
    }

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        // Move enemy y position to ball, (higher duration = more difficulty)
        enemy.run(SKAction.moveTo(y: ball.position.y, duration: 0.42 ))

        // Check for ball being behind paddles
        if ball.position.x <= main.position.x - 70 {
            addScore(playerWhoWon: enemy)
        }
        else if ball.position.x >= enemy.position.x + 70 {
            addScore(playerWhoWon: main)
        }
    }
}

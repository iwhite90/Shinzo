//
//  GameOverScene.swift
//  Shinzo
//
//  Created by Ian White on 24/04/2016.
//  Copyright © 2016 Ian White. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    let defaults = NSUserDefaults.standardUserDefaults()
    var newBestMoves = false
    var newBestTime = false
    var newBestStars = false
    
    init(size: CGSize, moves: Int, time: Double, boardType: String) {
        super.init(size: size)
        
        addBackground()
        
        let numStars = calculateStars(moves, boardType: boardType)
        saveScoreFor(boardType, moves: moves, time: time, stars: numStars)
        
        addStars(numStars)
        addYouWonLabel()
        addMovesLabel(moves)
        addTimeLabel(time)
    }
    
    func saveScoreFor(boardType: String, moves: Int, time: Double, stars: Int) {
        var bestMoves = moves
        var bestTime = time
        var bestStars = stars
        
        if let previousBest = defaults.arrayForKey(boardType) {
            let previousBestMoves: Int = previousBest[0] as! Int
            let previousBestTime: Double = previousBest[1] as! Double
            let previousBestStars: Int = previousBest[2] as! Int
            print("Previous best moves = \(previousBestMoves), best time = \(previousBestTime), best stars = \(previousBestStars)")
            
            if previousBestMoves <= bestMoves {
                bestMoves = previousBestMoves
            } else {
                newBestMoves = true
            }
            if previousBestTime <= bestTime {
                bestTime = previousBestTime
            } else {
                newBestTime = true
            }
            if previousBestStars <= bestStars {
                bestStars = previousBestStars
            } else {
                newBestStars = true
            }
        }
        
        defaults.setObject([bestMoves, bestTime, bestStars], forKey: boardType)
    }
    
    func addBackground() {
        backgroundColor = SKColor.whiteColor()
        let background = SKSpriteNode(imageNamed: "sky")
        background.size = self.frame.size
        background.anchorPoint = .zero
        background.zPosition = -1
        
        self.addChild(background)
    }
    
    func calculateStars(moves: Int, boardType: String) -> Int {
        if isEasyBoard(boardType) {
            return calculateEasyStars(moves)
        } else if isMediumBoard(boardType) {
            return calculateMediumStars(moves)
        } else {
            return calculateHardStars(moves)
        }
    }
    
    func isEasyBoard(boardType: String) -> Bool {
        if boardType == BoardConfig.easyAround || boardType == BoardConfig.easyDiagonal || boardType == BoardConfig.easyStraight {
            return true
        } else {
            return false
        }
    }
    
    func isMediumBoard(boardType: String) -> Bool {
        if boardType == BoardConfig.mediumAround || boardType == BoardConfig.mediumDiagonal || boardType == BoardConfig.mediumStraight {
            return true
        } else {
            return false
        }
    }
    
    func isHardBoard(boardType: String) -> Bool {
        if boardType == BoardConfig.hardAround || boardType == BoardConfig.hardDiagonal || boardType == BoardConfig.hardStraight {
            return true
        } else {
            return false
        }
    }
    
    func calculateEasyStars(moves: Int) -> Int {
        if moves <= 5 {
            return 3
        } else if moves <= 10 {
            return 2
        } else if moves <= 15 {
            return 1
        } else {
            return 0
        }
    }
    
    func calculateMediumStars(moves: Int) -> Int {
        if moves <= 15 {
            return 3
        } else if moves <= 25 {
            return 2
        } else if moves <= 35 {
            return 1
        } else {
            return 0
        }
    }
    
    func calculateHardStars(moves: Int) -> Int {
        if moves <= 25 {
            return 3
        } else if moves <= 40 {
            return 2
        } else if moves <= 55 {
            return 1
        } else {
            return 0
        }
    }
    
    func addStars(numStars: Int) {
        let label = SKLabelNode(fontNamed: "Thonburi")
        label.text = createStarsText(numStars)
        label.fontSize = 40
        label.fontColor = SKColor.yellowColor()
        label.position = CGPoint(x: size.width / 2, y: size.height / 2 + 100)
        
        addChild(label)
    }
    
    func createStarsText(numStars: Int) -> String {
        var stars = ""
        var count = 0
        for _ in 0 ..< numStars {
            stars += "★ "
            count += 1
        }
        
        for _ in count ..< 3 {
            stars += "☆ "
        }
        return stars
    }
    
    func addYouWonLabel() {
        let label = SKLabelNode(fontNamed: "Thonburi")
        label.text = "Winner!"
        label.fontSize = 40
        label.fontColor = SKColor.yellowColor()
        label.position = CGPoint(x: size.width/2, y: size.height/2 + 50)
        
        addChild(label)
    }
    
    func addMovesLabel(moves: Int) {
        let label = SKLabelNode(fontNamed: "Thonburi")
        label.text = "\(moves) moves"
        label.fontSize = 30
        label.fontColor = SKColor.yellowColor()
        label.position = CGPoint(x: size.width/2, y: size.height/2)
        
        addChild(label)
    }
    
    func addTimeLabel(time: Double) {
        let label = SKLabelNode(fontNamed: "Thonburi")
        label.text = "\(String(format: "%.1f", time)) seconds"
        label.fontSize = 30
        label.fontColor = SKColor.yellowColor()
        label.position = CGPoint(x: size.width/2, y: size.height/2 - 50)
        
        addChild(label)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        runAction(SKAction.runBlock() {
            let reveal = SKTransition.flipHorizontalWithDuration(0.5)
            let scene = HomeScene(size: self.size)
            self.view?.presentScene(scene, transition:reveal)
            })
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
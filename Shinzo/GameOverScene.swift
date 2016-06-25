//
//  GameOverScene.swift
//  Shinzo
//
//  Created by Ian White on 24/04/2016.
//  Copyright © 2016 Ian White. All rights reserved.
//

import Foundation
import SpriteKit
import GoogleMobileAds

class GameOverScene: SKScene {
    var gameSceneConfig: GameSceneConfig!
    var newBestMoves = false
    var newBestTime = false
    var newBestStars = false
    
    init(size: CGSize, gameSceneConfig: GameSceneConfig, moves: Int, time: Double) {
        self.gameSceneConfig = gameSceneConfig
        super.init(size: size)
        
        addBackground()
        
        let numStars = calculateStars(moves, boardType: gameSceneConfig.boardConfig, level: gameSceneConfig.level)
        saveScoreFor(gameSceneConfig.boardConfig, level: gameSceneConfig.level, moves: moves, time: time, stars: numStars)
        
        addStars(numStars)
        addYouWonLabel(numStars)
        addMovesLabel(moves)
        addControlButtons()
        //   addTimeLabel(time)
    }
    
    func saveScoreFor(boardType: String, level: Int, moves: Int, time: Double, stars: Int) {
        var bestMoves = moves
        var bestTime = time
        var bestStars = stars
        
        if Data.dataExistsFor(boardType, level: level) {
            let (previousBestMoves, previousBestTime, previousBestStars) = Data.movesTimeAndStarsFor(boardType, level: level)
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
            if previousBestStars >= bestStars {
                bestStars = previousBestStars
            } else {
                newBestStars = true
            }
        }
        
        Data.saveFor(boardType, level: level, moves: bestMoves, time: bestTime, stars: bestStars)
    }
    
    func addBackground() {
        backgroundColor = SKColor.whiteColor()
        let background = SKSpriteNode(imageNamed: "sky")
        background.size = self.frame.size
        background.anchorPoint = .zero
        background.zPosition = -1
        
        self.addChild(background)
    }
    
    func calculateStars(moves: Int, boardType: String, level: Int) -> Int {
        let (threeStars, twoStars, oneStar) = LevelMoves.movesForLevel(level, boardType: boardType)
        
        if moves <= threeStars {
            return 3
        } else if moves <= twoStars {
            return 2
        } else if moves <= oneStar {
            return 1
        } else {
            return 0
        }
    }
    
    func addStars(numStars: Int) {
        let label = SKLabelNode(fontNamed: "Thonburi")
        label.text = createStarsText(numStars)
        label.fontSize = 50
        label.fontColor = SKColor.yellowColor()
        label.position = CGPoint(x: size.width / 2, y: size.height / 2 + 125)
        
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
    
    func addYouWonLabel(numStars: Int) {
        let label = SKLabelNode(fontNamed: "Thonburi")
        
        if numStars == 3 {
            label.text = "Brilliant!"
        } else if numStars == 2 {
            label.text = "Well done!"
        } else if numStars == 1 {
            label.text = "Not bad..."
        } else {
            label.text = "Try again"
        }
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
    
    func addControlButtons() {
        let retryLabel = SKLabelNode(fontNamed: "Thonburi")
        retryLabel.text = "↻"
        retryLabel.fontSize = 60
        retryLabel.name = "retry"
        retryLabel.position = CGPoint(x: size.width * 0.75, y: size.height / 2 - 100)
        
        addChild(retryLabel)
        
        let backLabel = SKLabelNode(fontNamed: "Thonburi")
        backLabel.text = "↞"
        backLabel.fontSize = 60
        backLabel.name = "back"
        backLabel.position = CGPoint(x: size.width / 4, y: size.height / 2 - 100)
        
        addChild(backLabel)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            let node = self.nodeAtPoint(location)
            
            if let name = node.name {
                if name == "back" {
                    goToHomeScreen()
                } else if name == "retry" {
                    restartGame()
                }
            }
        }
    }
    
    func goToHomeScreen() {
        Utils.presentIntersitial()
        runAction(SKAction.runBlock() {
            let reveal = SKTransition.flipHorizontalWithDuration(0.5)
            let scene = HomeScene(size: self.size)
            self.view?.presentScene(scene, transition:reveal)
        })
    }
    
    func restartGame() {
        Utils.presentIntersitial()
        runAction(SKAction.runBlock() {
            let reveal = SKTransition.flipHorizontalWithDuration(0.5)
            let scene = GameScene(size: self.size, gameSceneConfig: self.gameSceneConfig)
            self.view?.presentScene(scene, transition: reveal)
        })
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
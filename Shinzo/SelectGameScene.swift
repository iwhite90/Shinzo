//
//  SelectGameScene.swift
//  Shinzo
//
//  Created by Ian White on 02/05/2016.
//  Copyright © 2016 Ian White. All rights reserved.
//

import Foundation
import SpriteKit

class SelectGameScene: SKScene {
    
    let previousScene: SKScene!
    var gameType: String!
    
    var yOffset: CGFloat {
        return self.frame.height / 7
    }
    
    var quarterX: CGFloat {
        return self.frame.width / 4
    }
    
    var midY: CGFloat {
        return size.height / 2
    }
    
    init(size: CGSize, cameFromScene: SKScene, gameType: String) {
        previousScene = cameFromScene
        super.init(size: size)
        self.gameType = gameType
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        addBackground()
        addTopBar()
        addTitle()
        addLevelButtons()
    }
    
    func addBackground() {
        backgroundColor = SKColor.lightGrayColor()
        let background = SKSpriteNode(imageNamed: "sky")
        background.size = self.frame.size
        background.anchorPoint = .zero
        background.zPosition = -1
        
        self.addChild(background)
    }
    
    func addTopBar() {
        let backArrow = SKLabelNode(fontNamed: "Thonburi")
        backArrow.fontSize = CGFloat(30)
        backArrow.text = "↩"
        backArrow.name = "back"
        backArrow.position = CGPoint(x: 20, y: self.frame.height - self.frame.width / 12)
        
        self.addChild(backArrow)

    }
    
    func addTitle() {
        let titleImage = SKSpriteNode(imageNamed: gameType)
        titleImage.setScale(0.75)
        titleImage.position = CGPoint(x: self.frame.width / 2, y: self.frame.height - yOffset)
        
        self.addChild(titleImage)
    }
    
    func addLevelButtons() {
        let levels = [
            BoardConfig.easyStraight, BoardConfig.mediumStraight, BoardConfig.hardStraight,
            BoardConfig.easyDiagonal, BoardConfig.mediumDiagonal, BoardConfig.hardDiagonal,
            BoardConfig.easyAround, BoardConfig.mediumAround, BoardConfig.hardAround]
        
        let positions = [
            CGPoint(x: quarterX, y: midY + 50), CGPoint(x: quarterX * 2, y: midY + 25), CGPoint(x: quarterX * 3, y: midY + 50),
            CGPoint(x: quarterX, y: midY - 50), CGPoint(x: quarterX * 2, y: midY - 75), CGPoint(x: quarterX * 3, y: midY - 50),
            CGPoint(x: quarterX, y: midY - 150), CGPoint(x: quarterX * 2, y: midY - 175), CGPoint(x: quarterX * 3, y: midY - 150)]
        
        for i in 1 ... 9 {
            let levelButton = SKSpriteNode(imageNamed: "level\(i)open")
            levelButton.name = levels[i - 1]
            levelButton.setScale(0.5)
            levelButton.position = positions[i - 1]
            
            self.addChild(levelButton)
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            let node = self.nodeAtPoint(location)
            
            if let name = node.name {
                if name == "back" {
                    goToPreviousScreen()
                } else {
                    startGame(name)
                }
            }
        }
    }
    
    func goToPreviousScreen() {
        let previousScreenAction = SKAction.runBlock() {
            let reveal = SKTransition.flipHorizontalWithDuration(0.5)
            self.view?.presentScene(self.previousScene, transition: reveal)
        }
        
        self.runAction(previousScreenAction)
    }
    
    func startGame(boardConfig: String) {
        let gameStartAction = SKAction.runBlock() {
            let reveal = SKTransition.flipHorizontalWithDuration(0.5)
            let (numColours, numColoursToWin) = self.unpackGameType(self.gameType)
            let gameStartScene = GameScene(
                size: self.size,
                cameFromScene: self,
                boardConfig: boardConfig,
                numberOfColours: numColours,
                numberOfColoursToWin: numColoursToWin)
            self.view?.presentScene(gameStartScene, transition: reveal)
        }
        
        self.runAction(gameStartAction)
    }
    
    func unpackGameType(gameType: String) -> (Int, Int) {
        var result = (3, 2)
        
        switch gameType {
            case "3-2": result = (3, 2)
            case "3-1": result = (3, 1)
            case "4-3": result = (4, 3)
            case "4-2": result = (4, 2)
            case "4-1": result = (4, 1)
            default: result = (3, 2)
        }
        
        return result
    }
}
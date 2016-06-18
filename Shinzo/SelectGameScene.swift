//
//  SelectGameScene.swift
//  Shinzo
//
//  Created by Ian White on 02/05/2016.
//  Copyright © 2016 Ian White. All rights reserved.
//

import Foundation
import SpriteKit
import GoogleMobileAds

class SelectGameScene: SKScene {
    
    let previousScene: SKScene!
    var gameType: String!
    var level: Int!
    var bannerView: GADBannerView!
    
    var yOffset: CGFloat {
        return self.frame.height / 7
    }
    
    var quarterX: CGFloat {
        return self.frame.width / 4
    }
    
    var midY: CGFloat {
        return size.height / 2
    }
    
    init(size: CGSize, cameFromScene: SKScene, gameType: String, level: Int, bannerView: GADBannerView) {
        previousScene = cameFromScene
        super.init(size: size)
        self.gameType = gameType
        self.level = level
        self.bannerView = bannerView
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        addBackground()
        addTopBar()
        addTitle()
        addLevelButtons()
        Utils.showBannerIfHidden(bannerView)
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
            CGPoint(x: quarterX, y: midY + 100), CGPoint(x: quarterX * 2, y: midY + 85), CGPoint(x: quarterX * 3, y: midY + 70),
            CGPoint(x: quarterX, y: midY), CGPoint(x: quarterX * 2, y: midY - 15), CGPoint(x: quarterX * 3, y: midY - 30),
            CGPoint(x: quarterX, y: midY - 100), CGPoint(x: quarterX * 2, y: midY - 115), CGPoint(x: quarterX * 3, y: midY - 130)]
        
        for i in 1 ... 9 {
            let levelButton = SKSpriteNode(imageNamed: "level\(i)open")
            levelButton.name = levels[i - 1]
            levelButton.setScale(0.5)
            levelButton.position = positions[i - 1]
            
            self.addChild(levelButton)
            
            let starsLabel = createStarsLabel(i)
            starsLabel.position = CGPoint(x: positions[i - 1].x, y: positions[i - 1].y - 55)
            self.addChild(starsLabel)
        }
    }
    
    func createStarsLabel(labelNum: Int) -> SKLabelNode {
        let label = SKLabelNode(fontNamed: "Thonburi")
        let numOfStars = numberOfStarsForLabelNum(labelNum)
        label.text = createStarsText(numOfStars)
        
        if numOfStars == 3 {
            label.fontSize = 20
        } else {
            label.fontSize = 15
        }
        label.fontColor = SKColor.yellowColor()
        
        return label
    }
    
    func numberOfStarsForLabelNum(labelNum: Int) -> Int {
        let boardTypes = [
            BoardConfig.easyStraight,
            BoardConfig.mediumStraight,
            BoardConfig.hardStraight,
            BoardConfig.easyDiagonal,
            BoardConfig.mediumDiagonal,
            BoardConfig.hardDiagonal,
            BoardConfig.easyAround,
            BoardConfig.mediumAround,
            BoardConfig.hardAround]

        return Data.numStarsFor(boardTypes[labelNum - 1], level: level)
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
                level: self.level,
                numberOfColours: numColours,
                numberOfColoursToWin: numColoursToWin,
                bannerView: self.bannerView)
            self.view?.presentScene(gameStartScene, transition: reveal)
        }
        
        Utils.hideBanner(bannerView)
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
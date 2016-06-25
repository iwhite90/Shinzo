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
    var scaleFactor: CGFloat = 1
    
    var yOffset: CGFloat {
        return self.frame.height / 7
    }
    
    var quarterX: CGFloat {
        return self.frame.width / 4
    }
    
    var midY: CGFloat {
        return size.height / 2
    }
    
    init(size: CGSize, cameFromScene: SKScene, gameType: String, level: Int) {
        previousScene = cameFromScene
        super.init(size: size)
        self.gameType = gameType
        self.level = level
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        setScaleFactor()
        addBackground()
        addTopBar()
        addTitle()
        addLevelButtons()
        Utils.showBannerIfHidden(Ads.bannerView)
        displayCoachMark()
    }
    
    func setScaleFactor() {
        if self.frame.height / self.frame.width < 1.4 {
            scaleFactor = 2
        } else if self.frame.height / self.frame.width < 1.6 {
            scaleFactor = 0.8
        }
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
        backArrow.fontSize = 30 * scaleFactor
        backArrow.text = "↩"
        backArrow.name = "back"
        backArrow.position = CGPoint(x: 20 * scaleFactor, y: self.frame.height - self.frame.width / 12)
        
        self.addChild(backArrow)

    }
    
    func addTitle() {
        let titleImage = SKSpriteNode(imageNamed: gameType)
        titleImage.setScale(0.75 * scaleFactor)
        titleImage.position = CGPoint(x: self.frame.width / 2, y: self.frame.height - yOffset)
        
        self.addChild(titleImage)
    }
    
    func addLevelButtons() {
        let levels = [
            BoardConfig.easyStraight, BoardConfig.mediumStraight, BoardConfig.hardStraight,
            BoardConfig.easyDiagonal, BoardConfig.mediumDiagonal, BoardConfig.hardDiagonal,
            BoardConfig.easyAround, BoardConfig.mediumAround, BoardConfig.hardAround]
        
        let positions = [
            CGPoint(x: quarterX, y: midY + 100 * scaleFactor), CGPoint(x: quarterX * 2, y: midY + 85 * scaleFactor), CGPoint(x: quarterX * 3, y: midY + 70 * scaleFactor),
            CGPoint(x: quarterX, y: midY), CGPoint(x: quarterX * 2, y: midY - 15 * scaleFactor), CGPoint(x: quarterX * 3, y: midY - 30 * scaleFactor),
            CGPoint(x: quarterX, y: midY - 100 * scaleFactor), CGPoint(x: quarterX * 2, y: midY - 115 * scaleFactor), CGPoint(x: quarterX * 3, y: midY - 130 * scaleFactor)]
        
        for i in 1 ... 9 {
            let levelButton = SKSpriteNode(imageNamed: "level\(i)open")
            levelButton.name = levels[i - 1]
            levelButton.setScale(0.5 * scaleFactor)
            levelButton.position = positions[i - 1]
            
            self.addChild(levelButton)
            
            let starsLabel = createStarsLabel(i)
            starsLabel.position = CGPoint(x: positions[i - 1].x, y: positions[i - 1].y - 55 * scaleFactor)
            self.addChild(starsLabel)
        }
    }
    
    func createStarsLabel(labelNum: Int) -> SKLabelNode {
        let label = SKLabelNode(fontNamed: "Thonburi")
        let numOfStars = numberOfStarsForLabelNum(labelNum)
        label.text = createStarsText(numOfStars)
        
        if numOfStars == 3 {
            label.fontSize = 20 * scaleFactor
        } else {
            label.fontSize = 15 * scaleFactor
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
    
    func displayCoachMark() {
        if !Utils.selectGameSceneCoachMarkSeen {
            let alertController = UIAlertController(title: "Select a level",
                                                    message: "Red is harder than green.\n\nEach level of the same colour plays slightly differently.\n\nTry to get three stars in each!",
                                                    preferredStyle: .Alert)
            
            let okAction = UIAlertAction(title:"Ok",
                                         style: .Default) { (action) -> Void in
                                            Utils.selectGameSceneCoachMarkSeen = true
            }
            alertController.addAction(okAction)
            
            Utils.rootVC.presentViewController(alertController, animated: true, completion: nil)
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
            let reveal = SKTransition.crossFadeWithDuration(0.5)
            self.view?.presentScene(self.previousScene, transition: reveal)
        }
        
        self.runAction(previousScreenAction)
    }
    
    func startGame(boardConfig: String) {
        let gameStartAction = SKAction.runBlock() {
            let reveal = SKTransition.doorsOpenVerticalWithDuration(0.5)
            let (numColours, numColoursToWin) = self.unpackGameType(self.gameType)
            let gameSceneConfig = GameSceneConfig(
                goBackScene: self,
                boardConfig: boardConfig,
                level: self.level,
                numberOfColours: numColours,
                numberOfColoursToWin: numColoursToWin)
            
            let gameStartScene = GameScene(
                size: self.size,
                gameSceneConfig: gameSceneConfig)
            self.view?.presentScene(gameStartScene, transition: reveal)
        }
        
        Utils.hideBanner(Ads.bannerView)
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
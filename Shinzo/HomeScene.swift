//
//  HomeScene.swift
//  Shinzo
//
//  Created by Ian White on 26/04/2016.
//  Copyright © 2016 Ian White. All rights reserved.
//

import Foundation
import SpriteKit
import GoogleMobileAds

class HomeScene: SKScene {
    var scaleFactor: CGFloat = 1
    
    let levelNames = ["3-2", "4-3", "4-2", "3-1", "4-1"]
    
    var buttonYOffset: CGFloat {
        return self.frame.height / 7
    }
    
    var titleTileWidth: CGFloat {
        return self.frame.width / 8
    }
    
    override func didMoveToView(view: SKView) {
        setScaleFactor()
        addBackground()
        addInteractiveElements()
        addTitle()
        addHelpButton()
        Utils.showBanner(Ads.bannerView, screenHeight: self.frame.height)
    }
    
    func setScaleFactor() {
        if self.frame.height / self.frame.width < 1.4 {
            scaleFactor = 2
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
    
    func addInteractiveElements() {
        addButtons()
        addLabels(5)
    }
    
    func addButtons() {
        for i in 0 ..< GameTitles.texts.count {
            let button = createButtonNumber(i, text: GameTitles.texts[i], name: levelNames[i], colour: GameTitles.colours[i])
            addButtonNumber(i, button: button)
        }
        
    }
    
    func createButtonNumber(buttonNumber: Int, text: String, name: String, colour: SKColor) -> SKLabelNode {
        let button = SKLabelNode(fontNamed: "Thonburi")
        button.fontSize = 24 * scaleFactor
        button.fontColor = colour
        button.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        button.text = text
        button.name = name
        
        return button
    }
    
    func addButtonNumber(buttonNumber: Int, button: SKLabelNode) {
        button.position = CGPoint(x: 20 * scaleFactor, y: self.frame.height - buttonYOffset * CGFloat(2 + buttonNumber))
        
        self.addChild(button)
    }
    
    func addLabels(numLabels: Int) {
        for i in 0 ..< numLabels {
            let label = createLabel(i + 1)
            addLabelNumber(i, label: label)
        }
    }
    
    func createLabel(level: Int) -> SKLabelNode {
        let label = SKLabelNode(fontNamed: "Thonburi")
        label.fontSize = 20 * scaleFactor
        label.fontColor = SKColor.grayColor()
        label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
        
        let score = numberOfThreeStarsForLevel(level)
        if score > 0 {
            label.fontColor = SKColor.yellowColor()
        }
        if score == 9 {
            label.fontSize = 25 * scaleFactor
        }
        label.text = "\(score) / 9"
        
        return label
    }
    
    func numberOfThreeStarsForLevel(level: Int) -> Int {
        let boardTypes = [
            BoardConfig.easyDiagonal,
            BoardConfig.mediumDiagonal,
            BoardConfig.hardDiagonal,
            BoardConfig.easyStraight,
            BoardConfig.mediumStraight,
            BoardConfig.hardStraight,
            BoardConfig.easyAround,
            BoardConfig.mediumAround,
            BoardConfig.hardAround]
        
        var result = 0
        
        for boardType in boardTypes {
            if Data.bestIsThreeStarsFor(boardType, level: level) {
                result += 1
            }
        }
        
        return result
    }
    
    func addLabelNumber(labelNumber: Int, label: SKLabelNode) {
        label.position = CGPoint(x: self.frame.width - 40 * scaleFactor, y: self.frame.height - buttonYOffset * CGFloat(2 + labelNumber))
        self.addChild(label)
    }
    
    func addTitle() {
        createAndAddTitleBackdrop()
        createAndAddTiles()
    }
    
    func createAndAddTitleBackdrop() {
        let backdrop = createTitleBackdrop()
        addTitleBackdrop(backdrop)
    }
    
    func createTitleBackdrop() -> SKShapeNode {
        let width = titleTileWidth * 6 + titleTileWidth / 10
        let height = titleTileWidth + titleTileWidth / 10
        let backdrop = SKShapeNode(path: CGPathCreateWithRoundedRect(CGRectMake(0, 0, width, height), 4, 4, nil))
        
        backdrop.strokeColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        backdrop.fillColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        backdrop.zPosition = 0
        
        return backdrop
    }
    
    func addTitleBackdrop(backdrop: SKShapeNode) {
        backdrop.position = CGPoint(x: titleTileWidth - titleTileWidth / 10, y: self.frame.height - (titleTileWidth * 2) - (titleTileWidth / 10))
        
        self.addChild(backdrop)
    }
    
    func createAndAddTiles() {
        let images = ["tile_green", "tile_blue", "tile_yellow", "tile_purple", "tile_green", "tile_blue"]
        let letters = ["s", "h", "i", "n", "z", "o"]
        
        for i in 0 ..< letters.count {
            let tileImage = createTitleTileWithImageName(images[i], imageWidth: titleTileWidth * 0.9)
            addTitleTileNumber(i, tile: tileImage)
            
            let letter = createTitleLetter(letters[i])
            let letterOffset = titleTileWidth + tileImage.size.width / 2
            addTitleLetterNumber(i, letter: letter, offset: letterOffset)
            
        }
    }
    
    func createTitleTileWithImageName(imageName: String, imageWidth: CGFloat) -> SKSpriteNode {
        let tile = SKSpriteNode(imageNamed: imageName)
        tile.size.width = imageWidth
        tile.size.height = imageWidth
        tile.anchorPoint = .zero
        
        return tile
    }
    
    func addTitleTileNumber(tileNumber: Int, tile: SKSpriteNode) {
        tile.position.x = titleTileWidth + titleTileWidth * CGFloat(tileNumber)
        tile.position.y = self.frame.height - titleTileWidth * 2
        tile.zPosition = 1
        
        self.addChild(tile)
    }
    
    func createTitleLetter(letter: String) -> SKLabelNode {
        let letterLabel = SKLabelNode(fontNamed: "Thonburi")
        letterLabel.fontSize = 25 * scaleFactor
        letterLabel.fontColor = SKColor.blackColor()
        letterLabel.text = letter
        letterLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
    
        return letterLabel
    }
    
    func addTitleLetterNumber(letterNumber: Int, letter:SKLabelNode, offset: CGFloat) {
        letter.position = CGPoint(x: offset + titleTileWidth * CGFloat(letterNumber), y: self.frame.height - titleTileWidth * 1.55)
        letter.zPosition = 2
        
        self.addChild(letter)
    }
    
    func addHelpButton() {
        let button = SKSpriteNode(imageNamed: "help-alpha")
        button.anchorPoint = .zero
        button.name = "help"
        button.setScale(0.25 * scaleFactor)
        button.zPosition = 2
        button.position = CGPoint(x: self.frame.width - 50 * scaleFactor, y: self.frame.height - 35 * scaleFactor)
        self.addChild(button)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            let node = self.nodeAtPoint(location)
            
            if let name = node.name {
                if name == "help" {
                    startCoachMarks()
                } else {
                    let gameSelectAction = SKAction.runBlock() {
                        let reveal = SKTransition.crossFadeWithDuration(0.5)
                        let selectGameScene = SelectGameScene(size: self.size, gameType: name, level: self.levelFrom(name))
                        self.view?.presentScene(selectGameScene, transition: reveal)
                    }
                    
                    self.runAction(gameSelectAction)
                }
            }
        }
    }
    
    func startCoachMarks() {
        Utils.selectGameSceneCoachMarkSeen = false
        Utils.gameSceneCoachMarkSeen = false
        displayCoachMark()
    }
    
    func displayCoachMark() {
        let alertController = UIAlertController(title: "Select a game",
                                                message: "Lower games are harder.\n\nFor instance, Peaceful pond has a board with 3 colours which you need to get down to 2.\n\nStormy sea starts with 4 colours which you need to get down to just 1!",
                                                preferredStyle: .Alert)
            
        let okAction = UIAlertAction(title:"Ok",
                                     style: .Default) { (action) -> Void in
                                        // Do nothing
        }
        alertController.addAction(okAction)
            
        Utils.rootVC.presentViewController(alertController, animated: true, completion: nil)

    }
    
    func levelFrom(name: String) -> Int {
        return levelNames.indexOf(name)! + 1
    }
}
//
//  GameScene.swift
//  Shinzo
//
//  Created by Ian White on 24/04/2016.
//  Copyright (c) 2016 Ian White. All rights reserved.
//

import SpriteKit
import GoogleMobileAds

class GameScene: SKScene {
    
    let gameSceneConfig: GameSceneConfig!
    var board: Board!
    var movesLabel = SKLabelNode(fontNamed: "Thonburi")
    var timerLabel = SKLabelNode(fontNamed: "Thonburi")
    var inPlay = true
    var scaleFactor: CGFloat = 1
    var movesForThreeStars: Int!
    var movesForTwoStars: Int!
    var movesForOneStar: Int!
    var starsLabel = SKLabelNode(fontNamed: "Thonburi")
    let threeStarsText = "★ ★ ★"
    let twoStarsText = "☆ ★ ★"
    let oneStarText = "☆ ☆ ★"
    let noStarsText = "☆ ☆ ☆"
    
    var moves: Int = 0 {
        didSet {
            if moves > movesForOneStar {
                starsLabel.text = noStarsText
            } else if moves > movesForTwoStars {
                starsLabel.text = oneStarText
            } else if moves > movesForThreeStars {
                starsLabel.text = twoStarsText
            }
            if moves <= movesForOneStar {
                movesLabel.text = "\(movesForOneStar - moves)"
            } else {
                movesLabel.text = "-"
            }
        }
    }
    
    var timerValue: Double = 0 {
        didSet {
            if timerValue < 10000 {
                timerLabel.text = "\(String(format: "%.0f", timerValue))"
            } else {
                timerLabel.text = "> 10k"
            }
        }
    }
    
    init(size: CGSize, gameSceneConfig: GameSceneConfig) {
        self.gameSceneConfig = gameSceneConfig
        super.init(size: size)
        board = Board(config: gameSceneConfig.boardConfig, numColours: gameSceneConfig.numberOfColours)
        
        let (threeStars, twoStars, oneStar) = LevelMoves.movesForLevel(gameSceneConfig.level, boardType: board.config)
        self.movesForThreeStars = threeStars
        self.movesForTwoStars = twoStars
        self.movesForOneStar = oneStar
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        setScaleFactor()
        addBackground()
        setupBoard()
        addTopBar()
        addExplanationLabel()
        displayCoachMark()
        Utils.createAndLoadInterstitial()
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
    
    func setupBoard() {
        board.width = boardWidth()
        board.offsetX = boardOffsetX()
        board.offsetY = boardOffsetY()
        let totalTileWidth = getTotalTileWidth()
        
        let backdrop = createBoardBackdrop(totalTileWidth, offsetX: board.offsetX, offsetY: board.offsetY, cols: board.cols, rows: board.rows)
        self.addChild(backdrop)
        
        addTilesToBoard(totalTileWidth)
    }
    
    func boardWidth() -> CGFloat {
        let ratio = self.frame.height / self.frame.width
        
        if ratio < 1.4 {
            return self.frame.width / 7 * 4
        } else if ratio < 1.6 {
            return self.frame.width / 7 * 4.3
        } else {
            return self.frame.width / 7 * 5
        }
    }
    
    func boardOffsetX() -> CGFloat {
        return (self.frame.width - board.width) / 2
    }
    
    func boardOffsetY() -> CGFloat {
        let ratio = self.frame.height / self.frame.width
        
        if ratio < 1.7 {
            return self.frame.width / 7
        } else {
            return self.frame.width / 5
        }
    }
    
    func getTotalTileWidth() -> CGFloat {
        return board.width / CGFloat(board.cols)
    }
    
    func createBoardBackdrop(tileWidth: CGFloat, offsetX: CGFloat, offsetY: CGFloat, cols: Int, rows: Int) -> SKShapeNode {
        let backdropWidth = tileWidth * CGFloat(cols) + tileWidth / 10
        let backdropHeight = tileWidth * CGFloat(rows) + tileWidth / 10
        let backdrop = SKShapeNode(path: CGPathCreateWithRoundedRect(CGRectMake(0, 0, backdropWidth, backdropHeight), 4, 4, nil))
        
        backdrop.strokeColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        backdrop.fillColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        backdrop.zPosition = 0
        backdrop.position = CGPoint(x: offsetX - tileWidth / 10, y: (offsetY * 2) - tileWidth / 10)
        
        return backdrop
    }
    
    func addTilesToBoard(totalTileWidth: CGFloat) {
        for x in 0 ..< board.cols {
            for y in 0 ..< board.rows {
                let tile = createTile(x, y: y, totalTileWidth: totalTileWidth)
                positionTile(tile, totalTileWidth: totalTileWidth)
                self.addChild(tile)
                expandTile(tile)
            }
        }
    }
    
    func createTile(x: Int, y: Int, totalTileWidth: CGFloat) -> Tile {
        let tile = board.tiles[x][y]
        tile.x = x
        tile.y = y
        tile.name = "tile"
        tile.size.width = totalTileWidth * 0.9
        tile.size.height = totalTileWidth * 0.9
        
        return tile
    }
    
    func positionTile(tile: Tile, totalTileWidth: CGFloat) {
        tile.position.x = board.offsetX + (totalTileWidth * CGFloat(tile.x)) + (tile.size.width / 2)
        tile.position.y = (board.offsetY * 2) + (totalTileWidth * CGFloat(tile.y) + (tile.size.width / 2))
        tile.zPosition = 1
        tile.setScale(0.25)
    }
    
    func expandTile(tile: Tile) {
        tile.runAction(SKAction.scaleBy(4, duration: 0.25))
    }
    
    func shrinkTile(tile: Tile) {
        tile.runAction(SKAction.scaleBy(0.25, duration: 0.25))
    }
    
    func addTopBar() {
        addTopBarBackdrop()
        setupLabels()
     //   setupTimer()
    }
    
    func addTopBarBackdrop() {
        let width = self.size.width
        let height = self.size.height / 12
        let backdrop = SKShapeNode(path: CGPathCreateWithRoundedRect(CGRectMake(0, 0, width, height), 4, 4, nil))
        
        backdrop.strokeColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        backdrop.fillColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        backdrop.zPosition = 0
        
        backdrop.position = CGPoint(x: 0, y: self.frame.height - (self.frame.height / 12))
        
        self.addChild(backdrop)
    }
    
    func setupLabels() {
        setupMovesWord()
        setupMovesLabel()
        setupBackArrow()
        setupStarsLabel()
        setupColoursLabel()
    }
    
    func setupMovesWord() {
        let movesWord = SKLabelNode(fontNamed: "Thonburi")
        movesWord.fontSize = 20 * scaleFactor
        movesWord.position.x = board.offsetX * 2
        movesWord.position.y = self.frame.height - (self.frame.height / 17)
        movesWord.text = "Moves:"
        
        self.addChild(movesWord)
    }
    
    func setupMovesLabel() {
        movesLabel.fontSize = 20 * scaleFactor
        movesLabel.position.x = board.offsetX * 2 + 45 * scaleFactor
        movesLabel.position.y = self.frame.height - (self.frame.height / 17)
        movesLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        movesLabel.text = "\(movesForOneStar)"
        
        self.addChild(movesLabel)
    }
    
    func setupBackArrow() {
        let backArrow = SKLabelNode(fontNamed: "Thonburi")
        backArrow.fontSize = 30 * scaleFactor
        backArrow.text = "↩"
        backArrow.name = "back"
        backArrow.position = CGPoint(x: 20 * scaleFactor, y: self.frame.height - self.frame.width / 12)
        
        self.addChild(backArrow)
    }
    
    func setupStarsLabel() {
        starsLabel.fontSize = 30 * scaleFactor
        starsLabel.fontColor = SKColor.yellowColor()
        starsLabel.text = threeStarsText
        starsLabel.position = CGPoint(x: size.width - 75 * scaleFactor, y: self.frame.height - (self.frame.height / 17))
        self.addChild(starsLabel)
    }
    
    func setupColoursLabel() {
        let spriteWidth = (board.width / CGFloat(8)) * 0.75
        let spriteYPosition = board.offsetY
        let startX = self.frame.width / 2 - (board.width / CGFloat(8)) * 2
        let colourNode = Labels.colourOrderNode(spriteWidth, numTiles: self.gameSceneConfig.numberOfColours)
        
        if self.gameSceneConfig.numberOfColours == 3 {
            colourNode.position = CGPoint(x: startX - spriteWidth, y: spriteYPosition - spriteWidth)
        } else if self.gameSceneConfig.numberOfColours == 4 {
            colourNode.position = CGPoint(x: startX - spriteWidth * 2.5, y: spriteYPosition - spriteWidth)
        } else {
            colourNode.position = CGPoint(x: startX - spriteWidth * 4, y: spriteYPosition - spriteWidth)
        }
        colourNode.zPosition = 0
        
        self.addChild(colourNode)
    }

    func setupTimer() {
        let timerWord = SKLabelNode(fontNamed: "Thonburi")
        timerWord.fontSize = CGFloat(20)
        timerWord.position = CGPoint(x: size.width / 4 * 2.5, y: self.frame.height - (self.frame.height / 17))
        timerWord.text = "Time:"
        self.addChild(timerWord)
        
        timerLabel.fontSize = 20
        timerLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        timerLabel.position = CGPoint(x: size.width / 4 * 2.5 + 40, y: self.frame.height - (self.frame.height / 17))
        timerLabel.text = "0"
        addChild(timerLabel)
        
        let wait = SKAction.waitForDuration(0.1)
        let block = SKAction.runBlock({
                self.timerValue += 0.1
            })
        let sequence = SKAction.sequence([wait, block])
        
        runAction(SKAction.repeatActionForever(sequence), withKey: "timer")
    }
    
    func stopTimer() {
        self.removeActionForKey("timer")
    }
    
    func addExplanationLabel() {
        let label = SKLabelNode(fontNamed: "Thonburi")
        let numToEliminate = self.gameSceneConfig.numberOfColours - self.gameSceneConfig.numberOfColoursToWin
        
        if numToEliminate == 1 {
            label.text = "Eliminate 1 colour"
        } else {
            label.text = "Eliminate \(numToEliminate) colours"
        }
        
        label.fontSize = 20 * scaleFactor
        label.fontColor = SKColor.yellowColor()
        label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        
        var yPosition = self.frame.height - (self.frame.height / 8)
        if scaleFactor == 1 {
            yPosition = self.frame.height - (self.frame.height / 7)
        }
        
        label.position = CGPoint(x: self.frame.width / 2, y: yPosition)
        
        self.addChild(label)
    }
    
    func displayCoachMark() {
        if !Utils.gameSceneCoachMarkSeen {
            let alertController = UIAlertController(title: "How to play",
                                                    message: "Tap a square to change it to the next colour in the sequence.\n\nThe squares around it will move to their next colours as well.\n\nWin by reducing the number of colours on the board.",
                                                    preferredStyle: .Alert)
            
            let okAction = UIAlertAction(title:"Ok",
                                         style: .Default) { (action) -> Void in
                                            Utils.gameSceneCoachMarkSeen = true
            }
            alertController.addAction(okAction)
            
            Utils.rootVC.presentViewController(alertController, animated: true, completion: nil)
        }
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if inPlay {
            for touch in touches {
                let location = touch.locationInNode(self)
                let node = self.nodeAtPoint(location)
                
                if let name = node.name {
                    if name == "back" {
                        quitGame()
                    }
                    else if name == "tile" {
                        let touchedTile = node as! Tile
                        dealWithTouchedTile(touchedTile)
                    }
                }
            }

        }
    }
    
    func quitGame() {
        stopTimer()
        
        let gameQuitAction = SKAction.runBlock() {
            let reveal = SKTransition.doorsCloseVerticalWithDuration(0.5)
            self.view?.presentScene(SelectGameScene(size: self.size, gameType: self.gameSceneConfig.gameType, level: self.gameSceneConfig.level), transition: reveal)
        }
        
        self.runAction(gameQuitAction)
    }
    
    func dealWithTouchedTile(touchedTile: Tile) {
        moves += 1
        
        let sequence = SKAction.sequence([
            SKAction.runBlock({touchedTile.next()}),
            SKAction.waitForDuration(0.075),
            SKAction.runBlock({
                if self.board.surroundType == SurroundType.diagonal {
                    for tile in self.board.diagonalTiles(touchedTile) {
                        tile.next()
                    }
                    self.checkForEnd()
                } else if self.board.surroundType == SurroundType.around {
                    for tile in self.board.aroundTiles(touchedTile) {
                        tile.next()
                    }
                    self.checkForEnd()
                } else if self.board.surroundType == SurroundType.straight {
                    for tile in self.board.straightTiles(touchedTile) {
                        tile.next()
                    }
                    self.checkForEnd()
                }})
            ])
        
        self.runAction(sequence)
    }
    
    func checkForEnd() {
        if board.end(gameSceneConfig.numberOfColoursToWin) {
            stopTimer()
            showGameOver()
        }
    }
    
    func showGameOver() {
        inPlay = false
        let wait1 = SKAction.waitForDuration(0.5)
        let wait2 = SKAction.waitForDuration(0.35)
        let shrinkTiles = SKAction.runBlock() {
            for row in self.board.tiles {
                for tile in row {
                    tile.shrink()
                }
            }
        }
        let gameOverAction = SKAction.runBlock() {
            let reveal = SKTransition.crossFadeWithDuration(0.5)
            let gameOverScene = GameOverScene(
                size: self.size,
                gameSceneConfig: self.gameSceneConfig,
                moves: self.moves,
                time: self.timerValue)
            self.view?.presentScene(gameOverScene, transition: reveal)
        }
        
        let sequence = SKAction.sequence([wait1, shrinkTiles, wait2, gameOverAction])
        self.runAction(sequence)
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}

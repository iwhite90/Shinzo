//
//  GameScene.swift
//  Shinzo
//
//  Created by Ian White on 24/04/2016.
//  Copyright (c) 2016 Ian White. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    let previousScene: SKScene!
    var board: Board!
    var numberOfColoursToWin: Int!
    var numberOfColours: Int!
    var movesLabel = SKLabelNode(fontNamed: "Thonburi")
    var timerLabel = SKLabelNode(fontNamed: "Thonburi")
    
    var moves: Int = 0 {
        didSet {
            if moves < 1000 {
                movesLabel.text = "\(moves)"
            } else {
                movesLabel.text = "> 1k"
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
    
    init(size: CGSize, cameFromScene: SKScene, boardConfig: String, numberOfColours: Int, numberOfColoursToWin: Int) {
        previousScene = cameFromScene
        super.init(size: size)
        self.numberOfColoursToWin = numberOfColoursToWin
        self.numberOfColours = numberOfColours
        board = Board(config: boardConfig, numColours: numberOfColours)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        addBackground()
        setupBoard()
        addTopBar()
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
        board.width = self.frame.width / 7 * 5
        board.offset = self.frame.width / 7
        let totalTileWidth = board.width / CGFloat(board.cols)
        
        let backdrop = createBoardBackdrop(totalTileWidth, offset: board.offset, cols: board.cols, rows: board.rows)
        self.addChild(backdrop)
        
        addTilesToBoard(totalTileWidth)
    }
    
    func createBoardBackdrop(tileWidth: CGFloat, offset: CGFloat, cols: Int, rows: Int) -> SKShapeNode {
        let backdropWidth = tileWidth * CGFloat(cols) + tileWidth / 10
        let backdropHeight = tileWidth * CGFloat(rows) + tileWidth / 10
        let backdrop = SKShapeNode(path: CGPathCreateWithRoundedRect(CGRectMake(0, 0, backdropWidth, backdropHeight), 4, 4, nil))
        
        backdrop.strokeColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        backdrop.fillColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        backdrop.zPosition = 0
        backdrop.position = CGPoint(x: offset - tileWidth / 10, y: (offset * 2) - tileWidth / 10)
        
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
        tile.position.x = board.offset + (totalTileWidth * CGFloat(tile.x)) + (tile.size.width / 2)
        tile.position.y = (board.offset * 2) + (totalTileWidth * CGFloat(tile.y) + (tile.size.width / 2))
        tile.zPosition = 1
        tile.setScale(0.25)
    }
    
    func expandTile(tile: Tile) {
        tile.runAction(SKAction.scaleBy(4, duration: 0.25))
    }
    
    func addTopBar() {
        addTopBarBackdrop()
        setupLabels()
        setupTimer()
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
        setupColoursLabel()
    }
    
    func setupMovesWord() {
        let movesWord = SKLabelNode(fontNamed: "Thonburi")
        movesWord.fontSize = CGFloat(20)
        movesWord.position.x = board.offset * 2
        movesWord.position.y = self.frame.height - (self.frame.height / 17)
        movesWord.text = "Moves:"
        
        self.addChild(movesWord)
    }
    
    func setupMovesLabel() {
        movesLabel.fontSize = CGFloat(20)
        movesLabel.position.x = board.offset * 2 + 45
        movesLabel.position.y = self.frame.height - (self.frame.height / 17)
        movesLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        movesLabel.text = "0"
        
        self.addChild(movesLabel)
    }
    
    func setupBackArrow() {
        let backArrow = SKLabelNode(fontNamed: "Thonburi")
        backArrow.fontSize = CGFloat(30)
        backArrow.text = "↩"
        backArrow.name = "back"
        backArrow.position = CGPoint(x: 20, y: self.frame.height - self.frame.width / 12)
        
        self.addChild(backArrow)
 
    }
    
    func setupColoursLabel() {
        let spriteWidth = (board.width / CGFloat(8)) * 0.75
        let spriteYPosition = board.offset
        let startX = self.frame.width / 2 - (board.width / CGFloat(8)) * 2
        let colourNode = Labels.colourOrderNode(spriteWidth, numTiles: self.numberOfColours)
        
        if self.numberOfColours == 3 {
            colourNode.position = CGPoint(x: startX - spriteWidth, y: spriteYPosition - spriteWidth)
        } else {
            colourNode.position = CGPoint(x: startX - spriteWidth * 2.5, y: spriteYPosition - spriteWidth)
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
        let sequence = SKAction.sequence([wait,block])
        
        runAction(SKAction.repeatActionForever(sequence), withKey: "timer")
    }
    
    func stopTimer() {
        self.removeActionForKey("timer")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
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
    
    func quitGame() {
        stopTimer()
        
        let gameQuitAction = SKAction.runBlock() {
            let reveal = SKTransition.flipHorizontalWithDuration(0.5)
            self.view?.presentScene(self.previousScene, transition: reveal)
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
        if board.end(numberOfColoursToWin) {
            stopTimer()
            showGameOver()
        }
    }
    
    func showGameOver() {
        let gameOverAction = SKAction.runBlock() {
            let reveal = SKTransition.flipHorizontalWithDuration(0.5)
            let gameOverScene = GameOverScene(size: self.size, moves: self.moves, time: self.timerValue, boardType: self.board.config)
            self.view?.presentScene(gameOverScene, transition: reveal)
        }
        
        self.runAction(gameOverAction)
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}

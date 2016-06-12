//
//  Labels.swift
//  Shinzo
//
//  Created by Ian White on 02/05/2016.
//  Copyright © 2016 Ian White. All rights reserved.
//

import Foundation
import SpriteKit

struct Labels {
    static func colourOrderNode(tileWidth: CGFloat, numTiles: Int) -> SKNode {
        let numElements = numTiles * 2 - 1
        let baseWidth = tileWidth * CGFloat(numElements)
        let width = numTiles == 3 ? baseWidth * 1.5 : baseWidth * 1.45
        let height = tileWidth * 2
        
        let node = SKNode()
        
        let backdrop = createBackdrop(width, height: height)
        node.addChild(backdrop)
        
        for i in 0..<numTiles {
            let tile = createTileNumber(i, dimension: tileWidth)
            node.addChild(tile)
        }
        
        for i in 0..<numTiles - 1 {
            let arrow = createArrowNumber(i, tileWidth: tileWidth)
            node.addChild(arrow)
        }
        
        return node
    }
    
    static func createBackdrop(width: CGFloat, height: CGFloat) -> SKShapeNode {
        let backdrop = SKShapeNode(path: CGPathCreateWithRoundedRect(CGRectMake(0, 0, width, height), 4, 4, nil))
        backdrop.strokeColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        backdrop.fillColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        backdrop.zPosition = 0
        
        return backdrop
    }
    
    static func createTileNumber(tileNumber: Int, dimension: CGFloat) -> Tile {
        let tile = Tile(num: tileNumber)
        tile.size = CGSize(width: dimension, height: dimension)
        tile.anchorPoint = .zero
        tile.zPosition = 1
        
        let offset = tile.size.width / 2
        tile.position.y = offset
        tile.position.x = offset + tile.size.width * 2.7 * CGFloat(tileNumber)
        
        return tile
    }
    
    static func createArrowNumber(arrowNumber: Int, tileWidth: CGFloat) -> SKLabelNode {
        let arrow = SKLabelNode(fontNamed: "Chalkduster")
        arrow.fontSize = tileWidth
        arrow.text = "➙"
        arrow.zPosition = 1
        
        let startArrowX = tileWidth * 1.5 * 1.75
        let arrowOffsetX = tileWidth * 2.7 * CGFloat(arrowNumber)
        arrow.position = CGPoint(x: startArrowX + arrowOffsetX, y: (tileWidth / 2) * 1.25)
        
        return arrow
    }
}

class Label: SKNode {
    var numColoursToWin: Int = 0
}
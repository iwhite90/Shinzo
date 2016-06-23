//
//  Board.swift
//  Shinzo
//
//  Created by Ian White on 26/04/2016.
//  Copyright © 2016 Ian White. All rights reserved.
//

import Foundation
import SpriteKit

struct BoardConfig {
    static let easyDiagonal = "ed"
    static let easyStraight = "es"
    static let easyAround = "ea"
    static let mediumDiagonal = "md"
    static let mediumStraight = "ms"
    static let mediumAround = "ma"
    static let hardDiagonal = "hd"
    static let hardStraight = "hs"
    static let hardAround = "ha"
}

struct SurroundType {
    static let diagonal = 1
    static let straight = 2
    static let around = 3
}

class Board {
    var tiles: [[Tile]] = [[Tile]]()
    var width: CGFloat = 0
    var offsetX: CGFloat = 0
    var offsetY: CGFloat = 0
    var cols: Int!
    var rows: Int!
    var surroundType: Int!
    var config: String!
    
    init(config: String, numColours: Int) {
        let (c, r, st) = unpackConfig(config)
        self.cols = c
        self.rows = r
        self.surroundType = st
        self.config = config
        
        for x in 0..<cols {
            tiles.append([Tile]())
            for _ in 0..<rows {
                tiles[x].append(Tile(numColours: numColours))
            }
        }
    }
    
    func unpackConfig(config: String) -> (Int, Int, Int) {
        var result = (1, 1, 1)
        switch config {
        case BoardConfig.easyDiagonal: result = (4, 6, SurroundType.diagonal)
        case BoardConfig.mediumDiagonal: result = (6, 9, SurroundType.diagonal)
        case BoardConfig.hardDiagonal: result = (8, 12, SurroundType.diagonal)
        case BoardConfig.easyStraight: result = (4, 6, SurroundType.straight)
        case BoardConfig.mediumStraight: result = (6, 9, SurroundType.straight)
        case BoardConfig.hardStraight: result = (8, 12, SurroundType.straight)
        case BoardConfig.easyAround: result = (4, 6, SurroundType.around)
        case BoardConfig.mediumAround: result = (6, 9, SurroundType.around)
        case BoardConfig.hardAround: result = (8, 12, SurroundType.around)
        default: result = (4, 6, SurroundType.diagonal)
        }
        return result
    }
    
    func diagonalTiles(tile: Tile) -> [Tile] {
        let x = tile.x
        let y = tile.y
        var checkTiles = [Tile]()
        var startX = x + 1
        var startY = y + 1
        var endX = cols - 2
        var endY = rows - 2
        
        if x > 0 {
            startX = x - 1
        }
        if y > 0 {
            startY = y - 1
        }
        if x < cols - 1 {
            endX = x + 2
        }
        if y < rows - 1 {
            endY = y + 2
        }
        
        while startX <= endX {
            var incY = startY
            while incY <= endY {
                checkTiles.append(tiles[startX][incY])
                incY += 2
            }
            startX += 2
        }
        
        return checkTiles
    }
    
    func straightTiles(tile: Tile) -> [Tile] {
        let x = tile.x
        let y = tile.y
        var checkTiles = [Tile]()
        
        if x > 0 {
            checkTiles.append(tiles[x - 1][y])
        }
        if x < cols - 1 {
            checkTiles.append(tiles[x + 1][y])
        }
        if y > 0 {
            checkTiles.append(tiles[x][y - 1])
        }
        if y < rows - 1 {
            checkTiles.append(tiles[x][y + 1])
        }
        
        return checkTiles
    }

    
    func aroundTiles(tile: Tile) -> [Tile] {
        let x = tile.x
        let y = tile.y
        var checkTiles = [Tile]()
        var startX = x
        var startY = y
        var endX = cols - 1
        var endY = rows - 1
        
        if x > 0 {
            startX = x - 1
        }
        if y > 0 {
            startY = y - 1
        }
        if x < cols - 1 {
            endX = x + 1
        }
        if y < rows - 1 {
            endY = y + 1
        }
        
        var incY = startY
        
        while startX <= endX {
            incY = startY
            while incY <= endY {
                if startX != x || incY != y {
                    checkTiles.append(tiles[startX][incY])
                }
                incY += 1
            }
            startX += 1
        }
        
        return checkTiles
    }
    
    func end(numberOfColours: Int) -> Bool {
        var imageNums: [Int] = []
        imageNums.append(tiles[0][0].imageNum)
        
        for x in 0 ..< cols {
            for y in 0 ..< rows {
                let imageNum = tiles[x][y].imageNum
                if imageNums.count == numberOfColours && !imageNums.contains(imageNum) {
                    return false
                }
                else if !imageNums.contains(imageNum) {
                    imageNums.append(imageNum)
                }
            }
        }
        return true
    }
}
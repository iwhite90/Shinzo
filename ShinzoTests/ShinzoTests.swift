//
//  ShinzoTests.swift
//  ShinzoTests
//
//  Created by Ian White on 24/04/2016.
//  Copyright © 2016 Ian White. All rights reserved.
//

import XCTest
@testable import Shinzo

class ShinzoTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTilesAroundBoard() {
        let board = Board(cols: 4, rows: 6, surroundType: SurroundType.around)
        
        for x in 0 ..< board.cols {
            for y in 0 ..< board.rows {
                let tile = board.tiles[x][y]
                tile.x = x
                tile.y = y
                tile.name = "tile"
            }
        }
        
        let topLeftAround = board.aroundTiles(board.tiles[0][board.rows - 1])
        XCTAssert(topLeftAround.count == 3)
        let midLeftAround = board.aroundTiles(board.tiles[0][1])
        XCTAssert(midLeftAround.count == 5)
        let bottomLeftAround = board.aroundTiles(board.tiles[0][0])
        XCTAssert(bottomLeftAround.count == 3)
        
        let topRightAround = board.aroundTiles(board.tiles[board.cols - 1][board.rows - 1])
        XCTAssert(topRightAround.count == 3)
        let midRightAround = board.aroundTiles(board.tiles[board.cols - 1][1])
        XCTAssert(midRightAround.count == 5)
        let bottomRightAround = board.aroundTiles(board.tiles[board.cols - 1][0])
        XCTAssert(bottomRightAround.count == 3)
        
        let middleAround = board.aroundTiles(board.tiles[1][1])
        XCTAssert(middleAround.count == 8)
    }
    
    func testTilesDiagonalBoard() {
        let board = Board(cols: 4, rows: 6, surroundType: SurroundType.diagonal)
        
        for x in 0 ..< board.cols {
            for y in 0 ..< board.rows {
                let tile = board.tiles[x][y]
                tile.x = x
                tile.y = y
                tile.name = "tile"
            }
        }
        
        let topLeft = board.diagonalTiles(board.tiles[0][board.rows - 1])
        XCTAssert(topLeft.count == 1)
        let midLeft = board.diagonalTiles(board.tiles[0][1])
        XCTAssert(midLeft.count == 2)
        let bottomLeft = board.diagonalTiles(board.tiles[0][0])
        XCTAssert(bottomLeft.count == 1)
        
        let topRight = board.diagonalTiles(board.tiles[board.cols - 1][board.rows - 1])
        XCTAssert(topRight.count == 1)
        let midRight = board.diagonalTiles(board.tiles[board.cols - 1][1])
        XCTAssert(midRight.count == 2)
        let bottomRight = board.diagonalTiles(board.tiles[board.cols - 1][0])
        XCTAssert(bottomRight.count == 1)
        
        let middle = board.diagonalTiles(board.tiles[1][1])
        XCTAssert(middle.count == 4)
    }
    
    func testTilesUpAndDownBoard() {
        let board = Board(cols: 4, rows: 6, surroundType: SurroundType.diagonal)
        
        for x in 0 ..< board.cols {
            for y in 0 ..< board.rows {
                let tile = board.tiles[x][y]
                tile.x = x
                tile.y = y
                tile.name = "tile"
            }
        }
        
        let topLeft = board.straightTiles(board.tiles[0][board.rows - 1])
        XCTAssert(topLeft.count == 2)
        let midLeft = board.straightTiles(board.tiles[0][1])
        XCTAssert(midLeft.count == 3)
        let bottomLeft = board.straightTiles(board.tiles[0][0])
        XCTAssert(bottomLeft.count == 2)
        
        let topRight = board.straightTiles(board.tiles[board.cols - 1][board.rows - 1])
        XCTAssert(topRight.count == 2)
        let midRight = board.straightTiles(board.tiles[board.cols - 1][1])
        XCTAssert(midRight.count == 3)
        let bottomRight = board.straightTiles(board.tiles[board.cols - 1][0])
        XCTAssert(bottomRight.count == 2)
        
        let middle = board.straightTiles(board.tiles[1][1])
        XCTAssert(middle.count == 4)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}

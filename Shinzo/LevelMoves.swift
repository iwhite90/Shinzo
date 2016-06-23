//
//  LevelMoves.swift
//  Shinzo
//
//  Created by Ian White on 23/06/2016.
//  Copyright © 2016 Ian White. All rights reserved.
//

import Foundation

struct LevelMoves {
    static let moves: [String: (Int, Int, Int)] = [
        "1-\(BoardConfig.easyStraight)" : (8, 16, 24),
        "1-\(BoardConfig.mediumStraight)" : (15, 25, 35),
        "1-\(BoardConfig.hardStraight)" : (25, 40, 55),
        "1-\(BoardConfig.easyDiagonal)" : (8, 16, 24),
        "1-\(BoardConfig.mediumDiagonal)" : (15, 25, 35),
        "1-\(BoardConfig.hardDiagonal)" : (25, 40, 55),
        "1-\(BoardConfig.easyAround)" : (8, 16, 24),
        "1-\(BoardConfig.mediumAround)" : (15, 25, 35),
        "1-\(BoardConfig.hardAround)" : (25, 40, 55),
        "2-\(BoardConfig.easyStraight)" : (8, 16, 24),
        "2-\(BoardConfig.mediumStraight)" : (15,25,35),
        "2-\(BoardConfig.hardStraight)" : (25, 40, 55),
        "2-\(BoardConfig.easyDiagonal)" : (8, 16, 24),
        "2-\(BoardConfig.mediumDiagonal)" : (15,25,35),
        "2-\(BoardConfig.hardDiagonal)" : (25, 40, 55),
        "2-\(BoardConfig.easyAround)" : (8, 16, 24),
        "2-\(BoardConfig.mediumAround)" : (15,25,35),
        "2-\(BoardConfig.hardAround)" : (25, 40, 55),
        "3-\(BoardConfig.easyStraight)" : (16, 25, 45),
        "3-\(BoardConfig.mediumStraight)" : (25, 45, 65),
        "3-\(BoardConfig.hardStraight)" : (45, 60, 75),
        "3-\(BoardConfig.easyDiagonal)" : (16, 25, 45),
        "3-\(BoardConfig.mediumDiagonal)" : (25, 45, 65),
        "3-\(BoardConfig.hardDiagonal)" : (45, 60, 75),
        "3-\(BoardConfig.easyAround)" : (16, 25, 45),
        "3-\(BoardConfig.mediumAround)" : (25, 45, 65),
        "3-\(BoardConfig.hardAround)" : (45, 60, 75),
        "4-\(BoardConfig.easyStraight)" : (30, 45, 60),
        "4-\(BoardConfig.mediumStraight)" : (45, 60, 90),
        "4-\(BoardConfig.hardStraight)" : (60, 90, 120),
        "4-\(BoardConfig.easyDiagonal)" : (30, 45, 60),
        "4-\(BoardConfig.mediumDiagonal)" : (45, 60, 90),
        "4-\(BoardConfig.hardDiagonal)" : (60, 90, 120),
        "4-\(BoardConfig.easyAround)" : (30, 45, 60),
        "4-\(BoardConfig.mediumAround)" : (45, 60, 90),
        "4-\(BoardConfig.hardAround)" : (60, 90, 120),
        "5-\(BoardConfig.easyStraight)" : (45, 70, 90),
        "5-\(BoardConfig.mediumStraight)" : (70, 100, 130),
        "5-\(BoardConfig.hardStraight)" : (100, 135, 180),
        "5-\(BoardConfig.easyDiagonal)" : (45, 70, 90),
        "5-\(BoardConfig.mediumDiagonal)" : (70, 100, 130),
        "5-\(BoardConfig.hardDiagonal)" : (100, 135, 180),
        "5-\(BoardConfig.easyAround)" : (45, 70, 90),
        "5-\(BoardConfig.mediumAround)" : (70, 100, 130),
        "5-\(BoardConfig.hardAround)" : (100, 135, 180)
    ]
    
    static func movesForLevel(level: Int, boardType: String) -> (Int, Int, Int) {
        return moves["\(level)-\(boardType)"]!
    }
}
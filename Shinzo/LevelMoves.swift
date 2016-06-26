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
        "2-\(BoardConfig.easyStraight)" : (5, 10, 20),
        "2-\(BoardConfig.mediumStraight)" : (10, 15, 25),
        "2-\(BoardConfig.hardStraight)" : (15, 20, 30),
        "2-\(BoardConfig.easyDiagonal)" : (5, 10, 20),
        "2-\(BoardConfig.mediumDiagonal)" : (10, 15, 25),
        "2-\(BoardConfig.hardDiagonal)" : (15, 20, 30),
        "2-\(BoardConfig.easyAround)" : (5, 10, 20),
        "2-\(BoardConfig.mediumAround)" : (10, 15, 25),
        "2-\(BoardConfig.hardAround)" : (15, 20, 30),
        "3-\(BoardConfig.easyStraight)" : (16, 25, 45),
        "3-\(BoardConfig.mediumStraight)" : (25, 45, 65),
        "3-\(BoardConfig.hardStraight)" : (45, 60, 75),
        "3-\(BoardConfig.easyDiagonal)" : (16, 25, 45),
        "3-\(BoardConfig.mediumDiagonal)" : (25, 45, 65),
        "3-\(BoardConfig.hardDiagonal)" : (45, 60, 75),
        "3-\(BoardConfig.easyAround)" : (25, 40, 60),
        "3-\(BoardConfig.mediumAround)" : (45, 60, 75),
        "3-\(BoardConfig.hardAround)" : (65, 80, 100),
        "4-\(BoardConfig.easyStraight)" : (3, 6, 12),
        "4-\(BoardConfig.mediumStraight)" : (5, 8, 15),
        "4-\(BoardConfig.hardStraight)" : (10, 15, 20),
        "4-\(BoardConfig.easyDiagonal)" : (3, 6, 12),
        "4-\(BoardConfig.mediumDiagonal)" : (5, 8, 15),
        "4-\(BoardConfig.hardDiagonal)" : (10, 15, 20),
        "4-\(BoardConfig.easyAround)" : (3, 6, 12),
        "4-\(BoardConfig.mediumAround)" : (5, 8, 15),
        "4-\(BoardConfig.hardAround)" : (10, 15, 20),
        "5-\(BoardConfig.easyStraight)" : (10, 20, 30),
        "5-\(BoardConfig.mediumStraight)" : (18, 26, 40),
        "5-\(BoardConfig.hardStraight)" : (26, 40, 60),
        "5-\(BoardConfig.easyDiagonal)" : (10, 20, 30),
        "5-\(BoardConfig.mediumDiagonal)" : (18, 26, 40),
        "5-\(BoardConfig.hardDiagonal)" : (26, 40, 60),
        "5-\(BoardConfig.easyAround)" : (10, 20, 30),
        "5-\(BoardConfig.mediumAround)" : (18, 26, 40),
        "5-\(BoardConfig.hardAround)" : (26, 40, 60),
        "6-\(BoardConfig.easyStraight)" : (20, 30, 40),
        "6-\(BoardConfig.mediumStraight)" : (30, 45, 60),
        "6-\(BoardConfig.hardStraight)" : (45, 65, 90),
        "6-\(BoardConfig.easyDiagonal)" : (20, 30, 40),
        "6-\(BoardConfig.mediumDiagonal)" : (30, 45, 60),
        "6-\(BoardConfig.hardDiagonal)" : (45, 65, 90),
        "6-\(BoardConfig.easyAround)" : (20, 30, 40),
        "6-\(BoardConfig.mediumAround)" : (30, 45, 60),
        "6-\(BoardConfig.hardAround)" : (45, 65, 90)
    ]
    
    static func movesForLevel(level: Int, boardType: String) -> (Int, Int, Int) {
        return moves["\(level)-\(boardType)"]!
    }
}
//
//  Data.swift
//  Shinzo
//
//  Created by Ian White on 13/06/2016.
//  Copyright © 2016 Ian White. All rights reserved.
//

import Foundation

class Data {
    static let defaults = NSUserDefaults.standardUserDefaults()
    
    static func bestIsThreeStarsFor(boardType: String, level: Int) -> Bool {
        if let defaultsValue = defaults.arrayForKey(Utils.defaultsKeyFor(boardType, level: level)) {
            let bestStars: Int = defaultsValue[2] as! Int
            if bestStars == 3 {
                return true
            }
        }
        return false
    }
    
    static func numStarsFor(boardType: String, level: Int) -> Int {
        if let defaultsValue = defaults.arrayForKey(Utils.defaultsKeyFor(boardType, level: level)) {
            return defaultsValue[2] as! Int
        }
        return 0
    }
    
    static func saveFor(boardType: String, level: Int, moves: Int, time: Double, stars: Int) {
        defaults.setObject([moves, time, stars], forKey: Utils.defaultsKeyFor(boardType, level: level))
    }
    
    static func dataExistsFor(boardType: String, level: Int) -> Bool {
        if let _ = defaults.arrayForKey(Utils.defaultsKeyFor(boardType, level: level)) {
            return true
        }
        return false
    }
    
    static func movesTimeAndStarsFor(boardType: String, level: Int) -> (Int, Double, Int) {
        let defaultsValue = defaults.arrayForKey(Utils.defaultsKeyFor(boardType, level: level))!
        let moves = defaultsValue[0] as! Int
        let time = defaultsValue[1] as! Double
        let stars = defaultsValue[2] as! Int
        
        return (moves, time, stars)
    }
}
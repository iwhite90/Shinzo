//
//  Utils.swift
//  Shinzo
//
//  Created by Ian White on 13/06/2016.
//  Copyright © 2016 Ian White. All rights reserved.
//

import Foundation

class Utils {
    static func defaultsKeyFor(boardType: String, level: Int) -> String {
        return "\(boardType)-level\(level)"
    }
}
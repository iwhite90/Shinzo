//
//  Tile.swift
//  Shinzo
//
//  Created by Ian White on 24/04/2016.
//  Copyright © 2016 Ian White. All rights reserved.
//

import Foundation
import SpriteKit

struct Tiles {
    static let images = ["tile_yellow", "tile_purple", "tile_green", "tile_blue", "tile_red"]
}

class Tile: SKSpriteNode {
    
    var x: Int = 0
    var y: Int = 0
    var numColours: Int!
    var imageNum: Int = 0
    
    init() {
        numColours = 3
        imageNum = Int(Random.random(min: 0, max: CGFloat(numColours)))
        let texture = SKTexture(imageNamed: Tiles.images[imageNum])
        super.init(texture: texture, color: SKColor.clearColor(), size: texture.size())
    }
    
    init(numColours: Int) {
        self.numColours = numColours
        imageNum = Int(Random.random(min: 0, max: CGFloat(numColours)))
        let texture = SKTexture(imageNamed: Tiles.images[imageNum])
        super.init(texture: texture, color: SKColor.clearColor(), size: texture.size())
    }
    
    init(num: Int) {
        imageNum = num
        let texture = SKTexture(imageNamed: Tiles.images[imageNum])
        super.init(texture: texture, color: SKColor.clearColor(), size: texture.size())
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func next() {
        incrementImageNum()
        
        let animation = SKAction.sequence([
            SKAction.scaleBy(0.25, duration: 0.1),
            SKAction.runBlock({self.texture = SKTexture(imageNamed: Tiles.images[self.imageNum])}),
            SKAction.scaleBy(4, duration: 0.1)
            ])
        
        self.runAction(animation)
    }
    
    func shrink() {
        let animation = SKAction.scaleBy(0.01, duration: 0.3)
        self.runAction(animation)
    }
    
    func incrementImageNum() {
        if imageNum == numColours - 1 {
            imageNum = 0
        } else {
            imageNum += 1
        }
    }
}
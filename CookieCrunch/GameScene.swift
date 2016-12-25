//
//  GameScene.swift
//  CookieCrunch
//
//  Created by Doug Trance on 12/24/16.
//  Copyright © 2016 Trance Apps. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var level: Level!
    
    let tileWidth: CGFloat = 32.0
    let tileHeight: CGFloat = 36.0
    
    let gameLayer = SKNode()
    let cookiesLayer = SKNode()
    let tilesLayer = SKNode()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        let background = SKSpriteNode(imageNamed: "Background")
        background.size = size
        addChild(background)
        
        addChild(gameLayer)
        
        let layerPosition = CGPoint(x: -tileWidth * CGFloat(NumColumns) / 2,
                                    y: -tileHeight * CGFloat(NumRows) / 2)
        tilesLayer.position = layerPosition
        gameLayer.addChild(tilesLayer)
        
        cookiesLayer.position = layerPosition
        gameLayer.addChild(cookiesLayer)
    }
    
    func addSprites(for cookies: Set<Cookie>) {
        for cookie in cookies {
            let sprite = SKSpriteNode(imageNamed: cookie.cookieType.spriteName)
            sprite.size = CGSize(width: tileWidth, height: tileHeight)
            sprite.position = pointFor(column: cookie.column, row: cookie.row)
            cookiesLayer.addChild(sprite)
            cookie.sprite = sprite
        }
    }
    
    func pointFor(column: Int, row: Int) -> CGPoint {
        return CGPoint(
                    x: CGFloat(column)*tileWidth + tileWidth/2,
                    y: CGFloat(row)*tileHeight + tileHeight/2)
    }
    
    func addTiles() {
        for row in 0..<NumRows {
            for column in 0..<NumColumns {
                if level.tileAt(column: column, row: row) != nil {
                    let tileNode = SKSpriteNode(imageNamed: "Tile")
                    tileNode.size = CGSize(width: tileWidth, height: tileHeight)
                    tileNode.position = pointFor(column: column, row: row)
                    tilesLayer.addChild(tileNode)
                }
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
}

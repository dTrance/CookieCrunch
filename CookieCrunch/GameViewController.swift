//
//  GameViewController.swift
//  CookieCrunch
//
//  Created by Doug Trance on 12/24/16.
//  Copyright © 2016 Trance Apps. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    var scene: GameScene!
    var level: Level!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the view
        let skView = view as! SKView
        skView.isMultipleTouchEnabled = false
        
        // Create and configure the scene
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .aspectFill
        
        level = Level(filename: "Level_1")
        scene.level = level
        scene.addTiles()
        scene.swipeHandler = handleSwipe
        
        // Present the scene
        skView.presentScene(scene)
        
        beginGame()
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait, .portraitUpsideDown]
    }


    override var prefersStatusBarHidden: Bool {
        return true
    }

    func beginGame() {
        shuffle()
    }

    func shuffle() {
        let newCookies = level.shuffle()
        scene.addSprites(for: newCookies)
    }

    func handleSwipe(swap: Swap) {
        view.isUserInteractionEnabled = false
        
        if level.isPossibleSwap(swap) {
            level.performSwap(swap: swap)
            scene.animate(swap, completion: handleMatches)
                self.view.isUserInteractionEnabled = true
            
        } else {
            scene.animateInvalidSwap(swap) {
            self.view.isUserInteractionEnabled = true
            }
        }
    }
    
    func handleMatches() {
        let chains = level.removeMatches()
        //TODO: do something with the chains set
    }
    
    
    
    
    
    
    
    
    
    
}

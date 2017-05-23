//
//  MainMenuScene.swift
//  StarFighter2
//
//  Created by student on 12/12/16.
//  Copyright © 2016 EP Games. All rights reserved.
//

import Foundation
import SpriteKit

class MaineMenuScene: SKScene{
    
    override func didMoveToView(view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "alteredSF2Bg")
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        //No need for these labels, background has the name of the game        
        let gameBy = SKLabelNode(fontNamed: "SPACEBOY")
        gameBy.text = "EP Games "
        gameBy.fontSize = 30
        gameBy.fontColor =  SKColor.blackColor()
        gameBy.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.04)
        gameBy.zPosition = 1
        self.addChild(gameBy)
        
        
        
        let startGame = SKLabelNode(fontNamed: "Breeze Personal Use")
        startGame.text = "Start Game"
        startGame.fontSize = 150
        //startGame.fontColor = SKColor.blackColor()
        startGame.fontColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.85)
        startGame.position = CGPoint(x: self.size.width * 0.53, y: self.size.height * 0.1)
        startGame.zPosition = 1
        startGame.name = "startButton"
        self.addChild(startGame)
       
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches{
            
            let pointOfTouch = touch.locationInNode(self)
            let nodeITapped = nodeAtPoint(pointOfTouch)
            
            if nodeITapped.name == "startButton"{
                
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fadeWithDuration(0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
            
        }
    }
 }
}



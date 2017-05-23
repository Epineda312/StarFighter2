//
//  GameOverScene.swift
//  StarFighter2
//
//  Created by student on 12/8/16.
//  Copyright © 2016 EP Games. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene{
    
    let restartLabel = SKLabelNode(fontNamed: "Breeze Personal Use")
    
    override func didMoveToView(view: SKView) {
        
        
        
        //set background
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        //make game over label
        let gameOverLabel = SKLabelNode(fontNamed: "Breeze Personal Use")
        gameOverLabel.text = "Game Over"
        gameOverLabel.fontSize = 200
        gameOverLabel.fontColor = SKColor.whiteColor()
        gameOverLabel.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.7)
        gameOverLabel.zPosition = 1
        self.addChild(gameOverLabel)
        
        //make score label display score after game is over
        let scoreLabel = SKLabelNode(fontNamed: "SPACEBOY")
        scoreLabel.text = "Score: \(gameScore)"
        scoreLabel.fontSize = 90
        scoreLabel.fontColor = SKColor.whiteColor()
        scoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.55)
        scoreLabel.zPosition = 1
        self.addChild(scoreLabel)
        
        //Area of our app that saves information after game is closed (saved until game is uninstalled)
        let defaults = NSUserDefaults()
        var highScoreNumber = defaults.integerForKey("highScoreSaved")
        
        //Sets new highscore when previous one is passed then saves on the phone        
        if gameScore > highScoreNumber{
            highScoreNumber = gameScore
            defaults.setInteger(highScoreNumber, forKey: "highScoreSaved")
        }
        
        //Make high score label and display it after game is over
        let highScoreLabel = SKLabelNode(fontNamed: "SPACEBOY")
        highScoreLabel.text = "High Score: \(highScoreNumber)"
        highScoreLabel.fontSize = 90
        highScoreLabel.fontColor = SKColor.whiteColor()
        highScoreLabel.zPosition = 1
        highScoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.45)
        self.addChild(highScoreLabel)
    
        //make restart label and display it when game is over
        //let restartLabel = SKLabelNode(fontNamed: "Breeze Personal Use")
        restartLabel.text = "Restart"
        restartLabel.fontSize = 90
        restartLabel.fontColor = SKColor.whiteColor()
        restartLabel.zPosition = 1
        restartLabel.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.3)
        self.addChild(restartLabel)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches{
            
          let pointOfTouch = touch.locationInNode(self)
            
            if restartLabel.containsPoint(pointOfTouch){
                
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fadeWithDuration(0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
            }
            
      }
        
    }
        
}
    
    

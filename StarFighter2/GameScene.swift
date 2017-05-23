//
//  GameScene.swift
//  StarFighter2
//
//  Created by student on 12/1/16.
//  Copyright (c) 2016 EP Games. All rights reserved.
//

import SpriteKit

//instantiate gameScore here to use in gameOver scene (make variable global)
var gameScore = 0

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //instantiate score label
    let scoreLabel = SKLabelNode(fontNamed: "SPACEBOY")
    
    //Keeps track of what level your on
    var levelNumber = 0
    
    //instantiate number of lives as well as lives label
    var livesNumber = 1
    let livesLabel = SKLabelNode(fontNamed: "SPACEBOY")
    
    //Instantiate Player ship
    let player = SKSpriteNode(imageNamed: "biggerPlayer")
    
    //Instantiate bulletSound
    let bulletSound = SKAction.playSoundFileNamed("lazerSoundEffect.mp3", waitForCompletion: false)
    
    //instantiate explosion sound
    let explosionSound = SKAction.playSoundFileNamed("explosionSound", waitForCompletion: false)
    
    let tapToStartLabel = SKLabelNode(fontNamed: "Breeze Personal Use")
    
    //determine what state of game player is in
    enum gameState{
        case preGame //when the game state is before the start of the game
        case inGame //when the game state is during the game
        case afterGame //when the game state is after the game
    }
    
    //set current state to inGame (game starts right away)
    var currentGameState = gameState.preGame
    
    
    //Give objects physics properties
    struct PhysicsCategories {
        static let None : UInt32 = 0
        static let Player : UInt32 = 0b1 //1
        static let Bullet : UInt32 = 0b10 //2
        static let Enemy : UInt32 = 0b100 //4
        
    }
    
    
    //Generate random enemy coordinates
    func random() -> CGFloat{
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    func random(min min: CGFloat, max: CGFloat) -> CGFloat{
        return random() * (max - min) + min
    }
    
    
    let gameArea: CGRect
    
    override init(size: CGSize) {
        
        let maxAspectRatio: CGFloat = 16.0/9.0
        let playableWidth = size.height / maxAspectRatio
        let margin = (size.width - playableWidth) / 2
        gameArea = CGRect(x: margin, y: 0, width: playableWidth, height: size.height)
        
        super.init(size: size)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView){
        
        gameScore = 0
        
        self.physicsWorld.contactDelegate = self
        
        //put background code in a for loop to create scrolling effect
        for i in 0...10{
            
        let background = SKSpriteNode(imageNamed: "background")
        background.size = self.size
        background.anchorPoint = CGPoint(x: 0.5, y: 0)
        background.position = CGPoint(x: self.size.width/2,
                                      y: self.size.height*CGFloat(i))
        background.zPosition = 0
        background.name = "Background"
        self.addChild(background)
        }
        
        //make player object and set it on screen
        player.setScale(1)
        player.position = CGPoint(x: self.size.width/2, y: 0 - player.size.height)
        player.zPosition = 2
        player.physicsBody = SKPhysicsBody(rectangleOfSize: player.size)
        player.physicsBody!.affectedByGravity = false
        player.physicsBody!.categoryBitMask = PhysicsCategories.Player
        player.physicsBody!.collisionBitMask = PhysicsCategories.None
        player.physicsBody!.contactTestBitMask = PhysicsCategories.Enemy
        self.addChild(player)
        
        //Create and place score label
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 70
        scoreLabel.fontColor = SKColor.whiteColor()
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        scoreLabel.position = CGPoint(x: self.size.width * 0.15, y: self.size.height + scoreLabel.frame.size.height)
        scoreLabel.zPosition = 100
        self.addChild(scoreLabel)
        
        //create and place lives label
        livesLabel.text = "Lives: 1"
        livesLabel.fontSize = 70
        livesLabel.fontColor = SKColor.whiteColor()
        livesLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
        livesLabel.position = CGPoint(x: self.size.width * 0.85, y: self.size.height + livesLabel.frame.size.height)
        livesLabel.zPosition = 100
        self.addChild(livesLabel)
        
        let moveOnToScreenAction = SKAction.moveToY(self.size.height * 0.9, duration: 0.3)
        scoreLabel.runAction(moveOnToScreenAction)
        //livesLabel.runAction(moveOnToScreenAction)
        
        //create tap to begin label
        tapToStartLabel.text = "Tap To Begin"
        tapToStartLabel.fontSize = 125
        tapToStartLabel.fontColor = SKColor.whiteColor()
        tapToStartLabel.zPosition = 1
        tapToStartLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        tapToStartLabel.alpha = 0
        self.addChild(tapToStartLabel)
        
        let fadeInAction = SKAction.fadeInWithDuration(0.3)
        tapToStartLabel.runAction(fadeInAction)
        
    }
    
    //create global variable to determine time between frames (time between "updates")
    var lastUpdateTime: NSTimeInterval = 0
    var deltaFrameTime: NSTimeInterval = 0
    var amountToMovePerSecond: CGFloat = 600.0

    //creates scrolling function : FramePerSecond = how many times update runs
    override func update(currentTime: NSTimeInterval){
        
        if lastUpdateTime == 0 {
            lastUpdateTime = currentTime
        }
        else{
            deltaFrameTime = currentTime - lastUpdateTime
            lastUpdateTime = currentTime
        }
        
        let amountToMoveBackground = amountToMovePerSecond * CGFloat(deltaFrameTime)
        
        self.enumerateChildNodesWithName("Background"){
            background, stop in
            
            //only make the background scroll when game is in "Play"
            if self.currentGameState == gameState.inGame{
            background.position.y -= amountToMoveBackground
            }
            
            //if background scrolls to bottom of the screen, start over from the top
            if background.position.y < -self.size.height{
                background.position.y += self.size.height*2
            }
        }
    }
    
    
    
    func startGame(){
        currentGameState = gameState.inGame
        
        let fadeOutAction = SKAction.fadeOutWithDuration(0.5)
        let deleteAction = SKAction.removeFromParent()
        let deleteSequence = SKAction.sequence([fadeOutAction, deleteAction])
        tapToStartLabel.runAction(deleteSequence)
        let moveShipOntoScreenAction = SKAction.moveToY(self.size.height * 0.2, duration: 0.5)
        let startLevelAction = SKAction.runBlock(startNewLevel)
        let startGameSequence = SKAction.sequence([moveShipOntoScreenAction, startLevelAction])
        player.runAction(startGameSequence)
        
    }
    
    
    func loseALife(){
        //code for losing a life 
        livesNumber -= 1
        livesLabel.text = "Lives: \(livesNumber)"
        
        //have lives label grow in size then shrink for each life lost
        let scaleUp = SKAction.scaleTo(1.5, duration: 0.2)
        let scaleDown = SKAction.scaleTo(1, duration:  0.2)
        let scaleSequence = SKAction.sequence([scaleUp, scaleDown])
        livesLabel.runAction(scaleSequence)
        
        if livesNumber == 0 {
            runGameOver()
        }
        
        
    }
    
    func addScore(){
        
        gameScore += 1
        scoreLabel.text = "Score: \(gameScore)"
        
        //Once you reach a certain score you advance through the levels
        if gameScore == 10 || gameScore == 25 || gameScore == 50 {
            startNewLevel()
        }
        
        
    }
    
    func runGameOver(){
        //change game state variable to show game is now over
        currentGameState = gameState.afterGame
        
        self.removeAllActions()
        
        //Stop and remove all instances of "bullets"
        self.enumerateChildNodesWithName("Bullet"){
            bullet, stop in
            
            bullet.removeAllActions()
            
        }
        //Stop and remove all instances of "Enemy"
        self.enumerateChildNodesWithName("Enemy"){
            enemy, stop in
            enemy.removeAllActions()
        }
        
        //changes to game over screen onces game is over
        let changeSceneAction = SKAction.runBlock(changeScene)
        let waitToChangeScene = SKAction.waitForDuration(1)
        let changeSceneSequence = SKAction.sequence([waitToChangeScene,changeSceneAction])
        self.runAction(changeSceneSequence)
    
    }
    
    func changeScene(){
        
        let sceneToMoveTo = GameOverScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        let myTransition = SKTransition.fadeWithDuration(0.5)
        self.view!.presentScene(sceneToMoveTo, transition: myTransition)
        
    }
    
    
    
    func didBeginContact(contact: SKPhysicsContact) {
        //Collision Code
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask{
            body1 = contact.bodyA
            body2 = contact.bodyB
        }
        else{
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
        
        //if the player has hit the enemy
        if body1.categoryBitMask == PhysicsCategories.Player && body2.categoryBitMask == PhysicsCategories.Enemy{
            
            //spawns explosion image
            if body1.node != nil{
            spawnExplosion(body1.node!.position)
            }
            if body2.node != nil{
            spawnExplosion(body2.node!.position)
            }
            
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            
            runGameOver()
        }
        
        //if the bullet has hit the enemy      
        if body1.categoryBitMask == PhysicsCategories.Bullet && body2.categoryBitMask == PhysicsCategories.Enemy && body2.node?.position.y < self.size.height {
            
            //Add score for each enemy hit
            addScore()
            
            //spawn explosion image
            if body2.node != nil{
            spawnExplosion(body2.node!.position)
            }
            //Remove enemy and bullet from view
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
        }
        
    }
    
    func  spawnExplosion(spawnPosition: CGPoint){
        
        let explosion = SKSpriteNode(imageNamed: "boom")
        explosion.position = spawnPosition
        explosion.zPosition = 3
        explosion.setScale(0)
        self.addChild(explosion)
        
        //makes exploson more realistic
        let scaleIn = SKAction.scaleTo(1, duration: 0.1)
        let fadeOut = SKAction.fadeOutWithDuration(0.1)
        let delete = SKAction.removeFromParent()

        let explosionSequence = SKAction.sequence([explosionSound, scaleIn, fadeOut, delete])
        
        explosion.runAction(explosionSequence)
    }
    
    func startNewLevel() {
        
        levelNumber += 1
        
        //if enemies are spawning already, restarts when new level is reached
        if self.actionForKey("spawningEnemies") != nil{
            self.removeActionForKey("spawningEnemies")
        }
        
        var levelDuration = NSTimeInterval()
        
        //Increase difficulty every level by lowering enemy spawn times
        switch levelNumber{
        case 1: levelDuration = 1.2
        case 2: levelDuration = 1
        case 3: levelDuration = 0.8
        case 4: levelDuration = 0.5
        default:
            levelDuration = 0.5
            print("Cannot find level info")
        }
        
        
        let spawn = SKAction.runBlock(spawnEnemy)
        let waitToSpawn = SKAction.waitForDuration(1)
        let spawnSequence = SKAction.sequence([waitToSpawn, spawn])
        let spawnForever = SKAction.repeatActionForever(spawnSequence)
        self.runAction(spawnForever, withKey: "spawningEnemies")
        
    }
    
    
    func fireBullet() {
        
        let bullet = SKSpriteNode(imageNamed: "bullet")
        bullet.name = "Bullet"
        bullet.setScale(1)
        bullet.position = player.position
        bullet.zPosition = 1
        bullet.physicsBody = SKPhysicsBody(rectangleOfSize: bullet.size)
        bullet.physicsBody!.affectedByGravity = false
        bullet.physicsBody!.categoryBitMask = PhysicsCategories.Bullet
        bullet.physicsBody!.collisionBitMask = PhysicsCategories.None
        bullet.physicsBody!.contactTestBitMask = PhysicsCategories.Enemy
        self.addChild(bullet)
        
        let moveBullet = SKAction.moveToY(self.size.height + bullet.size.height, duration: 1)
        let deleteBullet = SKAction.removeFromParent()
        
        let bulletSequence = SKAction.sequence([bulletSound, moveBullet, deleteBullet])
        bullet.runAction(bulletSequence)
        
    }
    
    func spawnEnemy(){
        
        let randomXStart = random(min: CGRectGetMinX(gameArea) , max: CGRectGetMaxX(gameArea))
        let randomXEnd = random(min: CGRectGetMinX(gameArea), max: CGRectGetMaxX(gameArea))
        
        let startPoint = CGPoint(x: randomXStart, y: self.size.height * 1.2)
        let endPoint = CGPoint(x: randomXEnd, y: -self.size.height * 0.2)
        
        let enemy = SKSpriteNode(imageNamed: "enemyShip")
        enemy.name = "Enemy"
        enemy.setScale(1)
        enemy.position = startPoint
        enemy.zPosition = 2
        enemy.physicsBody = SKPhysicsBody(rectangleOfSize: enemy.size)
        enemy.physicsBody!.affectedByGravity = false
        enemy.physicsBody!.categoryBitMask = PhysicsCategories.Enemy
        enemy.physicsBody!.collisionBitMask = PhysicsCategories.None
        enemy.physicsBody?.contactTestBitMask = PhysicsCategories.Player | PhysicsCategories.Bullet
        self.addChild(enemy)
        
        
        let moveEnemy = SKAction.moveTo(endPoint, duration: 1.5)
        let deleteEnemy = SKAction.removeFromParent()
        let loseALifeAction = SKAction.runBlock(loseALife)
        let enemySequence = SKAction.sequence([moveEnemy, deleteEnemy])
        
        //only allow enemies to move when "inGame"
        if currentGameState == gameState.inGame{
        enemy.runAction(enemySequence)
        }
        
        let dx = endPoint.x - startPoint.x
        let dy = endPoint.y - startPoint.y
        let amountToRotate = atan2(dy, dx)
        enemy.zRotation = amountToRotate
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        //start game when "tap to begin" is touched
        if currentGameState == gameState.preGame{
            startGame()
        }
        
        //can only fire bullets when "inGame'
        else if currentGameState == gameState.inGame{
        fireBullet()
        }
    }

    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches{
            
            let pointOfTouch = touch.locationInNode(self)
            let previousPointOfTouch = touch.previousLocationInNode(self)
            
            let amountDragged = pointOfTouch.x - previousPointOfTouch.x
            
            if currentGameState == gameState.inGame{
            player.position.x += amountDragged
            }
            if player.position.x > CGRectGetMaxX(gameArea) - player.size.width/2 {
                player.position.x = CGRectGetMaxX(gameArea) - player.size.width/2
            }
            
            if player.position.x < CGRectGetMinX(gameArea) + player.size.width/2{
                player.position.x = CGRectGetMinX(gameArea) + player.size.width/2
            }
            
    }
  }

}

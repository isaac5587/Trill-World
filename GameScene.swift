//
//  GameScene.swift
//  Xworld
//
//  Created by Trill Isaac on 1/22/19.
//  Copyright © 2019 Trill Isaac. All rights reserved.
//

import SpriteKit
import GameplayKit

var gameScore = 0;

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    let scoreLabel = SKLabelNode(fontNamed: "The Bold Font") //assigns font type
    var levelNumber = 0;
    var livesNumber = 6;
    let livesLabel = SKLabelNode(fontNamed: "The Bold Font")
    
    let player = SKSpriteNode(imageNamed: "player")    //creating spaceship and location
    let bulletSound = SKAction.playSoundFileNamed("bulletsound.wav", waitForCompletion: false)
    let explosionSound = SKAction.playSoundFileNamed("explosionSound.wav", waitForCompletion: false)
    
    let tapToStartLabel = SKLabelNode(fontNamed: "The Bold Font") // begin label
    let directionsLabel = SKLabelNode(fontNamed: "The Bold Font") // directions label
    let directionsLabel2 = SKLabelNode(fontNamed: "The Bold Font") // directions label
    let directionsLabel3 = SKLabelNode(fontNamed: "The Bold Font") // directions label
    
    
    enum gameState { // creating a unique data type
        case preGame  // before the start of the game
        case inGame   // during gameplay
        case afterGame // after gameplay
    }
    
    var currentGameState = gameState.preGame  // before the game is in action
    
    
    
    struct physicsCategories { // This struct holds various physics, so we can define which object types collide or have contact with each other.
        
        static let None: UInt32 = 0
        static let Player : UInt32 = 0b1 //1
        static let Bullet : UInt32 = 0b10 //2
        static let Enemy : UInt32 = 0b100 //2
        
    }
    func random() -> CGFloat{
        return(CGFloat(Float(arc4random()) / 0xFFFFFFFF)) // returns a random value with a specified range
    }
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    let gameArea: CGRect
    
    override init(size: CGSize) {
        
        // making the game size up across devices
        let maxAspectRatio: CGFloat = 16.0/9.0
        let playableWidth = size.height / maxAspectRatio
        let margin = (size.width - playableWidth) / 2
        gameArea = CGRect(x: margin, y: 0, width: playableWidth, height: size.height)
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) { //intializes a new view controller
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {  //positioning the space background
        
        gameScore = 0 // intializing the game's score
        
        self.physicsWorld.contactDelegate = self
        
        for i in 0...1 { // for loop for
            
            let background = SKSpriteNode(imageNamed: "background") // uses background image
            background.size = self.size // adjusting size to fit screen
            background.anchorPoint = CGPoint(x: 0.5, y: 0)   // background position
            background.position = CGPoint(x: self.size.width/2,
                                          y: self.size.height*CGFloat(i))
            background.zPosition = 0 //depth of the background position
            background.name = "Background"
            self.addChild(background) //adds a specified node (background) to the specified location
            
        }
        player.setScale(1)                              //positioning the player
        player.position = CGPoint(x: self.size.width/2, y: 0 - self.size.height)
        player.zPosition = 2
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody!.affectedByGravity = false  // player is not moved by gravity
        //physics properties for each thing
        player.physicsBody!.categoryBitMask = physicsCategories.Player
        player.physicsBody!.collisionBitMask = physicsCategories.None
        player.physicsBody!.contactTestBitMask = physicsCategories.Enemy
        self.addChild(player)
        
        scoreLabel.text = "Kills: 0" // kills label
        scoreLabel.fontSize = 70  //size
        scoreLabel.fontColor = SKColor.magenta
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scoreLabel.position = CGPoint(x: self.size.width*0.21, y: self.size.height + scoreLabel.frame.size.height) // positioning
        scoreLabel.zPosition = 100  //depth
        self.addChild(scoreLabel)
        
        livesLabel.text = "Lives : 6"
        livesLabel.fontSize = 70
        livesLabel.fontColor = SKColor.yellow
        livesLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        livesLabel.position = CGPoint(x: self.size.width*0.78, y: self.size.height + livesLabel.frame.size.height)
        livesLabel.zPosition = 100
        self.addChild(livesLabel)
        
        // transition for score and lives label
        let moveOnToScreenAction = SKAction.moveTo(y: self.size.height * 0.9, duration: 0.9)
        scoreLabel.run(moveOnToScreenAction)
        livesLabel.run(moveOnToScreenAction)
        
        
        // tap to start label
        tapToStartLabel.text = "Tap the screen to fire a bullet"
        tapToStartLabel.fontSize = 60
        tapToStartLabel.fontColor = SKColor.yellow
        tapToStartLabel.zPosition = 1
        tapToStartLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        tapToStartLabel.alpha = 0
        self.addChild(tapToStartLabel)
        
        let fadeInAction = SKAction.fadeIn(withDuration: 0.3)
        tapToStartLabel.run(fadeInAction)
        
        
        // directions label
        directionsLabel.text = "Move your finger"
        directionsLabel.fontSize = 60
        directionsLabel.fontColor = SKColor.yellow
        directionsLabel.zPosition = 1
        directionsLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.45)
        directionsLabel.alpha = 0
        self.addChild(directionsLabel)
        directionsLabel.run(fadeInAction)
        
        directionsLabel2.text = "left or right"
        directionsLabel2.fontSize = 60
        directionsLabel2.fontColor = SKColor.yellow
        directionsLabel2.zPosition = 1
        directionsLabel2.position = CGPoint(x: self.size.width/2, y: self.size.height*0.40)
        directionsLabel2.alpha = 0
        self.addChild(directionsLabel2)
        directionsLabel2.run(fadeInAction)
        
        directionsLabel3.text = "to  move  the  player"
        directionsLabel3.fontSize = 60
        directionsLabel3.fontColor = SKColor.yellow
        directionsLabel3.zPosition = 1
        directionsLabel3.position = CGPoint(x: self.size.width/2, y: self.size.height*0.35)
        directionsLabel3.alpha = 0
        self.addChild(directionsLabel3)
        directionsLabel3.run(fadeInAction)
        
    }
    // creating time intervals
    var lastUpdateTime : TimeInterval = 0
    var deltaFrameTime : TimeInterval = 0
    var amountToMovePerSecond: CGFloat = 600.0
    
    
    
    // function to check time intervals
    override func update(_ currentTime: TimeInterval) {
        
        if lastUpdateTime == 0{
            lastUpdateTime = currentTime
        }
        else{
            deltaFrameTime = currentTime - lastUpdateTime
            lastUpdateTime = currentTime
            
        }
        
        //allows background to move repeatedly
        let amountToMoveBackground = amountToMovePerSecond * CGFloat(deltaFrameTime)
        
        self.enumerateChildNodes(withName: "Background"){
            background, stop in
            
            if self.currentGameState == gameState.inGame{
                background.position.y -= amountToMoveBackground
            }
            
            if background.position.y < -self.size.height{
                background.position.y += self.size.height*2
            }
        }
        
    }
    
    //when the game begins
    func startGame(){
        currentGameState = gameState.inGame //change game state to in game
        
        let fadeOutAction = SKAction.fadeOut(withDuration: 0.5)
        let deleteAction = SKAction.removeFromParent()
        let deleteSequence = SKAction.sequence([fadeOutAction, deleteAction])
        tapToStartLabel.run(deleteSequence)
        directionsLabel.run(deleteSequence)
        directionsLabel2.run(deleteSequence)
        directionsLabel3.run(deleteSequence)
        
        
        
        
        let moveShipOntoScreenAction = SKAction.moveTo(y: self.size.height*0.2, duration: 0.5)
        let startLevelAction = SKAction.run(startNewLevel)
        let startGameSequence = SKAction.sequence([moveShipOntoScreenAction, startLevelAction])
        player.run(startGameSequence)
        
    }
    
    func loseALife(){ // when the player enemy passes by the player
        
        livesNumber -= 1
        livesLabel.text = "Lives Left: \(livesNumber)"
        livesLabel.fontColor = SKColor.red
        livesLabel.fontSize = 45
        let scaleUp = SKAction.scale(to: 1.5, duration: 0.2)
        let scaleDown =  SKAction.scale(to: 1.5, duration: 0.2)
        let scaleSequence = SKAction.sequence([scaleUp, scaleDown])
        livesLabel.run(scaleSequence)
        
        if livesNumber == 0{
            runGameOver()
        }
        
        
    }
    
    func addScore() { // adds the score when the enemy is killed
        
        gameScore += 1
        scoreLabel.text = "Kills: \(gameScore)"
        
        if gameScore == 5 || gameScore == 15 || gameScore == 25 || gameScore == 60 { // this determines how hard the level becomes
            
            startNewLevel()
        }
        
    }
    
    func runGameOver() { // when the player ends the game either by death or runs out of chances
        
        currentGameState = gameState.afterGame //when the player is killed
        
        self.removeAllActions()
        self.enumerateChildNodes(withName: "Bullet"){
            bullet, stop in // loops around objects on the list
            bullet.removeAllActions() //removes bullets
        }
        self.enumerateChildNodes(withName: "Enemy"){
            enemy, stop in
            enemy.removeAllActions() // removes enemies
        }
        
        let changeSceneAction = SKAction.run(changeScene) //switches scene based on what it was before
        let waitToChangeScene = SKAction.wait(forDuration: 1)
        let changeSceneSequence = SKAction.sequence([waitToChangeScene, changeSceneAction])
        self.run(changeSceneSequence)
    }
    
    func changeScene (){ //scene transition
        
        let sceneToMoveTo = GameOverScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        let myTransition = SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(sceneToMoveTo, transition: myTransition)
        
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) { // when enemies collide
        
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
        if body1.categoryBitMask == physicsCategories.Player && body2.categoryBitMask == physicsCategories.Enemy{ // if the player collides with enemy
            
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            spawnExplosion(spawnPosition: body1.node!.position)
            runGameOver()
        }
        if body1.categoryBitMask == physicsCategories.Bullet && body2.categoryBitMask == physicsCategories.Enemy { // if the bullet hits the enemy
            
            addScore()
            
            if body2.node != nil{
                if body2.node!.position.y > self.size.height{
                    return //if the enemy is off the top of the screen, 'return'. This will stop running this code here, therefore doing nothing unless we hit the enemy when it's on the screen. As we are already checking that body2.node isn't nothing, we can safely unwrap (with '!)' this here.
                }
                else{
                    spawnExplosion(spawnPosition: body2.node!.position)
                }
            }
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            
        }
    }
    
    // function to create explosions
    func spawnExplosion (spawnPosition: CGPoint) {
        let explosion = SKSpriteNode (imageNamed: "Explosion")
        explosion.position = spawnPosition
        explosion.zPosition = 3
        explosion.setScale(0)
        self.addChild(explosion)
        
        // time intervals
        let scaleIn = SKAction.scale(to: 1, duration: 0.1)
        let fadeOut = SKAction.fadeOut(withDuration: 0.1)
        let delete = SKAction.removeFromParent()
        let explosionSequence = SKAction.sequence([explosionSound,scaleIn,fadeOut, delete])
        explosion.run(explosionSequence)
    }
    
    func startNewLevel (){
        
        levelNumber += 1
        
        if self.action(forKey: "spawningEnemies") != nil{ //when to stop spawning enemies
            self.removeAction(forKey: "spawningEnemies")
        }
        
        var levelDuration = TimeInterval()
        
        
        // duration until the level increases
        switch levelNumber {
        case 1: levelDuration = 1
        case 2: levelDuration = 0.8
        case 3: levelDuration = 0.6
        case 4: levelDuration = 0.4
        case 5: levelDuration = 0.2
        case 6: levelDuration = 0.05
        case 7: levelDuration = 0.02
        case 8: levelDuration = 0.001
        default:
            levelDuration = 0.5 // cannot determine level information
            print("Cannot Find Level Information")
        }
        
        
        let spawn = SKAction.run(spawnEnemy)
        let waitToSpawn = SKAction.wait(forDuration: levelDuration)
        let spawnSequence = SKAction.sequence([waitToSpawn, spawn])
        let SpawnForever = SKAction.repeatForever(spawnSequence)
        self.run(SpawnForever, withKey: "spawningEnemies")
        
    }
    // firing bullets function
    func fireBullet() {
        
        let bullet = SKSpriteNode(imageNamed: "bullet")  //creating bullet and location
        bullet.name = "Bullet" //bullet's reference name
        bullet.setScale(1)
        bullet.position = player.position
        bullet.zPosition = 1
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
        bullet.physicsBody!.affectedByGravity = false
        bullet.physicsBody!.categoryBitMask = physicsCategories.Bullet
        bullet.physicsBody!.collisionBitMask = physicsCategories.None
        bullet.physicsBody!.contactTestBitMask = physicsCategories.Enemy
        self.addChild(bullet)
        
        let moveBullet = SKAction.moveTo(y: self.size.height + bullet.size.height,duration: 1)
        let deleteBullet = SKAction.removeFromParent()
        
        let bulletSequence = SKAction.sequence([bulletSound,moveBullet, deleteBullet]) //sound bullet
        bullet.run(bulletSequence)
    }
    
    func spawnEnemy(){       //creating enemy and random location
        
        let randomXStart = random(min: gameArea.minX , max: gameArea.maxX)
        let randomXEnd = random(min: gameArea.minX , max: gameArea.maxX)
        
        let startPoint = CGPoint(x: randomXStart, y: self.size.height * 1.2)
        let endPoint = CGPoint(x: randomXEnd, y: -self.size.height * 0.2)
        
        let enemy = SKSpriteNode(imageNamed: "enemyPlayer")
        enemy.name = "Enemy"
        enemy.setScale(1)
        enemy.position = startPoint
        enemy.zPosition = 2
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody!.affectedByGravity = false
        enemy.physicsBody!.categoryBitMask = physicsCategories.Enemy
        enemy.physicsBody!.collisionBitMask = physicsCategories.None
        enemy.physicsBody!.contactTestBitMask = physicsCategories.Player | physicsCategories.Bullet
        self.addChild(enemy)
        
        let moveEnemy = SKAction.move(to: endPoint, duration: 4.0)
        let deleteEnemy = SKAction.removeFromParent()
        let loseALifeAction = SKAction.run(loseALife)
        let enemySequence = SKAction.sequence([moveEnemy, deleteEnemy, loseALifeAction])
        
        if currentGameState == gameState.inGame{
            enemy.run(enemySequence)
        }
        
        let dx = endPoint.x - startPoint.x
        let dy = endPoint.y - startPoint.y
        let amountToRotate = atan2(dy,dx)
        enemy.zRotation = amountToRotate //rotates the enemy for all directions
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {// when tapped
        
        if currentGameState == gameState.preGame{
            startGame()
        }
            
        else if currentGameState == gameState.inGame{
            fireBullet()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch:AnyObject in touches{
            
            let pointOfTouch = touch.location(in: self)
            let previousPointOfTouch = touch.previousLocation(in: self)
            let amountDragged = pointOfTouch.x - previousPointOfTouch.x // how player slides
            
            if currentGameState == gameState.inGame{  // checking if state is ingame
                player.position.x += amountDragged
            }
            player.position.x += amountDragged   // math for player's new position
            
            if player.position.x > gameArea.maxX - player.size.width/2
            {player.position.x = gameArea.maxX - player.size.width/2
            }
            if player.position.x < gameArea.minX + player.size.width/2
            {player.position.x = gameArea.minX + player.size.width/2
            }
            
        }
    }
    
    
    
    
    
}





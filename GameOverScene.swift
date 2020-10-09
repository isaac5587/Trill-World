//
//  GameOverScene.swift
//  Space Journey
//
//  Created by Trill Isaac on 1/28/19.
//  Copyright © 2019 Trill Isaac. All rights reserved.
//

import Foundation
import SpriteKit


class GameOverScene: SKScene{
    
    let restartLabel = SKLabelNode(fontNamed: "The Bold Font")
    let exitLabel = SKLabelNode(fontNamed: "The Bold Font")
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "end")
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2  , y: self.size.height/2 )
        background.zPosition = 0
        self.addChild(background)
        
        let gameOverLabel = SKSpriteNode(imageNamed: "youdied")
        gameOverLabel.position = CGPoint(x: self.size.width*0.55, y: self.size.height*0.68)
        gameOverLabel.zPosition = 1
        self.addChild(gameOverLabel)
        
        
        /* let gameOverLabel = SKLabelNode(fontNamed: "The Bold Font")
         gameOverLabel.text = "YOU DIED"
         gameOverLabel.fontSize = 190
         gameOverLabel.fontColor = SKColor.red
         gameOverLabel.position = CGPoint(x: self.size.width * 0.51, y: self.size.height * 0.7)
         gameOverLabel.zPosition = 1
         self.addChild(gameOverLabel)
         */
        
        let scoreLabel = SKLabelNode(fontNamed: "The Bold Font")
        scoreLabel.text = "Kills: \(gameScore)"
        scoreLabel.fontSize = 120
        scoreLabel.fontColor = SKColor.magenta
        scoreLabel.position = CGPoint(x: self.size.width/2 , y: self.size.height*0.54)
        scoreLabel.zPosition = 1
        self.addChild(scoreLabel)
        
        let defaults = UserDefaults ()
        var highScoreNumber = defaults.integer(forKey: "highScoreSaved")
        
        if gameScore > highScoreNumber{ //setting a new high score
            highScoreNumber = gameScore
            defaults.set(highScoreNumber, forKey: "highScoreSaved")
        }
        
        let highScoreLabel = SKLabelNode(fontNamed: "The Bold Font")
        highScoreLabel.text = "High Score: \(highScoreNumber)"
        highScoreLabel.fontSize = 110
        highScoreLabel.fontColor = SKColor.yellow
        highScoreLabel.zPosition = 1
        highScoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.44)
        self.addChild(highScoreLabel)
        
        
        //let restartLabel = SKSpriteNode(imageNamed: "tryAgain")
        //restartLabel.zPosition = 1
        //restartLabel.position = CGPoint(x: self.size.width*0.52, y: self.size.height*0.35)
        //restartLabel.name = "startButton"
        //self.addChild(restartLabel)
        
        
        
        
        
        
        restartLabel.text = "Try Again"
        restartLabel.fontSize = 120
        restartLabel.fontColor = SKColor.green
        restartLabel.zPosition = 1
        restartLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.34)
        self.addChild(restartLabel)
        
        
        exitLabel.text = "Exit"
        exitLabel.fontSize = 150
        exitLabel.fontColor = SKColor.red
        exitLabel.zPosition = 1
        exitLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.1)
        self.addChild(exitLabel)
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches{
            
            let pointOfTouch = touch.location(in: self)
            
            if restartLabel.contains(pointOfTouch){
                
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
                
            }
            if exitLabel.contains(pointOfTouch) {
                
                let sceneToMoveTo = MainMenuScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
            }
        }
        
        
    }
    
    
}



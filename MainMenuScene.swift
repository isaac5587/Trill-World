//
//  MainMenuScene.swift
//  Xworld
//
//  Created by Trill Isaac on 1/29/19.
//  Copyright © 2019 Trill Isaac. All rights reserved.
//

import Foundation
import SpriteKit

class MainMenuScene: SKScene{
    
    override func didMove(to view: SKView) {
        
        //creating main menu background
        let background = SKSpriteNode(imageNamed: "bac")
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        background.name = "startButton"
        self.addChild(background)
        
        
        // placing logo image
        let logo = SKSpriteNode(imageNamed: "INGAMELOGO")
        logo.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.60)
        logo.zPosition = 1
        logo.name = "startButton"
        self.addChild(logo)
        
        // placing travis player head
        let player = SKSpriteNode(imageNamed: "player2")
        player.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.25)
        player.zPosition = 1
        player.name = "startButton"
        self.addChild(player)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            
            let pointOfTouch = touch.location(in: self)
            let nodeITapped = atPoint(pointOfTouch)
            
            if nodeITapped.name == "startButton" { // checking if start button is pressed
                
                let sceneToMoveTo = GameScene(size: self.size) // move to game scene
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
                
                
            }
            
        }
    }
}

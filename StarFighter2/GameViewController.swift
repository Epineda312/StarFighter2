//
//  GameViewController.swift
//  StarFighter2
//
//  Created by student on 12/1/16.
//  Copyright (c) 2016 EP Games. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

class GameViewController: UIViewController {
    
    //background music for game
    var backingAudio = AVAudioPlayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        //Path to music I want to be player
        let filePath = NSBundle.mainBundle().pathForResource("BoCt", ofType: "mp3")
        let audioNSURL = NSURL(fileURLWithPath: filePath!)
        do { backingAudio = try AVAudioPlayer(contentsOfURL: audioNSURL)}
            
        //in case audio dosent work
        catch{return print("Cannot Find The Audio")}
        
        //Number of times music loops, then code to start playing the selected music
        //When set to -1 it loops forever
        backingAudio.numberOfLoops = -1
        backingAudio.play()
        

        let scene = MaineMenuScene(size: CGSize(width: 1536, height: 2048))
            // Configure the view.
            let skView = self.view as! SKView
        
            //these are normally both true when still developing, when your done its best to set to false.
            skView.showsFPS = false
            skView.showsNodeCount = false
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
        
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

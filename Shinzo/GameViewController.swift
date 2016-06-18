//
//  GameViewController.swift
//  Shinzo
//
//  Created by Ian White on 24/04/2016.
//  Copyright (c) 2016 Ian White. All rights reserved.
//

import UIKit
import SpriteKit
import GoogleMobileAds

class GameViewController: UIViewController {

    var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Create a banner ad and add it to the view hierarchy.
        bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        bannerView.hidden = true
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"// test ad
       // bannerView.adUnitID = "ca-app-pub-2729774462696402/9351863773" // live ad
        bannerView.rootViewController = self
        view.addSubview(bannerView)
        
        let scene = HomeScene(size: view.bounds.size)
        // Configure the view.
        let skView = self.view as! SKView
            
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
            
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .AspectFill
        scene.bannerView = self.bannerView
            
        skView.presentScene(scene)
    }
    
    func showBanner() {
        bannerView.hidden = false
        let request = GADRequest()
   //     request.testDevices = ["2077ef9a63d2b398840261c8221a0c9b"]
        bannerView.loadRequest(request)
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

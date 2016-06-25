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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let scene = HomeScene(size: view.bounds.size)
        // Configure the view.
        let skView = self.view as! SKView
            
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
            
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .AspectFill
        
        setupAds()
            
        skView.presentScene(scene)
    }
    
    func setupAds() {
        Ads.bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        Ads.bannerView.hidden = true
        // Ads.bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"// test ad
        Ads.bannerView.adUnitID = "ca-app-pub-2729774462696402/9351863773" // live ad
        Ads.bannerView.rootViewController = self
        Ads.rootVC = self
        Ads.gamesToShowInterstitial = Int(Random.random(min: 1, max: 4))
        
        view.addSubview(Ads.bannerView)
    }
    
    func showBanner() {
        Ads.bannerView.hidden = false
        let request = GADRequest()
        request.testDevices = ["2077ef9a63d2b398840261c8221a0c9b"]
        Ads.bannerView.loadRequest(request)
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

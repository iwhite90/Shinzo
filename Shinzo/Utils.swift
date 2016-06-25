//
//  Utils.swift
//  Shinzo
//
//  Created by Ian White on 13/06/2016.
//  Copyright © 2016 Ian White. All rights reserved.
//

import Foundation
import GoogleMobileAds

class Utils {
    static func defaultsKeyFor(boardType: String, level: Int) -> String {
        return "\(boardType)-level\(level)"
    }
    
    static func showBanner(bannerView: GADBannerView, screenHeight: CGFloat) {
        bannerView.hidden = false
        let request = GADRequest()
        request.testDevices = [ kGADSimulatorID, "2fe890f315d2ba56207ad407abaf630c"]
        bannerView.loadRequest(request)
        var bannerFrame = bannerView.frame
        bannerFrame.origin.x = 0
        bannerFrame.origin.y = screenHeight - bannerFrame.size.height
        
        bannerView.frame = bannerFrame
    }
    
    static func hideBanner(bannerView: GADBannerView) {
        bannerView.hidden = true
    }
    
    static func showBannerIfHidden(bannerView: GADBannerView) {
        if bannerView.hidden {
            bannerView.hidden = false
        }
    }
    
    static func createAndLoadInterstitial() {
        //Ads.interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")// test ad
        Ads.interstitial = GADInterstitial(adUnitID: "ca-app-pub-2729774462696402/4745573771") // live ad
        if Ads.gamesToShowInterstitial == 0 {
            Ads.gamesToShowInterstitial = Int(Random.random(min: 2, max: 5))
            let request = GADRequest()
            request.testDevices = [ kGADSimulatorID, "2fe890f315d2ba56207ad407abaf630c" ]
            Ads.interstitial.loadRequest(request)
        } else {
            Ads.gamesToShowInterstitial -= 1
        }
    }
    
    static func presentIntersitial() {
        if Ads.interstitial.isReady {
            Ads.interstitial.presentFromRootViewController(Ads.rootVC)
        } else {
            print("Ad wasn't ready")
        }
    }

}
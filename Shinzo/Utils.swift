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
        request.testDevices = ["2fe890f315d2ba56207ad407abaf630c"]
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
}
//
//  CocoaCommon.swift
//  CocoaChina
//
//  Created by 何文新 on 15/7/13.
//  Copyright (c) 2015年 Hupun. All rights reserved.
//

import Foundation
import WebKit

class CocoaCommon {
    static func getConfig(name:String, extend:String, injection:WKUserScriptInjectionTime) -> WKWebViewConfiguration {
        let config = WKWebViewConfiguration()
        let resource = NSBundle.mainBundle().pathForResource(name, ofType: extend)
        let file = String(contentsOfFile: resource!, encoding: NSUTF8StringEncoding, error: nil)
        let script = WKUserScript(source: file!, injectionTime: injection, forMainFrameOnly: true)
        config.userContentController.addUserScript(script)
        return config
    }
}
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
        var scriptJS = jsDic[name]
        if scriptJS == nil {
            let resource = NSBundle.mainBundle().pathForResource(name, ofType: extend)
            scriptJS = String(contentsOfFile: resource!, encoding: NSUTF8StringEncoding, error: nil)
            jsDic[name] = scriptJS
        }
        
        let script = WKUserScript(source: scriptJS!, injectionTime: injection, forMainFrameOnly: true)
        config.userContentController.addUserScript(script)
        return config
    }
    
    static var jsDic = [String:String]()
}
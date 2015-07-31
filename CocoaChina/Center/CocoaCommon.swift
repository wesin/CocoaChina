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
        var script = jsDic[name]
        if script == nil {
            let resource = NSBundle.mainBundle().pathForResource(name, ofType: extend)
            let scriptJS = String(contentsOfFile: resource!, encoding: NSUTF8StringEncoding, error: nil)
            script = WKUserScript(source: scriptJS!, injectionTime: injection, forMainFrameOnly: true)
            jsDic[name] = script
        }
        config.userContentController.addUserScript(script!)
        return config
    }
    
    static func getJS(name:String, extend:String, injection:WKUserScriptInjectionTime) -> WKUserScript {
        var script = jsDic[name]
        if script == nil {
            let resource = NSBundle.mainBundle().pathForResource(name, ofType: extend)
            let scriptJS = String(contentsOfFile: resource!, encoding: NSUTF8StringEncoding, error: nil)
            script = WKUserScript(source: scriptJS!, injectionTime: injection, forMainFrameOnly: true)
            jsDic[name] = script
        }
        return script!
    }
    
    static var jsDic = [String:WKUserScript]()
}
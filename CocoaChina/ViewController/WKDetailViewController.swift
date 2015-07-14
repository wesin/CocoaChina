//
//  WKDetailViewController.swift
//  CocoaChina
//
//  Created by 何文新 on 15/7/10.
//  Copyright (c) 2015年 Hupun. All rights reserved.
//

import UIKit
import WebKit

class WKDetailViewController:UIViewController, WKNavigationDelegate {
    
    var url = ""
    var wkView:WKWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let config = CocoaCommon.getConfig("detail", extend: "js", injection:WKUserScriptInjectionTime.AtDocumentEnd)
        wkView = WKWebView(frame: CGRectZero, configuration: config)
        wkView?.loadRequest(NSURLRequest(URL: NSURL(string: url)!, cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy, timeoutInterval: 60*60*1000))
        wkView?.navigationDelegate = self
        self.view.addSubview(wkView!)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        wkView?.frame = self.view.bounds
    }
    
    //MARK:WKNavigationDelegate
//    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
//        wkView?.frame = self.view.bounds
//    }
    
    
    

}


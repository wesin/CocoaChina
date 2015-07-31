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
    
    var swipeGesture:UISwipeGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let config = CocoaCommon.getConfig("detail", extend: "js", injection:WKUserScriptInjectionTime.AtDocumentEnd)
        wkView = WKWebView(frame: CGRectZero, configuration: config)
        wkView?.loadRequest(NSURLRequest(URL: NSURL(string: url)!, cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy, timeoutInterval: 60*60*1000))
        wkView?.navigationDelegate = self
        wkView?.userInteractionEnabled = true
        self.view.addSubview(wkView!)
        
        swipeGesture = UISwipeGestureRecognizer(target: self, action: Selector("turnBack"))
        swipeGesture?.direction = UISwipeGestureRecognizerDirection.Right
        wkView?.addGestureRecognizer(swipeGesture!)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        wkView?.frame = self.view.bounds
    }
    
    //MARK:WKNavigationDelegate
//    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
//        wkView?.frame = self.view.bounds
//    }
    
    func turnBack() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

}


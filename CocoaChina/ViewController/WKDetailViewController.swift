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
    
    @IBOutlet weak var progress: UIProgressView!
    
    var swipeGesture:UISwipeGestureRecognizer?
//    var progress:HPProgress?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let config = CocoaCommon.getConfig("detail", extend: "js", injection:WKUserScriptInjectionTime.AtDocumentEnd)
        wkView = WKWebView(frame: CGRectZero, configuration: config)
        wkView?.loadRequest(NSURLRequest(URL: NSURL(string: url)!, cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy, timeoutInterval: 60*60))
        wkView?.navigationDelegate = self
        wkView?.userInteractionEnabled = true
        self.view.insertSubview(wkView!, belowSubview: progress)
        
        swipeGesture = UISwipeGestureRecognizer(target: self, action: Selector("turnBack"))
        swipeGesture?.direction = UISwipeGestureRecognizerDirection.Right
        wkView?.addGestureRecognizer(swipeGesture!)

//        [webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
//        [webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        wkView?.frame = self.view.bounds
        wkView?.addObserver(self, forKeyPath: "estimatedProgress", options: NSKeyValueObservingOptions.New, context: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        wkView?.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
    //MARK:WKNavigationDelegate
//    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
//        wkView?.frame = self.view.bounds
//    }
    
    func turnBack() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "estimatedProgress" {
            progress.alpha = 1
            progress.setProgress(Float(wkView!.estimatedProgress), animated: true)
            if wkView?.estimatedProgress >= 1 {
                progress.hidden = true
            } else {
                progress.hidden = false
            }
        }
    }

}


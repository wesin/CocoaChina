//
//  BGViewController.swift
//  CocoaChina
//
//  Created by 何文新 on 15/7/10.
//  Copyright (c) 2015年 Hupun. All rights reserved.
//

import UIKit
import WebKit

class BGViewController:UIViewController,WKScriptMessageHandler {
    
    var mainView:MainViewController?
    var leadView:LeadViewController?
    var webView:WKWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataSource("alldata", type: "js", urlStr: mainUrl)
        getDataSource("special", type: "js", urlStr: mainUrl + "//special")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    //MARK:WKScriptMessageHandler
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        if message.name == MessageHandler.MainHandler.rawValue {
            if let contentDic = message.body as? [String:[[String:AnyObject]]] {
                for (key,value) in contentDic {
                    var tempData = [DataContent]()
                    value.map(){
                        tempData.append(DataContent(contentObj: $0))
                    }
                    switch key {
                    case "main":
                        PageDataCenter.instance.dataAll[ListType.Main] = tempData
                        showView()
                    case "new":
                        PageDataCenter.instance.dataAll[ListType.New] = tempData
                    case "special":
                        PageDataCenter.instance.dataAll[ListType.Special] = tempData
                    default:
                        return
                    }
                }
                //异步加载图片数据
//                PageDataCenter.instance.loadImageAsync()
            }
        }
    }
    
    private func showView() {
        mainView = CommonFunc.getViewFromStoryBoard("Main", viewIndetifier: "viewmain") as? MainViewController
        self.presentViewController(mainView!, animated: false, completion: nil)
    }
    
    /**
    获取数据源
    
    :param: name	文件名
    :param: type	文件后缀名
    */
    func getDataSource(name:String, type:String, urlStr:String) {
        let config = CocoaCommon.getConfig(name, extend: type, injection: WKUserScriptInjectionTime.AtDocumentEnd)
        config.userContentController.addScriptMessageHandler(self, name: MessageHandler.MainHandler.rawValue)
        webView = WKWebView(frame: CGRectZero, configuration: config)
//                webView.navigationDelegate = self
        //        webView.loadRequest(NSURLRequest(URL: ))
        webView?.loadRequest(NSURLRequest(URL: NSURL(string: urlStr)!, cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy, timeoutInterval: 60*60))
        self.view.addSubview(webView!)
    }
    
    
    

    
}

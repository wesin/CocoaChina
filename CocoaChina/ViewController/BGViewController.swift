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
    
    @IBOutlet weak var imgBG: UIImageView!
    
    var mainView:MainViewController?
    var leadView:LeadViewController?
    var webView:WKWebView?
    
    var tapGesture:UITapGestureRecognizer?
    /// 是否接收点击继续功能
    var canTap = false
    var hud:MBProgressHUD?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgBG.image = UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("launchbg", ofType: "jpg")!)


        loadSource()
        
        print(NSTemporaryDirectory())
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    deinit{
        print("bgview deinit")
    }
    
    //MARK:WKScriptMessageHandler
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        if message.name == MessageHandler.MainHandler.rawValue {
            if let contentDic = message.body as? [String:[[String:AnyObject]]] {
                for (key,value) in contentDic {
//                    var tempData = [DataContent]()
                    let tempData = value.map({DataContent(contentObj: $0)})
//                    value.map(){
//                        tempData.append(DataContent(contentObj: $0))
//                    }
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
        //翻转
        mainView?.modalPresentationStyle = UIModalPresentationStyle.FullScreen
        mainView?.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
        self.presentViewController(mainView!, animated: true, completion: nil)
    }
    
    /**
    获取数据源
    
    - parameter name:	文件名
    - parameter type:	文件后缀名
    */
    func getDataSource(name:String, type:String, urlStr:String) {
        let config = CocoaCommon.getConfig(name, extend: type, injection: WKUserScriptInjectionTime.AtDocumentEnd)
        config.userContentController.addScriptMessageHandler(LeakAvoider(delegate: self), name: MessageHandler.MainHandler.rawValue)
        webView = WKWebView(frame: CGRectZero, configuration: config)
//                webView.navigationDelegate = self
        //        webView.loadRequest(NSURLRequest(URL: ))
        webView?.loadRequest(NSURLRequest(URL: NSURL(string: urlStr)!, cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy, timeoutInterval: 60*60))
        self.view.addSubview(webView!)
    }
    
    func continueView() {
        if canTap {
//            if !IJReachability.isConnectedToNetwork() {
//                hud?.show(true)
//                hud?.hide(true, afterDelay: 3)
//                return
//            }
            canTap = false
            loadSource()
        }
    }
    
    func loadSource() {
        
        getDataSource("alldata", type: "js", urlStr: mainUrl)
        getDataSource("special", type: "js", urlStr: mainUrl + "//special")
    }
    
    /**
    添加点击继续功能
    */
    func addContinue() {
        canTap = true
        tapGesture = UITapGestureRecognizer(target: self, action: Selector("continueView"))
        tapGesture?.numberOfTapsRequired = 1
        tapGesture?.numberOfTouchesRequired = 1
        imgBG.addGestureRecognizer(tapGesture!)
        imgBG.userInteractionEnabled = true
    }
    
}

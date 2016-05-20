//
//  LeadListViewController.swift
//  CocoaChina
//
//  Created by 何文新 on 15/7/15.
//  Copyright (c) 2015年 Hupun. All rights reserved.
//

import UIKit
import WebKit

/// 防止delegate强引用造成循环引用问题的解决类
class LeakAvoider : NSObject, WKScriptMessageHandler {
    weak var delegate : WKScriptMessageHandler?
    init(delegate:WKScriptMessageHandler) {
        self.delegate = delegate
        super.init()
    }
    func userContentController(userContentController: WKUserContentController,
        didReceiveScriptMessage message: WKScriptMessage) {
            self.delegate?.userContentController(
                userContentController, didReceiveScriptMessage: message)
    }
}

class LeadListViewController:ListCommonViewController,WKScriptMessageHandler {
    
    var url = ""
    /// 下一页的url
    var nextUrl = ""
    var webView:WKWebView?
    var txtTitle = ""
    
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var tableList: UITableView!
    
    var header:MJRefreshNormalHeader?
    var footer:MJRefreshBackNormalFooter?
    
    var hud:MBProgressHUD?
    
    var timer:NSTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataSource()
        navItem.title = txtTitle
        tableList.tableFooterView = UIView(frame: CGRectZero)
        pageType = .Content
        tableList.registerNib(UINib(nibName: "ContentListRowCell", bundle: nil), forCellReuseIdentifier: "contentlistrowcell")
        dataSource = [DataContent]()
        
        header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(LeadListViewController.getDataSource))
        header?.lastUpdatedTimeLabel!.hidden = true
        header?.setTitle("下拉刷新", forState: MJRefreshStateIdle)
        header?.setTitle("加载中...", forState: MJRefreshStateRefreshing)
        header?.setTitle("松开结束", forState: MJRefreshStatePulling)
        tableList.header = header
        
        footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(LeadListViewController.getNextData))
        tableList.footer = footer
        
        hud = MBProgressHUD(view: self.view)
        self.view.addSubview(hud!)
        hud?.labelText = "刷新中..."
        hud?.show(true)
        timer = NSTimer(timeInterval: 15, target: self, selector: #selector(LeadListViewController.stopLoading), userInfo: nil, repeats: false)
        NSRunLoop.currentRunLoop().addTimer(timer!, forMode: NSDefaultRunLoopMode)
        
        let rightSwiper = UISwipeGestureRecognizer(target: self, action: #selector(LeadListViewController.back(_:)))
        rightSwiper.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(rightSwiper)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        CommonFunc.changeUserAgent(false)
        CalculateFunc.beginPage("List:" + url)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        CalculateFunc.endPage("List:" + url)
    }
    
    
    
    deinit {
        print("LeadList deinit")
        webView?.configuration.userContentController.removeScriptMessageHandlerForName(MessageHandler.ContentHandler.rawValue)
    }
    
    @IBAction func back(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let content = dataSource![indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("contentlistrowcell", forIndexPath: indexPath) as! ContentListRowTableViewCell
        if let data = PageDataCenter.instance.loadImageLoacation(content.imgurl) {
            cell.imgTitle.image = UIImage(data: data)
        } else {
            cell.imgTitle.image = UIImage(named: "logo")
            getImage(indexPath)
        }
        cell.labelTitle.text = content.title
        cell.labelTime.text = content.time
        cell.labelClick.text = content.click
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == self.dataSource!.count - 5 {
            getNextData()
        }
    }
    
    //MARK:WKScriptMessageHandler
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        if message.name == MessageHandler.ContentHandler.rawValue {
            if let contentDic = message.body as? [String:AnyObject] {
                if contentDic["preurl"] as? String == nil {
                    self.dataSource?.removeAll()
                }
                for (key,value) in contentDic {
//                    var tempData = [DataContent]()
                    if key == "content" {
                        if let data = value as? [[String:AnyObject]] {
                            _ = data.map(){
                                self.dataSource?.append(DataContent(contentObj: $0))
                            }
                            if data.count > 0 {
                                tableList.reloadData()
                            }
                        }
                    } else if key == "nexturl" {
                        if value as? String == nil || self.dataSource?.count > maxCount {
                            nextUrl = ""
                        } else {
                            nextUrl = url + "//" + (value as! String)
                        }
                    }
                }
            }
        }
        header?.endRefreshing()
        footer?.endRefreshing()
        hud?.hide(true)
        timer?.invalidate()
    }
    
    /**
    异步加载图片
    
    - parameter index:	cell indexpath
    */
    func getImage(index:NSIndexPath) {
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        dispatch_async(queue) {
            if let data = PageDataCenter.instance.loadImage(self.dataSource![index.row].imgurl) {
                if let cell = self.tableList.cellForRowAtIndexPath(index) as? ContentListRowTableViewCell {
                    dispatch_sync(dispatch_get_main_queue()) {
                        cell.imgTitle.image = UIImage(data: data)
                    }
                }
                
            }
        }
    }
    
    /**
    获取数据源
    
    - parameter name:	文件名
    - parameter type:	文件后缀名
    */
    func getDataSource() {
        if webView == nil {
            let config = CocoaCommon.getConfig("content", extend: "js", injection: WKUserScriptInjectionTime.AtDocumentEnd)
            config.userContentController.addScriptMessageHandler(LeakAvoider(delegate: self), name: MessageHandler.ContentHandler.rawValue)
            webView = WKWebView(frame: CGRectZero, configuration: config)
            webView?.loadRequest(NSURLRequest(URL: NSURL(string: url)!, cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy, timeoutInterval: 60*60))
            self.view.addSubview(webView!)
        } else {
            webView?.loadRequest(NSURLRequest(URL: NSURL(string: url)!))
        }
    }
    
    func getNextData() {
        if nextUrl == "" {
            footer?.noticeNoMoreData()
            return
        }
        webView?.loadRequest(NSURLRequest(URL: NSURL(string: nextUrl)!))
    }
    
    func stopLoading() {
//        if IJReachability.isConnectedToNetwork() {
//            hud?.labelText = "网络延迟"
//        } else {
            hud?.labelText = "网络连接失败"
//        }
        hud?.show(true)
        hud?.hide(true, afterDelay: 2)
    }
}

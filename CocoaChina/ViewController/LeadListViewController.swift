//
//  LeadListViewController.swift
//  CocoaChina
//
//  Created by 何文新 on 15/7/15.
//  Copyright (c) 2015年 Hupun. All rights reserved.
//

import UIKit
import WebKit

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
    
    weak var headerFreshConfig:WKUserContentController?
    
    var hud:MBProgressHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataSource()
        navItem.title = txtTitle
        tableList.tableFooterView = UIView(frame: CGRectZero)
        pageType = .Content
        tableList.registerNib(UINib(nibName: "ContentListRowCell", bundle: nil), forCellReuseIdentifier: "contentlistrowcell")
        dataSource = [DataContent]()
        
        header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: Selector("getDataSource"))
        header?.lastUpdatedTimeLabel.hidden = true
        header?.setTitle("下拉刷新", forState: MJRefreshStateIdle)
        header?.setTitle("加载中...", forState: MJRefreshStateRefreshing)
        header?.setTitle("松开结束", forState: MJRefreshStatePulling)
        tableList.header = header
        
        footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: Selector("getNextData"))
        tableList.footer = footer
        
        hud = MBProgressHUD(view: self.view)
        self.view.addSubview(hud!)
        hud?.labelText = "刷新中..."
        hud?.show(true)
    }
    
    
    
    deinit {
        println("LeadList deinit")
        webView?.configuration.userContentController.removeScriptMessageHandlerForName(MessageHandler.ContentHandler.rawValue)
    }
    
    @IBAction func back(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let content = dataSource![indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("contentlistrowcell", forIndexPath: indexPath) as! ContentListRowTableViewCell
        if let data = PageDataCenter.instance.loadImage(content.imgurl) {
            cell.imgTitle.image = UIImage(data: data)
        }
        cell.labelTitle.text = content.title
        cell.labelTime.text = content.time
        cell.labelClick.text = content.click
        return cell
    }
    
    //MARK:WKScriptMessageHandler
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        if message.name == MessageHandler.ContentHandler.rawValue {
            if let contentDic = message.body as? [String:AnyObject] {
                for (key,value) in contentDic {
//                    var tempData = [DataContent]()
                    if key == "content" {
                        if headerFreshConfig == userContentController {
                            self.dataSource?.removeAll(keepCapacity: true)
                        }
                        if let data = value as? [[String:AnyObject]] {
                            data.map(){
                                self.dataSource?.append(DataContent(contentObj: $0))
                            }
                            if data.count > 0 {
                                tableList.reloadData()
                            }
                        }
                    } else {
                        if value as? String == nil {
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
    }
    
    /**
    获取数据源
    
    :param: name	文件名
    :param: type	文件后缀名
    */
    func getDataSource() {
        webView?.configuration.userContentController.removeScriptMessageHandlerForName(MessageHandler.ContentHandler.rawValue)
        webView?.removeFromSuperview()
        webView = nil
        let config = CocoaCommon.getConfig("content", extend: "js", injection: WKUserScriptInjectionTime.AtDocumentEnd)
        headerFreshConfig = config.userContentController
        config.userContentController.addScriptMessageHandler(LeakAvoider(delegate: self), name: MessageHandler.ContentHandler.rawValue)
        webView = WKWebView(frame: CGRectZero, configuration: config)
        webView?.loadRequest(NSURLRequest(URL: NSURL(string: url)!, cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy, timeoutInterval: 60*60))
        self.view.addSubview(webView!)
    }
    
    func getNextData() {
        if nextUrl == "" {
            footer?.noticeNoMoreData()
//            footer?.endRefreshing()
            return
        }
        webView?.configuration.userContentController.removeScriptMessageHandlerForName(MessageHandler.ContentHandler.rawValue)
        webView?.removeFromSuperview()
        webView = nil
        let config = CocoaCommon.getConfig("content", extend: "js", injection: WKUserScriptInjectionTime.AtDocumentEnd)
        config.userContentController.addScriptMessageHandler(LeakAvoider(delegate: self), name: MessageHandler.ContentHandler.rawValue)
        webView = WKWebView(frame: CGRectZero, configuration: config)
        webView?.loadRequest(NSURLRequest(URL: NSURL(string: nextUrl)!, cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy, timeoutInterval: 60*60))
        self.view.addSubview(webView!)
    }
}

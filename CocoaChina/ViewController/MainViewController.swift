//
//  MainViewController.swift
//  CocoaChina
//
//  Created by 何文新 on 15/7/10.
//  Copyright (c) 2015年 Hupun. All rights reserved.
//

import UIKit
import WebKit

enum ListType:Int {
    case Main = 0
    case New = 1
    case Special = 2
    case Favorite = 3
    case Content = 100
}

class MainViewController:ListCommonViewController, HPSwitchDelegate,WKScriptMessageHandler {
    
    @IBOutlet weak var switchSeg: HPSwitch!
    
    @IBOutlet weak var tableMain: UITableView!
    
    @IBOutlet weak var tabItem: UITabBarItem!
    
    var leadView:LeadViewController?
    var leftGesture:UISwipeGestureRecognizer?
    var leadWidthPer:CGFloat = 0.5
    var converView:UIView?
    
    var header:MJRefreshNormalHeader?
    
    var webView:WKWebView?
    override func viewDidLoad() {
        super.viewDidLoad()
        switchSeg.arrayTitle = ["推荐", "最新", "专题","收藏"]
        switchSeg.delegate = self
        tableMain.contentInset = UIEdgeInsetsMake(2.5, 0, 0, 0)
        tableMain.registerNib(UINib(nibName: "ListRowCell", bundle: nil), forCellReuseIdentifier: "listrowcell")
        tableMain.registerNib(UINib(nibName: "ListRowDetailCell", bundle: nil), forCellReuseIdentifier: "listrowdetailcell")
        tableMain.registerNib(UINib(nibName: "FavoriteRowCell", bundle: nil), forCellReuseIdentifier: "favoriterowcell")
        dataSource = PageDataCenter.instance.dataAll[ListType.Main]
        
        header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: Selector("getDataSource"))
        header?.lastUpdatedTimeLabel!.hidden = true
        header?.setTitle("下拉刷新", forState: MJRefreshStateIdle)
        header?.setTitle("加载中...", forState: MJRefreshStateRefreshing)
        header?.setTitle("松开结束", forState: MJRefreshStatePulling)
        tableMain.header = header
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        hideLeadingImmediately()
    }
    
    @IBAction func showLeading(sender: AnyObject) {
        if converView == nil {
            converView = UIView(frame: self.view.bounds)
            converView?.backgroundColor = UIColor.blackColor()
            let tapGesture = UITapGestureRecognizer(target: self, action: Selector("hideLeading"))
            tapGesture.numberOfTapsRequired = 1
            tapGesture.numberOfTouchesRequired = 1
            converView?.addGestureRecognizer(tapGesture)
        }
        converView?.alpha = 0
        self.view.addSubview(converView!)
        if leadView == nil {
            leadView = CommonFunc.getViewFromStoryBoard("Main", viewIndetifier: "viewlead") as? LeadViewController
            leadView?.parentView = self
            
        }
        let width = self.view.bounds.width * leadWidthPer
        leadView?.view.frame = CGRect(x: -width, y: 0, width: width, height: self.view.bounds.height)
        self.view.addSubview(leadView!.view)

        if leftGesture == nil {
            leftGesture = UISwipeGestureRecognizer(target: self, action: Selector("hideLeading"))
            leftGesture?.direction = UISwipeGestureRecognizerDirection.Left
        }
        UIView.animateWithDuration(0.3, animations: {
            self.leadView?.view.frame = CGRectOffset(self.leadView!.view.frame, self.leadView!.view.frame.width, 0)
            self.converView?.alpha = 0.5
            }, completion: {
            (Bool) -> Void in
                self.leadView?.view.addGestureRecognizer(leftGesture!)
        })
    }
    
    func hideLeading() {
        UIView.animateWithDuration(0.3, animations: {
            self.leadView?.view.frame = CGRectOffset(self.leadView!.view.frame, -self.leadView!.view.frame.width, 0)
            self.converView?.alpha = 0
            }, completion: {
                (Bool) -> Void in
                self.converView?.removeFromSuperview()
                self.leadView?.view.removeFromSuperview()
        })
    }
    
    func hideLeadingImmediately() {
        self.converView?.removeFromSuperview()
        self.leadView?.view.removeFromSuperview()
    }
    
    func refreshView() {
        tableMain.reloadData()
    }
    
    //HPSwitchDelegate
    func switchClick(switchBtn: HPSwitch, atIndex index: Int) {
        pageType = ListType(rawValue: index)!
        if pageType == ListType.Favorite {
            PageDataCenter.instance.getFavoriteList()
            CalculateFunc.beginPage("FavoriteView")
        }
        dataSource = PageDataCenter.instance.dataAll[pageType]
        refreshView()
    }
    
    //MARK:UITabelViewOverride
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return pageType == .Favorite
    }
    
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String! {
        return "删除"
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            FavoriteCenter.instance.deleteFavoriteByIndex(indexPath.row)
            dataSource?.removeAtIndex(indexPath.row)
            tableMain.beginUpdates()
            tableMain.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            tableMain.endUpdates()
        }
    }
    
    //MARK:ReloadView
    
    //MARK:WKScriptMessageHandler
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        if message.name == MessageHandler.MainHandler.rawValue {
            if let contentDic = message.body as? [String:[[String:AnyObject]]] {
                for (key,value) in contentDic {
                    var tempData = [DataContent]()
                     _ = value.map(){
                        tempData.append(DataContent(contentObj: $0))
                    }
                    switch key {
                    case "main":
                        PageDataCenter.instance.dataAll[ListType.Main] = tempData
                    case "new":
                        PageDataCenter.instance.dataAll[ListType.New] = tempData
                    case "special":
                        PageDataCenter.instance.dataAll[ListType.Special] = tempData
                    default:
                        return
                    }
                }
                tableMain.reloadData()
                //异步加载图片数据
                //                PageDataCenter.instance.loadImageAsync()
            }
        }
        header?.endRefreshing()
    }
    
    /**
    获取数据源
    
    - parameter name:	文件名
    - parameter type:	文件后缀名
    */
    func getDataSource() {
        if pageType == ListType.Favorite {
            PageDataCenter.instance.getFavoriteList()
            dataSource = PageDataCenter.instance.dataAll[pageType]
            refreshView()
            header?.endRefreshing()
            return
        }
        if webView == nil {
            let config = CocoaCommon.getConfig("alldata", extend: "js", injection: WKUserScriptInjectionTime.AtDocumentEnd)
            config.userContentController.addScriptMessageHandler(LeakAvoider(delegate: self), name: MessageHandler.MainHandler.rawValue)
            webView = WKWebView(frame: CGRectZero, configuration: config)
            //                webView.navigationDelegate = self
            //        webView.loadRequest(NSURLRequest(URL: ))
            webView?.loadRequest(NSURLRequest(URL: NSURL(string: mainUrl)!, cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy, timeoutInterval: 60*60))
            self.view.addSubview(webView!)
        } else {
            webView?.loadRequest(NSURLRequest(URL: NSURL(string: mainUrl)!))
        }
    }
    
}

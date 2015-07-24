//
//  SearchViewController.swift
//  CocoaChina
//
//  Created by 何文新 on 15/7/16.
//  Copyright (c) 2015年 Hupun. All rights reserved.
//

import UIKit
import WebKit

class SearchViewController: ListCommonViewController,WKScriptMessageHandler {

    @IBOutlet weak var tableResult: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    let searchUrl = "http://www.cocoachina.com//cms//plus//search.php?kwtype=0&keyword=%@&searchtype=titlekeyword"
    var nextUrl = ""
    var webView:WKWebView?
    var lastKeyWords = ""
    
    
    var footer:MJRefreshBackNormalFooter?
    
    var hud:MBProgressHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = [DataContent]()
        // Do any additional setup after loading the view.
        tableResult.registerNib(UINib(nibName: "SearchRowCell", bundle: nil), forCellReuseIdentifier: "searchrowcell")
        tableResult.tableFooterView = UIView(frame: CGRectZero)
        
        footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: Selector("getNextData"))
        tableResult.footer = footer
    }
    
    deinit{
        println("search deinit")
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK:UISearchBarDelegate
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        let keyWord = searchBar.text
        if keyWord == lastKeyWords {
            return
        }
        
        hud = MBProgressHUD(view: self.view)
        self.view.addSubview(hud!)
        //        hud.delegate = self
        hud?.labelText = "搜索中..."
        hud?.show(true)
        let url = String.localizedStringWithFormat(searchUrl, keyWord)
        getDataSource("search", type: "js", urlStr: url)
        
        searchBar.resignFirstResponder()
    }
    
    //MARK:UITableViewDataSource
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var content = dataSource![indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("searchrowcell", forIndexPath: indexPath) as! SearchRowTableViewCell
        cell.labelTitle.text = content.title
        cell.labelContent.text = content.content
        cell.labelTime.text = content.time
        cell.labelRead.text = content.click
        return cell
    }
    
    //MARK:WKScriptMessageHandler
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        if message.name == MessageHandler.SearchHandler.rawValue {
            if let contentDic = message.body as? [String:AnyObject] {
                for (key,value) in contentDic {
                    if key == "result" {
                        if let data = value as? [[String:AnyObject]] {
                            if lastKeyWords != searchBar.text {
                                self.dataSource!.removeAll(keepCapacity: false)
                                lastKeyWords = searchBar.text

                            }
                            data.map(){
                                self.dataSource!.append(DataContent(contentObj: $0))
                            }
                            tableResult.reloadData()
                            if dataSource!.count > 0 {
                                tableResult.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: false)
                            }
                        }
                    } else {
                        if value as? String == nil {
                            nextUrl = ""
                        } else {
                            nextUrl = mainUrl + "//" + (value as! String)
                        }
                    }
                }
            }
        }
        footer?.endRefreshing()
        hud?.hide(true)
    }
    
    
    /**
    获取数据源
    
    :param: name	文件名
    :param: type	文件后缀名
    */
    private func getDataSource(name:String, type:String, urlStr:String) {
        webView?.configuration.userContentController.removeScriptMessageHandlerForName(MessageHandler.SearchHandler.rawValue)
        webView?.removeFromSuperview()
        webView == nil
        let config = CocoaCommon.getConfig(name, extend: type, injection: WKUserScriptInjectionTime.AtDocumentEnd)
        config.userContentController.addScriptMessageHandler(LeakAvoider(delegate: self), name: MessageHandler.SearchHandler.rawValue)
        webView = WKWebView(frame: CGRectZero, configuration: config)
        webView?.loadRequest(NSURLRequest(URL: NSURL(string: urlStr.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)!, cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy, timeoutInterval: 60*60))
        self.view.addSubview(webView!)
    }
    
    /**
    获取数据源
    
    :param: name	文件名
    :param: type	文件后缀名
    */
    func getNextData() {
        if nextUrl == "" {
            footer?.noticeNoMoreData()
            return
        }
        webView?.configuration.userContentController.removeScriptMessageHandlerForName(MessageHandler.SearchHandler.rawValue)
        webView?.removeFromSuperview()
        webView == nil
        let config = CocoaCommon.getConfig("search", extend: "js", injection: WKUserScriptInjectionTime.AtDocumentEnd)
        config.userContentController.addScriptMessageHandler(LeakAvoider(delegate: self), name: MessageHandler.SearchHandler.rawValue)
        webView = WKWebView(frame: CGRectZero, configuration: config)
        webView?.loadRequest(NSURLRequest(URL: NSURL(string: nextUrl)!, cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy, timeoutInterval: 60*60))
        self.view.addSubview(webView!)
    }
    

}

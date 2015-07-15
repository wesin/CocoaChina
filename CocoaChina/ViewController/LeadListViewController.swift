//
//  LeadListViewController.swift
//  CocoaChina
//
//  Created by 何文新 on 15/7/15.
//  Copyright (c) 2015年 Hupun. All rights reserved.
//

import UIKit
import WebKit

class LeadListViewController:ListCommonViewController,WKScriptMessageHandler {
    
    var url = ""
    /// 下一页的url
    var nextUrl = ""
    var webView:WKWebView?
    var txtTitle = ""
    
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var tableList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataSource("content", type: "js", urlStr: url)
        navItem.title = txtTitle
        tableList.tableFooterView = UIView(frame: CGRectZero)
        pageType = .Content
        tableList.registerNib(UINib(nibName: "ContentListRowCell", bundle: nil), forCellReuseIdentifier: "contentlistrowcell")
        dataSource = [DataContent]()
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
                        if let data = value as? [[String:AnyObject]] {
                            data.map(){
                                self.dataSource?.append(DataContent(contentObj: $0))
                            }
                            if data.count > 0 {
                                tableList.reloadData()
                            }
                        }
                    } else {
                        url = url + "//" + (value as! String)
                    }
                }
            }
        }
    }
    
    /**
    获取数据源
    
    :param: name	文件名
    :param: type	文件后缀名
    */
    private func getDataSource(name:String, type:String, urlStr:String) {
        webView?.removeFromSuperview()
        webView = nil
        let config = CocoaCommon.getConfig(name, extend: type, injection: WKUserScriptInjectionTime.AtDocumentEnd)
        config.userContentController.addScriptMessageHandler(self, name: MessageHandler.ContentHandler.rawValue)
        webView = WKWebView(frame: CGRectZero, configuration: config)
        webView?.loadRequest(NSURLRequest(URL: NSURL(string: urlStr)!, cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy, timeoutInterval: 60*60))
        self.view.addSubview(webView!)
    }
}

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
    var webView:WKWebView?
    var lastKeyWords = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = [DataContent]()
        // Do any additional setup after loading the view.
        tableResult.registerNib(UINib(nibName: "SearchRowCell", bundle: nil), forCellReuseIdentifier: "searchrowcell")
        tableResult.tableFooterView = UIView(frame: CGRectZero)
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
        let url = String.localizedStringWithFormat(searchUrl, keyWord)
        getDataSource("search", type: "js", urlStr: url)
        searchBar.resignFirstResponder()
    }
    
    //MARK:UITableViewDataSource
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.dataSource?.count ?? 0) == 0 {
            return 1
        }
        return self.dataSource?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var content:DataContent?
        if (self.dataSource?.count ?? 0) == 0 {
            content = DataContent()
            content?.title = "没有数据!"
        } else {
            content = dataSource![indexPath.row]
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("searchrowcell", forIndexPath: indexPath) as! SearchRowTableViewCell
        cell.labelTitle.text = content!.title
        cell.labelContent.text = content!.content
        cell.labelTime.text = content!.time
        cell.labelRead.text = content!.click
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
                        }
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
        webView == nil
        let config = CocoaCommon.getConfig(name, extend: type, injection: WKUserScriptInjectionTime.AtDocumentEnd)
        config.userContentController.addScriptMessageHandler(self, name: MessageHandler.SearchHandler.rawValue)
        webView = WKWebView(frame: CGRectZero, configuration: config)
        webView?.loadRequest(NSURLRequest(URL: NSURL(string: urlStr.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)!, cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy, timeoutInterval: 60*60))
        self.view.addSubview(webView!)
    }

}
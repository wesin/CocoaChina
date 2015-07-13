//
//  MainViewController.swift
//  CocoaChina
//
//  Created by 何文新 on 15/7/10.
//  Copyright (c) 2015年 Hupun. All rights reserved.
//

import UIKit
import WebKit

class MainViewController:UIViewController, UITableViewDataSource, UITableViewDelegate,WKScriptMessageHandler,WKNavigationDelegate {
    
    
    @IBOutlet weak var tableMain: UITableView!
    let messageHander = "mainhandler"
    
    var dataSource:[DataContent]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableMain.registerNib(UINib(nibName: "ListRowCell", bundle: nil), forCellReuseIdentifier: "listrowcell")
        getDataSource()
    }
    
    @IBAction func showLeading(sender: AnyObject) {
        
    }
    
    //MARK:UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("listrowcell", forIndexPath: indexPath) as! ListRowTableViewCell
        let content = dataSource![indexPath.row]
        if let url = NSURL(string: content.imgurl) {
            if let data = NSData(contentsOfURL: url) {
                cell.imgTitle.image = UIImage(data: data)
            }
        }
        cell.labelTitle.text = content.title
        return cell
    }
    
    //MARK:WKScriptMessageHandler
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        dataSource = [DataContent]()
        if message.name == messageHander {
            if let contentLst = message.body as? [[String:AnyObject]] {
                contentLst.map({
                    self.dataSource?.append(DataContent(contentObj: $0))
                })
            }
        }
        tableMain.reloadData()
    }
    
    //MARK:Private 
    private func getDataSource() {
        let config = WKWebViewConfiguration()
        let scriptURL = NSBundle.mainBundle().pathForResource("main", ofType: "js")
        let scriptContent = String(contentsOfFile:scriptURL!, encoding:NSUTF8StringEncoding, error: nil)
        let script = WKUserScript(source: scriptContent!, injectionTime: .AtDocumentEnd, forMainFrameOnly: true)
        config.userContentController.addUserScript(script)
        config.userContentController.addScriptMessageHandler(self, name: messageHander)
        let webView = WKWebView(frame: CGRectZero, configuration: config)
        webView.navigationDelegate = self
        webView.loadRequest(NSURLRequest(URL: NSURL(string: "http://www.cocoachina.com")!))
        self.view.addSubview(webView)
    }
    
}

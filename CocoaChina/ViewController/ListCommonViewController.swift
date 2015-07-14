//
//  ListCommonViewController.swift
//  CocoaChina
//
//  Created by 何文新 on 15/7/10.
//  Copyright (c) 2015年 Hupun. All rights reserved.
//

import UIKit
import WebKit

enum MessageHandler:String {
    case MainHander = "mainhandler"
}

class ListCommonViewController:UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var dataSource:[DataContent]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
//        if let data = PageDataCenter.instance.loadImage(content.imgurl) {
        let fileName = PageDataCenter.instance.loadImage(content.imgurl)
        if fileName != "" {
            cell.imgTitle.image = UIImage(contentsOfFile: PageDataCenter.instance.imagePath.stringByAppendingPathComponent(fileName))
        }
//        if let url = NSURL(string: content.imgurl) {
//            if let data = NSData(contentsOfURL: url) {
//                let img = UIImage(data: data)
//                cell.imgTitle.image = UIImage(data: data)
//            }
//        }
        cell.labelTitle.text = content.title
        cell.labelTime.text = content.time
        cell.labelClick.text = content.click
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let content = dataSource![indexPath.row]
        let detailView = CommonFunc.getViewFromStoryBoard("Main", viewIndetifier: "viewdetail") as! DetailViewController
        detailView.content = content
        self.presentViewController(detailView, animated: true, completion: nil)
    }
   
    //MARK:Public
    func refreshView() {
        
    }
    
}

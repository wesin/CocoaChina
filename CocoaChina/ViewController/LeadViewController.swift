//
//  LeadViewController.swift
//  CocoaChina
//
//  Created by 何文新 on 15/7/10.
//  Copyright (c) 2015年 Hupun. All rights reserved.
//

import UIKit

class LeadViewController:UIViewController, UITableViewDataSource, UITableViewDelegate,UIViewControllerTransitioningDelegate {
    
    @IBOutlet weak var tableLead: UITableView!
    
    var parentView:UIViewController?
    
    var leadSource:[(url:String, title:String)]?
    var listDic = [String:LeadListViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        leadSource = [("ios","iOS开发"),("swift","Swift"),("appstore","App Store研究"),("game","游戏开发"),("review","应用评测"),("apple","苹果相关"),("design","产品设计"),("market","营销推广"),("cocos","Cocos引擎"),("industry","业界动态"),("webapp","WebApp"),("programmer","程序人生")]
        tableLead.tableFooterView = UIView(frame: CGRectZero)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leadSource!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("leadrowcell", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel?.text = leadSource![indexPath.row].title
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let content = leadSource![indexPath.row]
        let url = mainUrl + "//" + content.url
        var viewTmp = listDic[url]
        if viewTmp == nil {
            viewTmp = CommonFunc.getViewFromStoryBoard("Main", viewIndetifier: "viewleadlist") as? LeadListViewController
            viewTmp?.txtTitle = content.title
            viewTmp?.url = url
        }
        viewTmp?.transitioningDelegate = self
        parentView?.presentViewController(viewTmp!, animated: true, completion: nil)
        
    }
    
    //MARK:UIViewControllerTransitioningDelegate
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ToLeftTransition()
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ToRightTransition()
    }
}

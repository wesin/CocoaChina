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
//    var listDic = [String:LeadListViewController]()
    var leadList:LeadListViewController?
    var settingView:SettingViewController?
    
    var headImage:UIImage?
    var selectColor:UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        leadSource = [("ios","iOS开发"),("swift","Swift"),("appstore","App Store研究"),("game","游戏开发"),("review","应用评测"),("apple","苹果相关"),("design","产品设计"),("market","营销推广"),("cocos","Cocos引擎"),("industry","业界动态"),("webapp","WebApp"),("programmer","程序人生")]
        tableLead.tableFooterView = UIView(frame: CGRectZero)
        headImage = UIImage(contentsOfFile: PageDataCenter.instance.imageHeadName)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("changehead:"), name: "changehead", object: nil)
        selectColor = UIColor(red: 65/255, green: 174/255, blue: 247/255, alpha: 1)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(animated: Bool) {
        if let index = tableLead.indexPathForSelectedRow() {
            tableLead.deselectRowAtIndexPath(index, animated: false)
        }
        super.viewDidDisappear(animated)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "changehead", object: nil)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 88
        }
        return 44
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leadSource!.count + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("headrowcell", forIndexPath: indexPath) as! HeadRowTableViewCell
            cell.imgHead.image = headImage
            cell.selectedBackgroundView = UIView(frame: cell.frame)
            cell.selectedBackgroundView.backgroundColor = selectColor
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("leadrowcell", forIndexPath: indexPath) as! UITableViewCell
            cell.textLabel?.text = leadSource![indexPath.row - 1].title
            cell.selectedBackgroundView = UIView(frame: cell.frame)
            cell.selectedBackgroundView.backgroundColor = selectColor
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            settingView = CommonFunc.getViewFromStoryBoard("Main", viewIndetifier: "viewsetting") as? SettingViewController
            settingView?.transitioningDelegate = self
            CommonFunc.presentView(parentView!, toVC: settingView!)
//            parentView?.presentViewController(settingView!, animated: true, completion: nil)
            return
        }
        let content = leadSource![indexPath.row - 1]
        let url = mainUrl + "//" + content.url
        leadList = nil
        leadList = CommonFunc.getViewFromStoryBoard("Main", viewIndetifier: "viewleadlist") as? LeadListViewController
        leadList?.txtTitle = content.title
        leadList?.url = url
        leadList?.transitioningDelegate = self
        CommonFunc.presentView(parentView!, toVC: leadList!)
        
//        var viewTmp = listDic[url]
//        if viewTmp == nil {
//            viewTmp = CommonFunc.getViewFromStoryBoard("Main", viewIndetifier: "viewleadlist") as? LeadListViewController
//            viewTmp?.txtTitle = content.title
//            viewTmp?.url = url
//        }
//        viewTmp?.transitioningDelegate = self
//        CommonFunc.presentView(parentView!, toVC: viewTmp!)
        
    }
    
    //MARK:UIViewControllerTransitioningDelegate
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ToLeftTransition()
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ToRightTransition()
    }
    
    func changehead(message:NSNotification) {
        headImage = message.object as? UIImage
        tableLead.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: .None)
    }
}

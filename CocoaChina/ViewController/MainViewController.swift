//
//  MainViewController.swift
//  CocoaChina
//
//  Created by 何文新 on 15/7/10.
//  Copyright (c) 2015年 Hupun. All rights reserved.
//

import UIKit

enum ListType:Int {
    case Main = 0
    case New = 1
    case Special = 2
    case Content = 100
}

class MainViewController:ListCommonViewController, HPSwitchDelegate {
    
    @IBOutlet weak var switchSeg: HPSwitch!
    
    @IBOutlet weak var tableMain: UITableView!
    
    @IBOutlet weak var tabItem: UITabBarItem!
    
    var leadView:LeadViewController?
    var leftGesture:UISwipeGestureRecognizer?
    var leadWidthPer:CGFloat = 0.5
    var converView:UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switchSeg.arrayTitle = ["推荐", "最新", "专题"]
        switchSeg.delegate = self
        tableMain.contentInset = UIEdgeInsetsMake(2.5, 0, 0, 0)
        tableMain.registerNib(UINib(nibName: "ListRowCell", bundle: nil), forCellReuseIdentifier: "listrowcell")
        tableMain.registerNib(UINib(nibName: "ListRowDetailCell", bundle: nil), forCellReuseIdentifier: "listrowdetailcell")
        dataSource = PageDataCenter.instance.dataAll[ListType.Main]
        
    }
    
    @IBAction func showLeading(sender: AnyObject) {
        if converView == nil {
            converView = UIView(frame: self.view.bounds)
            converView?.backgroundColor = UIColor.blackColor()
            converView?.alpha = 0
            var tapGesture = UITapGestureRecognizer(target: self, action: Selector("hideLeading"))
            tapGesture.numberOfTapsRequired = 1
            tapGesture.numberOfTouchesRequired = 1
            converView?.addGestureRecognizer(tapGesture)
        }
        self.view.addSubview(converView!)
        if leadView == nil {
            leadView = CommonFunc.getViewFromStoryBoard("Main", viewIndetifier: "viewlead") as? LeadViewController
            leadView?.parentView = self
            
            let width = self.view.bounds.width * leadWidthPer
            leadView?.view.frame = CGRect(x: -width, y: 0, width: width, height: self.view.bounds.height)
        }
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
    
    func refreshView() {
        tableMain.reloadData()
    }
    
    //HPSwitchDelegate
    func switchClick(switchBtn: HPSwitch, atIndex index: Int) {
        pageType = ListType(rawValue: index)!
        dataSource = PageDataCenter.instance.dataAll[pageType]
        refreshView()
    }
    
}

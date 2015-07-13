//
//  BGViewController.swift
//  CocoaChina
//
//  Created by 何文新 on 15/7/10.
//  Copyright (c) 2015年 Hupun. All rights reserved.
//

import UIKit

class BGViewController:UIViewController {
    
    var tabView:TabViewController?
    var leadView:LeadViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabView = CommonFunc.getViewFromStoryBoard("Main", viewIndetifier: "viewtab") as? TabViewController
        self.view.addSubview(tabView!.view)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tabView?.view.frame = self.view.bounds
    }
    
    
    
}

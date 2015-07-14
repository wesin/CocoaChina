//
//  TabViewController.swift
//  CocoaChina
//
//  Created by 何文新 on 15/7/10.
//  Copyright (c) 2015年 Hupun. All rights reserved.
//

import UIKit

class TabViewController: UITabBarController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let mainView = CommonFunc.getViewFromStoryBoard("Main", viewIndetifier: "viewmain") as! MainViewController
        mainView.pageType = .Main
        let newView = CommonFunc.getViewFromStoryBoard("Main", viewIndetifier: "viewmain") as! MainViewController
        newView.pageType = .New
        newView.tabItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.MostRecent, tag: 0)

        self.viewControllers = [mainView,newView]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func getStandardView() -> UIViewController {
        let views = NSUserDefaults.standardUserDefaults().arrayForKey("tabshow") as? [String]
        
        let viewTmp = CommonFunc.getViewFromStoryBoard("Main", viewIndetifier: "viewlist") as! ListCommonViewController
        return viewTmp
    }

}

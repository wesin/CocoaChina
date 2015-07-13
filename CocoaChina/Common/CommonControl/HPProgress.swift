//
//  HPProgress.swift
//  HupunErp
//
//  Created by 何文新 on 15/4/3.
//  Copyright (c) 2015年 wesin. All rights reserved.
//

import UIKit

class HPProgress: UIView {
    
    var controller:UIViewController?
    var imageView:UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(viewController:UIViewController) {
        self.init()
        controller = viewController
        controller?.view.addSubview(self)
        layout(self){
            view in
            //进度条起全屏遮盖效果，可以挡住下面页面切换的突兀跳转效果
            view.center == view.superview!.center
            view.size == view.superview!.size
        }
        let data = NSData(contentsOfFile: NSBundle.mainBundle().pathForResource("gif3", ofType: "gif")!)
        let image = UIImage.animatedImageWithData(data!)

        imageView = UIImageView(frame: CGRectZero)
        imageView!.image = image
        self.addSubview(imageView!)
        controller?.view.sendSubviewToBack(self)
        layout(imageView!) {
            view in
            view.height == 30
            view.width == 100
            view.center == view.superview!.center
        }
        self.backgroundColor = UIColor.clearColor()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func show() {
        println("show")
        imageView?.startAnimating()
        controller?.view.bringSubviewToFront(self)
    }
    
    func hide() {
        println("hide")
        imageView?.stopAnimating()
        controller?.view.sendSubviewToBack(self)
    }

}

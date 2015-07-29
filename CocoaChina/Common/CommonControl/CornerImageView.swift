//
//  CornerImageView.swift
//  CocoaChina
//
//  Created by 何文新 on 15/7/29.
//  Copyright (c) 2015年 Hupun. All rights reserved.
//

import UIKit

@IBDesignable
class CornerImageView: UIImageView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    @IBInspectable
    var corner:CGFloat = 3
    @IBInspectable
    var borderW:CGFloat = 2.5
    @IBInspectable
    var borderC:UIColor = UIColor.whiteColor()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = corner
        self.layer.borderColor = borderC.CGColor
        self.layer.borderWidth = borderW
        self.layer.masksToBounds = true
    }

}

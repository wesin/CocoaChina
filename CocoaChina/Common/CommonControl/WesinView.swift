//
//  WesinImageView.swift
//  HupunErp
//
//  Created by 何文新 on 15/3/19.
//  Copyright (c) 2015年 wesin. All rights reserved.
//

import UIKit

@IBDesignable
class WesinView: UIView {
    
    @IBInspectable
    var borderWidth:CGFloat = 4
    @IBInspectable
    var borderColor:UIColor = UIColor.whiteColor()
    @IBInspectable
    var shadowColor:UIColor = UIColor.greenColor()
    @IBInspectable
    var shadowRadius:CGFloat = 3.0
    
    var viewLayer:CALayer?
    
    override func drawRect(rect: CGRect) {
        viewLayer = self.layer
        viewLayer?.cornerRadius = rect.width / 2
        viewLayer?.masksToBounds = true
        viewLayer?.borderWidth = borderWidth
        viewLayer?.borderColor = borderColor.CGColor
        viewLayer!.shadowOpacity = 1
        viewLayer!.shadowOffset = CGSize(width: 0, height: 0)
        viewLayer!.shadowColor = shadowColor.CGColor
        viewLayer!.shadowRadius = shadowRadius
        viewLayer!.magnificationFilter = kCAFilterLinear
        super.drawRect(rect)
    }
    
    

}

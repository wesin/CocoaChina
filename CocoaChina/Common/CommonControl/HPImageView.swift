//
//  HPImageView.swift
//  HupunErp
//
//  Created by 何文新 on 15/6/19.
//  Copyright (c) 2015年 Hupun. All rights reserved.
//

import UIKit

class HPImageView: UIImageView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.bounds.width / 2
        self.layer.borderColor = UIColor.whiteColor().CGColor
        self.layer.borderWidth = 2.5
        self.layer.masksToBounds = true
//        super.drawRect(rect)
    }
    
//    override func drawRect(rect: CGRect) {
//        
//    }

}

//
//  Animator.swift
//  HupunErp
//
//  Created by 何文新 on 15/5/22.
//  Copyright (c) 2015年 Hupun. All rights reserved.
//

import UIKit

class Animator: NSObject,UIViewControllerAnimatedTransitioning {
   
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.3
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let fromView = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toView = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        transitionContext.containerView()!.addSubview(toView!.view)
        toView?.view.alpha = 0
        UIView.animateWithDuration(self.transitionDuration(transitionContext), animations: {
            fromView?.view.transform = CGAffineTransformMakeScale(0.1, 0.1)
            toView?.view.alpha = 1
            }, completion: {
                (t) -> Void in
                fromView?.view.transform = CGAffineTransformIdentity
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        })
    }
}

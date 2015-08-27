//
//  ToRightTransition.swift
//  HupunErp
//
//  Created by 何文新 on 15/6/15.
//  Copyright (c) 2015年 Hupun. All rights reserved.
//

import UIKit

class ToRightTransition:NSObject,UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.2
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let screenBounds = UIScreen.mainScreen().bounds
        let initFrame = transitionContext.initialFrameForViewController(fromVC!)
        let finalFrame = CGRectOffset(initFrame, screenBounds.width, 0)
        
        let containerView = transitionContext.containerView()
        containerView!.addSubview(toVC!.view)
        containerView!.sendSubviewToBack(toVC!.view)
        
        let duration = self.transitionDuration(transitionContext)
        UIView.animateWithDuration(duration, animations: {
            fromVC?.view.frame = finalFrame
            }, completion: {
                (t) -> Void in
                transitionContext.completeTransition(true)
        })
        
        
        
        // 1. Get controllers from transition context
//        UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
//        UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
//        
//        // 2. Set init frame for fromVC
//        CGRect screenBounds = [[UIScreen mainScreen] bounds];
//        CGRect initFrame = [transitionContext initialFrameForViewController:fromVC];
//        CGRect finalFrame = CGRectOffset(initFrame, screenBounds.size.width, 0);
//        
//        // 3. Add target view to the container, and move it to back.
//        UIView *containerView = [transitionContext containerView];
//        [containerView addSubview:toVC.view];
//        [containerView sendSubviewToBack:toVC.view];
//        
//        // 4. Do animate now
//        NSTimeInterval duration = [self transitionDuration:transitionContext];
//        [UIView animateWithDuration:duration animations:^{
//            fromVC.view.frame = finalFrame;
//            } completion:^(BOOL finished) {
//            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
//            }];
    }
}
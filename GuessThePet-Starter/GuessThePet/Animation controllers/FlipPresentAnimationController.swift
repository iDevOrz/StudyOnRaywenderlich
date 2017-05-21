//
//  FlipPresentAnimationController.swift
//  GuessThePet
//
//  Created by 张建宇 on 2017/5/21.
//  Copyright © 2017年 Razeware LLC. All rights reserved.
//

import UIKit

class FlipPresentAnimationController: NSObject,UIViewControllerAnimatedTransitioning {

    var originFrame = CGRect.zero
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // 1
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {
                return
        }
        
        // 2
        let initialFrame = originFrame
        let finalFrame = transitionContext.finalFrame(for: toVC)
        
        // 3
        let snapshot = toVC.view.snapshotView(afterScreenUpdates: true)
        snapshot?.frame = initialFrame
        snapshot?.layer.cornerRadius = 25
        snapshot?.layer.masksToBounds = true
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toVC.view)
        containerView.addSubview(snapshot!)
        toVC.view.isHidden = true
        
        AnimationHelper.perspectiveTransformForContainerView(containerView)
        snapshot?.layer.transform = AnimationHelper.yRotation(.pi / 2)
        
        // 1
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animateKeyframes(
            withDuration: duration,
            delay: 0,
            options: .calculationModeCubic,
            animations: {
                // 2
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1/3, animations: {
                    fromVC.view.layer.transform = AnimationHelper.yRotation(-.pi / 2)
                })
                
                // 3
                UIView.addKeyframe(withRelativeStartTime: 1/3, relativeDuration: 1/3, animations: {
                    snapshot?.layer.transform = AnimationHelper.yRotation(0.0)
                })
                
                // 4
                UIView.addKeyframe(withRelativeStartTime: 2/3, relativeDuration: 1/3, animations: {
                    snapshot?.frame = finalFrame
                })
        },
            completion: { _ in
                // 5
                toVC.view.isHidden = false
                fromVC.view.layer.transform = AnimationHelper.yRotation(0.0)
                snapshot?.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
    


}

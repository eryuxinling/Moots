//
//  DismissAnimator.swift
//  MagicMove
//
//  Created by xiAo_Ju on 2018/6/13.
//  Copyright © 2018 Bourne. All rights reserved.
//

import UIKit

class DismissTransition : NSObject {
    let duration: TimeInterval
    init(duration: TimeInterval) {
        self.duration = duration
        super.init()
    }
}

extension DismissTransition: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from) else {
            return
        }

        let containerView = transitionContext.containerView
        containerView.addSubview(fromView)

        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.1, options: .curveLinear, animations: {
            fromView.frame.origin.x = containerView.frame.width
            containerView.backgroundColor = UIColor(white: 0, alpha: 0)
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}

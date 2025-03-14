//
//  InstantaneousPushVC.swift
//  Lumia
//
//  Created by 黄伯驹 on 2019/12/31.
//  Copyright © 2019 黄伯驹. All rights reserved.
//

import UIKit

class InstantaneousPushVC: UIViewController {

    private lazy var square: UIImageView = {
        let square = UIImageView(image: UIImage(named: "Box1"))
        return square
    }()
    
    private lazy var centerPoint: UIImageView = {
       let centerPoint = UIImageView(image: UIImage(named: "Origin"))
        centerPoint.translatesAutoresizingMaskIntoConstraints = false
        return centerPoint
    }()
    
    private lazy var pushBehavior: UIPushBehavior = {
       let pushBehavior = UIPushBehavior(items: [square], mode: .instantaneous)
       pushBehavior.angle = 0.0
       pushBehavior.magnitude = 0.0
       return pushBehavior
    }()
    
    private lazy var animator: UIDynamicAnimator = {
        let animator = UIDynamicAnimator(referenceView: self.view)
        return animator
    }()
    
    private lazy var textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.text = "Tap anywhere to create a force."
        textLabel.font = UIFont(name: "Chalkduster", size: 15)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        return textLabel
    }()

    override func loadView() {
        view = DecorationView()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(textLabel)
        textLabel.bottomAnchor.constraint(equalTo: view.safeBottomAnchor).isActive = true
        textLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(centerPoint)
        centerPoint.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        centerPoint.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        square.frame.origin = CGPoint(x: 200, y: 200)
        view.addSubview(square)

        let collisionBehavior = UICollisionBehavior(items: [square])
        collisionBehavior.setTranslatesReferenceBoundsIntoBoundary(with: UIEdgeInsets(top: view.safeAreaInsets.top, left: 0, bottom:  view.safeAreaInsets.bottom, right:  0))
        // Account for any top and bottom bars when setting up the reference bounds.
        animator.addBehavior(collisionBehavior)

        animator.addBehavior(pushBehavior)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleSnapGesture))
        view.addGestureRecognizer(tap)
    }
    
    @objc func handleSnapGesture(_ gesture: UITapGestureRecognizer) {
        // Tapping will change the angle and magnitude of the impulse. To visually
        // show the impulse vector on screen, a red arrow representing the angle
        // and magnitude of this vector is briefly drawn.
        let p = gesture.location(in: view)

        let o = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        var distance = sqrt(pow(p.x - o.x, 2.0)+pow(p.y-o.y, 2.0))
        let angle = atan2(p.y-o.y, p.x-o.x)
        distance = min(distance, 100.0)
        
        // Display an arrow showing the direction and magnitude of the applied
        // impulse.
        (view as? DecorationView)?.drawMagnitudeVector(with: distance, angle: angle, color: .red, forLimitedTime: true)

        // These two lines change the actual force vector.
        pushBehavior.magnitude = distance / 100
        pushBehavior.angle = angle
        // A push behavior in instantaneous (impulse) mode automatically
        // deactivate itself after applying the impulse. We thus need to reactivate
        // it when changing the impulse vector.
        pushBehavior.active = true
    }
}

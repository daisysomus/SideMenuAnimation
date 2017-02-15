//
//  SideMenuAnimation.swift
//  SideMenuAnimation
//
//  Created by liaojinhua on 2017/2/9.
//  Copyright © 2017年 Daisy. All rights reserved.
//

import UIKit

protocol SideMenuAnimationProtocol {
    func animationViews() -> [UIView]
    func parentView() -> UIView
}

class SideMenuAnimation {
    
    var delegate:SideMenuAnimationProtocol
    var rightView:UIView
    var rootView:UIView
    
    var isOpen = true
    
    private var animationViews = [UIView]()
    
    private let animationDuration = 1.0
    
    private let dimmingView = UIView()
    private let shadowView = UIView()
    private let shadowWidth:CGFloat = 20
    
    
    init(delegate:SideMenuAnimationProtocol, rootView:UIView, rightView:UIView) {
        self.delegate = delegate
        self.rightView = rightView
        self.rootView = rootView
        
        self.configForAnimations()
    }
    
    private func configForAnimations() {
        self.dimmingView.backgroundColor = UIColor.black
        self.dimmingView.frame = self.rightView.frame
        self.rootView.addSubview(self.dimmingView)
        self.dimmingView.alpha = 0.5
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(handleTapGesture(gesture:)))
        self.dimmingView.addGestureRecognizer(tapGesture)
        
        self.shadowView.frame = CGRect(x:self.delegate.parentView().frame.width, y:0, width:self.shadowWidth, height:self.rootView.frame.height)
        let layer = CAGradientLayer()
        layer.frame = self.shadowView.bounds
        layer.colors = [UIColor(white:0.0, alpha: 0.5).cgColor, UIColor(white:0.0, alpha: 0.0).cgColor]
        layer.startPoint = CGPoint(x:0.0, y:0.0)
        layer.endPoint = CGPoint(x:1.0, y:0.0)
        shadowView.layer.insertSublayer(layer, at: 1)
        shadowView.alpha = 1.0
        self.rootView.addSubview(shadowView)
        
    }
    
    private func viewWidth() -> CGFloat {
        return self.delegate.parentView().frame.width
    }
    
    @objc func handleTapGesture(gesture:UITapGestureRecognizer) {
        self.closeMenu()
    }
    
    func prepareForAnimation() {
        self.animationViews = self.delegate.animationViews()
    
        for view in self.animationViews {
            view.layer.anchorPoint = CGPoint(x: 0.0, y: 0.5)
            view.frame = view.frame.offsetBy(dx: -0.5 * view.frame.width, dy: 0)
        }
    }
    
    func openMenu() {
        
        guard !isOpen else {
            return
        }
        self.rootView.addSubview(self.delegate.parentView())
        
        UIView.animateKeyframes(withDuration: animationDuration, delay: 0, options: .layoutSubviews, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: self.animationTime(), animations: {
                self.dimmingView.center = self.dimmingView.center.offsetBy(dx: self.viewWidth(), dy: 0)
                self.shadowView.center = self.shadowView.center.offsetBy(dx: self.viewWidth(), dy: 0)
                self.rightView.center = self.rightView.center.offsetBy(dx: self.viewWidth(), dy: 0)
                
                self.dimmingView.alpha = 0.5
                self.shadowView.alpha = 1.0
            })
            self.startAnimation(transform: CATransform3DIdentity)
        }) { (finished) in
            self.isOpen = true
            for view in self.animationViews {
                view.layer.anchorPoint = CGPoint(x:0.5, y:0.5)
                view.frame = view.frame.offsetBy(dx: 0.5 * view.frame.width, dy: 0)
            }
            self.animationViews.removeAll()
        }
    }
    
    func closeMenu() {
        guard isOpen else {
            return
        }
        
        self.prepareForAnimation()
        
        UIView.animateKeyframes(withDuration: animationDuration, delay: 0, options: .layoutSubviews, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0, animations: {
                self.dimmingView.center = self.dimmingView.center.offsetBy(dx: -self.viewWidth(), dy: 0)
                self.shadowView.center = self.shadowView.center.offsetBy(dx: -self.viewWidth(), dy: 0)
                self.rightView.center = self.rightView.center.offsetBy(dx: -self.viewWidth(), dy: 0)
                
                self.dimmingView.alpha = 0.0
                self.shadowView.alpha = 0.0
            })
            self.startAnimation(transform: CATransform3DMakeRotation(CGFloat(M_PI_2), 0.0, 1.0, 0.0))
        }) { (finished) in
            self.isOpen = false
           
            self.delegate.parentView().removeFromSuperview()
        }
    }
    
    let interval = 0.6
    func startAnimation(transform:CATransform3D) {
        
        let animationTime = self.animationTime()
        
        var startTime = 0.0
        for (index, view) in self.animationViews.enumerated() {
            startTime = (TimeInterval)(index) * interval * animationTime
            UIView.addKeyframe(withRelativeStartTime: startTime,
                               relativeDuration: animationTime,
                               animations: {
                view.layer.transform = transform
            })
        }
    }
    
    private func animationTime() -> TimeInterval {
        return 1.0 / (TimeInterval(self.animationViews.count - 1) * interval + 1)
    }
}

extension CGPoint {
    func offsetBy(dx:CGFloat, dy:CGFloat) -> CGPoint {
        return CGPoint(x:self.x + dx,y:self.y + dy)
    }
}


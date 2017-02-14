//
//  SideMenuAnimation.swift
//  SideMenuAnimation
//
//  Created by liaojinhua on 2017/2/9.
//  Copyright © 2017年 Daisy. All rights reserved.
//

import UIKit

class SideMenuAnimation {
    
    var rootVC:UIViewController
    var menuVC:SideMenuViewController
    var rightVC:UIViewController
    
    var isOpen = true
    
    private var animationViews = [UIView]()
    
    private let animationDuration = 1.0
    
    private let dimmingView = UIView()
    private let shadowView = UIView()
    private let shadowWidth:CGFloat = 20
    
    private var menuCellSize:CGFloat = 0
    
    init(rootVC:UIViewController,menuVC:SideMenuViewController, rightVC:UIViewController) {
        self.rootVC = rootVC
        self.menuVC = menuVC
        self.rightVC = rightVC
        
        self.configForAnimations()
    }
    
    private func configForAnimations() {
        self.dimmingView.backgroundColor = UIColor.black
        self.dimmingView.frame = self.rightVC.view.frame
        self.rootVC.view.addSubview(self.dimmingView)
        self.dimmingView.alpha = 0.5
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(handleTapGesture(gesture:)))
        self.dimmingView.addGestureRecognizer(tapGesture)
        
        self.shadowView.frame = CGRect(x:self.menuVC.view.frame.width, y:0, width:self.shadowWidth, height:self.rootVC.view.frame.height)
        let layer = CAGradientLayer()
        layer.frame = self.shadowView.bounds
        layer.colors = [UIColor(white:0.0, alpha: 0.5).cgColor, UIColor(white:0.0, alpha: 0.0).cgColor]
        layer.startPoint = CGPoint(x:0.0, y:0.0)
        layer.endPoint = CGPoint(x:1.0, y:0.0)
        shadowView.layer.insertSublayer(layer, at: 1)
        shadowView.alpha = 1.0
        self.rootVC.view.addSubview(shadowView)
        
        self.menuCellSize = self.menuVC.view.frame.width
    }
    
    @objc func handleTapGesture(gesture:UITapGestureRecognizer) {
        self.closeMenu()
    }
    
    func prepareForAnimation() {
        let visibleCells = self.menuVC.tableView.visibleCells
        
        let yOffset = -self.menuVC.tableView.contentOffset.y
        
        for cell in visibleCells {
            if let view = cell.resizableSnapshotView(from: cell.bounds, afterScreenUpdates: true, withCapInsets: .zero) {
                view.frame = cell.frame.offsetBy(dx: 0, dy: yOffset)
                view.layer.anchorPoint = CGPoint(x: 0.0, y: 0.5)
                view.frame = view.frame.offsetBy(dx: -0.5 * view.frame.width, dy: 0)
                self.animationViews.append(view)
                self.menuVC.view.addSubview(view)
            }
        }
        
    }
    
    func openMenu() {
        //TODO:第一次打开的时候
        
        self.rootVC.view.addSubview(self.menuVC.view)
        UIView.animateKeyframes(withDuration: animationDuration, delay: 0, options: .layoutSubviews, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0, animations: { 
                self.dimmingView.center = self.dimmingView.center.offsetBy(dx: self.menuCellSize, dy: 0)
                self.shadowView.center = self.shadowView.center.offsetBy(dx: self.menuCellSize, dy: 0)
                self.rightVC.view.center = self.rightVC.view.center.offsetBy(dx: self.menuCellSize, dy: 0)
                
                self.dimmingView.alpha = 0.5
                self.shadowView.alpha = 1.0
            })
            self.startAnimation(transform: CATransform3DIdentity)
        }) { (finished) in
            self.isOpen = true
            self.menuVC.tableView.isHidden = false
            for view in self.animationViews {
                view.removeFromSuperview()
            }
            self.animationViews.removeAll()
        }
    }
    
    func closeMenu() {
        guard isOpen else {
            return
        }
        
        self.prepareForAnimation()
        self.menuVC.tableView.isHidden = true
        
        UIView.animateKeyframes(withDuration: animationDuration, delay: 0, options: .layoutSubviews, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0, animations: {
                self.dimmingView.center = self.dimmingView.center.offsetBy(dx: -self.menuCellSize, dy: 0)
                self.shadowView.center = self.shadowView.center.offsetBy(dx: -self.menuCellSize, dy: 0)
                self.rightVC.view.center = self.rightVC.view.center.offsetBy(dx: -self.menuCellSize, dy: 0)
                
                self.dimmingView.alpha = 0.0
                self.shadowView.alpha = 0.0
            })
            self.startAnimation(transform: CATransform3DMakeRotation(CGFloat(M_PI_2), 0.0, 1.0, 0.0))
        }) { (finished) in
            self.isOpen = false
           
            self.menuVC.view.removeFromSuperview()
        }
    }
    
    func startAnimation(transform:CATransform3D) {
        let interval = 0.6
        let animationTime = 1.0 / (TimeInterval(self.animationViews.count) * interval + (1 - interval))
        
        var startTime = 0.0
        for (index, view) in self.animationViews.enumerated() {
            startTime = fmax(TimeInterval(index) * animationTime - TimeInterval(index - 1) * (1 - interval) * animationTime, 0.0)
            UIView.addKeyframe(withRelativeStartTime: startTime, relativeDuration: animationTime, animations: {
                view.layer.transform = transform
            })
        }
    }
}

extension CGPoint {
    func offsetBy(dx:CGFloat, dy:CGFloat) -> CGPoint {
        return CGPoint(x:self.x + dx,y:self.y + dy)
    }
}


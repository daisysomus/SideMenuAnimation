//
//  RootViewController.swift
//  SideMenuAnimation
//
//  Created by liaojinhua on 2017/2/10.
//  Copyright © 2017年 Daisy. All rights reserved.
//

import UIKit

class RootViewController:UIViewController {
    
    private var menuVC:SideMenuViewController?
    private var contentVC:ViewController?
    
    private var sideMenuAnimation:SideMenuAnimation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navVC = self.childViewControllers.first as? UINavigationController
        self.contentVC = navVC?.viewControllers.first as? ViewController
        self.contentVC?.rootVC = self
        
        
        self.menuVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SideMenuViewController") as? SideMenuViewController
        if let _ = self.menuVC {
            self.addChildViewController(self.menuVC!)
            self.menuVC!.view.frame = CGRect(x: 0, y: 0, width: 80, height: self.view.frame.height)
            self.view.addSubview(self.menuVC!.view)
            self.menuVC!.didMove(toParentViewController: self)
        }
        
        navVC!.view.frame = CGRect(x: 80, y: 0, width: navVC!.view.frame.width, height: navVC!.view.frame.height)
        
        self.sideMenuAnimation = SideMenuAnimation.init(rootVC: self, menuVC: self.menuVC!, rightVC: navVC!)
    }
    
    func openMenu() {
        self.sideMenuAnimation?.openMenu()
    }
}

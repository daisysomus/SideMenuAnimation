//
//  ViewController.swift
//  SideMenuAnimation
//
//  Created by liaojinhua on 2017/2/9.
//  Copyright © 2017年 Daisy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    weak var rootVC:RootViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func menuAction(_ sender: Any) {
        self.rootVC?.openMenu()
    }
}


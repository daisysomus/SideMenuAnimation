//
//  SideMenuViewController.swift
//  SideMenuAnimation
//
//  Created by liaojinhua on 2017/2/10.
//  Copyright © 2017年 Daisy. All rights reserved.
//

import UIKit

extension UIColor {
    public convenience init(hexValue:NSInteger) {
        self.init(red: (CGFloat)((hexValue & 0xFF0000) >> 16)/255.0, green: (CGFloat)((hexValue & 0xFF00) >> 8)/255.0, blue: (CGFloat)(hexValue & 0xFF)/255.0, alpha: 1)
    }
    
}

class SideMenuViewController:UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let cellsData = [UIColor(hexValue:0xA52C31),
                             UIColor(hexValue:0xC1413F),
                             UIColor(hexValue:0xDB4C48),
                             UIColor(hexValue:0xD4634B),
                             UIColor(hexValue:0xE36D47),
                             UIColor(hexValue:0xE4754A),
                             UIColor(hexValue:0xED9253),
                             UIColor(hexValue:0xF0A86C),
                             UIColor(hexValue:0xF5AC53),
                             UIColor(hexValue:0xF0B754),
                             UIColor(hexValue:0xf3cd49)]
    
    @IBOutlet weak var tableView: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell")
        cell?.backgroundColor = cellsData[indexPath.row]
        return cell!
    }
    
}

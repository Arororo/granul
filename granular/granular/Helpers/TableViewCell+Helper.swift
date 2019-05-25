//
//  TableViewCell+Helper.swift
//  granular
//
//  Created by Dmitry Babenko on 2019-05-25.
//  Copyright © 2019 Decowareb. All rights reserved.
//

import UIKit

extension UITableViewCell {
    
    @objc static func defaultNibName() -> String {
        let longNibName = NSStringFromClass(self)
        let result = longNibName.components(separatedBy: ".").last!
        return result
    }
    
    @objc static func defaultIdentifier() -> String {
        return self.defaultNibName()
        
    }
    
    @objc static func registerNib(tableView: UITableView) {
        let nibName = self.defaultNibName()
        let nib = UINib(nibName: nibName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: self.defaultIdentifier())
    }
}

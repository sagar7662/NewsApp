//
//  UIViewController+RefreshControl.swift
//  News App
//
//  Created by SK on 16/11/18.
//  Copyright © 2018 SK. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func addRefreshControl(_ tableView: UITableView, selector: Selector, andTintColor color: UIColor = .gray) {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            selector, for: .valueChanged)
        refreshControl.tintColor = color
        
        tableView.addSubview(refreshControl)
    }
}

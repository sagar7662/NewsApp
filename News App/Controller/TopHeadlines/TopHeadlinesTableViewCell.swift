//
//  TopHeadlinesTableViewCell.swift
//  News App
//
//  Created by SK on 18/11/18.
//  Copyright © 2018 SK. All rights reserved.
//

import UIKit

class TopHeadlinesTableViewCell: UITableViewCell, NibReusable {
    
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var articleAuthorLabel: UILabel!
    @IBOutlet weak var articleTitleLabel: UILabel!
    @IBOutlet weak var articleDescriptionLabel: UILabel!
    @IBOutlet weak var articleDateLabel: UILabel!
}

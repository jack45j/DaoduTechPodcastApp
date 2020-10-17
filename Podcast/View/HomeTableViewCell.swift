//
//  HomeTableViewCell.swift
//  Podcast
//
//  Created by Yi-Cheng Lin on 2020/10/15.
//  Copyright © 2020 Yi-Cheng Lin. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
	var episodeData: Episode!
	@IBOutlet weak var episodeImageView: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var pubDateLabel: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

//
//  SlackUserTableViewCell.swift
//  RoverInterview
//
//  Created by Samuel Kitono on 7/2/18.
//  Copyright © 2018 Samuel Kitono. All rights reserved.
//

import UIKit

class SlackUserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var realNameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

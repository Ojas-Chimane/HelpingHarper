//
//  StorieTableViewCell.swift
//  HelpingHarper
//
//  Created by Ojas Chimane on 12/4/20.
//  Copyright © 2020 HelpingHarper. All rights reserved.
//

import UIKit

class StoryTableViewCell: UITableViewCell {
    @IBOutlet weak var storyImageView: UIImageView!
    @IBOutlet weak var storyNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        storyImageView.layer.cornerRadius = storyImageView.frame.width/15

               storyImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

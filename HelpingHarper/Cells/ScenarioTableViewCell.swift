//
//  ScenarioTableViewCell.swift
//  HelpingHarper
//
//  Created by Ojas Chimane on 12/4/20.
//  Copyright © 2020 HelpingHarper. All rights reserved.
//

import UIKit

class ScenarioTableViewCell: UITableViewCell {

    @IBOutlet weak var scenarioImageView: UIImageView!
    @IBOutlet weak var scenarioNameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        scenarioImageView.layer.cornerRadius = scenarioImageView.frame.width/15

        scenarioImageView.clipsToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

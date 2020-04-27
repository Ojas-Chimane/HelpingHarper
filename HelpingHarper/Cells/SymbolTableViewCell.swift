//
//  SymbolTableViewCell.swift
//  HelpingHarper
//
//  Created by Ojas Chimane on 27/4/20.
//  Copyright © 2020 HelpingHarper. All rights reserved.
//

import UIKit

class SymbolTableViewCell: UITableViewCell {

    @IBOutlet weak var symbolImageView: UIImageView!
    @IBOutlet weak var symbolDescTextView: UITextView!
    @IBOutlet weak var symbolNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

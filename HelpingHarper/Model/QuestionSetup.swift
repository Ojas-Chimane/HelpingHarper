//
//  QuestionSetup.swift
//  HelpingHarper
//
//  Created by Ojas Chimane on 16/4/20.
//  Copyright © 2020 HelpingHarper. All rights reserved.
//

import Foundation

class QuestionSetup: Codable{
    var setup_desc: String
    var setup_img_URL: String
    
    init(setup_desc:String,setup_img_URL:String) {
        self.setup_desc = setup_desc
        self.setup_img_URL = setup_img_URL
    }
    
}

//
//  Story.swift
//  HelpingHarper
//
//  Created by Ojas Chimane on 16/4/20.
//  Copyright © 2020 HelpingHarper. All rights reserved.
//

import Foundation

class Story: Codable{
    var story_id: Int
    var story_img_URL: String
    var story_name:String
    var story_setup:String
    
    init(story_id:Int,story_img_URL: String,story_name:String,story_setup:String){
        self.story_id = story_id
        self.story_img_URL = story_img_URL
        self.story_name = story_name
        self.story_setup = story_setup
    }
    
}

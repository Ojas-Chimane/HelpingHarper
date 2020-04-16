//
//  Answer.swift
//  HelpingHarper
//
//  Created by Ojas Chimane on 16/4/20.
//  Copyright © 2020 HelpingHarper. All rights reserved.
//

import Foundation

class Answer: Codable{
    var is_correct_ans:Int
    var answer:String
    var ans_feedback:String
    var ans_feed_img_URL:String
    
    init(is_correct_ans:Int,answer:String,ans_feedback:String,ans_feed_img_URL:String) {
        self.is_correct_ans = is_correct_ans
        self.answer = answer
        self.ans_feedback = ans_feedback
        self.ans_feed_img_URL = ans_feed_img_URL
    }
    
}

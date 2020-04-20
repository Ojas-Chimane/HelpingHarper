//
//  Answer.swift
//  HelpingHarper
//
//  Created by Ojas Chimane on 16/4/20.
//  Copyright © 2020 HelpingHarper. All rights reserved.
//

import Foundation

class Answer: Codable{
    var ans_is_correct:Int
    var answer:String
    var ans_feedback:String
    var ans_feed_img_URL:String
    var ans_id:Int
    var question_id:Int
    
    init(ans_id:Int,question_id:Int,ans_is_correct:Int,answer:String,ans_feedback:String,ans_feed_img_URL:String) {
        self.ans_id = ans_id
        self.question_id = question_id
        self.ans_is_correct = ans_is_correct
        self.answer = answer
        self.ans_feedback = ans_feedback
        self.ans_feed_img_URL = ans_feed_img_URL
    }
    
}

//
//  QuestionData.swift
//  HelpingHarper
//
//  Created by Ojas Chimane on 18/4/20.
//  Copyright © 2020 HelpingHarper. All rights reserved.
//

import Foundation

class QuestionData: Codable {
    let question_id:Int
    let question: String
    //let answers: [String]
    //var correctAnswers: Set<UInt8>! = []
    //let correct: UInt8?
    let img_URL: String?
    let answerList : [Answer]
    let questionSetupList : [QuestionSetup]
    
    
    
    init(question_id:Int,question: String, imageURL: String? = nil,answerList : [Answer],questionSetupList : [QuestionSetup]) {
        self.question_id = question_id
        self.question = question.trimmingCharacters(in: .whitespacesAndNewlines)
        self.img_URL = imageURL?.trimmingCharacters(in: .whitespacesAndNewlines)
        self.answerList = answerList
        self.questionSetupList = questionSetupList
    }
}

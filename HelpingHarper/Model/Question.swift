//
//  Question.swift
//  HelpingHarper
//
//  Created by Ojas Chimane on 15/4/20.
//  Copyright © 2020 HelpingHarper. All rights reserved.
//

import Foundation

class Question: Codable {
    let question_id:Int
	let question: String
	let img_URL: String?

    init(question_id:Int,question: String, imageURL: String? = nil) {
        self.question_id = question_id
		self.question = question.trimmingCharacters(in: .whitespacesAndNewlines)
		self.img_URL = imageURL?.trimmingCharacters(in: .whitespacesAndNewlines)
	}
}


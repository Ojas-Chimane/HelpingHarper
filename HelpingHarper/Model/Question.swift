//
//  QuestionType.swift
//  Questions
//
//  Created by Daniel Illescas Romero on 24/05/2018.
//  Copyright © 2018 Daniel Illescas Romero. All rights reserved.
//

import Foundation

class Question: Codable {
    
	let question: String
	//let answers: [String]
	//var correctAnswers: Set<UInt8>! = []
	//let correct: UInt8?
	let img_URL: String?
    let answerList : [Answer]
    let questionSetupList : [QuestionSetup]
    
    
	
	init(question: String, imageURL: String? = nil,answerList : [Answer],questionSetupList : [QuestionSetup]) {
		self.question = question.trimmingCharacters(in: .whitespacesAndNewlines)
		self.img_URL = imageURL?.trimmingCharacters(in: .whitespacesAndNewlines)
        self.answerList = answerList
        self.questionSetupList = questionSetupList
	}
}

//extension Question: Equatable {
//	static func ==(lhs: Question, rhs: Question) -> Bool {
//		return lhs.question == rhs.question && lhs.answers == rhs.answers && lhs.correctAnswers == rhs.correctAnswers
//	}
//}
//
//extension Question: Hashable {
//	func hash(into hasher: inout Hasher) {
//		hasher.combine(self.question.hash)
//	}
//}

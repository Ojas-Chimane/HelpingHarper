//
//  Topic.swift
//  HelpingHarper
//
//  Created by Ojas Chimane on 15/4/20.
//  Copyright © 2020 HelpingHarper. All rights reserved.
//

import Foundation

struct Topic: Codable {
	let sets: [[Question]]
}

extension Topic {
	var inJSON: String {
		if let data = try? JSONEncoder().encode(self), let jsonQuiz = String(data: data, encoding: .utf8) {
			return jsonQuiz
		}
		return ""
	}
}

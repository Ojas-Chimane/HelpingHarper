//
//  Symbol.swift
//  HelpingHarper
//
//  Created by Lindsay Chang on 2020/4/25.
//  Copyright © 2020 HelpingHarper. All rights reserved.
//

import Foundation

class Symbol: Codable{
    
    var symbol_id: Int
    var symbol_name: String
    var symbol_desc: String
    
    init(symbol_id: Int,symbol_name: String,symbol_desc: String) {
        self.symbol_id = symbol_id
        self.symbol_name = symbol_name
        self.symbol_desc = symbol_desc
    }
    
}

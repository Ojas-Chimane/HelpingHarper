//
//  Scenario.swift
//  HelpingHarper
//
//  Created by Ojas Chimane on 15/4/20.
//  Copyright © 2020 HelpingHarper. All rights reserved.
//

import Foundation

class Scenario: Codable{
    var scenario_id: Int
    var scenario_img_URL: String
    var scenario_name:String
    
    init(scenario_id:Int,scenario_img_URL: String,scenario_name:String){
        self.scenario_id = scenario_id
        self.scenario_img_URL = scenario_img_URL
        self.scenario_name = scenario_name
    }
    
}

//
//  StoryViewController.swift
//  HelpingHarper
//
//  Created by Ojas Chimane on 12/4/20.
//  Copyright © 2020 HelpingHarper. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class StoryViewController: UIViewController {
    
    var scenarioId: Int = 0
    private var storyList = [Story]()
    var selectedStoryId:Int = 0
    
    @IBOutlet weak var storyTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStoryData()
        
        print("Story scenarioId:\(scenarioId)")
    }
    
    private func setupStoryData() {
        
        print("setupStoryData")
        guard let urlToExecute  = URL(string: Constants.baseURL+"/getStoryByScenarioId/\(scenarioId)") else {
            return
        }
        
        AF.request(urlToExecute).responseJSON {response in
            debugPrint(response.result)
            
            
            switch response.result {
            case .success:
                if let data = response.data {
                    print(data)
                    // Convert This in JSON
                    do {
                        let responseDecoded = try JSONDecoder().decode(Array<Story>.self, from: data)
                        print("Story Name: ", responseDecoded[0].story_name)
                        self.storyList = responseDecoded
                        self.storyTableView.tableFooterView = UIView()
                        self.storyTableView.reloadData()
                    }catch let error as NSError{
                        print(error)
                    }
                    
                }
            case .failure(let error):
                print("Error:", error)
            }
            
        }
        
    }
    
}

extension StoryViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "STORY_CELL_IDENTIFIER", for: indexPath) as! StoryTableViewCell
        cell.storyNameLabel.text = storyList[indexPath.row].story_name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected ScenarioId: \(storyList[indexPath.row].story_id)")
        selectedStoryId = storyList[indexPath.row].story_id
        performSegue(withIdentifier: "SEGUE_TO_QUESTIONS", sender: selectedStoryId)
    }
    
    
}

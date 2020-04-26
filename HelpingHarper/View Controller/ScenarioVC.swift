//
//  ScenarioVC.swift
//  HelpingHarper
//
//  Created by Ojas Chimane on 12/4/20.
//  Copyright © 2020 HelpingHarper. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage


class ScenarioVC: UIViewController {
    
    private let networkingClient = NetworkingClient()
    private var scenarioList = [Scenario]()
    var selectedScenarioId:Int = 0
    @IBOutlet weak var scenarioTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScenarioData()
        
    }
    
    private func setupScenarioData() {
        
        print("setupScenarioData")
        guard let urlToExecute  = URL(string: Constants.baseURL+"/getAllScenarios") else {
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
                        let responseDecoded = try JSONDecoder().decode(Array<Scenario>.self, from: data)
                        print("Scenario ", responseDecoded[0].scenario_name)
                        self.scenarioList = responseDecoded
                        self.scenarioTableView.tableFooterView = UIView()
                        self.scenarioTableView.reloadData()
                    }catch let error as NSError{
                        print(error)
                    }
                    
                }
            case .failure(let error):
                print("Error:", error)
            }
            
        }
        
    }
    
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? StoryViewController, let detailToSend = sender as? Int {
            vc.scenarioId = detailToSend
        }
        
    }
    
    
}

extension ScenarioVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scenarioList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SCENARIO_CELL_IDENTIFIER", for: indexPath) as! ScenarioTableViewCell
        
        cell.scenarioNameLabel.text = self.scenarioList[indexPath.row].scenario_name
        // TODO - Add image after api call
       // cell.scenarioImageView.image = nil
        
//        AF.request(scenarioList[indexPath.row].scenario_img_URL).responseImage { response in
//            debugPrint(response)
//
////            print(response.request)
////            print(response.response)
//            debugPrint(response.result)
//
//            if case .success(let image) = response.result {
//                if let cellToUpdate = tableView.cellForRow(at: indexPath) {
//                    print("image downloaded: \(image)")
//                    cell.scenarioImageView.image = image
//                    cellToUpdate.setNeedsLayout()
//
//                }
 
                
       //     }
    //    }
        
        
        return cell
    } 
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected ScenarioId: \(scenarioList[indexPath.row].scenario_id)")
        selectedScenarioId = scenarioList[indexPath.row].scenario_id
        performSegue(withIdentifier: "SEGUE_TO_STORIES", sender: selectedScenarioId)
    }
    
    
    
}

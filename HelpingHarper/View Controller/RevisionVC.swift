//
//  RevisionVC.swift
//  HelpingHarper
//
//  Created by Ojas Chimane on 1/6/20.
//  Copyright © 2020 HelpingHarper. All rights reserved.
//

import UIKit

class RevisionVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    //symbols_segue
    
    @IBAction func onBeachFlagButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "symbols_segue", sender: 1)
    }
    
    @IBAction func onRedButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "symbols_segue", sender: 2)
    }
    
    @IBAction func onYellowButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "symbols_segue", sender: 3)
    }
    
    @IBAction func onBlueButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "symbols_segue", sender: 4)
    }
    
    // MARK: - Navigation
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
         if segue.identifier == "symbols_segue"
           {
               let controller = segue.destination as! SymbolViewController
               controller.symbolId = sender as! Int
           }
    }
    
    
}

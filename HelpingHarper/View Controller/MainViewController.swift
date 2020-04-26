//
//  ViewController.swift
//  HelpingHarper
//
//  Created by Ojas Chimane on 9/4/20.
//  Copyright © 2020 HelpingHarper. All rights reserved.
//

import UIKit


class MainViewController: UIViewController {

    @IBOutlet weak var hhHomePageImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        hhHomePageImageView?.layer.cornerRadius = (hhHomePageImageView?.frame.size.width ?? 0.0) / 2
        hhHomePageImageView?.clipsToBounds = true
        hhHomePageImageView?.layer.borderWidth = 3.0
        hhHomePageImageView?.layer.borderColor = UIColor.white.cgColor
    }
    
    


}


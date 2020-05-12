//
//  ViewController.swift
//  HelpingHarper
//
//  Created by Ojas Chimane on 9/4/20.
//  Copyright © 2020 HelpingHarper. All rights reserved.
//

import UIKit
import paper_onboarding
import SwiftySound

class MainViewController: UIViewController {
    let defaults = UserDefaults.standard

    @IBOutlet weak var hhHomePageImageView: UIImageView!
    var setupScreenList = [OnboardingItemInfo?]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup image view on home screen
        hhHomePageImageView?.layer.cornerRadius = (hhHomePageImageView?.frame.size.width ?? 0.0) / 2
        hhHomePageImageView?.clipsToBounds = true
        hhHomePageImageView?.layer.borderWidth = 3.0
        hhHomePageImageView?.layer.borderColor = UIColor.white.cgColor
        
       // playIntroSound()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let isOnboarded = defaults.bool(forKey: "isOnBoardComplete")
        if isOnboarded != true {
            setupOnboardingScreen()
        }
    }
    
    private func setupOnboardingScreen(){
        
        
        let backgroundColorOne = UIColor(red: 236/255, green: 210/255, blue: 175/255, alpha: 1)
        let backgroundColorTwo = UIColor(red: 37/255, green: 37/255, blue: 42/255, alpha: 1)
        let titleFont = UIFont(name: "Chalkduster", size: 22)!
        
        let itemOne = OnboardingItemInfo(informationImage: UIImage(named: "Helping Harper") ?? UIImage(), title: "", description: "Hi! 👋🏻 I'm Harper. I like playing in the water. 🏄‍♀️🏊‍♀️🤽‍♀️🚣‍♀️Come help me make good decisions around water so we can have fun! 🌊😄", pageIcon: UIImage(), color: backgroundColorOne, titleColor: backgroundColorTwo, descriptionColor: backgroundColorTwo, titleFont: titleFont, descriptionFont: titleFont)
        
        let itemTwo = OnboardingItemInfo(informationImage: UIImage(named: "SHARKS") ?? UIImage(), title: "", description: "Check out the \"Revision\" section to find out more about safety symbols! ⛔🚸🚷⚠️", pageIcon: UIImage(), color: backgroundColorOne, titleColor: backgroundColorTwo, descriptionColor: backgroundColorTwo, titleFont: titleFont, descriptionFont: titleFont)
        
        self.setupScreenList.append(itemOne)
        self.setupScreenList.append(itemTwo)
        defaults.set(true, forKey: "isOnBoardComplete")
        invokeSetupScreen()
    }
    
    private func invokeSetupScreen(){
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SETUP_SCREEN_IDENTIFIER") as? SetupScreenViewController
        {
            vc.modalPresentationStyle = .fullScreen
            
            vc.onBoardList = self.setupScreenList
            present(vc, animated: true, completion: nil)
        }
    }
    
    private func playIntroSound(){
        Sound.play(file: "harper_audio_test.wav")
    }

}


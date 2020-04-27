//
//  ViewController.swift
//  OnBoard Test
//
//  Created by Ojas Chimane on 18/4/20.
//  Copyright © 2020 HelpingHarper. All rights reserved.
//

import UIKit
import paper_onboarding


class SetupScreenViewController: UIViewController,PaperOnboardingDataSource,PaperOnboardingDelegate {
    
    @IBOutlet weak var dismissSetupScreenButton: UIButton!
    @IBOutlet weak var setupScreenView: OnboardingView!
    
    var itemOne: OnboardingItemInfo?
    var onBoardList = [OnboardingItemInfo?]()
    
    
    func onboardingItemsCount() -> Int {
        return onBoardList.count
    }
    
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        return onBoardList[index]!
    }
    
    @IBAction func onSetupScreenDismissBtnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScreenView.delegate = self
        setupScreenView.dataSource = self
        
        if onBoardList.count == 1{
            UIView.animate(withDuration: 0.4, animations: {
                self.dismissSetupScreenButton.alpha = 1
            })
        }
    }
    
    
    func onboardingWillTransitonToIndex(_ index: Int) {
        if self.dismissSetupScreenButton.alpha == 1 {
            UIView.animate(withDuration: 0.2, animations: {
                self.dismissSetupScreenButton.alpha = 0
            })
        }
    }
    
    func onboardingDidTransitonToIndex(_ index: Int) {
        if index == onBoardList.count - 1 {
            UIView.animate(withDuration: 0.4, animations: {
                self.dismissSetupScreenButton.alpha = 1
            })
        }else{
            UIView.animate(withDuration: 0.2, animations: {
                self.dismissSetupScreenButton.alpha = 0
            })
        }
    }
    
    func onboardingConfigurationItem(_ item: OnboardingContentViewItem, index _: Int) {
        if let imageSize = item.imageView?.image?.size {
            item.informationImageWidthConstraint?.constant = 350
            item.informationImageHeightConstraint?.constant = 350
            item.setNeedsUpdateConstraints()
        }
    }
    
    
}


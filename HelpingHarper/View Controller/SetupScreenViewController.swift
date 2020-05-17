//
//  ViewController.swift
//  OnBoard Test
//
//  Created by Ojas Chimane on 18/4/20.
//  Copyright © 2020 HelpingHarper. All rights reserved.
//

import UIKit
import paper_onboarding
import SwiftySound

class SetupScreenViewController: UIViewController,PaperOnboardingDataSource,PaperOnboardingDelegate {
    
    @IBOutlet weak var dismissSetupScreenButton: UIButton!
    @IBOutlet weak var setupScreenView: OnboardingView!
    
    var itemOne: OnboardingItemInfo?
    var onBoardList = [OnboardingItemInfo?]()
    var audioList = [String]()
    var callback : ((Bool)->())?
    var isGameOver: Bool?
    
    func onboardingItemsCount() -> Int {
        return onBoardList.count
    }
    
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        return onBoardList[index]!
    }
    
    @IBAction func onSetupScreenDismissBtnTapped(_ sender: Any) {
        if isGameOver == false{
        Sound.stopAll()
        self.dismiss(animated: true, completion: nil)
            callback?(false)
        }else{
        self.dismiss(animated: true, completion: nil)
            callback?(true)
        }
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
        
        if isGameOver == false{
            playSetupAudioClip(withfileName: (audioList[0]+".wav"))
            
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
        
        if index == 0{
            if onBoardList.indices.contains(0){
                if audioList.indices.contains(0){
                print("Audio 1")
                playSetupAudioClip(withfileName: (audioList[0]+".wav"))
                }
                
            }
        }
        
        if index == 1{
        if onBoardList.indices.contains(1){
            if audioList.indices.contains(1){
                print("Audio 2")
                playSetupAudioClip(withfileName: (audioList[1]+".wav"))
            }}
        }
        
        
        if index == 2{
        if onBoardList.indices.contains(2){
            if audioList.indices.contains(2){
                print("Audio 3")
               playSetupAudioClip(withfileName: (audioList[2]+".wav"))
            }}
        }
        
        if index == 3{
               if onBoardList.indices.contains(3){
                  if audioList.indices.contains(3){
                       print("Audio 4")
                      playSetupAudioClip(withfileName: (audioList[3]+".wav"))
                }}
               }
        if index == 4{
        if onBoardList.indices.contains(4){
            if audioList.indices.contains(4){
                print("Audio 5")
               playSetupAudioClip(withfileName: (audioList[4]+".wav"))
            }}
        }
        if index == 5{
        if onBoardList.indices.contains(5){
            if audioList.indices.contains(5){
                print("Audio 6")
               playSetupAudioClip(withfileName: (audioList[5]+".wav"))
            }}
        }
        if index == 6{
               if onBoardList.indices.contains(6){
                  if audioList.indices.contains(6){
                       print("Audio 7")
                      playSetupAudioClip(withfileName: (audioList[6]+".wav"))
                }}
               }
        
        
    }
    
    func onboardingConfigurationItem(_ item: OnboardingContentViewItem, index _: Int) {
        if let imageSize = item.imageView?.image?.size {
            item.informationImageWidthConstraint?.constant = 350
            item.informationImageHeightConstraint?.constant = 350
            item.descriptionLabel?.adjustsFontSizeToFitWidth = true
            item.setNeedsUpdateConstraints()
        }
    }
    
    private func playSetupAudioClip(withfileName: String){
        Sound.stopAll()
        Sound.play(file: withfileName)
    }
    
    
    
}


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
        print("onboardingItemsCount")
        return onBoardList.count
    }
    
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        print("onboardingItem")
        //        let backgroundColorOne = UIColor(red: 217/255, green: 72/255, blue: 89/255, alpha: 1)
        //        let backgroundColorTwo = UIColor(red: 106/255, green: 166/255, blue: 211/255, alpha: 1)
        //        let titleFont = UIFont(name: "AvenirNext-Bold", size: 24)!
        //
        ////        fetchImage(for: "https://helpingharperbucket.s3.amazonaws.com/Game+Image/Q1D1+square.png", completion: )
        //        var item = OnboardingItemInfo(informationImage: UIImage(), title: "rocket", description: "Caramels cheesecake bonbon bonbon topping. Candy halvah cotton candy chocolate bar cake. Fruitcake liquorice candy canes marshmallow topping powder.", pageIcon: UIImage(), color: backgroundColorOne, titleColor: backgroundColorTwo, descriptionColor: backgroundColorTwo, titleFont: titleFont, descriptionFont: titleFont)
        //
        //        fetchImage(for: "https://helpingharperbucket.s3.amazonaws.com/Game+Image/Q1D1+square.png") { (onboardItem) in
        //            self.itemOne = onboardItem
        //        }
        //
        
        return onBoardList[index]!
        
        //
        //  let backgroundColorTwo = UIColor(red: 106/255, green: 166/255, blue: 211/255, alpha: 1)
        //              let backgroundColorThree = UIColor(red: 168/255, green: 200/255, blue: 78/255, alpha: 1)
        //
        //              let titleFont = UIFont(name: "AvenirNext-Bold", size: 24)!
        //              let descirptionFont = UIFont(name: "AvenirNext-Regular", size: 18)!
        //
        //              return [("rocket", "A Great Rocket Start", "Caramels cheesecake bonbon bonbon topping. Candy halvah cotton candy chocolate bar cake. Fruitcake liquorice candy canes marshmallow topping powder.", "", backgroundColorOne, UIColor.white, UIColor.white, titleFont, descirptionFont),
        //
        //                      ("brush", "Design your Experience", "Caramels cheesecake bonbon bonbon topping. Candy halvah cotton candy chocolate bar cake. Fruitcake liquorice candy canes marshmallow topping powder.", "", backgroundColorTwo, UIColor.white, UIColor.white, titleFont, descirptionFont),
        //
        //                      ("notification", "Stay Up To Date", "Get notified of important updates.", "", backgroundColorThree, UIColor.white, UIColor.white, titleFont, descirptionFont)][index]
    }
    
    @IBAction func onSetupScreenDismissBtnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("View DId load")
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
          // if !onBoardList[index].imageName.contains("ic_") {
                 if let imageSize = item.imageView?.image?.size {
                     item.informationImageWidthConstraint?.constant = 350
                     item.informationImageHeightConstraint?.constant = 350
                     item.setNeedsUpdateConstraints()
                 }
         //    }
    }
    //
    //    private func retrieveImage()->UIImage{
    //
    //        var resImage = UIImage()
    //        AF.request("https://helpingharperbucket.s3.amazonaws.com/Game+Image/Q1D1+square.png").responseImage { response in
    //            debugPrint(response)
    //
    //            //            print(response.request)
    //            //            print(response.response)
    //            debugPrint(response.result)
    //
    //            if case .success(let image) = response.result {
    //                print("image downloaded: \(image)")
    //
    //               resImage = image
    //
    //            }
    //
    //        }
    //        return resImage
    //    }
    //
    
    
    
}


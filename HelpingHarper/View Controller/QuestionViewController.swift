//
//  QuestionViewController.swift
//  HelpingHarper
//
//  Created by Ojas Chimane on 12/4/20.
//  Copyright © 2020 HelpingHarper. All rights reserved.
//

import UIKit


import UIKit
import Alamofire
import AlamofireImage
import PromiseKit

class QuestionViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var answerStub: RoundedButton!
    
    var answerButtons: [RoundedButton] = []
    
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var remainingQuestionsLabel: UILabel!
    @IBOutlet weak var quizTimerLabel: UILabel!
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var questionImageButton: UIButton!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var answersStackView: UIStackView!
    
    @IBOutlet weak var pauseView: UIView!
    @IBOutlet weak var goBack: UIButton!
    @IBOutlet weak var muteMusic: UIButton!
    @IBOutlet weak var mainMenu: UIButton!
    
    @IBOutlet weak var helpButton: UIButton!
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    //let oldScore = UserDefaultsManager.score
    var correctAnswersSet: Set<UInt8> = []
    var correctAnswers = Int()
    var incorrectAnswers = Int()
    var repeatTimes = UInt8()
    var currentTopicIndex = Int()
    var currentSetIndex = Int()
    var isSetFromJSON = false
    var set: [Question] = []
    var quiz: EnumeratedSequence<[Question]>.Iterator!
    var quizTime = TimeInterval()
    var previousQuizTime: TimeInterval = -1
    var answersUntilNextQuestion: Int = 0
    
    var questionList = [Question]()
    var questionSetupList = [QuestionSetup]()
    var answerList = [Answer]()
    var questionDataList = [QuestionData]()
    
    // MARK: View life cycle
    
    // MARK: TODO
    //    private var currentQuizOfTopic: Topic {
    //      // return SetOfTopics.shared.currentTopics[currentTopicIndex].topic
    //    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupQuestions()
        //
        //        self.questionImageButton.setImage(nil, for: .normal)
        //        self.questionImageButton.imageView?.contentMode = .scaleAspectFill
        //        self.questionImageButton.imageView?.clipsToBounds = true
        //        self.questionImageButton.clipsToBounds = true
        //        self.questionImageButton.layer.cornerRadius = 10
        
        //        if self.isSetFromJSON {
        //            self.goBack.isHidden = true
        //        }
        // MARK: TODO
        //        self.setUpQuiz()
        //        self.preloadImages()
        // MARK: TODO
        //  self.createAnswerButtons()
        // self.pickQuestion()
        
        //        let title = AudioSounds.bgMusic?.isPlaying == true ? Localized.Questions_PauseMenu_Music_Pause : Localized.Questions_PauseMenu_Music_Play
        //        self.muteMusic.setTitle(title.localized, for: .normal)
        //
        //        self.goBack.setTitle(Localized.Questions_PauseMenu_Back_QuestionsMenu.localized, for: .normal)
        //        self.mainMenu.setTitle(Localized.Questions_PauseMenu_Back_MainMenu.localized, for: .normal)
        //        self.pauseButton.setTitle(Localized.Questions_PauseMenu_Pause, for: .normal)
        //        self.pauseView.isHidden = true
        //        self.blurView.isHidden = true
        
        //self.loadCurrentTheme()
        
        //        NotificationCenter.default.addObserver(self, selector: #selector(self.appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        //        if QuestionsAppOptions.privacyFeaturesEnabled {
        //            NotificationCenter.default.addObserver(self, selector: #selector(self.userDidTakeScreenshot), name: UIApplication.userDidTakeScreenshotNotification, object: nil)
        //        }
        //
        //        if UserDefaultsManager.score < abs(QuestionsAppOptions.helpActionPoints) {
        //            self.helpButton.alpha = 0.4
        //        }
        
        //self.pickQuestion()
        //        self.updateTimer()
        
        //let helpButtonEnabled = self.currentQuizOfTopic.options?.helpButtonEnabled ?? true
        //self.helpButton.isHidden = !(helpButtonEnabled && QuestionsAppOptions.isHelpEnabled && self.answerButtons.count >= 3)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.detectIfScreenIsCaptured()
    }
    
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //        // Redraw the buttons to update the rounded corners when rotating the device
        //        self.answerButtons.forEach { $0.setNeedsDisplay() }
        //        self.pauseButton.setNeedsDisplay()
        //        self.pauseView.setNeedsDisplay()
        //        self.mainMenu.setNeedsDisplay()
        //        self.goBack.setNeedsDisplay()
        //        self.muteMusic.setNeedsDisplay()
    }
    
    private func setupQuestions(){
        
        
        
        retrieveQuestionData { (question) in
            print("Questions DOne ")
            
            
            for question in self.questionList{
                 print(" Question Outside order: \(question.question_id)")
                self.questionSetupList.removeAll()
                self.answerList.removeAll()
                
           self.retrieveQuestionSetupData(questionId: question.question_id).done { (questionSetup) in
//                   print("Question# Inside order: \(question.question_id)")
//                    print("Question# Done \(questionSetup[0].setup_desc)")
            
                self.retrieveAnswerData(questionId: question.question_id).done { (answer) in
                print("Question# Inside order: \(question.question_id)")
                print("Question# Setup \(questionSetup[0].setup_desc)")
                    print("Question# Answer \(answer[0].answer)")
                    
                }
           }
                
//                print(" ### getQuestionSetupId Answer: \(question.question_id)###")
//                guard let urlAnswerToExecute  = URL(string: Constants.baseURL+"/getAnswerByQuestionId/\(question.question_id)") else {
//                    return()
//                }
//
//                AF.request(urlAnswerToExecute).responseJSON {response in
//                    debugPrint(response.result)
//
//
//                    switch response.result {
//                    case .success:
//                        if let data = response.data {
//                            print(data)
//                            // Convert This in JSON
//                            do {
//                                let responseDecoded = try JSONDecoder().decode(Array<Answer>.self, from: data)
//                                print("Answer  ", responseDecoded[0].answer)
//                                self.answerList = responseDecoded
//
//                                let questionData = QuestionData(question_id: question.question_id, question: question.question, imageURL: question.img_URL, answerList: self.answerList, questionSetupList: self.questionSetupList)
//
//
//                                self.questionDataList.append(questionData)
//
//                                //for question in self.questionDataList{
//                                print("Question No: \(self.questionDataList[0].question_id)")
//                                print("Question setup Desc: \(self.questionDataList[0].questionSetupList[0].setup_desc)")
//                                print("Question Answer: \(self.questionDataList[0].answerList[0].answer)")
//                                //                                myGroup.leave()
//                                //                  }
//
//
//                                //                          self.scenarioTableView.reloadData()
//                            }catch let error as NSError{
//                                print(error)
//                            }
//
//                        }
//                    case .failure(let error):
//                        print("Error:", error)
//                    }
//
//                }
//
                
            }
            
            
        }
        
        
        
        
        
    }
    
    private func retrieveQuestionData(completion: @escaping (Question?)->()) {
        
        print(" ### getQuestionByStoryId ###")
        guard let urlToExecute  = URL(string: Constants.baseURL+"/getQuestionByStoryId/\(1)") else {
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
                        let responseDecoded = try JSONDecoder().decode(Array<Question>.self, from: data)
                        print("Question ", responseDecoded[0].question)
                        self.questionList = responseDecoded
                        completion(responseDecoded[0])
                        
                        
                    }catch let error as NSError{
                        print(error)
                    }
                    
                }
            case .failure(let error):
                print("Error:", error)
            }
            
        }
        
    }
    
    private func retrieveQuestionSetupData(questionId:Int) -> Promise<[QuestionSetup]> {
        
        
        return Promise { fulfill in
           
        print(" ### getQuestion Answer Id: \(questionId)###")
            guard let urlToExecute  = URL(string: Constants.baseURL+"/getQuestionSetupByQuestionId/\(questionId)" ) else {
                return()
            }
        AF.request(urlToExecute).responseJSON {response in
            debugPrint(response.result)
            
            
            switch response.result {
            case .success:
                if let data = response.data {
                    print(data)
                    // Convert This in JSON
                    do {
                        let responseDecoded = try JSONDecoder().decode(Array<QuestionSetup>.self, from: data)
                        print("Setup Desc ", responseDecoded[0].setup_desc)
                        //self.questionSetupList = responseDecoded
                        fulfill.fulfill(responseDecoded)
                        
                        //                                myGroup.wait()
                        
                        
                        
                        //                          self.scenarioTableView.reloadData()
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
    
    private func retrieveAnswerData(questionId:Int) -> Promise<[Answer]> {
         
         
         return Promise { fulfill in
             
         print(" ### getQuestionSetupId: \(questionId)###")
             guard let urlToExecute  = URL(string: Constants.baseURL+"/getAnswerByQuestionId/\(questionId)") else {
                 return()
             }
         AF.request(urlToExecute).responseJSON {response in
             debugPrint(response.result)
             
             
             switch response.result {
             case .success:
                 if let data = response.data {
                     print(data)
                     // Convert This in JSON
                     do {
                         let responseDecoded = try JSONDecoder().decode(Array<Answer>.self, from: data)
                        print("Setup Desc ", responseDecoded[0].answer)
                         //self.questionSetupList = responseDecoded
                         fulfill.fulfill(responseDecoded)
                         
                         //                                myGroup.wait()
                         
                         
                         
                         //                          self.scenarioTableView.reloadData()
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
    
    
    
    
    
}
// MARK: UIStoryboardSegue Handling

//    @IBAction func unwindToQuestions(_ segue: UIStoryboardSegue) { }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        if segue.identifier == "unwindToQRScanner" {
//            AudioSounds.bgMusic?.setVolumeLevel(to: AudioSounds.defaultBGMusicLevel)
//        }
//        else if segue.identifier == "imageDetailsSegue", let imageDetailsVC = segue.destination as? ImageDetailsViewController {
//            imageDetailsVC.modalPresentationStyle = .overCurrentContext
//            imageDetailsVC.viewDidLoad()
//            imageDetailsVC.imageView?.image = self.questionImageButton.imageView?.image
//            imageDetailsVC.closeViewButton?.backgroundColor = .themeStyle(dark: .orange, light: .coolBlue)
//            imageDetailsVC.preferredContentSize = imageDetailsVC.imageView?.sizeThatFits(self.view.frame.size) ?? imageDetailsVC.view.frame.size
//        }
//
//        if segue.identifier != "imageDetailsSegue" {
//            self.saveScore()
//        }
//    }

// MARK: Actions

//    @IBAction func tapAnyWhereToClosePauseMenu(_ sender: UITapGestureRecognizer) {
//        if !self.pauseView.isHidden {
//            self.pauseMenuAction()
//        }
//    }
// MARK: TODO
//    @objc func verifyButton(_ sender: RoundedButton) {
//        self.verify(answer: UInt8(sender.tag))
//    }

//    @IBAction func pauseMenu() {
//        self.pauseMenuAction()
//    }

//    @IBAction func goBackAction() {
//        if !self.isSetFromJSON {
//            performSegue(withIdentifier: "unwindToQuizSelector", sender: self)
//        } else {
//            performSegue(withIdentifier: "unwindToQRScanner", sender: self)
//        }
//    }


// MARK: Convenience

//    @objc private func appWillEnterForeground() {
//        self.pauseMenuAction()
//    }


// MARK: createAnswerButtons
// MARK: TODO
//    private func createAnswerButtons() {
//
//        // Should fix this stuff in the storyboard...
//        self.answerStub.isHidden = true
//       // MARK: TODO
//      //  let numberOfAnswers = set.first?.answers.count ?? 4
//
//        for i in 0..<numberOfAnswers {
//
//            let button = RoundedButton()
//            button.cornerRadius = 15
//            button.setup(shadows:
//                ShadowEffect(
//                    shadowColor: .black,
//                    shadowOffset: CGSize(width: 0.5, height: 3.5),
//                    shadowOpacity: 0.15,
//                    shadowRadius: 4)
//            )
//            button.tag = i
//            button.addTarget(self, action: #selector(self.verifyButton), for: .touchDown)
//            button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
//
//            self.answerButtons.append(button)
//            self.answersStackView.addArrangedSubview(button)
//        }
//    }

//    private func preloadImages() {
//        for fullQuestion in self.set.dropFirst() { // Drops the first because it will be cached by the 'pickQuestion()' function
//            OnlineImagesManager.shared.preloadImage(withURL: fullQuestion.imageURL)
//        }
//    }

//    private func pauseMenuAction(animated: Bool = true) {
//
//        if self.pauseView.isHidden {
//            self.previousQuizTime = self.quizTime
//        } else {
//            self.quizTime = self.previousQuizTime
//            self.previousQuizTime = -1
//            self.detectIfScreenIsCaptured()
//        }
//
//        let duration: TimeInterval = animated ? 0.1 : 0.0
//        let title = (pauseView.isHidden) ? Localized.Questions_PauseMenu_Continue : Localized.Questions_PauseMenu_Pause
//        pauseButton.setTitle(title.localized, for: .normal)
//
//        UIView.transition(with: self.view, duration: duration, options: [.transitionCrossDissolve], animations: {
//            self.pauseView.isHidden = !self.pauseView.isHidden
//            self.blurView.isHidden = !self.blurView.isHidden
//        })
//
//        let newVolume = (pauseView.isHidden) ? AudioSounds.defaultBGMusicLevel : (AudioSounds.defaultBGMusicLevel / 5.0)
//        AudioSounds.bgMusic?.setVolumeLevel(to: newVolume)
//    }

//    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//        super.traitCollectionDidChange(previousTraitCollection)
//        loadCurrentTheme()
//    }
//
//    @objc func loadCurrentTheme() {
//
//        if #available(iOS 13, *) {
//
//            self.questionLabel.textColor = .label
//            self.remainingQuestionsLabel.textColor = .secondaryLabel
//            self.quizTimerLabel.textColor = .secondaryLabel
//            self.blurView.effect = UserDefaultsManager.darkThemeSwitchIsOn ? UIBlurEffect(style: .dark) : UIBlurEffect(style: .light)
//
//            self.answerButtons.forEach {
//                $0.backgroundColor = .themeStyle(dark: .orange, light: .defaultTintColor)
//                $0.dontInvertColors()
//            }
//
//            self.pauseButton.backgroundColor = .secondarySystemBackground
//            self.pauseButton.setTitleColor(dark: .white, light: .defaultTintColor, for: .normal)
//            self.helpButton.setTitleColor(dark: .orange, light: .defaultTintColor, for: .normal)
//
//            detectIfScreenIsCaptured()
//
//            return
//        }
//
//        let currentThemeColor = UIColor.themeStyle(dark: .white, light: .black)
//
//        if #available(iOS 13, *) {
//            self.activityIndicatorView.style = .medium
//        } else {
//            self.activityIndicatorView.style = UserDefaultsManager.darkThemeSwitchIsOn ? .white : .gray
//        }
//        self.helpButton.setTitleColor(dark: .orange, light: .defaultTintColor, for: .normal)
//        self.remainingQuestionsLabel.textColor = currentThemeColor
//        self.quizTimerLabel.textColor = currentThemeColor
//        self.questionLabel.textColor = currentThemeColor
//        self.view.backgroundColor = .themeStyle(dark: .black, light: .white)
//        self.pauseButton.backgroundColor = .themeStyle(dark: .veryDarkGray, light: .veryLightGray)
//        self.pauseButton.setTitleColor(dark: .white, light: .defaultTintColor, for: .normal)
//        self.pauseView.backgroundColor = .themeStyle(dark: .lightGray, light: .veryVeryLightGray)
//
//        self.pauseView.subviews.first?.subviews.forEach { ($0 as? UIButton)?.setTitleColor(dark: .black, light: .darkGray, for: .normal)
//            ($0 as? UIButton)?.backgroundColor = .themeStyle(dark: .warmColor, light: .warmYellow) }
//
//        self.blurView.effect = UserDefaultsManager.darkThemeSwitchIsOn ? UIBlurEffect(style: .dark) : UIBlurEffect(style: .light)
//
//        self.answerButtons.forEach { $0.backgroundColor = .themeStyle(dark: .orange, light: .defaultTintColor); $0.dontInvertColors() }
//
//        self.setNeedsStatusBarAppearanceUpdate()
//        self.detectIfScreenIsCaptured()
//    }

//    private func detectIfScreenIsCaptured() {
//        if QuestionsAppOptions.privacyFeaturesEnabled, #available(iOS 11.0, *), UIScreen.main.isCaptured {
//
//            if self.pauseView.isHidden {
//                self.pauseMenuAction()
//            }
//
//            let contentIsProtectedAlert = UIAlertController(title: Localized.Security_Alerts_ProtectedContent_Title, message: Localized.Security_Alerts_ProtectedContent_Message, preferredStyle: .alert)
//
//            contentIsProtectedAlert.addAction(title: Localized.Security_Alerts_ProtectedContent_Exit, style: .cancel) { _ in
//                self.goBackAction()
//            }
//
//            contentIsProtectedAlert.addAction(title: Localized.Security_Alerts_ProtectedContent_OK, style: .default) { _ in
//                if UIScreen.main.isCaptured {
//                    self.present(contentIsProtectedAlert, animated: true)
//                }
//            }
//
//            self.present(contentIsProtectedAlert, animated: true)
//        }
//    }

//    public func pickQuestion() {

//        if self.currentQuizOfTopic.options?.multipleCorrectAnswersAsMandatory ?? false {
//            self.answersUntilNextQuestion -= 1
//            guard self.answersUntilNextQuestion <= 0 else { return }
//        }



// Restore
//        UIView.animate(withDuration: 0.75) {
//            self.answerButtons.forEach { $0.alpha = 1 }
//
//            if UserDefaultsManager.score >= abs(QuestionsAppOptions.helpActionPoints) {
//                self.helpButton.alpha = 1.0
//            }
//      }

//        if let quiz0 = self.quiz.next() {
//
//            let fullQuestion = quiz0.element
// MARK: TODO
//            self.answersUntilNextQuestion = fullQuestion.correctAnswers.count
//
//            self.correctAnswersSet = fullQuestion.correctAnswers
//            self.questionLabel.text = fullQuestion.question.localized
//
//            let answers = fullQuestion.answers
//
//            for i in 0..<self.answerButtons.count {
//                self.answerButtons[i].setTitle(answers[i].localized, for: .normal)
//            }
//
//            self.remainingQuestionsLabel.text = "\(quiz0.offset + 1)/\(self.set.count)"
//
//            OnlineImagesManager.shared.load(url: fullQuestion.imageURL ?? "", prepareForDownload: {
//                self.questionImageButton.alpha = 0.0
//                self.questionImageButton.isHidden = true
//                self.activityIndicatorView.startAnimating()
//            },
//            onSuccess: { cachedImage in
//                self.activityIndicatorView.stopAnimating()
//                self.questionImageButton.isHidden = false
//                UIView.transition(with: self.questionImageButton, duration: 0.2, options: [.curveEaseInOut], animations: {
//                    self.questionImageButton.alpha = 1.0
//                    self.questionImageButton.setImage(cachedImage, for: .normal)
//                })
//            },
//            onError: { _ in
//                UIView.transition(with: self.questionImageButton, duration: 0.2, options: [.curveEaseInOut], animations: {
//                    self.questionImageButton.alpha = 0.0
//                }, completion: { completed in
//                    self.questionImageButton.isHidden = true
//                })
//                self.activityIndicatorView.stopAnimating()
//            })
//        }
//        else {
//            self.endOfQuestionsAlert()
//        }
//    }
// MARK: TODO
//    private func isSetCompleted() -> Bool {
//        let topicName = SetOfTopics.shared.currentTopics[currentTopicIndex].displayedName
//        if let topicQuiz = DataStoreArchiver.shared.completedSets[topicName] {
//            return topicQuiz[currentSetIndex] ?? false
//        }
//        return false
//    }
// MARK: TODO
//    private func saveScore() {
//
//        if !self.isSetCompleted() {
//            UserDefaultsManager.correctAnswers += correctAnswers
//            UserDefaultsManager.incorrectAnswers += incorrectAnswers
//            UserDefaultsManager.score += (self.correctAnswers * QuestionsAppOptions.correctAnswerPoints) + (self.incorrectAnswers * QuestionsAppOptions.incorrectAnswerPoints)
//        }
//
//        let topicName = SetOfTopics.shared.currentTopics[self.currentTopicIndex].displayedName
//        DataStoreArchiver.shared.completedSets[topicName]?[self.currentSetIndex] = true
//        guard DataStoreArchiver.shared.save() else { print("Error saving settings"); return }


//    private func okActionDetailed() {
//        if !self.isSetFromJSON {
//            self.performSegue(withIdentifier: "unwindToQuizSelector", sender: self)
//        } else {
//            self.performSegue(withIdentifier: "unwindToMainMenu", sender: self)
//        }
//    }
// MARK: TODO
//    private func repeatActionDetailed() {
//        self.repeatTimes += 1
//        self.correctAnswers = 0
//        self.incorrectAnswers = 0
//        self.updateTimer()
//        self.setUpQuiz()
//        UserDefaultsManager.score = oldScore
//        self.pickQuestion()
//    }
// MARK: TODO
//    @objc private func verify(answer: UInt8) {
//
//        self.pausePreviousSounds()
//
//        let isCorrectAnswer = correctAnswersSet.contains(answer)
//        let willNoticeIfAnswerIsCorrectOrIncorrect = self.currentQuizOfTopic.options?.showCorrectIncorrectAnswer ?? true
//
//        if isCorrectAnswer {
//            correctAnswers += 1
//            if willNoticeIfAnswerIsCorrectOrIncorrect {
//                DispatchQueue.global().async { AudioSounds.correct?.play() }
//            }
//        }
//        else {
//            incorrectAnswers += 1
//            if willNoticeIfAnswerIsCorrectOrIncorrect {
//                DispatchQueue.global().async { AudioSounds.incorrect?.play() }
//            }
//        }
//
//        UIView.transition(with: self.answerButtons[Int(answer)], duration: 0.25, options: [.transitionCrossDissolve], animations: {
//            if willNoticeIfAnswerIsCorrectOrIncorrect {
//                self.answerButtons[Int(answer)].backgroundColor = isCorrectAnswer ? .darkGreen : .alternativeRed
//            } else {
//                self.answerButtons[Int(answer)].backgroundColor = .themeStyle(dark: .warmYellow, light: .coolBlue)
//            }
//
//        }) { completed in
//            if completed {
//                self.pickQuestion()
//                UIView.transition(with: self.answerButtons[Int(answer)], duration: 0.2, options: [.transitionCrossDissolve], animations: {
//                    self.answerButtons[Int(answer)].backgroundColor = .themeStyle(dark: .orange, light: .defaultTintColor)
//                })
//            }
//        }
//        if #available(iOS 10.0, *) {
//            if willNoticeIfAnswerIsCorrectOrIncorrect {
//                FeedbackGenerator.notificationOcurredOf(type: isCorrectAnswer ? .success : .error)
//            } else {
//                FeedbackGenerator.impactOcurredWith(style: .light)
//            }
//        }
//    }

//    private func pausePreviousSounds() {
//        DispatchQueue.global().async {
//            if let incorrectSound = AudioSounds.incorrect, incorrectSound.isPlaying {
//                incorrectSound.pause()
//                incorrectSound.currentTime = 0
//            }
//
//            if let correctSound = AudioSounds.correct, correctSound.isPlaying {
//                correctSound.pause()
//                correctSound.currentTime = 0
//            }
//        }
//    }
// MARK: TODO
//    private func setUpQuiz() {
//
//        if !self.isSetFromJSON { self.set = SetOfTopics.shared.currentTopics[currentTopicIndex].topic.sets[currentSetIndex] }
//
//        if self.currentQuizOfTopic.options?.questionsInRandomOrder ?? true {
//            self.set.shuffle()
//        }
//
//        self.quiz = self.set.enumerated().makeIterator()
//    }

// Alerts
// MARK: TODO
//    private func endOfQuestionsAlert() {
//
//        let helpScore = self.oldScore - UserDefaultsManager.score
//        let score = (self.correctAnswers * QuestionsAppOptions.correctAnswerPoints) + (self.incorrectAnswers * QuestionsAppOptions.incorrectAnswerPoints) - helpScore
//                    //(correctAnswers * 20) - (incorrectAnswers * 10) - helpScore
//
//        let extraTitle = (self.quizTimerLabel.text == "0s" || self.quizTimerLabel.text == "0.0s") ? "(\(Localized.Questions_Alerts_TimeRunOut)\n" : ""
//
//        let title = extraTitle.localized + String(format: Localized.Questions_Alerts_End_Score, score) + " pts"
//        let message = String(format: Localized.Questions_Alerts_End_CorrectAnswers, "\(correctAnswers)/\(set.count)")
//
//        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
//
//        alertViewController.addAction(title: Localized.Common_OK, style: .default) { action in self.okActionDetailed() }
//
//        if (self.correctAnswers < set.count) && (self.repeatTimes < 2) && !isSetCompleted() {
//            let repeatText = Localized.Questions_Alerts_End_Repeat + " (\(2 - self.repeatTimes))"
//            alertViewController.addAction(title: repeatText, style: .cancel) { action in
//                self.repeatActionDetailed()
//                self.blurView.isHidden = true
//            }
//        }
//
//        if QuestionsAppOptions.privacyFeaturesEnabled {
//            UIView.transition(with: self.view, duration: 0.2, options: [.transitionCrossDissolve], animations: {
//                self.blurView.isHidden = false
//            })
//        }
//
//        self.present(alertViewController, animated: true)
//    }
//
//    private func showOKAlertWith(title: String, message: String) {
//        let alertViewController = UIAlertController.OKAlert(title: title, message: message)
//        present(alertViewController, animated: true)
//    }
//}





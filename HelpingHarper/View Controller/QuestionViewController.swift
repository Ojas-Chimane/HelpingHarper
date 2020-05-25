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
import paper_onboarding
import PromiseKit
import PMAlertController
import SwiftySound
import Lottie

class QuestionViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var answerStub: RoundedButton!
    @IBOutlet weak var remainingQuestionsLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var questionImageButton: UIButton!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var answersStackView: UIStackView!
    @IBOutlet weak var loadingView: UIView!
    let animationView = AnimationView()
    
    // Variables
    var correctAnswerFromSet = Int()
    var correctAnswers = Int()
    var incorrectAnswers = Int()
    var repeatTimes = UInt8()
    var currentTopicIndex = Int()
    var currentSetIndex = Int()
    var selectedStoryId:Int = 0
    var currentQuestionAudio:String?

    // Arrays
    var questionList = [Question]()
    var audioList = [String]()
    var questionSetupList = [QuestionSetup]()
    var answerList = [Answer]()
    var correctIncorrectAnswerList = [Answer]()
    var questionDataList = [QuestionData]()
    var set: [QuestionData] = []
    var quiz: EnumeratedSequence<[QuestionData]>.Iterator!
    var answerButtons: [RoundedButton] = []
    var setupScreenList = [OnboardingItemInfo?]()
    
    // Setup screen background color
    let backgroundColorOne = UIColor(red: 236/255, green: 210/255, blue: 175/255, alpha: 1)
    let backgroundColorTwo = UIColor(red: 37/255, green: 37/255, blue: 42/255, alpha: 1)
    
    // MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.startLoadingAnimation()
        self.loadingView.alpha = 1
        
        // Retrieve the question data from the server
        setupQuestions()
        
        // Setup the imageview for the questions
        self.questionImageButton.setImage(nil, for: .normal)
        self.questionImageButton.imageView?.contentMode = .scaleAspectFit
        self.questionImageButton.imageView?.clipsToBounds = true
        self.questionImageButton.clipsToBounds = true
        self.questionImageButton.layer.cornerRadius = 10
    }
    
    private func startLoadingAnimation(){
        let animation = Animation.named("loading-unicorn")
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.frame.size = loadingView.frame.size
        animationView.loopMode = .loop
        
        loadingView.addSubview(animationView)
        animationView.play()
    }
    

        
    private func invokeSetupScreen(isGameOver:Bool){
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SETUP_SCREEN_IDENTIFIER") as? SetupScreenViewController
        {
            vc.modalPresentationStyle = .fullScreen
            vc.audioList = self.audioList
            vc.onBoardList = self.setupScreenList
            vc.isGameOver = isGameOver
         
            vc.callback = { (result) -> () in
                print("## Setup DONE ##")
                if result == true{
                   self.dismiss(animated: true, completion: nil)
                    print("## Game Over ##")
                }else{
                    self.playSetupAudioClip(withfileName: self.currentQuestionAudio!+".wav")
                    
                    // Hide the loading view
                    self.animationView.stop()
                    self.loadingView.alpha = 0
                }
            }
            present(vc, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func onPauseButtonTapped(_ sender: Any) {
        let alertVC = PMAlertController(title: "", description:"", image: UIImage(named: "S2E2"), style: .alert)
        
        alertVC.addAction(PMAlertAction(title: "Quit Story👋😴", style: .default, action: { ()
            self.dismiss(animated: true, completion: nil)
        }))
        alertVC.addAction(PMAlertAction(title: "Resume✊", style: .default, action: { ()
            
        }))
        self.present(alertVC, animated: true, completion: nil)
        }
    
    @objc func verifyButton(_ sender: RoundedButton) {
        self.verify(answer: UInt8(sender.tag))
    }
     
    // Create answer buttons
    private func createAnswerButtons() {
        
        self.answerStub.isHidden = true
        
        let numberOfAnswers = set.first?.answerList.count ?? 4
        
        for i in 0..<numberOfAnswers {
            
            let button = RoundedButton()
            button.cornerRadius = 15
            button.setup(shadows:
                ShadowEffect(
                    shadowColor: .black,
                    shadowOffset: CGSize(width: 0.5, height: 3.5),
                    shadowOpacity: 0.15,
                    shadowRadius: 4)
            )
            
            button.tag = set.first?.answerList[i].ans_id ?? i
            button.addTarget(self, action: #selector(self.verifyButton), for: .touchDown)
            button.titleLabel?.font = UIFont(name: Fonts.customFont, size: 18)!
            button.tintColor = .black
            self.answerButtons.append(button)
            self.answersStackView.addArrangedSubview(button)
        }
    }
    
    
    @objc func loadCurrentTheme() {

        if #available(iOS 13, *) {

            self.questionLabel.textColor = .black
            self.remainingQuestionsLabel.textColor = .black

            self.answerButtons.forEach {
                $0.backgroundColor = .themeStyle(dark: .coolBlue, light: .defaultTintColor)
            }
            return
        }
        
        self.remainingQuestionsLabel.textColor = .black
        self.questionLabel.textColor = .black
        self.answerButtons.forEach { $0.backgroundColor = .themeStyle(dark: .coolBlue, light: .defaultTintColor) }
        
    }
    
    // Pick a question for each screen
    public func pickQuestion() {
        
        // Restore
        UIView.animate(withDuration: 0.75) {
            self.answerButtons.forEach { $0.alpha = 1 }
            
        }
        
        if let quiz0 = self.quiz.next() {
            self.correctIncorrectAnswerList.removeAll()
            self.setupScreenList.removeAll()
            self.audioList.removeAll()
            
            for setup in quiz0.element.questionSetupList{
                let titleFont = UIFont(name: Fonts.customCerealAppBookFont, size: 22)!
                
                let itemOne = OnboardingItemInfo(informationImage: UIImage(named: setup.setup_img_URL.trimmingCharacters(in: .whitespacesAndNewlines)) ?? UIImage(), title: "", description: setup.setup_desc, pageIcon: UIImage(), color: backgroundColorOne, titleColor: backgroundColorTwo, descriptionColor: backgroundColorTwo, titleFont: titleFont, descriptionFont: titleFont)
                self.setupScreenList.append(itemOne)
                self.audioList.append(setup.setup_img_URL)
            }
            self.invokeSetupScreen(isGameOver: false)
            
            let fullQuestion = quiz0.element
            self.currentQuestionAudio = fullQuestion.img_URL
            self.correctIncorrectAnswerList = fullQuestion.answerList
            
            for answer in fullQuestion.answerList{
                if answer.ans_is_correct == 1{
                    self.correctAnswerFromSet = answer.ans_id
                }
            }
            
            self.questionLabel.text = fullQuestion.question
            
            let answers = fullQuestion.answerList
            
            for i in 0..<self.answerButtons.count {
                self.answerButtons[i].setTitle(answers[i].answer, for: .normal)
                self.answerButtons[i].tag = answers[i].ans_id
            }
            
            self.remainingQuestionsLabel.text = "\(quiz0.offset + 1)/\(self.set.count)"
            
            self.questionImageButton.isHidden = false
            UIView.transition(with: self.questionImageButton, duration: 0.2, options: [.curveEaseInOut], animations: {
                self.questionImageButton.alpha = 1.0
                self.questionImageButton.setImage(UIImage(named: fullQuestion.img_URL?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "beach"), for: .normal)
            })
            
            
        }
        else {
            self.endOfQuestionsAlert()
        }
    }
    
    
    private func isSetCompleted() -> Bool {
        if quiz.next() == nil{
            return true
        }
        return false
    }
    
    private func repeatActionDetailed() {
        self.repeatTimes += 1
        self.setUpQuiz()
        self.pickQuestion()
    }
    
    // Verify the correct answer
    @objc private func verify(answer: UInt8) {
        self.startLoadingAnimation()
        self.loadingView.alpha = 1
        let isCorrectAnswer: Bool
        if correctAnswerFromSet == answer{
            isCorrectAnswer = true
        }else{
            isCorrectAnswer = false
        }
        
        if isCorrectAnswer {
            playCorrectAnswerAudio()
            correctAnswers += 1
            print("## Correct Answer Selected ##")
            for answer in correctIncorrectAnswerList{
                if answer.ans_is_correct == 1{
                    presentFeebackDialog(title: "Correct Answer🥳👍", description: answer.ans_feedback, imageURL: answer.ans_feed_img_URL)
                }
            }
        }
        else {
            playInCorrectAnswerAudio()
            incorrectAnswers += 1
            print("## Incorrect Answer Selected ##")
            
            for answer in correctIncorrectAnswerList{
                if answer.ans_is_correct == 0{
                    presentFeebackDialog(title: "Incorrect Answer☹️👎", description: answer.ans_feedback, imageURL: answer.ans_feed_img_URL)
                }
            }
            
        }
        
        if #available(iOS 10.0, *) {
            if isCorrectAnswer {
                FeedbackGenerator.notificationOcurredOf(type: isCorrectAnswer ? .success : .error)
            } else {
                FeedbackGenerator.impactOcurredWith(style: .light)
            }
        }
    }
    
    private func presentFeebackDialog(title:String,description:String,imageURL:String){
        let alertVC = PMAlertController(title: title, description:description, image: UIImage(named: imageURL), style: .walkthrough)
        
        alertVC.addAction(PMAlertAction(title: "OK", style: .default, action: { () in
            
            self.pickQuestion()
        }))
        
        
        
        self.present(alertVC, animated: true, completion: nil)
    }
    
    private func playCorrectAnswerAudio(){
        Sound.stopAll()
        Sound.play(file: "correct_answer.wav")
    }
    
    private func playInCorrectAnswerAudio(){
        Sound.stopAll()
        Sound.play(file: "incorrect_answer.wav")
    }
    
    private func setUpQuiz() {
        
        set = self.questionDataList.sorted(by: { $0.question_id < $1.question_id })
        quiz = set.enumerated().makeIterator()
        
        createAnswerButtons()
        pickQuestion()
        loadCurrentTheme()
    }
    
    private func playSetupAudioClip(withfileName: String){
           Sound.stopAll()
           Sound.play(file: withfileName)
       }
    
    fileprivate func setupGameOverScreens(_ score: Int, _ titleFont: UIFont) {
       
        self.setupScreenList.removeAll()
        self.audioList.removeAll()
        
        if selectedStoryId == 1{
            let item = OnboardingItemInfo(informationImage: UIImage(named: "Q9D1 Square") ?? UIImage(), title: "Your Score: \(score)", description: "Hooray!🎉🎉🎉 Although it has been a long day, Harper and her family left the beach safely. 🏠🎉🎉😃", pageIcon: UIImage(), color: backgroundColorOne, titleColor: backgroundColorTwo, descriptionColor: backgroundColorTwo, titleFont: titleFont, descriptionFont: titleFont)
            self.setupScreenList.append(item)
            self.audioList.append("E1")
        }else if selectedStoryId == 2{
            let itemOne = OnboardingItemInfo(informationImage: UIImage(named: "S2E1") ?? UIImage(), title: "Your Score: \(score)", description: "It turns out the person asking for help was having a cramp in the leg while swimming because he didn’t warm up beforehand. Thankfully the lifeguard brought him back on the shore safely.", pageIcon: UIImage(), color: backgroundColorOne, titleColor: backgroundColorTwo, descriptionColor: backgroundColorTwo, titleFont: titleFont, descriptionFont: titleFont)
            let itemTwo = OnboardingItemInfo(informationImage: UIImage(named: "S2E2") ?? UIImage(), title: "Your Score: \(score)", description: "It’s getting darker on the island. Harper says goodbye to Yuni and Jimmy, and Pico sends her back home through the purle portal", pageIcon: UIImage(), color: backgroundColorOne, titleColor: backgroundColorTwo, descriptionColor: backgroundColorTwo, titleFont: titleFont, descriptionFont: titleFont)
            
            self.setupScreenList.append(itemOne)
            self.setupScreenList.append(itemTwo)
            self.audioList.append("S2E1")
            self.audioList.append("S2E2")
            
        }else if selectedStoryId == 3{
            let itemOne = OnboardingItemInfo(informationImage: UIImage(named: "S3E1") ?? UIImage(), title: "Your Score: \(score)", description: "Harper asks for three things: a sand castle that will never break, a storm in a bottle and a piece of marshmellow cloud. 🛕⚡☁️", pageIcon: UIImage(), color: backgroundColorOne, titleColor: backgroundColorTwo, descriptionColor: backgroundColorTwo, titleFont: titleFont, descriptionFont: titleFont)
            
            let itemTwo = OnboardingItemInfo(informationImage: UIImage(named: "S3E2") ?? UIImage(), title: "Your Score: \(score)", description: "After Harper makes her wishes, she can feel the wind gently stroking her and carrying her up from the ground. In the blink of an eye she is in her bedroom again 🛏️", pageIcon: UIImage(), color: backgroundColorOne, titleColor: backgroundColorTwo, descriptionColor: backgroundColorTwo, titleFont: titleFont, descriptionFont: titleFont)
            
            let itemThree = OnboardingItemInfo(informationImage: UIImage(named: "S3E3") ?? UIImage(), title: "Your Score: \(score)", description: "Sweet dreams, Harper, your wishes will come true when you wake up in the morning 🛌🌌", pageIcon: UIImage(), color: backgroundColorOne, titleColor: backgroundColorTwo, descriptionColor: backgroundColorTwo, titleFont: titleFont, descriptionFont: titleFont)
            
            self.setupScreenList.append(itemOne)
            self.setupScreenList.append(itemTwo)
            self.setupScreenList.append(itemThree)
            
            self.audioList.append("S3E2")
            self.audioList.append("S3E3")
            self.audioList.append("S3E4")
        }
        self.invokeSetupScreen(isGameOver: true)
    }
    
    private func endOfQuestionsAlert() {
       
        let titleFont = UIFont(name: Fonts.customFont, size: 22)!
        
        if ((self.repeatTimes < 2) && !isSetCompleted()) {
            self.repeatActionDetailed()
        }else{
            print("Story completed")
            let score = (self.correctAnswers * Constants.correctAnswerPoints) + (self.incorrectAnswers * Constants.incorrectAnswerPoints)
            print("Score: \(score)")
            setupGameOverScreens(score, titleFont)
            
           
            
          //  self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    // Retrive data from the server using promises api.
    private func setupQuestions(){
        
        retrieveQuestionData { (question) in
            print("Questions DOne ")
            
            for question in self.questionList{
                print(" Question Outside order: \(question.question_id)")
                self.questionSetupList.removeAll()
                self.answerList.removeAll()
                
                self.retrieveQuestionSetupData(questionId: question.question_id).done { (questionSetup) in
                    
                    self.retrieveAnswerData(questionId: question.question_id).done { (answer) in
                        print("Question# Inside order: \(question.question_id)")
                        print("Question# Setup \(questionSetup[0].setup_desc)")
                        print("Question# Answer \(answer[0].answer)")
                        
                        self.insertQuestionIntoList(questionData: QuestionData(question_id: question.question_id, question: question.question, imageURL: question.img_URL, answerList: answer, questionSetupList: questionSetup))
  
                    }
                }
                
            }
            
        }
        
    }
    
    
    private func insertQuestionIntoList(questionData:QuestionData){
        self.questionDataList.append(questionData)
        if self.questionDataList.count == 10{
            print("Data Insertion complete")
            self.setUpQuiz()
        }
    }
    
    // MARK: API Calls
    private func retrieveQuestionData(completion: @escaping (Question?)->()) {
        print(" ### getQuestionByStoryId ###")
        guard let urlToExecute  = URL(string: Constants.baseURL+"/getQuestionByStoryId/\(selectedStoryId)") else {
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
                            
                            fulfill.fulfill(responseDecoded)
                            
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
                            
                            fulfill.fulfill(responseDecoded)
                            
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

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

class QuestionViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var answerStub: RoundedButton!
    @IBOutlet weak var remainingQuestionsLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var questionImageButton: UIButton!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var answersStackView: UIStackView!
    
    // Variables
    var correctAnswerFromSet = Int()
    var correctAnswers = Int()
    var incorrectAnswers = Int()
    var repeatTimes = UInt8()
    var currentTopicIndex = Int()
    var currentSetIndex = Int()
    var selectedStoryId:Int = 0

    // Arrays
    var questionList = [Question]()
    var questionSetupList = [QuestionSetup]()
    var answerList = [Answer]()
    var correctIncorrectAnswerList = [Answer]()
    var questionDataList = [QuestionData]()
    var set: [QuestionData] = []
    var quiz: EnumeratedSequence<[QuestionData]>.Iterator!
    var answerButtons: [RoundedButton] = []
    var setupScreenList = [OnboardingItemInfo?]()
    
    
    // MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Retrieve the question data from the server
        setupQuestions()
        
        // Setup the imageview for the questions
        self.questionImageButton.setImage(nil, for: .normal)
        self.questionImageButton.imageView?.contentMode = .scaleAspectFit
        self.questionImageButton.imageView?.clipsToBounds = true
        self.questionImageButton.clipsToBounds = true
        self.questionImageButton.layer.cornerRadius = 10
    }
        
    private func invokeSetupScreen(){
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SETUP_SCREEN_IDENTIFIER") as? SetupScreenViewController
        {
            vc.modalPresentationStyle = .fullScreen
            
            vc.onBoardList = self.setupScreenList
            present(vc, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func onPauseButtonTapped(_ sender: Any) {
        let alertVC = PMAlertController(title: "", description:"", image: nil, style: .alert)
        
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
            button.titleLabel?.font = UIFont(name: "Chalkduster", size: 18)!
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
            
            
            for setup in quiz0.element.questionSetupList{
                
                let backgroundColorOne = UIColor(red: 236/255, green: 210/255, blue: 175/255, alpha: 1)
                let backgroundColorTwo = UIColor(red: 37/255, green: 37/255, blue: 42/255, alpha: 1)
                let titleFont = UIFont(name: "Chalkduster", size: 22)!
                
                let itemOne = OnboardingItemInfo(informationImage: UIImage(named: setup.setup_img_URL.trimmingCharacters(in: .whitespacesAndNewlines)) ?? UIImage(), title: "", description: setup.setup_desc, pageIcon: UIImage(), color: backgroundColorOne, titleColor: backgroundColorTwo, descriptionColor: backgroundColorTwo, titleFont: titleFont, descriptionFont: titleFont)
                self.setupScreenList.append(itemOne)
                
            }
            self.invokeSetupScreen()
            
            
            let fullQuestion = quiz0.element
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
        let isCorrectAnswer: Bool
        if correctAnswerFromSet == answer{
            isCorrectAnswer = true
        }else{
            isCorrectAnswer = false
        }
        
        if isCorrectAnswer {
            correctAnswers += 1
            print("## Correct Answer Selected ##")
            for answer in correctIncorrectAnswerList{
                if answer.ans_is_correct == 1{
                    presentFeebackDialog(title: "Correct Answer🥳👍", description: answer.ans_feedback, imageURL: answer.ans_feed_img_URL)
                }
            }
        }
        else {
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
    
    private func setUpQuiz() {
        
        set = self.questionDataList.sorted(by: { $0.question_id < $1.question_id })
        quiz = set.enumerated().makeIterator()
        
        createAnswerButtons()
        pickQuestion()
        loadCurrentTheme()
    }
    
    private func endOfQuestionsAlert() {
        
        if ((self.repeatTimes < 2) && !isSetCompleted()) {
            self.repeatActionDetailed()
        }else{
            print("Story completed")
            let score = (self.correctAnswers * Constants.correctAnswerPoints) + (self.incorrectAnswers * Constants.incorrectAnswerPoints)
            print("Score: \(score)")
            let alertVC = PMAlertController(title: "Your Score: \(score)", description:"Hooray!🎉🎉🎉 Although it has been a long day, Harper and her family left the beach safely. 🏠🎉🎉😃", image: UIImage(named: "Q9D1 Square"), style: .walkthrough)
            
            alertVC.addAction(PMAlertAction(title: "OK", style: .default, action: { ()
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alertVC, animated: true, completion: nil)
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

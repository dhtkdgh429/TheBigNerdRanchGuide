//
//  ViewController.swift
//  Quiz
//
//  Created by Oh Sangho on 16/03/2019.
//  Copyright © 2019 Oh Sangho. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // View
    @IBOutlet var currentQuestionLabel: UILabel!
    @IBOutlet weak var currentQuestionLabelCenterX: NSLayoutConstraint!
    @IBOutlet var nextQuestionLabel: UILabel!
    @IBOutlet weak var nextQuestionLabelCenterX: NSLayoutConstraint!
    
    @IBOutlet var answerLabel: UILabel!
    
    // Model
    let questions: [String] = ["From what is congnac made?",
                               "What is 7+7",
                               "What is the capital of Vermont?"]
    let answers: [String] = ["Grapes",
                             "14",
                             "Montpelier"]
    
    var currentQuestionIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentQuestionLabel.text = questions[currentQuestionIndex]
        updateOffScreenLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 라벨 초기 알파 값 설정
        self.nextQuestionLabel.alpha = 0
    }
    
    private func updateOffScreenLabel() {
        let screenWidth = view.frame.width
        nextQuestionLabelCenterX.constant = -screenWidth
    }
    
    private func animateLabelTransitions() {
        
        // 아직 처리하지 않은 레이아웃의 변경 요청.
        view.layoutIfNeeded()
        
        // 알파 값을 변경..
        // + center x 조건 변경
        let screenWidth = view.frame.width
        self.nextQuestionLabelCenterX.constant = 0
        self.currentQuestionLabelCenterX.constant += screenWidth
        
        // spring animation..
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.5,
                       options: .curveEaseOut,
                       animations: {
                        self.currentQuestionLabel.alpha = 0
                        self.nextQuestionLabel.alpha = 1
                        
                        self.view.layoutIfNeeded()
        }) { _ in
            swap(&self.currentQuestionLabel,
                 &self.nextQuestionLabel)
            swap(&self.currentQuestionLabelCenterX,
                 &self.nextQuestionLabelCenterX)
            
            self.updateOffScreenLabel()
        }
    }
    
    @IBAction func showNextQuestion(sender: AnyObject) {
        currentQuestionIndex += 1
        if currentQuestionIndex == questions.count {
            currentQuestionIndex = 0
        }
        
        let question: String = questions[currentQuestionIndex]
        nextQuestionLabel.text = question
        answerLabel.text = "???"
        
        animateLabelTransitions()
    }
    
    @IBAction func showAnswer(sender: AnyObject) {
        let answer: String = answers[currentQuestionIndex]
        answerLabel.text = answer
    }

}


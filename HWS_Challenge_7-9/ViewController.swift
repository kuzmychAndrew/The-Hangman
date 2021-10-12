//
//  ViewController.swift
//  HWS_Challenge_7-9
//
//  Created by Андрій Кузьмич on 07.10.2021.
//

import UIKit

class ViewController: UIViewController {
    var scoreLabel: UILabel!
    var wrongAnswersLabel: UILabel!
    var reportLabel: UILabel!
    var chosenLetter: UILabel!
    
    var submitButton: UIButton!
    var clearButton: UIButton!
    var letterButtons = [UIButton]()
    var activatedButton = [UIButton]()
//    var nextWordButton: UIButton!
//    var restartButton: UIButton!
    
    var currentAnswer: UITextField!
    
    var score = 0 {
            didSet {
                scoreLabel.text = "Score: \(score)"
            }
        }
        var wrongScore = 0 {
            didSet {
                wrongAnswersLabel.text = "Wrong answers: \(wrongScore)."
            }
        }
    var countOfAttempts = 0
    var guessedLetters = 0
    var word = ""
    var usedLetters = [Character]()
    var promptWord = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        performSelector(inBackground: #selector(loadWords), with: nil)
    }

    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Score: 0"
        view.addSubview(scoreLabel)
        
        wrongAnswersLabel = UILabel()
        wrongAnswersLabel.translatesAutoresizingMaskIntoConstraints = false
        wrongAnswersLabel.textAlignment = .left
        wrongAnswersLabel.text = "Wrong answers: 0"
        view.addSubview(wrongAnswersLabel)
        
        reportLabel = UILabel()
        reportLabel.translatesAutoresizingMaskIntoConstraints = false
        reportLabel.font = UIFont.systemFont(ofSize: 24)
        reportLabel.text = "REPORT"
        reportLabel.numberOfLines = 0
        reportLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(reportLabel)
        
        chosenLetter = UILabel()
        chosenLetter.translatesAutoresizingMaskIntoConstraints = false
        chosenLetter.text = "___"
        chosenLetter.textAlignment = .center
        view.addSubview(chosenLetter)
        
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.placeholder = "Tap letter to guess"
        currentAnswer.textAlignment = .center
        currentAnswer.font = UIFont.systemFont(ofSize: 36)
        currentAnswer.isUserInteractionEnabled = false
        view.addSubview(currentAnswer)
        
        submitButton = UIButton(type: .system)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.setTitle("Submit", for: .normal )
        submitButton.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        view.addSubview(submitButton)
        
        clearButton = UIButton(type: .system)
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        clearButton.setTitle("Clear", for: .normal )
        clearButton.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        view.addSubview(clearButton)
        
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        let width = 60
        let height = 50
    
        for row in 0..<5{
            for col in 0..<6{
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 24)
                
                letterButton.setTitle("w", for: .normal)
                
                
                let frame = CGRect(x: col * width, y: row * height, width: width, height: height )
                letterButton.frame = frame
                letterButton.layer.borderWidth = 1
                letterButton.layer.borderColor = UIColor.lightGray.cgColor
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                buttonsView.addSubview(letterButton)
                
                letterButtons.append(letterButton)
                
            }
        
        
        }
        
        let allLetters = (65...90).map { Character(Unicode.Scalar($0)) }
        
        for (index, button) in letterButtons.enumerated(){
            if index <= 25{
            button.setTitle(String(allLetters[index]), for: .normal)
            }else{
                button.setTitle("__", for: .normal)
                
            }
            
        }
        
        
        NSLayoutConstraint.activate([
        
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            wrongAnswersLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            wrongAnswersLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            
            reportLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            reportLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            reportLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 1),
            
            
            currentAnswer.topAnchor.constraint(equalTo: reportLabel.bottomAnchor,constant: 10),
            currentAnswer.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 1),
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            chosenLetter.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            chosenLetter.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor, constant: 15),
            chosenLetter.heightAnchor.constraint(equalToConstant: 44),

            
            submitButton.centerYAnchor.constraint(equalTo: chosenLetter.centerYAnchor),
            submitButton.leadingAnchor.constraint(equalTo: currentAnswer.leadingAnchor),
            submitButton.trailingAnchor.constraint(equalTo: chosenLetter.leadingAnchor, constant: -15),
            submitButton.heightAnchor.constraint(equalToConstant: 44),
            
            clearButton.centerYAnchor.constraint(equalTo: chosenLetter.centerYAnchor),
            clearButton.trailingAnchor.constraint(equalTo: currentAnswer.trailingAnchor),
            clearButton.leadingAnchor.constraint(equalTo: chosenLetter.trailingAnchor, constant: 15),
            clearButton.heightAnchor.constraint(equalToConstant: 44),
            
            buttonsView.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 1),
            buttonsView.heightAnchor.constraint(equalToConstant: 250),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: chosenLetter.bottomAnchor, constant: 20),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
            
            
            
        ])
        
        let labels = [reportLabel, chosenLetter]
        for label in labels {
            label!.layer.borderWidth = 1
            label!.layer.borderColor = UIColor.lightGray.cgColor
        }
    let buttons = [submitButton,clearButton]
        for button in buttons {
            button!.layer.borderWidth = 1
            button!.layer.borderColor = UIColor.lightGray.cgColor
        }
        currentAnswer.layer.borderWidth = 1
        currentAnswer.layer.borderColor = UIColor.lightGray.cgColor

    }
    
    @objc func loadWords(){
        if let wordListURL = Bundle.main.url(forResource: "wordlist", withExtension: "txt"){
            if let wordListContent = try?String(contentsOf: wordListURL){
                var words = wordListContent.components(separatedBy: "\n")
                words.shuffled()
                
                word = words.randomElement()!
                print("Word: \(word)")
                
                for letter in word {
                    usedLetters.append(letter)
                    promptWord.append("?")
                }
                
                print("Used letters: \(usedLetters)")
                print("Prompt word: \(promptWord)")
                
                DispatchQueue.main.async {
                    self.currentAnswer.text = self.promptWord.joined()
                }
                countOfAttempts = word.count - 1
            }
        }
    }
    
    @objc func letterTapped(_ sender:UIButton){
        guard let buttonTitle = sender.titleLabel?.text else {return}
        
        chosenLetter.text = buttonTitle
        activatedButton.append(sender)
        sender.isHidden = true
        sender.isUserInteractionEnabled = false
    }
        
    @objc func submitTapped(){
        guard let answerLetter = chosenLetter.text?.lowercased() else {return}
        
        if usedLetters.contains(Character(answerLetter)){
            for(index, character) in usedLetters.enumerated(){
                if character == Character(answerLetter){
                    promptWord[index] = answerLetter
                    currentAnswer.text = promptWord.joined().uppercased()
                    score += 1
                    guessedLetters += 1
                    chosenLetter.text = "_"
                    if guessedLetters == word.count{
                        let ac = UIAlertController(title: "Congratulations", message: "You guessed it", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: nextWord))
                        present(ac, animated: true)
                    }
                }
                    
            }
                
        }else{
            wrongScore += 1
            if wrongScore <= countOfAttempts{
                let ac = UIAlertController(title: "It's wrong", message: "Choose another letter", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default){ _ in
                    self.chosenLetter.text = "_"
                })
                present(ac, animated: true)
            }else{
                let ac = UIAlertController(title: "GAME OVER", message: "YOU ARE DIED", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Try again", style: .default, handler: retry))
                present(ac, animated: true)
            }
            
        }
    }
    
    @objc func clearTapped(_ sender: UIButton){
        let buttonToClear = activatedButton.removeLast()
        buttonToClear.isHidden = true
        buttonToClear.isUserInteractionEnabled = false
        chosenLetter.text = "_"
    }
    func nextWord(action: UIAlertAction! = nil) {
            word = ""
            promptWord.removeAll()
            usedLetters.removeAll()
            showButtons()
            score = 0
            wrongScore = 0
            loadWords()
        }
    
    func retry(action: UIAlertAction! = nil) {
        score = 0
        wrongScore = 0
        promptWord.removeAll()
                    
        for _ in word {
            promptWord.append("?")
        }
                    
        showButtons()
        currentAnswer.text = promptWord.joined()
        chosenLetter.text = "_"
        
    }
    
    func showButtons(){
        for button in activatedButton{
            button.isHidden = false
            button.isUserInteractionEnabled = true
        }
    }
    
    
    
    
}


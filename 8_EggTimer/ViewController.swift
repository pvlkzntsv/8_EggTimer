//
//  ViewController.swift
//  8_EggTimer
//
//  Created by pvl kzntsv on 28.01.2023.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    //MARK: Elements
    
    private let contentStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .center
        return stack
    }()
    
    private let choiceLabel: UILabel = {
        let label = UILabel()
        label.text = "How do you like your eggs?"
        label.font = UIFont(name: "Helvetica Neue", size: 30)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.numberOfLines = 3
        label.textAlignment = .center
        return label
    }()
    
    private let eggStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var timerProgressView: UIProgressView = {
        var progressView = UIProgressView(progressViewStyle: .bar)
//        progressView.progress = 0.8
        progressView.contentMode = .center
        progressView.progressTintColor = .yellow
        progressView.trackTintColor = .gray
        return progressView
    }()
    
    private lazy var progressView = UIView()
    
    func addEggButtons() {
        let eggArray = ["soft egg", "medium egg", "hard egg"]
        for egg in eggArray {
            let button = UIButton()
            button.setTitle(egg, for: .normal)
            button.setImage(UIImage(imageLiteralResourceName: egg), for: .normal)
            button.imageView?.contentMode = .scaleAspectFit
            button.imageView?.image = UIImage(imageLiteralResourceName: egg)
            eggStackView.addArrangedSubview(button)
            button.addAction(UIAction { _ in self.setTimer(button)}, for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    //MARK: Timer
    
    var timer = Timer()
    var player = AVAudioPlayer()
    let eggsHardnesSeconds = ["soft egg": 3.0, "medium egg": 5.0, "hard egg": 7.0]
    var totalTime =  0.0
    var secondsPassed = 0.0
    
    func setTimer(_ sender: UIButton) {
        timer.invalidate()
        choiceLabel.text = "You choose \(sender.currentTitle!), please cook until timer ring"
        guard let seconds = eggsHardnesSeconds[sender.currentTitle!] else {return}
        totalTime = seconds
        secondsPassed = 0.0
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if secondsPassed < totalTime {
            secondsPassed += 1.0
            timerProgressView.progress = Float(secondsPassed/totalTime)
        } else {
            timer.invalidate()
            choiceLabel.text = "DONE!"
            playAlarmSound()
        }
    }

    func playAlarmSound(){
        let url = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3")
                player = try! AVAudioPlayer(contentsOf: url!)
                player.play()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.7953952551, green: 0.9488922954, blue: 0.9872274995, alpha: 1)
        view.setView(contentStackView)
        view.setView(choiceLabel)
        view.setView(eggStackView)
        view.setView(timerProgressView)
        view.setView(contentStackView)
        view.setView(progressView)
        addEggButtons()
        setupUI()
        setConstraints()
   }
    
// MARK: Set View
    
    func setupUI() {
        progressView.addSubview(timerProgressView)
        contentStackView.addArrangedSubview(choiceLabel)
        contentStackView.addArrangedSubview(eggStackView)
        contentStackView.addArrangedSubview(progressView)
        progressView.contentMode = .center
    }
  
    //MARK: Constraints
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            contentStackView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            contentStackView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor),
            contentStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            progressView.widthAnchor.constraint(equalTo: contentStackView.widthAnchor, multiplier: 0.8),
            timerProgressView.widthAnchor.constraint(equalTo: progressView.widthAnchor),
            timerProgressView.heightAnchor.constraint(equalToConstant: 6),
            timerProgressView.centerXAnchor.constraint(equalTo: progressView.centerXAnchor),
            timerProgressView.centerYAnchor.constraint(equalTo: progressView.centerYAnchor)
        ])       
    }
}


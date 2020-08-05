//
//  ViewController.swift
//  Expendibots
//
//  Created by 施杰煌 on 12/7/20.
//  Copyright © 2020 施杰煌. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var point: UILabel!
    @IBOutlet weak var playBoard: UIView!
    @IBOutlet weak var changeNum: UIStepper!
    @IBOutlet weak var num: UILabel!
    @IBOutlet weak var whiteWin: UILabel!
    @IBOutlet weak var blackWin: UILabel!
    @IBOutlet weak var volumn: UIButton!
    
    var game : Game!
    var bgm : AVAudioPlayer!
    var boom : AVAudioPlayer!
    var mute = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        game = Game.init(startBoard: playBoard, label: point)
        self.view.addSubview(game.board)
        //self.playSound(soundFileName: "三轮学", soundExtension: "mp3")
        changeNum.maximumValue = 12
        changeNum.minimumValue = 1
        changeNum.value = 1
        changeNum.stepValue = 1
        changeNum.wraps = true
    }
    @IBAction func restart(_ sender: UIButton) {
        reset()
    }
    @IBAction func mute(_ sender: UIButton) {
        /*if self.bgm.isPlaying {
            self.bgm.stop()
            volumn.setImage(UIImage(named: "静音.jpg"), for: UIControl.State.normal)
        }
        else {
            self.playSound(soundFileName: "三轮学", soundExtension: "mp3")
            volumn.setImage(UIImage(named: "音量.jpg"), for: UIControl.State.normal)
        }*/
    }
    
    func reset() {
        game.reset()
        game.board.resetBoard()
        game.board.initilizeBoard(game: game)
        game.currentPlayer = 1
        point.text = "wating for white player to select..."
    }
    
    @IBAction func ChangeNum(_ sender: UIStepper) {
        num.text = "Number of tokens to move: " + String(Int(sender.value))
        game.movedNum = Int(sender.value)
    }
    
    @IBAction func playWithAI(_ sender: UIButton) {
        /*reset()
        game.AI = true
        game.currentPlayer = 1*/
    }
    
    
    @IBAction func boom(_ sender: UIButton) {
        game.boom()
        whiteWin.text = "white player win: " + String(game.whiteWin)
        blackWin.text = "black player win: " + String(game.blackWin)
        game.continuous = false
    }
    
    @objc private func valueChanged(sender: UISlider) {
        sender.setValue(sender.value + 1, animated: false)
    }
    
    /*func playSound(soundFileName : String, soundExtension: String) {
        let soundURL = Bundle.main.url(forResource: soundFileName, withExtension: soundExtension)
        self.bgm =  try! AVAudioPlayer(contentsOf: soundURL!)
        self.bgm.numberOfLoops = -1
        self.bgm.play()
    }*/
}


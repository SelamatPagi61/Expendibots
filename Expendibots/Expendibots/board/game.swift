//
//  game.swift
//  Expendibots
//
//  Created by 施杰煌 on 18/7/20.
//  Copyright © 2020 施杰煌. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class Game {
    
    var board : Board!
    var selected = [Int]()
    var moved = [Int]()
    var label : UILabel
    var whiteBoard = [[Int]]()
    var blackBoard = [[Int]]()
    var explosion_areas = [[Int]]()
    var boom_point = [[Int]]()
    var viewBoard : UIView!
    var selectedPoint : Piece!
    var movedNum = 1
    var currentPlayer = 1
    var AI = false
    var continuous = false
    var select : AVAudioPlayer!
    var boomSound : AVAudioPlayer!
    var blackWin = 0
    var whiteWin = 0
    var AIplayer : AIPlayer!
    
    init(startBoard: UIView, label: UILabel) {
        self.label = label
        viewBoard = startBoard
        board = Board.init(startBoard: startBoard)
        board.initilizeBoard(game: self)
        AIplayer = AIPlayer.init()
        blackBoard = [[1,0,7], [1,1,7], [1,3,7], [1,4,7], [1,6,7], [1,7,7], [1,0,6], [1,1,6], [1,3,6], [1,4,6], [1,6,6], [1,7,6]]
        whiteBoard = [[1,0,1], [1,1,1], [1,3,1], [1,4,1], [1,6,1], [1,7,1], [1,0,0], [1,1,0], [1,3,0], [1,4,0], [1,6,0], [1,7,0]]
    }
    
    func play() {
        var one = false
        var remove_token_index = -1
        var exist = false
        var num = board.pieceButton[selected[1]][selected[0]].pieceNum
        var move = false
        if (movedNum < num) {
            num = movedNum
        }
        if !selected.isEmpty && !moved.isEmpty {
            if board.pieceButton[selected[1]][selected[0]].pieceColor == PieceColor.black && currentPlayer == 2{
                for i in 0...blackBoard.count - 1 {
                    let token = [blackBoard[i][0], blackBoard[i][1], blackBoard[i][2]]
                    if selected == [token[1], token[2]] {
                        if (token[0] - num) > 0 {
                            blackBoard[i][0] -= num
                            board.addPiece(x: selected[1], y: selected[0], num: -num, game: self, color: PieceColor.black)
                        }
                        else {
                            one = true
                            remove_token_index = i
                        }
                    }
                    if moved == [token[1], token[2]] {
                        blackBoard[i][0] += num
                        exist = true
                        board.addPiece(x: moved[1], y: moved[0], num: num, game: self, color: PieceColor.black)
                    }
                }
                if exist == false {
                    let new_token = [num, moved[0], moved[1]]
                    blackBoard.append(new_token)
                    board.addPiece(x: moved[1], y: moved[0], num: num, game: self, color: PieceColor.black)
                }
                if one {
                    board.removePiece(x: selected[1], y: selected[0])
                    blackBoard.remove(at: remove_token_index)
                }
                move = true
            }
            if board.pieceButton[selected[1]][selected[0]].pieceColor == PieceColor.white && currentPlayer == 1{
                for i in 0...whiteBoard.count - 1 {
                    let token = [whiteBoard[i][0], whiteBoard[i][1], whiteBoard[i][2]]
                    if selected == [token[1], token[2]] {
                        if (token[0] - num) > 0 {
                            whiteBoard[i][0] -= num
                            board.addPiece(x: selected[1], y: selected[0], num: -num, game: self, color: PieceColor.white)
                        }
                        else {
                            one = true
                            remove_token_index = i
                        }
                    }
                    if moved == [token[1], token[2]] {
                        whiteBoard[i][0] += num
                        exist = true
                        board.addPiece(x: moved[1], y: moved[0], num: num, game: self, color: PieceColor.white)
                    }
                }
                if exist == false {
                    let new_token = [num, moved[0], moved[1]]
                    whiteBoard.append(new_token)
                    board.addPiece(x: moved[1], y: moved[0], num: num, game: self, color: PieceColor.white)
                }
                if one {
                    board.removePiece(x: selected[1], y: selected[0])
                    whiteBoard.remove(at: remove_token_index)
                }
                move = true
            }
        }
        if currentPlayer == 1 && move == true{
            label.text = "wating for black player to select..."
            currentPlayer = 2
            moved.removeAll()
            selected.removeAll()
        }
        else if currentPlayer == 2 && move == true{
            label.text = "wating for white player to select..."
            currentPlayer = 1
            moved.removeAll()
            selected.removeAll()
        }
    }
    
    func exist() -> Bool{
        for point in blackBoard {
            if [point[1], point[2]] == selected {
                return true
            }
        }
        for point in whiteBoard {
            if [point[1], point[2]] == selected {
                return true
            }
        }
        return false
    }
    
    func checkWin() -> Bool {
        if !blackBoard.isEmpty && !whiteBoard.isEmpty {
            return true
        }
        return false
    }
    
    func boom() {
        var stop = true
        if !selected.isEmpty && exist() && checkWin(){
            if explosion_areas.isEmpty {
                explosion_areas.append([selected[0], selected[1]])
            }
            for i in 0...blackBoard.count - 1 {
                let token = [blackBoard[i][1], blackBoard[i][2]]
                explosion()
                if !explosion_areas.contains(token) && boom_point.contains(token) {
                    explosion_areas.append(token)
                    board.removePiece(x: token[1], y: token[0])
                    blackBoard.remove(at: i)
                    stop = false
                    break
                }
            }
            for i in 0...whiteBoard.count - 1 {
                let token = [whiteBoard[i][1], whiteBoard[i][2]]
                explosion()
                if !explosion_areas.contains(token) && boom_point.contains(token) {
                    explosion_areas.append(token)
                    board.removePiece(x: token[1], y: token[0])
                    whiteBoard.remove(at: i)
                    stop = false
                    break
                }
            }
            if stop == false {
                boom()
            }
            self.playSound(soundFileName: "爆炸", soundExtension: "mp3")
        }
        if (!selected.isEmpty && !blackBoard.isEmpty) {
            for i in 0...blackBoard.count - 1 {
                let token = [blackBoard[i][1], blackBoard[i][2]]
                if token == [selected[0], selected[1]] {
                    blackBoard.remove(at: i)
                    board.removePiece(x: token[1], y: token[0])
                    break
                }
            }
        }
        if (!selected.isEmpty && !whiteBoard.isEmpty) {
            for i in 0...whiteBoard.count - 1 {
                let token = [whiteBoard[i][1], whiteBoard[i][2]]
                if token == [selected[0], selected[1]] {
                    whiteBoard.remove(at: i)
                    board.removePiece(x: token[1], y: token[0])
                    break
                }
            }
        }
        if !continuous {
            if blackBoard.isEmpty && !whiteBoard.isEmpty {
                label.text = "White player win!"
                whiteWin += 1
                board.mutePiece()
            }
            else if !blackBoard.isEmpty && whiteBoard.isEmpty {
                label.text = "black player win!"
                blackWin += 1
                board.mutePiece()
            }
            else if blackBoard.isEmpty && whiteBoard.isEmpty {
                label.text = "no winner!"
                board.mutePiece()
            }
            else {
                if !selected.isEmpty {
                    if currentPlayer == 1 {
                        label.text = "white player boom at " + "[" + String(selected[0]) + " ," + String(selected[1]) + "]"
                        currentPlayer = 2
                    }
                    else if currentPlayer == 2 {
                        label.text = "black player boom at " + "[" + String(selected[0]) + " ," + String(selected[1]) + "]"
                        currentPlayer = 1
                    }
                }
            }
        }
        continuous = true
        explosion_areas.removeAll()
    }
    
    func playWithAI() {
        AIplayer.play(game: self)
    }
    
    func explosion() {
        var boom_area = [[Int]]()
        boom_point.removeAll()

        for point in explosion_areas {
            for x in point[0] - 1...point[0] + 1 {
                for y in point[1] - 1...point[1] + 1 {
                    if x >= 0 && x < 8 && y >= 0 && y < 8 {
                        boom_area.append([x, y])
                    }
                }
            }
        }
        for point in boom_area {
            if !explosion_areas.contains(point) {
                boom_point.append(point)
            }
        }
    }
    
    func indexOfToken(x: Int, y: Int) -> Int {
        for i in 0...whiteBoard.count - 1 {
            if whiteBoard[i][1] == x && whiteBoard[i][2] == y {
                return i
            }
        }
        for i in 0...blackBoard.count - 1 {
            if blackBoard[i][1] == x && blackBoard[i][2] == y {
                return i
            }
        }
        return -1
    }
    
    func reset() {
        blackBoard = [[1,0,7], [1,1,7], [1,3,7], [1,4,7], [1,6,7], [1,7,7], [1,0,6], [1,1,6], [1,3,6], [1,4,6], [1,6,6], [1,7,6]]
        whiteBoard = [[1,0,1], [1,1,1], [1,3,1], [1,4,1], [1,6,1], [1,7,1], [1,0,0], [1,1,0], [1,3,0], [1,4,0], [1,6,0], [1,7,0]]
        selected.removeAll()
        moved.removeAll()
    }
    
    func validSelect() -> Bool{
        if currentPlayer == 2 {
            for point in blackBoard {
                if [point[1], point[2]] == selected {
                    return true
                }
            }
        }
        else if currentPlayer == 1 {
            for point in whiteBoard {
                if [point[1], point[2]] == selected {
                    return true
                }
            }
        }
        return false
    }
    
    func playSound(soundFileName : String, soundExtension: String) {
        let soundURL = Bundle.main.url(forResource: soundFileName, withExtension: soundExtension)
            
            if soundFileName == "select" {
                self.select =  try! AVAudioPlayer(contentsOf: soundURL!)
                self.select.play()
            }
            else if soundFileName == "爆炸" {
                self.boomSound =  try! AVAudioPlayer(contentsOf: soundURL!)
                self.boomSound.play()
            }
    }
    
    @objc public func didClickButton(sender: UIButton) {
        if selected.isEmpty {
            selected.append(sender.tag % 8)
            selected.append(sender.tag / 8)
        }
        else {
            let row = abs(sender.tag % 8 - (selected[0]))
            let column = abs(sender.tag / 8 - selected[1])
            let color = board.pieceButton[selected[1]][selected[0]].pieceColor
            let movedColor = board.pieceButton[sender.tag / 8][sender.tag % 8].pieceColor
            if (row + column) <= board.pieceButton[selected[1]][selected[0]].pieceNum && ((row == 0 && column != 0) || (row != 0 && column == 0)) {
                if (color == PieceColor.white && movedColor != PieceColor.black) || (color == PieceColor.black && movedColor != PieceColor.white) {
                    moved.append(sender.tag % 8)
                    moved.append(sender.tag / 8)
                }
            }
            else {
                selected.removeAll()
                moved.removeAll()
                selected.append(sender.tag % 8)
                selected.append(sender.tag / 8)
            }
        }
        if validSelect() {
            label.text = "[" + String(selected[0]) + " ," + String(selected[1]) + "]"
            if AI {
                if currentPlayer == 1 {
                    //playSound(soundFileName: "select", soundExtension: "wav")
                    play()
                }
                else if currentPlayer == 2{
                    playWithAI()
                }
            }
            else {
                //playSound(soundFileName: "select", soundExtension: "wav")
                play()
            }
        }
        else {
            if currentPlayer == 1{
                label.text = "wating for white player to select..."
            }
            else if currentPlayer == 2{
                if AI {
                    label.text = "wating for AI to select..."
                }
                else {
                    label.text = "wating for black player to select..."
                }
            }
            selected.removeAll()
        }
    }
}

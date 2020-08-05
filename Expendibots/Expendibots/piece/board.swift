//
//  board.swift
//  Expendibots
//
//  Created by 施杰煌 on 12/7/20.
//  Copyright © 2020 施杰煌. All rights reserved.
//

import Foundation
import UIKit

class Board: UIView {
    
    var white : UIImage!
    var black : UIImage!
    var pieceButton = [[Piece]]()
    var board : UIView!
    
    init(startBoard: UIView) {
        super.init(frame: .zero)
        board = startBoard
        var tagNum = 0
        for i in 0...7 {
            var columnButton = [Piece]()
            for j in 0...7 {
                let piece = UIButton(frame: CGRect(x: CGFloat(10 + 93 * j), y: CGFloat(15 + 93 * (7 - i)), width: CGFloat(75), height: CGFloat(75)))
                piece.tag = tagNum
                let occupyingPiece = Piece(button: piece, num: 0, color: PieceColor.none)
                columnButton.append(occupyingPiece)
                tagNum += 1
            }
            pieceButton.append(columnButton)
        }
        white = UIImage(named: "白.png")
        black = UIImage(named: "黑.png")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initilizeBoard(game: Game) {
        for i in 0...7 {
            for j in 0...7 {
                if j == 0 || j == 3 || j == 6 {
                    if i == 0 || i == 1 {
                        pieceButton[i][j].setPiece(image: white, gameBoard: board, color: PieceColor.white, game: game, num: 1)
                        pieceButton[i][j + 1].setPiece(image: white, gameBoard: board, color: PieceColor.white, game: game, num: 1)
                    }
                    if i == 6 || i == 7 {
                        pieceButton[i][j].setPiece(image: black, gameBoard: board, color: PieceColor.black, game: game, num: 1)
                        pieceButton[i][j + 1].setPiece(image: black, gameBoard: board, color: PieceColor.black, game: game, num: 1)
                    }
                    else {
                        pieceButton[i][j].setAction(gameBoard: board, game: game)
                    }
                }
                else {
                    pieceButton[i][j].setAction(gameBoard: board, game: game)
                }
            }
        }
        board.isUserInteractionEnabled = true
    }
    
    func resetBoard() {
        for i in 0...7 {
            for j in 0...7 {
                pieceButton[i][j].removePiece(gameBoard: board)
            }
        }
    }
    
    func removePiece(x: Int, y: Int) {
        pieceButton[x][y].removePiece(gameBoard: board)
    }
    
    func mutePiece() {
        board.isUserInteractionEnabled = false
    }
    
    func addPiece(x: Int, y: Int, num: Int, game: Game, color: PieceColor) {
        if color == PieceColor.black {
            pieceButton[x][y].setNumImage(image: black, num: num, color: PieceColor.black)
        }
        if color == PieceColor.white {
            pieceButton[x][y].setNumImage(image: white, num: num, color: PieceColor.white)
        }
    }
}

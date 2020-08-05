//
//  File.swift
//  Expendibots
//
//  Created by 施杰煌 on 12/7/20.
//  Copyright © 2020 施杰煌. All rights reserved.
//

import Foundation
import UIKit

enum PieceColor{
    case black
    case white
    case none
}

class Piece {
    
    var pieceButton : UIButton!
    var pieceNum : Int
    var pieceColor : PieceColor!
    var pieceTag : Int
    
    init(button: UIButton, num: Int, color: PieceColor){
        pieceColor = color
        pieceButton = button
        pieceNum = num
        pieceTag = button.tag
    }
    
    func textToImage(drawText: NSString, inImage: UIImage, atPoint: CGPoint) -> UIImage{     // Setup the font specific variables
        let textColor = UIColor.black
        let textFont = UIFont(name: "Helvetica Bold", size: 150)
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(inImage.size, false, scale)
        let textFontAttributes = [NSAttributedString.Key.font: textFont,         NSAttributedString.Key.foregroundColor: textColor]
        inImage.draw(in: CGRect(origin: CGPoint.zero, size: inImage.size))
        let rect = CGRect(origin: atPoint, size: inImage.size)
        drawText.draw(in: rect, withAttributes: textFontAttributes as [NSAttributedString.Key : Any])
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    func setPiece(image: UIImage, gameBoard: UIView, color: PieceColor, game: Game, num: Int){
        self.pieceColor = color
        self.pieceNum = num
        let image = textToImage(drawText: String(pieceNum) as NSString, inImage: image, atPoint: CGPoint.init(x: 112, y: 75))
        pieceButton.setImage(image, for: UIControl.State.normal)
        pieceButton.addTarget(game, action: #selector(game.didClickButton(sender:)), for:  UIControl.Event.touchUpInside)
        gameBoard.addSubview(pieceButton)
    }
    
    func setNumImage(image: UIImage, num: Int, color: PieceColor) {
        self.pieceColor = color
        self.pieceNum += num
        let image = textToImage(drawText: String(pieceNum) as NSString, inImage: image, atPoint: CGPoint.init(x: 112, y: 75))
        pieceButton.setImage(image, for: UIControl.State.normal)
    }
    
    func setAction(gameBoard: UIView, game: Game) {
        pieceButton.addTarget(game, action: #selector(game.didClickButton(sender:)), for:  UIControl.Event.touchUpInside)
        gameBoard.addSubview(pieceButton)
    }
    
    func removePiece(gameBoard: UIView) {
        pieceNum = 0
        pieceColor = PieceColor.none
        pieceButton.setImage(nil, for: UIControl.State.normal)
        gameBoard.addSubview(pieceButton)
    }
    
    func muteAction() {
        pieceButton.isHighlighted = false
    }
}

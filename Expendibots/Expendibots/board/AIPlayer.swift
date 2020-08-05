//
//  AIPlayer.swift
//  Expendibots
//
//  Created by 施杰煌 on 19/7/20.
//  Copyright © 2020 施杰煌. All rights reserved.
//

import Foundation
import UIKit

// AI player (Alpha-Beta)
// haven't finished
class AIPlayer {
    
    var game: Game!
    var total = [[[Int]]]()
    var common_area = [[Int]]()
    var target = [[Int]]()
    var whiteCopy = [[Int]]()
    var group = [[Int]]()
    var boom_point = [[Int]]()
    var selected = [Int]()
    var moved = [Int]()
    
    init() {
    }
    
    func play(game: Game) {
        whiteCopy = game.whiteBoard
        for i in 0...whiteCopy.count - 1 {
            if whiteCopy[i][0] != 0 {
                group = [[Int]]()
                let point_cor = whiteCopy[i]
                group.append(point_cor)
                whiteCopy[i] = [0, -1, -1]
                other_boom()
                total.append(group)
            }
        }
        print("total:", total)
        group.removeAll()
        total.removeAll()
        boom_point.removeAll()
    }
    
    func other_boom() {
        for i in 0...whiteCopy.count - 1 {
            if whiteCopy[i][0] != 0 {
                let other_point_cor = whiteCopy[i]
                explosion(group: group)
                if boom_point.contains([other_point_cor[1], other_point_cor[2]]) {
                    group.append(other_point_cor)
                    whiteCopy[i] = [0, -1 , -1]
                    other_boom()
                }
            }
        }
    }
    
    func explosion(group: [[Int]]) {
        var boom_area = [[Int]]()
        boom_point.removeAll()

        for point in group {
            for x in point[1] - 1...point[1] + 1 {
                for y in point[2] - 1...point[2] + 1 {
                    if x >= 0 && x < 8 && y >= 0 && y < 8 {
                        boom_area.append([x, y])
                    }
                }
            }
        }
        for point in boom_area {
            if !group.contains(point) {
                boom_point.append(point)
            }
        }
    }
    /*
    func find_target() {
        var common = false
        for groups in total {
            if target.count > 0 {
                for i in 0...common_area.count {
                    explosion(group: groups)
                    if !boom_point.contains(common_area[i]) {
                        common = false
                    }
                    else {
                        if !boom_point.contains(target[i]) {
                            
                        }
                    }
                }
            }
        }
    }
    */
}

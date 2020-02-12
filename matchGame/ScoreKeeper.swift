//
//  ScoreKeeper.swift
//  matchGame
//
//  Created by Tony Buckner on 2/11/20.
//  Copyright © 2020 Osman Hajiyev. All rights reserved.
//

//This file will contain all varibles and functions pertaining to traking and keeping the "Best Score"

import Foundation
import UIKit

///This will check if the game has been ran for the first time and will set the initial score to 0.
func checkForInitialRun() {
    if UserDefaults.standard.bool(forKey: "hasRanBefore"){
        print("This app has ran before.")
    } else {
        UserDefaults.standard.set(true, forKey: "hasRanBefore")
        
        //Best Score initial value
        UserDefaults.standard.set(0, forKey: "bestScore")
    }
}

///This will take the current score and compare it to the Best Score. If the new score is higher than the previous one, the new score will be set.
func compareScore(score: Int) {
    if score > UserDefaults.standard.integer(forKey: "bestScore") {
        UserDefaults.standard.set(score, forKey: "bestScore")
    }
}

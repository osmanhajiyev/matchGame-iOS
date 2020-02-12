//
//  TitleViewController.swift
//  matchGame
//
//  Created by Tony Buckner on 2/11/20.
//  Copyright © 2020 Osman Hajiyev. All rights reserved.
//

import Foundation
import UIKit

class TitleViewController: UIViewController {
    
    @IBOutlet weak var highScoreLabel: UILabel!
    
    override func viewDidLoad() {
        //set Best Score as per what is saved locally
        let bestScore = UserDefaults.standard.integer(forKey: "bestScore")
        highScoreLabel.text = "Best Score: \(bestScore)"
        
    }
    
    @IBAction func gameStart(_ sender: Any) {
        //this segue is being implemented programaticaly for future use, incase a function needs to be done before the actual segue. A "present" may acually be better
        self.performSegue(withIdentifier: "ToGame", sender: self)
        
    }

}

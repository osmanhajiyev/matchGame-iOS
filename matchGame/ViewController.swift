//
//  ViewController.swift
//  matchGame
//
//  Created by Osman Hajiyev on 1/19/20.
//  Copyright © 2020 Osman Hajiyev. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var timerLabel: UILabel!

    @IBOutlet weak var scoreLabel: UILabel!

    @IBOutlet weak var collectionView: UICollectionView!

    var model = CardModel()
    var cardArray = [Card]()

    let gridSizeList = [10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48]
    var gridSize = 10

    @IBOutlet weak var pickerView: UIPickerView!

    var score = 0

    var firstFlippedCardIndex:IndexPath?

    var timer:Timer?
    var milliseconds:Float = 10 * 10000 // 100 seconds

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        //alertWithTF()

        // Call the getCards method of the card model
        cardArray = model.getCards(gridSize)

        collectionView.delegate = self
        collectionView.dataSource = self

        //pickerview code
        self.pickerView.delegate = self
        self.pickerView.dataSource = self

        // Create timer
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerElapsed), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
        collectionView.backgroundColor = UIColor.clear.withAlphaComponent(0)

        scoreLabel.textColor = UIColor.white
        timerLabel.textColor = UIColor.white

    }

    // picker view functions below
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return gridSizeList.count
    }

    /*
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(gridSizeList[row])
    }*/
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributedString = NSAttributedString(string: "Grid Size: \(gridSizeList[row])", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        return attributedString
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        gridSize = gridSizeList[row]
    }


    @IBAction func restart(_ sender: Any) {
        restartGame()
    }
    
    ///Function to restart game
    func restartGame() {
        //alertWithTF()
        cardArray = model.getCards(gridSize)

        collectionView.delegate = self
        collectionView.dataSource = self

        score = 0
        scoreLabel.text = "Score: \(score)"
        milliseconds = 10 * 10000
        firstFlippedCardIndex = nil

        // Create timer
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerElapsed), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
        timerLabel.textColor = UIColor.white

        collectionView.reloadData()
    }

    override func viewDidAppear(_ animated: Bool) {

        SoundManager.playSound(.shuffle)
    }

    // MARK: - Timer Methods

    @objc func timerElapsed() {
        milliseconds -= 1

        //Convert to seconds
        let seconds = String(format: "%.2f", milliseconds/1000)

        // Set label
        timerLabel.text = "Time Remaining: \(seconds)"

        // When the timer has reached 0..
        if milliseconds <= 0 {

            // Stop the timer
            timer?.invalidate()
            timerLabel.textColor = UIColor.red

            // Check if there are any cards unmatched
            checkGameEnded()
        }
    }

    // Score tracker

    func increaseScore(){
        score += 1
        scoreLabel.text = "Score: \(score)"
    }

    // MARK: - UICollectionView Protocol Methods

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return cardArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        // Get a CardCollectionViewCell Object 
        let cell =
            collectionView.dequeueReusableCell(withReuseIdentifier:
                "CardCell", for: indexPath) as! CardCollectionViewCell

        // Get the card that the collection view is trying to display
        let card = cardArray[indexPath.row]

        // Set that card for the cell
        cell.setCard(card)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO:

        // CHeck if there is any time left
        if milliseconds <= 0 {
            return
        }

        let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell

        // Get the card the user selected
        let card = cardArray[indexPath.row]

        if card.isFlipped == false {
            // Flip the card
            cell.flip()

            // Play the sound
            SoundManager.playSound(.flip)

            card.isFlipped = true

            if firstFlippedCardIndex == nil
            {
                // This is the first card being flipped
                firstFlippedCardIndex = indexPath

            } else {
                // This is the second card being flipped

                // TODO: Perform the matching logic
                checkForMatches(indexPath)
            }

        }
            /*
        else {
            // Flib back
            cell.flipBack()
            card.isFlipped = false 
         }*/ // we dont need this part anymore

    }

    // Mark: - Game logic methods

    func checkForMatches(_ secondFlippedCardIndex:IndexPath){

        // Get the cells for the two cards that were revealed
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell

        let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell

        // Get the cards for the two
        let cardOne = cardArray[firstFlippedCardIndex!.row]
        let cardTwo = cardArray[secondFlippedCardIndex.row]

        // Compare the two cards
        if cardOne.imageName == cardTwo.imageName {
            // It is a match

            // Play sound
            SoundManager.playSound(.match)

            // Set the statuses of the cards
            cardOne.isMatched = true
            cardTwo.isMatched = true

            increaseScore()

            // Remove the cards from the grid
            cardOneCell?.remove() // with question mark it is a like safe way to call this method, if it is null the method won't run
            cardTwoCell?.remove()

            // Check if there are any cards left unmatched
            checkGameEnded()
        }
        else {
            // Not a match

            // Play sound
            SoundManager.playSound(.nomatch)

            // Set the statuses of the cards
            cardOne.isFlipped = false
            cardTwo.isFlipped = false

            // Flip both cards back
            cardOneCell?.flipBack()
            cardTwoCell?.flipBack()
        }

        firstFlippedCardIndex = nil
        checkGameEnded()

    }

    func checkGameEnded() {

        // Determine if there are any cards unmatched
        var isWon = true

        for card in cardArray {
            if card.isMatched == false {
                isWon = false
                break
            }
        }
        
        //check new score
        compareScore(score: score)
        
        // Messaging variables
        var title = ""
        //var message = ""

        // If not, then user has won, stop the timer
        if isWon == true {

            if milliseconds > 0 {
                timer?.invalidate()
            }

            title = "Congratulations, YOU HAVE WON!!!"
            //message = "YOU HAVE WON!!!"
        }
        else {
            // If there are unmatched cards, check if there is any time left
            if milliseconds > 0 {
                return
            }

            title = "GAME OVER! RIP..."
            //message = "RIP"

        }
        
        // Show if won or lost
        showAlert(title) //message )

    }

    func showAlert(_ title:String) { //_ message:String
        let bestScore = UserDefaults.standard.integer(forKey: "bestScore")
        
        let alert = UIAlertController(title: title, message: "Score:\(score)  Best Score:\(bestScore)", preferredStyle: .alert)
        
        //go back to title screen
        let home = UIAlertAction(title: "Home", style: UIAlertAction.Style.default, handler: {(_) in
            self.performSegue(withIdentifier: "ToTitle", sender: self)
        })
        
        //restart game
        let restart = UIAlertAction(title: "Restart", style: UIAlertAction.Style.default, handler: {(_) in
            self.restartGame()
        })
        
        alert.addAction(home)
        alert.addAction(restart)

        //let alertAction = UIAlertAction(title: "Okay", style: .default, handler: nil)

        //alert.addAction(alertAction)

        present(alert, animated: true, completion: nil)
    }

    /*
    func alertWithTF() {
        let alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
        alert.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "Enter text:"
            textField.isSecureTextEntry = true // for password input
        })
        self.present(alert, animated: true, completion: nil)

    }*/

}


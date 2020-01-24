//
//  ViewController.swift
//  matchGame
//
//  Created by Osman Hajiyev on 1/19/20.
//  Copyright © 2020 Osman Hajiyev. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {


    @IBOutlet weak var timerLabel: UILabel!


    @IBOutlet weak var scoreLabel: UILabel!

    @IBOutlet weak var collectionView: UICollectionView!

    var model = CardModel()
    var cardArray = [Card]()

    var score = 0

    var firstFlippedCardIndex:IndexPath?

    var timer:Timer?
    var milliseconds:Float = 10 * 10000 // 100 seconds

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        // Call the getCards method of the card model
        cardArray = model.getCards()

        collectionView.delegate = self
        collectionView.dataSource = self

        // Create timer
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerElapsed), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)

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

        // Messaging variables
        var title = ""
        var message = ""

        // If not, then user has won, stop the timer
        if isWon == true {

            if milliseconds > 0 {
                timer?.invalidate()
            }

            title = "Congratulations!"
            message = "YOU HAVE WON!!!"
        }
        else {
            // If there are unmatched cards, check if there is any time left
            if milliseconds > 0 {
                return
            }

            title = "GAME OVER!"
            message = "RIP"

        }
        // Show if won or lost
        showAlert(title, message )

    }

    func showAlert(_ title:String, _ message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let alertAction = UIAlertAction(title: "Okay", style: .default, handler: nil)

        alert.addAction(alertAction)

        present(alert, animated: true, completion: nil)
    }

}


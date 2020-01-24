//
//  CardModel.swift
//  matchGame
//
//  Created by Osman Hajiyev on 1/19/20.
//  Copyright © 2020 Osman Hajiyev. All rights reserved.
//

import Foundation

class CardModel {

    func getCards() -> [Card] {

        // Declare an array to store numbers we have already generated
        var generatedNumbersArray = [Int]()

        // Declare an array to store the generated cards
        var generatedCardsArray = [Card]()

        // Randomly generate pairs of cards
        while generatedNumbersArray.count < 11 {

            // Get a random number
            let randomNumber = arc4random_uniform(13) + 1

            if generatedNumbersArray.contains(Int(randomNumber)) == false {

                // print the number
                print(randomNumber)

                // Store the number into the generated NumbersArray
                generatedNumbersArray.append(Int(randomNumber))

                //Create the first card object
                let cardOne = Card()
                cardOne.imageName = "card\(randomNumber)"

                generatedCardsArray.append(cardOne)

                // Create the second card object
                let cardTwo = Card()
                cardTwo.imageName = "card\(randomNumber)"

                generatedCardsArray.append(cardTwo)
            }
        }


        // Return the array

        return generatedCardsArray.shuffled()
    }

}

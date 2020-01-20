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

        // Declare an array to store the generated cards
        var generatedCardsArray = [Card]()

        // Randomly generate pairs of cards
        for _ in 0...9 {

            // Get a random number
            let randomNumber = arc4random_uniform(13) + 1

            print(randomNumber)

            // Create the first card object
            let cardOne = Card()
            cardOne.imageName = "card\(randomNumber)"

            generatedCardsArray.append(cardOne)

            // Create the second card object
            let cardTwo = Card()
            cardTwo.imageName = "card\(randomNumber)"

            generatedCardsArray.append(cardTwo)

            // Optional: Make it so we only have unique pairs. Random number may generate
            // the same number

        }

        // TODO: Randomize the array

        // Return the array

        return generatedCardsArray.shuffled()
    }

}

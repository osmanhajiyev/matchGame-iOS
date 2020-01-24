//
//  CardCollectionViewCell.swift
//  matchGame
//
//  Created by Osman Hajiyev on 1/19/20.
//  Copyright © 2020 Osman Hajiyev. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var frontImageView: UIImageView!

    @IBOutlet weak var backImageView: UIImageView!

    var card:Card?

    func setCard(_ card:Card){

        self.card = card
        frontImageView.image = UIImage(named: card.imageName)

        if card.isMatched == true {
            backImageView.alpha = 0
            frontImageView.alpha = 0
        } else {
            backImageView.alpha = 1
            frontImageView.alpha = 1
        }

        // Determine if the card in in a flipped up state or flipped down state
        if(card.isFlipped == true){
            // Make sure the front image is on top
            UIView.transition(from: backImageView, to: frontImageView, duration: 0, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
        } else {
            // Make sure the back image is on top
            UIView.transition(from: frontImageView, to: backImageView, duration: 0, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
        }
    }

    func flip() {

        UIView.transition(from: backImageView, to: frontImageView, duration: 0.3, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)

    }

    func flipBack() {

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            UIView.transition(from: self.frontImageView, to: self.backImageView, duration: 0.3, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
        }


    }

    func remove() {

        // removes both imageviews from being visible
        // TODO: Animate

        // This alpha 0 makes themm invisible
        backImageView.alpha = 0
        frontImageView.alpha = 0

    }

}

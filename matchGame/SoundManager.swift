//
//  SoundManager.swift
//  matchGame
//
//  Created by Osman Hajiyev on 1/23/20.
//  Copyright © 2020 Osman Hajiyev. All rights reserved.
//

import Foundation
import AVFoundation

class SoundManager {

    static var audioPlayer:AVAudioPlayer?

    enum SoundEffect {

        case flip
        case shuffle
        case match
        case nomatch

    }

    static func playSound(_ effect:SoundEffect) {

        var soundFilename = ""

        // Determine which sound effect we want to play
        // and set the appropriate file name
        switch effect {

        case.flip:
            soundFilename = "cardflip"

        case .shuffle:
            soundFilename = "shuffle"

        case .match:
            soundFilename = "dingcorrect"

        case .nomatch:
            soundFilename = "dingwrong"
        }

        // Get the path to the sound file inside the bundle
        let bundlePath = Bundle.main.path(forResource: soundFilename, ofType: "wav")

        guard bundlePath != nil else {
            print("Could not find sound file \(soundFilename) in the bundle")
            return
        }

        // Create a URL object from this string path
        let soundURL = URL(fileURLWithPath: bundlePath!)


        do {
            // Create audio player object
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)

            // Play the sound
            audioPlayer?.play()
        } catch {
            // Could not create audio player object
            print("Could not create the audio player object for sound file \(soundFilename)")
        }

    }

}
